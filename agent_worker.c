// Persistent xv6 user program used by the host-side Python agent.
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "taint.h"

#define MAX_LINE 120
#define MAX_OUTPUT 4096

// Fixed message written by WRITE to avoid model-controlled content.
#define WRITE_MSG "agent-write-test\n"
#define WRITE_MSG_LEN 17

static void
finish(char *status)
{
  printf(1, "@XV6 DONE %s\n", status);
}

// Hex keeps file contents separate from protocol control lines.
static void
send_data(char *buf, int n)
{
  char hex[129];
  char *digits = "0123456789abcdef";
  int i;

  for(i = 0; i < n; i++){
    hex[2*i] = digits[((uchar)buf[i]) >> 4];
    hex[2*i+1] = digits[((uchar)buf[i]) & 15];
  }
  hex[2*n] = 0;
  printf(1, "@XV6 DATA %s\n", hex);
}

static int
valid_path(char *path)
{
  int i, n = strlen(path);
  if(n < 1 || n > 80 || path[0] != '/')
    return 0;
  for(i = 0; i < n; i++)
    if(!((path[i] >= 'a' && path[i] <= 'z') ||
         (path[i] >= 'A' && path[i] <= 'Z') ||
         (path[i] >= '0' && path[i] <= '9') ||
         path[i] == '/' || path[i] == '_' || path[i] == '-' || path[i] == '.'))
      return 0;
  return 1;
}

static void
read_file(int fd)
{
  char buf[64];
  int n, total = 0;

  while(total < MAX_OUTPUT){
    n = read(fd, buf, sizeof(buf));
    if(n < 0){
      finish("ERROR read_failed");
      return;
    }
    if(n == 0){
      finish("OK");
      return;
    }
    if(total+n > MAX_OUTPUT)
      n = MAX_OUTPUT-total;
    send_data(buf, n); // send back i hexadecimal
    total += n;
  }
  n = read(fd, buf, 1);
  finish(n > 0 ? "TRUNCATED" : n == 0 ? "OK" : "ERROR read_failed");
}

static void
list_files(int fd)
{
  struct dirent entry;
  char name[DIRSIZ+2];
  int n, total = 0;

  while((n = read(fd, &entry, sizeof(entry))) == sizeof(entry)){
    if(entry.inum == 0)
      continue;
    memmove(name, entry.name, DIRSIZ);
    name[DIRSIZ] = 0;
    if(strcmp(name, ".") == 0 || strcmp(name, "..") == 0)
      continue;
    n = strlen(name);
    name[n++] = '\n';
    if(total+n > MAX_OUTPUT){
      finish("TRUNCATED");
      return;
    }
    send_data(name, n);
    total += n;
  }
  finish(n == 0 ? "OK" : "ERROR read_failed");
}

static void
handle_request(char *line)
{
  char *path;
  struct stat st;
  int fd;

  // STATUS has no path argument — handle it first.
  if(strcmp(line, "STATUS") == 0){
    printf(1, "@XV6 TAINT %d\n", istainted());
    return;
  }

  path = strchr(line, ' ');
  if(path == 0){
    finish("ERROR invalid_request");
    return;
  }
  *path++ = 0;

  // TAINT: mark a file as an untrusted taint source.
  if(strcmp(line, "TAINT") == 0){
    if(!valid_path(path)){
      finish("ERROR invalid_request");
      return;
    }
    if(marktaint(path) < 0)
      finish("ERROR marktaint_failed");
    else
      finish("OK");
    return;
  }

  // WRITE: open an existing file and write a fixed test message.
  if(strcmp(line, "WRITE") == 0){
    if(!valid_path(path)){
      finish("ERROR invalid_request");
      return;
    }
    fd = open(path, O_RDWR);
    if(fd < 0){
      finish("ERROR open_failed");
      return;
    }
    int n = write(fd, WRITE_MSG, WRITE_MSG_LEN);
    close(fd);
    if(n < 0)
      finish("ERROR write_blocked");
    else
      finish("OK");
    return;
  }

  if(!valid_path(path)){
    finish("ERROR invalid_request");
    return;
  }
  if(strcmp(line, "READ") != 0 && strcmp(line, "LIST") != 0){
    finish("ERROR unknown_operation");
    return;
  }
  fd = open(path, O_RDONLY);
  if(fd < 0){
    finish("ERROR open_failed");
    return;
  }
  if(fstat(fd, &st) < 0)
    finish("ERROR stat_failed");
  else if(strcmp(line, "READ") == 0 && st.type == T_FILE)
    read_file(fd);
  else if(strcmp(line, "LIST") == 0 && st.type == T_DIR)
    list_files(fd);
  else
    finish("ERROR wrong_file_type");
  close(fd);
}

int
main(void)
{
  char line[MAX_LINE];

  printf(1, "@XV6 READY %d\n", getpid());
  while(1){
    gets(line, sizeof(line));
    if(strlen(line) > 0 && line[strlen(line)-1] == '\n')
      line[strlen(line)-1] = 0;
    handle_request(line);
  }
}
