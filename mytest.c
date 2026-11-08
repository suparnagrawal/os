#include "types.h"    // contains basic xv6 type definations  
#include "user.h" // contains declarations of fn/system call that the user program can use

int main(int argc, char *argv[]) 
{ 
    printf(1, "Hey, I am trying xv6\n"); 
    exit();
}

// 0 → stdin
// 1 → stdout
// 2 → stderr