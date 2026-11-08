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
  int fd_c, fd_u, fd_n;
  char buf[8];

  // Prepare clean and untrusted files
  fd_c = open("/pol_clean", O_CREATE | O_RDWR);
  write(fd_c, "clean", 5);

  fd_u = open("/pol_untrust", O_CREATE | O_RDWR);
  write(fd_u, "untrust", 7);
  close(fd_u);
  marktaint("/pol_untrust");

  // Taint process
  fd_u = open("/pol_untrust", O_RDWR);
  read(fd_u, buf, 1);
  check("process is tainted", istainted() == 1);

  // Policy checks
  check("write to clean file fails", write(fd_c, "x", 1) == -1);
  check("write to untrusted file succeeds", write(fd_u, "x", 1) == 1);
  check("write to console succeeds", write(1, "", 0) == 0);
  check("unlink fails when tainted", unlink("/pol_clean") == -1);

  // Create new file while tainted: succeeds and can be written
  fd_n = open("/pol_new", O_CREATE | O_RDWR);
  check("create new file while tainted succeeds", fd_n >= 0);
  check("write to new file succeeds", write(fd_n, "n", 1) == 1);
  close(fd_n);

  close(fd_c);
  close(fd_u);
  printf(1, "taint_policy: all tests passed\n");
  exit();
}
