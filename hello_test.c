#include "types.h"
#include "user.h"

int
main(int argc, char* argv[])
{
    int r = hello(); // calling the hello system call
    printf(1, "hello() returned %d\n", r); // printing the return value of hello system call
    exit();

}