#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

static int failures = 0;

static void
check(char *name, int condition)
{
  if(condition)
    printf(1, "PASS: %s\n", name);
  else {
    printf(1, "FAIL: %s\n", name);
    failures++;
  }
}

static void
itostring(int n, char *s)
{
  int i = 0, j;
  char tmp[16];
  if(n == 0){
    s[0] = '0';
    s[1] = 0;
    return;
  }
  while(n > 0){
    tmp[i++] = (n % 10) + '0';
    n /= 10;
  }
  for(j = 0; j < i; j++)
    s[j] = tmp[i - 1 - j];
  s[i] = 0;
}

int
main(void)
{
  int fd, p[2];
  char buf[16];
  char res;
  char fd_str[16];

  printf(1, "taint_exec: starting tests\n");

  // Step 0: While still clean, perform setup
  unlink("/safe/taint_probe");
  unlink("/safeevil/taint_probe");
  unlink("/u_exec");

  // Create /safe directory and link /taint_probe as /safe/taint_probe
  mkdir("/safe");
  if(link("/taint_probe", "/safe/taint_probe") < 0){
    printf(1, "FAIL: link(/taint_probe, /safe/taint_probe) failed\n");
    exit();
  }

  // Create /safeevil directory and link /taint_probe as /safeevil/taint_probe to test exact prefix check
  mkdir("/safeevil");
  link("/taint_probe", "/safeevil/taint_probe");

  // Prepare untrusted file
  fd = open("/u_exec", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "FAIL: open /u_exec failed\n");
    exit();
  }
  write(fd, "exec_taint_data", 15);
  close(fd);
  if(marktaint("/u_exec") < 0){
    printf(1, "FAIL: marktaint /u_exec failed\n");
    exit();
  }

  // Case 1: A clean process can execute a valid program outside /safe/
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    itostring(p[1], fd_str);
    char *argv[] = { "/taint_probe", "clean", fd_str, 0 };
    exec(argv[0], argv);
    // If exec fails:
    write(p[1], "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("clean process can execute outside /safe/", res == 'P');

  // Case 2: A process becomes tainted after successfully reading an untrusted file
  fd = open("/u_exec", O_RDONLY);
  if(fd < 0){
    printf(1, "FAIL: open /u_exec failed\n");
    exit();
  }
  int r = read(fd, buf, 1);
  close(fd);
  check("process becomes tainted after reading untrusted file", r == 1 && istainted() == 1);

  // Case 3: A tainted process cannot execute /taint_probe
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    char *argv[] = { "/taint_probe", 0 };
    int ret = exec(argv[0], argv);
    // We expect exec to return -1 for non-/safe/ path
    write(p[1], ret == -1 ? "P" : "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("tainted process cannot execute /taint_probe", res == 'P');

  // Case 4: A tainted process cannot execute /safeevil/taint_probe
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    char *argv[] = { "/safeevil/taint_probe", 0 };
    int ret = exec(argv[0], argv);
    write(p[1], ret == -1 ? "P" : "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("tainted process cannot execute /safeevil/taint_probe", res == 'P');

  // Case 5: A tainted process cannot execute safe/taint_probe (relative path)
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    char *argv[] = { "safe/taint_probe", 0 };
    int ret = exec(argv[0], argv);
    write(p[1], ret == -1 ? "P" : "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("tainted process cannot execute safe/taint_probe (relative path)", res == 'P');

  // Case 6 & 7: A tainted process can execute /safe/taint_probe, and probe confirms taint survived
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    itostring(p[1], fd_str);
    char *argv[] = { "/safe/taint_probe", "tainted", fd_str, 0 };
    exec(argv[0], argv);
    // If exec fails:
    write(p[1], "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("tainted process can execute /safe/taint_probe", res == 'P');
  check("probe confirms taint survived successful exec", res == 'P');

  if(failures == 0)
    printf(1, "taint_exec: all tests passed\n");
  else
    printf(1, "taint_exec: %d test(s) failed\n", failures);

  exit();
}
