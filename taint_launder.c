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
  int fd, fd2;
  char buf[8];

  // 1. Dup laundering: child tests dup and becomes tainted
  if(fork() == 0){
    fd = open("/l_dup", O_CREATE | O_RDWR);
    write(fd, "x", 1);
    close(fd);
    marktaint("/l_dup");

    fd = open("/l_dup", O_RDONLY);
    fd2 = dup(fd);
    close(fd);
    read(fd2, buf, 1);
    close(fd2);
    check("dup descriptor taints reader", istainted() == 1);
    exit();
  }
  wait();

  // 2. Recreated file laundering: clean parent unlinks and recreates
  unlink("/l_dup");
  fd = open("/l_dup", O_CREATE | O_RDWR);
  write(fd, "clean", 5);
  close(fd);

  fd = open("/l_dup", O_RDONLY);
  read(fd, buf, 1);
  close(fd);
  check("recreated file begins clean", istainted() == 0);

  printf(1, "taint_launder: all tests passed\n");
  exit();
}
