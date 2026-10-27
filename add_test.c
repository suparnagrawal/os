#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    int result;

    result = add(10, 20);

    printf(1, "10 + 20 = %d\n", result);

    exit();
}