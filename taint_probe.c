#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int tainted = istainted();
  int ok = 1;

  if(argc > 1){
    if(strcmp(argv[1], "clean") == 0){
      ok = (tainted == 0);
      if(ok)
        printf(1, "PASS: probe confirmed process is clean\n");
      else
        printf(1, "FAIL: probe expected clean, but process is tainted\n");
    } else if(strcmp(argv[1], "tainted") == 0){
      ok = (tainted == 1);
      if(ok)
        printf(1, "PASS: probe confirmed taint survived exec\n");
      else
        printf(1, "FAIL: probe expected tainted, but process is clean\n");
    } else {
      printf(1, "probe: unknown argument %s\n", argv[1]);
      ok = 0;
    }
  } else {
    printf(1, "probe: istainted=%d\n", tainted);
  }

  // If a communication file descriptor was supplied, report result to parent
  if(argc > 2){
    int out_fd = atoi(argv[2]);
    if(out_fd > 0)
      write(out_fd, ok ? "P" : "F", 1);
  }

  exit();
}
