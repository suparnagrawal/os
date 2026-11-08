#include "types.h"
#include "stat.h"
#include "user.h"

static int failures;

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
  check("new process is clean", istainted() == 0);
  check("mark regular file", marktaint("/README") == 0);
  check("mark is idempotent", marktaint("/README") == 0);
  check("reject missing file", marktaint("/missing") == -1);
  check("reject directory", marktaint("/") == -1);
  check("marking alone does not taint", istainted() == 0);

  if(failures == 0)
    printf(1, "taint_basic: all tests passed\n");
  else
    printf(1, "taint_basic: %d test(s) failed\n", failures);
  exit();
}
