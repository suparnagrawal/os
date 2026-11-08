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

int
main(void)
{
  int fd, p[2];
  char buf[16];
  char res;

  printf(1, "taint_fork: starting tests\n");

  // Setup: while clean, clean up any previous test file and create untrusted file
  unlink("/u_fork");
  fd = open("/u_fork", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "FAIL: failed to create /u_fork\n");
    exit();
  }
  write(fd, "untrusted_payload", 17);
  close(fd);
  if(marktaint("/u_fork") < 0){
    printf(1, "FAIL: failed to marktaint /u_fork\n");
    exit();
  }

  // 1. A newly started process is clean.
  check("newly started process is clean", istainted() == 0);

  // 2. A clean parent creates a clean child.
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    int child_clean = (istainted() == 0);
    write(p[1], child_clean ? "P" : "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("clean parent creates clean child", res == 'P');

  // 3. Reading zero bytes from an untrusted file does not taint the parent.
  fd = open("/u_fork", O_RDONLY);
  if(fd < 0){
    printf(1, "FAIL: failed to open /u_fork for zero-byte read\n");
    exit();
  }
  int r = read(fd, buf, 0);
  close(fd);
  check("reading zero bytes does not taint parent", r == 0 && istainted() == 0);

  // 5. A child that taints itself does not contaminate its clean parent.
  // (Tested while parent is still clean, before Case 4)
  if(fork() == 0){
    fd = open("/u_fork", O_RDONLY);
    if(fd >= 0){
      read(fd, buf, 1);
      close(fd);
    }
    if(istainted() == 1)
      exit();
    else {
      printf(1, "FAIL: child failed to taint itself\n");
      exit();
    }
  }
  wait();
  check("child self-tainting does not contaminate clean parent", istainted() == 0);

  // 4. Reading at least one byte from an untrusted file taints the calling process.
  fd = open("/u_fork", O_RDONLY);
  if(fd < 0){
    printf(1, "FAIL: failed to open /u_fork for read\n");
    exit();
  }
  r = read(fd, buf, 1);
  close(fd);
  check("reading >= 1 byte taints calling process", r == 1 && istainted() == 1);

  // 6. A tainted parent creates a tainted child.
  if(pipe(p) < 0){
    printf(1, "FAIL: pipe failed\n");
    exit();
  }
  if(fork() == 0){
    close(p[0]);
    int child_tainted = (istainted() == 1);
    write(p[1], child_tainted ? "P" : "F", 1);
    close(p[1]);
    exit();
  }
  close(p[1]);
  res = 0;
  read(p[0], &res, 1);
  close(p[0]);
  wait();
  check("tainted parent creates tainted child", res == 'P');

  if(failures == 0)
    printf(1, "taint_fork: all tests passed\n");
  else
    printf(1, "taint_fork: %d test(s) failed\n", failures);

  exit();
}
