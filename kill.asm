
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	bb 01 00 00 00       	mov    $0x1,%ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 27                	jle    4a <main+0x4a>
  23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	push   (%edi,%ebx,4)
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    kill(atoi(argv[i]));
  31:	e8 fa 01 00 00       	call   230 <atoi>
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 95 02 00 00       	call   2d3 <kill>
  for(i=1; i<argc; i++)
  3e:	83 c4 10             	add    $0x10,%esp
  41:	39 de                	cmp    %ebx,%esi
  43:	75 e3                	jne    28 <main+0x28>
  exit();
  45:	e8 59 02 00 00       	call   2a3 <exit>
    printf(2, "usage: kill pid...\n");
  4a:	50                   	push   %eax
  4b:	50                   	push   %eax
  4c:	68 f8 06 00 00       	push   $0x6f8
  51:	6a 02                	push   $0x2
  53:	e8 98 03 00 00       	call   3f0 <printf>
    exit();
  58:	e8 46 02 00 00       	call   2a3 <exit>
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  61:	31 c0                	xor    %eax,%eax
{
  63:	89 e5                	mov    %esp,%ebp
  65:	53                   	push   %ebx
  66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  77:	83 c0 01             	add    $0x1,%eax
  7a:	84 d2                	test   %dl,%dl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  81:	89 c8                	mov    %ecx,%eax
  83:	c9                   	leave
  84:	c3                   	ret
  85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  8c:	00 
  8d:	8d 76 00             	lea    0x0(%esi),%esi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 17                	jne    b8 <strcmp+0x28>
  a1:	eb 3a                	jmp    dd <strcmp+0x4d>
  a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ac:	83 c2 01             	add    $0x1,%edx
  af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  b2:	84 c0                	test   %al,%al
  b4:	74 1a                	je     d0 <strcmp+0x40>
  b6:	89 d9                	mov    %ebx,%ecx
  b8:	0f b6 19             	movzbl (%ecx),%ebx
  bb:	38 c3                	cmp    %al,%bl
  bd:	74 e9                	je     a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  bf:	29 d8                	sub    %ebx,%eax
}
  c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c4:	c9                   	leave
  c5:	c3                   	ret
  c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  cd:	00 
  ce:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  d4:	31 c0                	xor    %eax,%eax
  d6:	29 d8                	sub    %ebx,%eax
}
  d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  db:	c9                   	leave
  dc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  dd:	0f b6 19             	movzbl (%ecx),%ebx
  e0:	31 c0                	xor    %eax,%eax
  e2:	eb db                	jmp    bf <strcmp+0x2f>
  e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  eb:	00 
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 3a 00             	cmpb   $0x0,(%edx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 c0                	xor    %eax,%eax
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c0 01             	add    $0x1,%eax
 103:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 107:	89 c1                	mov    %eax,%ecx
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	89 c8                	mov    %ecx,%eax
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret
 10f:	90                   	nop
  for(n = 0; s[n]; n++)
 110:	31 c9                	xor    %ecx,%ecx
}
 112:	5d                   	pop    %ebp
 113:	89 c8                	mov    %ecx,%eax
 115:	c3                   	ret
 116:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 11d:	00 
 11e:	66 90                	xchg   %ax,%ax

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	8b 7d fc             	mov    -0x4(%ebp),%edi
 135:	89 d0                	mov    %edx,%eax
 137:	c9                   	leave
 138:	c3                   	ret
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 12                	jne    163 <strchr+0x23>
 151:	eb 1d                	jmp    170 <strchr+0x30>
 153:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 158:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	84 d2                	test   %dl,%dl
 161:	74 0d                	je     170 <strchr+0x30>
    if(*s == c)
 163:	38 d1                	cmp    %dl,%cl
 165:	75 f1                	jne    158 <strchr+0x18>
      return (char*)s;
  return 0;
}
 167:	5d                   	pop    %ebp
 168:	c3                   	ret
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 170:	31 c0                	xor    %eax,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret
 174:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 17b:	00 
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 185:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 188:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 189:	31 db                	xor    %ebx,%ebx
{
 18b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 18e:	eb 27                	jmp    1b7 <gets+0x37>
    cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	6a 01                	push   $0x1
 195:	56                   	push   %esi
 196:	6a 00                	push   $0x0
 198:	e8 1e 01 00 00       	call   2bb <read>
    if(cc < 1)
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 c0                	test   %eax,%eax
 1a2:	7e 1d                	jle    1c1 <gets+0x41>
      break;
    buf[i++] = c;
 1a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
 1ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1af:	3c 0a                	cmp    $0xa,%al
 1b1:	74 10                	je     1c3 <gets+0x43>
 1b3:	3c 0d                	cmp    $0xd,%al
 1b5:	74 0c                	je     1c3 <gets+0x43>
  for(i=0; i+1 < max; ){
 1b7:	89 df                	mov    %ebx,%edi
 1b9:	83 c3 01             	add    $0x1,%ebx
 1bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1bf:	7c cf                	jl     190 <gets+0x10>
 1c1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cd:	5b                   	pop    %ebx
 1ce:	5e                   	pop    %esi
 1cf:	5f                   	pop    %edi
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret
 1d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1d9:	00 
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	56                   	push   %esi
 1e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	6a 00                	push   $0x0
 1ea:	ff 75 08             	push   0x8(%ebp)
 1ed:	e8 f1 00 00 00       	call   2e3 <open>
  if(fd < 0)
 1f2:	83 c4 10             	add    $0x10,%esp
 1f5:	85 c0                	test   %eax,%eax
 1f7:	78 27                	js     220 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1f9:	83 ec 08             	sub    $0x8,%esp
 1fc:	ff 75 0c             	push   0xc(%ebp)
 1ff:	89 c3                	mov    %eax,%ebx
 201:	50                   	push   %eax
 202:	e8 f4 00 00 00       	call   2fb <fstat>
  close(fd);
 207:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 20a:	89 c6                	mov    %eax,%esi
  close(fd);
 20c:	e8 ba 00 00 00       	call   2cb <close>
  return r;
 211:	83 c4 10             	add    $0x10,%esp
}
 214:	8d 65 f8             	lea    -0x8(%ebp),%esp
 217:	89 f0                	mov    %esi,%eax
 219:	5b                   	pop    %ebx
 21a:	5e                   	pop    %esi
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret
 21d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 220:	be ff ff ff ff       	mov    $0xffffffff,%esi
 225:	eb ed                	jmp    214 <stat+0x34>
 227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22e:	00 
 22f:	90                   	nop

00000230 <atoi>:

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	0f be 02             	movsbl (%edx),%eax
 23a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 23d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 240:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 245:	77 1e                	ja     265 <atoi+0x35>
 247:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24e:	00 
 24f:	90                   	nop
    n = n*10 + *s++ - '0';
 250:	83 c2 01             	add    $0x1,%edx
 253:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 256:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 25a:	0f be 02             	movsbl (%edx),%eax
 25d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 260:	80 fb 09             	cmp    $0x9,%bl
 263:	76 eb                	jbe    250 <atoi+0x20>
  return n;
}
 265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 268:	89 c8                	mov    %ecx,%eax
 26a:	c9                   	leave
 26b:	c3                   	ret
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	8b 45 10             	mov    0x10(%ebp),%eax
 277:	8b 55 08             	mov    0x8(%ebp),%edx
 27a:	56                   	push   %esi
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 c0                	test   %eax,%eax
 280:	7e 13                	jle    295 <memmove+0x25>
 282:	01 d0                	add    %edx,%eax
  dst = vdst;
 284:	89 d7                	mov    %edx,%edi
 286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 28d:	00 
 28e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 290:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 291:	39 f8                	cmp    %edi,%eax
 293:	75 fb                	jne    290 <memmove+0x20>
  return vdst;
}
 295:	5e                   	pop    %esi
 296:	89 d0                	mov    %edx,%eax
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret

0000029b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29b:	b8 01 00 00 00       	mov    $0x1,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <exit>:
SYSCALL(exit)
 2a3:	b8 02 00 00 00       	mov    $0x2,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <wait>:
SYSCALL(wait)
 2ab:	b8 03 00 00 00       	mov    $0x3,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <pipe>:
SYSCALL(pipe)
 2b3:	b8 04 00 00 00       	mov    $0x4,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <read>:
SYSCALL(read)
 2bb:	b8 05 00 00 00       	mov    $0x5,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <write>:
SYSCALL(write)
 2c3:	b8 10 00 00 00       	mov    $0x10,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <close>:
SYSCALL(close)
 2cb:	b8 15 00 00 00       	mov    $0x15,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <kill>:
SYSCALL(kill)
 2d3:	b8 06 00 00 00       	mov    $0x6,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <exec>:
SYSCALL(exec)
 2db:	b8 07 00 00 00       	mov    $0x7,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <open>:
SYSCALL(open)
 2e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <mknod>:
SYSCALL(mknod)
 2eb:	b8 11 00 00 00       	mov    $0x11,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <unlink>:
SYSCALL(unlink)
 2f3:	b8 12 00 00 00       	mov    $0x12,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <fstat>:
SYSCALL(fstat)
 2fb:	b8 08 00 00 00       	mov    $0x8,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <link>:
SYSCALL(link)
 303:	b8 13 00 00 00       	mov    $0x13,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <mkdir>:
SYSCALL(mkdir)
 30b:	b8 14 00 00 00       	mov    $0x14,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <chdir>:
SYSCALL(chdir)
 313:	b8 09 00 00 00       	mov    $0x9,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <dup>:
SYSCALL(dup)
 31b:	b8 0a 00 00 00       	mov    $0xa,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <getpid>:
SYSCALL(getpid)
 323:	b8 0b 00 00 00       	mov    $0xb,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <sbrk>:
SYSCALL(sbrk)
 32b:	b8 0c 00 00 00       	mov    $0xc,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <sleep>:
SYSCALL(sleep)
 333:	b8 0d 00 00 00       	mov    $0xd,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <uptime>:
SYSCALL(uptime)
 33b:	b8 0e 00 00 00       	mov    $0xe,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <hello>:
SYSCALL(hello) 
 343:	b8 16 00 00 00       	mov    $0x16,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret
 34b:	66 90                	xchg   %ax,%ax
 34d:	66 90                	xchg   %ax,%ax
 34f:	90                   	nop

00000350 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
 356:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 358:	89 d1                	mov    %edx,%ecx
{
 35a:	83 ec 3c             	sub    $0x3c,%esp
 35d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 360:	85 d2                	test   %edx,%edx
 362:	0f 89 80 00 00 00    	jns    3e8 <printint+0x98>
 368:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 36c:	74 7a                	je     3e8 <printint+0x98>
    x = -xx;
 36e:	f7 d9                	neg    %ecx
    neg = 1;
 370:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 375:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 378:	31 f6                	xor    %esi,%esi
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 380:	89 c8                	mov    %ecx,%eax
 382:	31 d2                	xor    %edx,%edx
 384:	89 f7                	mov    %esi,%edi
 386:	f7 f3                	div    %ebx
 388:	8d 76 01             	lea    0x1(%esi),%esi
 38b:	0f b6 92 6c 07 00 00 	movzbl 0x76c(%edx),%edx
 392:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 396:	89 ca                	mov    %ecx,%edx
 398:	89 c1                	mov    %eax,%ecx
 39a:	39 da                	cmp    %ebx,%edx
 39c:	73 e2                	jae    380 <printint+0x30>
  if(neg)
 39e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3a1:	85 c0                	test   %eax,%eax
 3a3:	74 07                	je     3ac <printint+0x5c>
    buf[i++] = '-';
 3a5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3aa:	89 f7                	mov    %esi,%edi
 3ac:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3af:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3b2:	01 df                	add    %ebx,%edi
 3b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3b8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	88 45 d7             	mov    %al,-0x29(%ebp)
 3c1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3c4:	6a 01                	push   $0x1
 3c6:	50                   	push   %eax
 3c7:	56                   	push   %esi
 3c8:	e8 f6 fe ff ff       	call   2c3 <write>
  while(--i >= 0)
 3cd:	89 f8                	mov    %edi,%eax
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	83 ef 01             	sub    $0x1,%edi
 3d5:	39 c3                	cmp    %eax,%ebx
 3d7:	75 df                	jne    3b8 <printint+0x68>
}
 3d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3dc:	5b                   	pop    %ebx
 3dd:	5e                   	pop    %esi
 3de:	5f                   	pop    %edi
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3e8:	31 c0                	xor    %eax,%eax
 3ea:	eb 89                	jmp    375 <printint+0x25>
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 3fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 3ff:	0f b6 1e             	movzbl (%esi),%ebx
 402:	83 c6 01             	add    $0x1,%esi
 405:	84 db                	test   %bl,%bl
 407:	74 67                	je     470 <printf+0x80>
 409:	8d 4d 10             	lea    0x10(%ebp),%ecx
 40c:	31 d2                	xor    %edx,%edx
 40e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 411:	eb 34                	jmp    447 <printf+0x57>
 413:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 418:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 41b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 420:	83 f8 25             	cmp    $0x25,%eax
 423:	74 18                	je     43d <printf+0x4d>
  write(fd, &c, 1);
 425:	83 ec 04             	sub    $0x4,%esp
 428:	8d 45 e7             	lea    -0x19(%ebp),%eax
 42b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 42e:	6a 01                	push   $0x1
 430:	50                   	push   %eax
 431:	57                   	push   %edi
 432:	e8 8c fe ff ff       	call   2c3 <write>
 437:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 43a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 43d:	0f b6 1e             	movzbl (%esi),%ebx
 440:	83 c6 01             	add    $0x1,%esi
 443:	84 db                	test   %bl,%bl
 445:	74 29                	je     470 <printf+0x80>
    c = fmt[i] & 0xff;
 447:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 44a:	85 d2                	test   %edx,%edx
 44c:	74 ca                	je     418 <printf+0x28>
      }
    } else if(state == '%'){
 44e:	83 fa 25             	cmp    $0x25,%edx
 451:	75 ea                	jne    43d <printf+0x4d>
      if(c == 'd'){
 453:	83 f8 25             	cmp    $0x25,%eax
 456:	0f 84 04 01 00 00    	je     560 <printf+0x170>
 45c:	83 e8 63             	sub    $0x63,%eax
 45f:	83 f8 15             	cmp    $0x15,%eax
 462:	77 1c                	ja     480 <printf+0x90>
 464:	ff 24 85 14 07 00 00 	jmp    *0x714(,%eax,4)
 46b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 470:	8d 65 f4             	lea    -0xc(%ebp),%esp
 473:	5b                   	pop    %ebx
 474:	5e                   	pop    %esi
 475:	5f                   	pop    %edi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret
 478:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 47f:	00 
  write(fd, &c, 1);
 480:	83 ec 04             	sub    $0x4,%esp
 483:	8d 55 e7             	lea    -0x19(%ebp),%edx
 486:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 48a:	6a 01                	push   $0x1
 48c:	52                   	push   %edx
 48d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 490:	57                   	push   %edi
 491:	e8 2d fe ff ff       	call   2c3 <write>
 496:	83 c4 0c             	add    $0xc,%esp
 499:	88 5d e7             	mov    %bl,-0x19(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4a1:	52                   	push   %edx
 4a2:	57                   	push   %edi
 4a3:	e8 1b fe ff ff       	call   2c3 <write>
        putc(fd, c);
 4a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ab:	31 d2                	xor    %edx,%edx
 4ad:	eb 8e                	jmp    43d <printf+0x4d>
 4af:	90                   	nop
        printint(fd, *ap, 16, 0);
 4b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4b3:	83 ec 0c             	sub    $0xc,%esp
 4b6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bb:	8b 13                	mov    (%ebx),%edx
 4bd:	6a 00                	push   $0x0
 4bf:	89 f8                	mov    %edi,%eax
        ap++;
 4c1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 4c4:	e8 87 fe ff ff       	call   350 <printint>
        ap++;
 4c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cf:	31 d2                	xor    %edx,%edx
 4d1:	e9 67 ff ff ff       	jmp    43d <printf+0x4d>
        s = (char*)*ap;
 4d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4d9:	8b 18                	mov    (%eax),%ebx
        ap++;
 4db:	83 c0 04             	add    $0x4,%eax
 4de:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4e1:	85 db                	test   %ebx,%ebx
 4e3:	0f 84 87 00 00 00    	je     570 <printf+0x180>
        while(*s != 0){
 4e9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 4ec:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 4ee:	84 c0                	test   %al,%al
 4f0:	0f 84 47 ff ff ff    	je     43d <printf+0x4d>
 4f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4f9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4fc:	89 de                	mov    %ebx,%esi
 4fe:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 500:	83 ec 04             	sub    $0x4,%esp
 503:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 506:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 509:	6a 01                	push   $0x1
 50b:	53                   	push   %ebx
 50c:	57                   	push   %edi
 50d:	e8 b1 fd ff ff       	call   2c3 <write>
        while(*s != 0){
 512:	0f b6 06             	movzbl (%esi),%eax
 515:	83 c4 10             	add    $0x10,%esp
 518:	84 c0                	test   %al,%al
 51a:	75 e4                	jne    500 <printf+0x110>
      state = 0;
 51c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 17 ff ff ff       	jmp    43d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 526:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 529:	83 ec 0c             	sub    $0xc,%esp
 52c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 531:	8b 13                	mov    (%ebx),%edx
 533:	6a 01                	push   $0x1
 535:	eb 88                	jmp    4bf <printf+0xcf>
        putc(fd, *ap);
 537:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 53a:	83 ec 04             	sub    $0x4,%esp
 53d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 540:	8b 03                	mov    (%ebx),%eax
        ap++;
 542:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 545:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 548:	6a 01                	push   $0x1
 54a:	52                   	push   %edx
 54b:	57                   	push   %edi
 54c:	e8 72 fd ff ff       	call   2c3 <write>
        ap++;
 551:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 554:	83 c4 10             	add    $0x10,%esp
      state = 0;
 557:	31 d2                	xor    %edx,%edx
 559:	e9 df fe ff ff       	jmp    43d <printf+0x4d>
 55e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 5d e7             	mov    %bl,-0x19(%ebp)
 566:	8d 55 e7             	lea    -0x19(%ebp),%edx
 569:	6a 01                	push   $0x1
 56b:	e9 31 ff ff ff       	jmp    4a1 <printf+0xb1>
 570:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 575:	bb 0c 07 00 00       	mov    $0x70c,%ebx
 57a:	e9 77 ff ff ff       	jmp    4f6 <printf+0x106>
 57f:	90                   	nop

00000580 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 580:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	a1 18 0a 00 00       	mov    0xa18,%eax
{
 586:	89 e5                	mov    %esp,%ebp
 588:	57                   	push   %edi
 589:	56                   	push   %esi
 58a:	53                   	push   %ebx
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 58e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 598:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59a:	39 c8                	cmp    %ecx,%eax
 59c:	73 32                	jae    5d0 <free+0x50>
 59e:	39 d1                	cmp    %edx,%ecx
 5a0:	72 04                	jb     5a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a2:	39 d0                	cmp    %edx,%eax
 5a4:	72 32                	jb     5d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ac:	39 fa                	cmp    %edi,%edx
 5ae:	74 30                	je     5e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5b3:	8b 50 04             	mov    0x4(%eax),%edx
 5b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b9:	39 f1                	cmp    %esi,%ecx
 5bb:	74 3a                	je     5f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5bd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5bf:	5b                   	pop    %ebx
  freep = p;
 5c0:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 5c5:	5e                   	pop    %esi
 5c6:	5f                   	pop    %edi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 d0                	cmp    %edx,%eax
 5d2:	72 04                	jb     5d8 <free+0x58>
 5d4:	39 d1                	cmp    %edx,%ecx
 5d6:	72 ce                	jb     5a6 <free+0x26>
{
 5d8:	89 d0                	mov    %edx,%eax
 5da:	eb bc                	jmp    598 <free+0x18>
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 5e0:	03 72 04             	add    0x4(%edx),%esi
 5e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	8b 12                	mov    (%edx),%edx
 5ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 50 04             	mov    0x4(%eax),%edx
 5f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f3:	39 f1                	cmp    %esi,%ecx
 5f5:	75 c6                	jne    5bd <free+0x3d>
    p->s.size += bp->s.size;
 5f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 5fa:	a3 18 0a 00 00       	mov    %eax,0xa18
    p->s.size += bp->s.size;
 5ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 602:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 605:	89 08                	mov    %ecx,(%eax)
}
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000610 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 61c:	8b 15 18 0a 00 00    	mov    0xa18,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 622:	8d 78 07             	lea    0x7(%eax),%edi
 625:	c1 ef 03             	shr    $0x3,%edi
 628:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 62b:	85 d2                	test   %edx,%edx
 62d:	0f 84 8d 00 00 00    	je     6c0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 633:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 635:	8b 48 04             	mov    0x4(%eax),%ecx
 638:	39 f9                	cmp    %edi,%ecx
 63a:	73 64                	jae    6a0 <malloc+0x90>
  if(nu < 4096)
 63c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 641:	39 df                	cmp    %ebx,%edi
 643:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 646:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 64d:	eb 0a                	jmp    659 <malloc+0x49>
 64f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 650:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 652:	8b 48 04             	mov    0x4(%eax),%ecx
 655:	39 f9                	cmp    %edi,%ecx
 657:	73 47                	jae    6a0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 659:	89 c2                	mov    %eax,%edx
 65b:	3b 05 18 0a 00 00    	cmp    0xa18,%eax
 661:	75 ed                	jne    650 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	56                   	push   %esi
 667:	e8 bf fc ff ff       	call   32b <sbrk>
  if(p == (char*)-1)
 66c:	83 c4 10             	add    $0x10,%esp
 66f:	83 f8 ff             	cmp    $0xffffffff,%eax
 672:	74 1c                	je     690 <malloc+0x80>
  hp->s.size = nu;
 674:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 677:	83 ec 0c             	sub    $0xc,%esp
 67a:	83 c0 08             	add    $0x8,%eax
 67d:	50                   	push   %eax
 67e:	e8 fd fe ff ff       	call   580 <free>
  return freep;
 683:	8b 15 18 0a 00 00    	mov    0xa18,%edx
      if((p = morecore(nunits)) == 0)
 689:	83 c4 10             	add    $0x10,%esp
 68c:	85 d2                	test   %edx,%edx
 68e:	75 c0                	jne    650 <malloc+0x40>
        return 0;
  }
}
 690:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 693:	31 c0                	xor    %eax,%eax
}
 695:	5b                   	pop    %ebx
 696:	5e                   	pop    %esi
 697:	5f                   	pop    %edi
 698:	5d                   	pop    %ebp
 699:	c3                   	ret
 69a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6a0:	39 cf                	cmp    %ecx,%edi
 6a2:	74 4c                	je     6f0 <malloc+0xe0>
        p->s.size -= nunits;
 6a4:	29 f9                	sub    %edi,%ecx
 6a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6ac:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6af:	89 15 18 0a 00 00    	mov    %edx,0xa18
}
 6b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6b8:	83 c0 08             	add    $0x8,%eax
}
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6c0:	c7 05 18 0a 00 00 1c 	movl   $0xa1c,0xa18
 6c7:	0a 00 00 
    base.s.size = 0;
 6ca:	b8 1c 0a 00 00       	mov    $0xa1c,%eax
    base.s.ptr = freep = prevp = &base;
 6cf:	c7 05 1c 0a 00 00 1c 	movl   $0xa1c,0xa1c
 6d6:	0a 00 00 
    base.s.size = 0;
 6d9:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 6e0:	00 00 00 
    if(p->s.size >= nunits){
 6e3:	e9 54 ff ff ff       	jmp    63c <malloc+0x2c>
 6e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ef:	00 
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 08                	mov    (%eax),%ecx
 6f2:	89 0a                	mov    %ecx,(%edx)
 6f4:	eb b9                	jmp    6af <malloc+0x9f>
