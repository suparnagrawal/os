#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

static void
check(char *name, int ok)
{
  printf(1, "%s: %s\n", ok ? "PASS" : "FAIL", name);
  if(!ok) exit();
}

int
main(void)
{
  int p[2], fd;
  char buf[8];

  // Setup an untrusted file
  fd = open("/u_pipe", O_CREATE | O_RDWR);
  write(fd, "x", 1);
  close(fd);
  marktaint("/u_pipe");

  // 1. Clean writer to clean reader
  if(fork() == 0){
    pipe(p);
    write(p[1], "a", 1);
    read(p[0], buf, 1);
    close(p[0]); close(p[1]);
    check("clean pipe reader stays clean", istainted() == 0);
    exit();
  }
  wait();

  // 2. Tainted writer to reader
  if(fork() == 0){
    pipe(p);
    if(fork() == 0){
      fd = open("/u_pipe", O_RDONLY);
      read(fd, buf, 1);
      close(fd);
      write(p[1], "b", 1);
      exit();
    }
    wait();
    read(p[0], buf, 1);
    close(p[0]); close(p[1]);
    check("tainted pipe taints reader", istainted() == 1);
    exit();
  }
  wait();

  // 3. Shared pipe with clean and tainted writers
  if(fork() == 0){
    pipe(p);
    write(p[1], "c", 1);
    if(fork() == 0){
      fd = open("/u_pipe", O_RDONLY);
      read(fd, buf, 1);
      close(fd);
      write(p[1], "t", 1);
      exit();
    }
    wait();
    read(p[0], buf, 2);
    close(p[0]); close(p[1]);
    check("shared pipe taints reader", istainted() == 1);
    exit();
  }
  wait();

  printf(1, "taint_pipe: all tests passed\n");
  exit();
}
