xv6 has a MakeFile which specifies what should be built

mytest.c
     ↓
compiled by host compiler
     ↓
_mytest executable
     ↓
included in xv6 filesystem image
     ↓
QEMU boots xv6
     ↓
xv6 shell
     ↓
mytest
     ↓
program 


stub is a bridge between user program and the kernel

uSys.S
// creates a tiny assembly stub - a bridge between the user program and the kernel. It sets up the system call number in %eax, triggers the interrupt, and returns to the user program.


hello_test
hello()
SYSCALL(hello)
trap into the kernel
SYS_hello
syscall table
sys_hello()
cprintf()
back to user space
