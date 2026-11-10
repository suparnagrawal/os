
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 55 11 80       	mov    $0x801155d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 31 10 80       	mov    $0x80103130,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 74 10 80       	push   $0x80107400
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 b5 44 00 00       	call   80104510 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 74 10 80       	push   $0x80107407
80100097:	50                   	push   %eax
80100098:	e8 43 43 00 00       	call   801043e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 17 46 00 00       	call   80104700 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 39 45 00 00       	call   801046a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 42 00 00       	call   80104420 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 22 00 00       	call   801023d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 74 10 80       	push   $0x8010740e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 42 00 00       	call   801044c0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 21 00 00       	jmp    801023d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 74 10 80       	push   $0x8010741f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 42 00 00       	call   801044c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 42 00 00       	call   80104480 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 e0 44 00 00       	call   80104700 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 32 44 00 00       	jmp    801046a0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 74 10 80       	push   $0x80107426
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 16 00 00       	call   80101980 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 5b 44 00 00       	call   80104700 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 ae 3e 00 00       	call   80104180 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 37 00 00       	call   80103ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 a5 43 00 00       	call   801046a0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 15 00 00       	call   801018a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 4f 43 00 00       	call   801046a0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 15 00 00       	call   801018a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 26 00 00       	call   801029d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 74 10 80       	push   $0x8010742d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 00 78 10 80 	movl   $0x80107800,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 41 00 00       	call   80104530 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 74 10 80       	push   $0x80107441
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 1c 5b 00 00       	call   80105f40 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 51 5a 00 00       	call   80105f40 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 45 5a 00 00       	call   80105f40 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 39 5a 00 00       	call   80105f40 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 43 00 00       	call   80104890 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 42 00 00       	call   80104800 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 74 10 80       	push   $0x80107445
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 13 00 00       	call   80101980 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 30 41 00 00       	call   80104700 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 97 40 00 00       	call   801046a0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 12 00 00       	call   801018a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 14 79 10 80 	movzbl -0x7fef86ec(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 23 3f 00 00       	call   80104700 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 a0 3e 00 00       	call   801046a0 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 58 74 10 80       	mov    $0x80107458,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 5f 74 10 80       	push   $0x8010745f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ef 10 80       	push   $0x8010ef20
801008b3:	e8 48 3e 00 00       	call   80104700 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ef 10 80       	push   $0x8010ef20
801008ed:	e8 ae 3d 00 00       	call   801046a0 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100914:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100933:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010094a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010095e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100998:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a05:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a27:	68 00 ef 10 80       	push   $0x8010ef00
80100a2c:	e8 0f 38 00 00       	call   80104240 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 cc 38 00 00       	jmp    80104320 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 74 10 80       	push   $0x80107468
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 9b 3a 00 00       	call   80104510 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 1a 00 00       	call   80102560 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "elf.h"
#include "taint.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 ef 2f 00 00       	call   80103ab0 <myproc>

  if(curproc->tainted == TAINT_UNTRUSTED){
80100ac1:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
  struct proc *curproc = myproc();
80100ac5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  if(curproc->tainted == TAINT_UNTRUSTED){
80100acb:	0f 84 67 01 00 00    	je     80100c38 <exec+0x188>
      cprintf("exec: refused tainted exec of %s\n", path);
      return -1;
    }
  }

  begin_op();
80100ad1:	e8 6a 23 00 00       	call   80102e40 <begin_op>

  if((ip = namei(path)) == 0){
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	ff 75 08             	push   0x8(%ebp)
80100adc:	e8 9f 16 00 00       	call   80102180 <namei>
80100ae1:	83 c4 10             	add    $0x10,%esp
80100ae4:	89 c7                	mov    %eax,%edi
80100ae6:	85 c0                	test   %eax,%eax
80100ae8:	0f 84 6c 03 00 00    	je     80100e5a <exec+0x3aa>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100aee:	83 ec 0c             	sub    $0xc,%esp
80100af1:	50                   	push   %eax
80100af2:	e8 a9 0d 00 00       	call   801018a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100af7:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100afd:	6a 34                	push   $0x34
80100aff:	6a 00                	push   $0x0
80100b01:	50                   	push   %eax
80100b02:	57                   	push   %edi
80100b03:	e8 a8 10 00 00       	call   80101bb0 <readi>
80100b08:	83 c4 20             	add    $0x20,%esp
80100b0b:	83 f8 34             	cmp    $0x34,%eax
80100b0e:	0f 85 07 01 00 00    	jne    80100c1b <exec+0x16b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b14:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b1b:	45 4c 46 
80100b1e:	0f 85 f7 00 00 00    	jne    80100c1b <exec+0x16b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b24:	e8 87 65 00 00       	call   801070b0 <setupkvm>
80100b29:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b2f:	85 c0                	test   %eax,%eax
80100b31:	0f 84 e4 00 00 00    	je     80100c1b <exec+0x16b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b37:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b3e:	00 
80100b3f:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b45:	0f 84 df 02 00 00    	je     80100e2a <exec+0x37a>
  sz = 0;
80100b4b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b52:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b55:	31 db                	xor    %ebx,%ebx
80100b57:	e9 92 00 00 00       	jmp    80100bee <exec+0x13e>
80100b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b67:	75 70                	jne    80100bd9 <exec+0x129>
      continue;
    if(ph.memsz < ph.filesz)
80100b69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b75:	0f 82 8f 00 00 00    	jb     80100c0a <exec+0x15a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b7b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b81:	0f 82 83 00 00 00    	jb     80100c0a <exec+0x15a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b87:	83 ec 04             	sub    $0x4,%esp
80100b8a:	50                   	push   %eax
80100b8b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b91:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b97:	e8 44 63 00 00       	call   80106ee0 <allocuvm>
80100b9c:	83 c4 10             	add    $0x10,%esp
80100b9f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba5:	85 c0                	test   %eax,%eax
80100ba7:	74 61                	je     80100c0a <exec+0x15a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ba9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100baf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bb4:	75 54                	jne    80100c0a <exec+0x15a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bb6:	83 ec 0c             	sub    $0xc,%esp
80100bb9:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bbf:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bc5:	57                   	push   %edi
80100bc6:	50                   	push   %eax
80100bc7:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bcd:	e8 3e 62 00 00       	call   80106e10 <loaduvm>
80100bd2:	83 c4 20             	add    $0x20,%esp
80100bd5:	85 c0                	test   %eax,%eax
80100bd7:	78 31                	js     80100c0a <exec+0x15a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd9:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100be0:	83 c3 01             	add    $0x1,%ebx
80100be3:	83 c6 20             	add    $0x20,%esi
80100be6:	39 d8                	cmp    %ebx,%eax
80100be8:	0f 8e 82 00 00 00    	jle    80100c70 <exec+0x1c0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bee:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bf4:	6a 20                	push   $0x20
80100bf6:	56                   	push   %esi
80100bf7:	50                   	push   %eax
80100bf8:	57                   	push   %edi
80100bf9:	e8 b2 0f 00 00       	call   80101bb0 <readi>
80100bfe:	83 c4 10             	add    $0x10,%esp
80100c01:	83 f8 20             	cmp    $0x20,%eax
80100c04:	0f 84 56 ff ff ff    	je     80100b60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c0a:	83 ec 0c             	sub    $0xc,%esp
80100c0d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c13:	e8 18 64 00 00       	call   80107030 <freevm>
  if(ip){
80100c18:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c1b:	83 ec 0c             	sub    $0xc,%esp
80100c1e:	57                   	push   %edi
80100c1f:	e8 0c 0f 00 00       	call   80101b30 <iunlockput>
    end_op();
80100c24:	e8 87 22 00 00       	call   80102eb0 <end_op>
80100c29:	83 c4 10             	add    $0x10,%esp
80100c2c:	e9 1a 01 00 00       	jmp    80100d4b <exec+0x29b>
80100c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strncmp(path, "/safe/", 6) != 0){
80100c38:	83 ec 04             	sub    $0x4,%esp
80100c3b:	6a 06                	push   $0x6
80100c3d:	68 70 74 10 80       	push   $0x80107470
80100c42:	ff 75 08             	push   0x8(%ebp)
80100c45:	e8 b6 3c 00 00       	call   80104900 <strncmp>
80100c4a:	83 c4 10             	add    $0x10,%esp
80100c4d:	85 c0                	test   %eax,%eax
80100c4f:	0f 84 7c fe ff ff    	je     80100ad1 <exec+0x21>
      cprintf("exec: refused tainted exec of %s\n", path);
80100c55:	83 ec 08             	sub    $0x8,%esp
80100c58:	ff 75 08             	push   0x8(%ebp)
80100c5b:	68 28 79 10 80       	push   $0x80107928
80100c60:	e8 4b fa ff ff       	call   801006b0 <cprintf>
      return -1;
80100c65:	83 c4 10             	add    $0x10,%esp
80100c68:	e9 de 00 00 00       	jmp    80100d4b <exec+0x29b>
80100c6d:	8d 76 00             	lea    0x0(%esi),%esi
  sz = PGROUNDUP(sz);
80100c70:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c76:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c7c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c82:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c88:	83 ec 0c             	sub    $0xc,%esp
80100c8b:	57                   	push   %edi
80100c8c:	e8 9f 0e 00 00       	call   80101b30 <iunlockput>
  end_op();
80100c91:	e8 1a 22 00 00       	call   80102eb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c96:	83 c4 0c             	add    $0xc,%esp
80100c99:	53                   	push   %ebx
80100c9a:	56                   	push   %esi
80100c9b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ca1:	56                   	push   %esi
80100ca2:	e8 39 62 00 00       	call   80106ee0 <allocuvm>
80100ca7:	83 c4 10             	add    $0x10,%esp
80100caa:	89 c7                	mov    %eax,%edi
80100cac:	85 c0                	test   %eax,%eax
80100cae:	0f 84 86 00 00 00    	je     80100d3a <exec+0x28a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb4:	83 ec 08             	sub    $0x8,%esp
80100cb7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100cbd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cbf:	50                   	push   %eax
80100cc0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cc1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc3:	e8 88 64 00 00       	call   80107150 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	8b 10                	mov    (%eax),%edx
80100cd0:	85 d2                	test   %edx,%edx
80100cd2:	0f 84 5e 01 00 00    	je     80100e36 <exec+0x386>
80100cd8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cde:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ce1:	eb 23                	jmp    80100d06 <exec+0x256>
80100ce3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ce8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100ceb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cf2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cf8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cfb:	85 d2                	test   %edx,%edx
80100cfd:	74 59                	je     80100d58 <exec+0x2a8>
    if(argc >= MAXARG)
80100cff:	83 f8 20             	cmp    $0x20,%eax
80100d02:	74 36                	je     80100d3a <exec+0x28a>
80100d04:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d06:	83 ec 0c             	sub    $0xc,%esp
80100d09:	52                   	push   %edx
80100d0a:	e8 e1 3c 00 00       	call   801049f0 <strlen>
80100d0f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d11:	58                   	pop    %eax
80100d12:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d15:	83 eb 01             	sub    $0x1,%ebx
80100d18:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1b:	e8 d0 3c 00 00       	call   801049f0 <strlen>
80100d20:	83 c0 01             	add    $0x1,%eax
80100d23:	50                   	push   %eax
80100d24:	ff 34 b7             	push   (%edi,%esi,4)
80100d27:	53                   	push   %ebx
80100d28:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d2e:	e8 ed 65 00 00       	call   80107320 <copyout>
80100d33:	83 c4 20             	add    $0x20,%esp
80100d36:	85 c0                	test   %eax,%eax
80100d38:	79 ae                	jns    80100ce8 <exec+0x238>
    freevm(pgdir);
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d43:	e8 e8 62 00 00       	call   80107030 <freevm>
80100d48:	83 c4 10             	add    $0x10,%esp
      return -1;
80100d4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d53:	5b                   	pop    %ebx
80100d54:	5e                   	pop    %esi
80100d55:	5f                   	pop    %edi
80100d56:	5d                   	pop    %ebp
80100d57:	c3                   	ret
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d58:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d5f:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d65:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d6b:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d6e:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d71:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d78:	00 00 00 00 
  ustack[1] = argc;
80100d7c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d82:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d89:	ff ff ff 
  ustack[1] = argc;
80100d8c:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d92:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d94:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d96:	29 d0                	sub    %edx,%eax
80100d98:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d9e:	56                   	push   %esi
80100d9f:	51                   	push   %ecx
80100da0:	53                   	push   %ebx
80100da1:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100da7:	e8 74 65 00 00       	call   80107320 <copyout>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	85 c0                	test   %eax,%eax
80100db1:	78 87                	js     80100d3a <exec+0x28a>
  for(last=s=path; *s; s++)
80100db3:	8b 45 08             	mov    0x8(%ebp),%eax
80100db6:	8b 55 08             	mov    0x8(%ebp),%edx
80100db9:	0f b6 00             	movzbl (%eax),%eax
80100dbc:	84 c0                	test   %al,%al
80100dbe:	74 17                	je     80100dd7 <exec+0x327>
80100dc0:	89 d1                	mov    %edx,%ecx
80100dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100dc8:	83 c1 01             	add    $0x1,%ecx
80100dcb:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100dcd:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100dd0:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dd3:	84 c0                	test   %al,%al
80100dd5:	75 f1                	jne    80100dc8 <exec+0x318>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dd7:	83 ec 04             	sub    $0x4,%esp
80100dda:	6a 10                	push   $0x10
80100ddc:	52                   	push   %edx
80100ddd:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100de3:	8d 46 6c             	lea    0x6c(%esi),%eax
80100de6:	50                   	push   %eax
80100de7:	e8 c4 3b 00 00       	call   801049b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100dec:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100df2:	89 f0                	mov    %esi,%eax
80100df4:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100df7:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100df9:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dfc:	89 c1                	mov    %eax,%ecx
80100dfe:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e04:	8b 40 18             	mov    0x18(%eax),%eax
80100e07:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e0a:	8b 41 18             	mov    0x18(%ecx),%eax
80100e0d:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e10:	89 0c 24             	mov    %ecx,(%esp)
80100e13:	e8 68 5e 00 00       	call   80106c80 <switchuvm>
  freevm(oldpgdir);
80100e18:	89 34 24             	mov    %esi,(%esp)
80100e1b:	e8 10 62 00 00       	call   80107030 <freevm>
  return 0;
80100e20:	83 c4 10             	add    $0x10,%esp
80100e23:	31 c0                	xor    %eax,%eax
80100e25:	e9 26 ff ff ff       	jmp    80100d50 <exec+0x2a0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e2a:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e2f:	31 f6                	xor    %esi,%esi
80100e31:	e9 52 fe ff ff       	jmp    80100c88 <exec+0x1d8>
  for(argc = 0; argv[argc]; argc++) {
80100e36:	be 10 00 00 00       	mov    $0x10,%esi
80100e3b:	ba 04 00 00 00       	mov    $0x4,%edx
80100e40:	b8 03 00 00 00       	mov    $0x3,%eax
80100e45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e4c:	00 00 00 
80100e4f:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e55:	e9 17 ff ff ff       	jmp    80100d71 <exec+0x2c1>
    end_op();
80100e5a:	e8 51 20 00 00       	call   80102eb0 <end_op>
    cprintf("exec: fail\n");
80100e5f:	83 ec 0c             	sub    $0xc,%esp
80100e62:	68 77 74 10 80       	push   $0x80107477
80100e67:	e8 44 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e6c:	83 c4 10             	add    $0x10,%esp
80100e6f:	e9 d7 fe ff ff       	jmp    80100d4b <exec+0x29b>
80100e74:	66 90                	xchg   %ax,%ax
80100e76:	66 90                	xchg   %ax,%ax
80100e78:	66 90                	xchg   %ax,%ax
80100e7a:	66 90                	xchg   %ax,%ax
80100e7c:	66 90                	xchg   %ax,%ax
80100e7e:	66 90                	xchg   %ax,%ax

80100e80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e86:	68 83 74 10 80       	push   $0x80107483
80100e8b:	68 60 ef 10 80       	push   $0x8010ef60
80100e90:	e8 7b 36 00 00       	call   80104510 <initlock>
}
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	c9                   	leave
80100e99:	c3                   	ret
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ea0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100ea9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100eac:	68 60 ef 10 80       	push   $0x8010ef60
80100eb1:	e8 4a 38 00 00       	call   80104700 <acquire>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb 10                	jmp    80100ecb <filealloc+0x2b>
80100ebb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec0:	83 c3 18             	add    $0x18,%ebx
80100ec3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ec9:	74 25                	je     80100ef0 <filealloc+0x50>
    if(f->ref == 0){
80100ecb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	75 ee                	jne    80100ec0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ed5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edc:	68 60 ef 10 80       	push   $0x8010ef60
80100ee1:	e8 ba 37 00 00       	call   801046a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ee6:	89 d8                	mov    %ebx,%eax
      return f;
80100ee8:	83 c4 10             	add    $0x10,%esp
}
80100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eee:	c9                   	leave
80100eef:	c3                   	ret
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ef3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ef5:	68 60 ef 10 80       	push   $0x8010ef60
80100efa:	e8 a1 37 00 00       	call   801046a0 <release>
}
80100eff:	89 d8                	mov    %ebx,%eax
  return 0;
80100f01:	83 c4 10             	add    $0x10,%esp
}
80100f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f07:	c9                   	leave
80100f08:	c3                   	ret
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 60 ef 10 80       	push   $0x8010ef60
80100f1f:	e8 dc 37 00 00       	call   80104700 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 1a                	jle    80100f48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f37:	68 60 ef 10 80       	push   $0x8010ef60
80100f3c:	e8 5f 37 00 00       	call   801046a0 <release>
  return f;
}
80100f41:	89 d8                	mov    %ebx,%eax
80100f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f46:	c9                   	leave
80100f47:	c3                   	ret
    panic("filedup");
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	68 8a 74 10 80       	push   $0x8010748a
80100f50:	e8 2b f4 ff ff       	call   80100380 <panic>
80100f55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f5c:	00 
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi

80100f60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 28             	sub    $0x28,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f6c:	68 60 ef 10 80       	push   $0x8010ef60
80100f71:	e8 8a 37 00 00       	call   80104700 <acquire>
  if(f->ref < 1)
80100f76:	8b 53 04             	mov    0x4(%ebx),%edx
80100f79:	83 c4 10             	add    $0x10,%esp
80100f7c:	85 d2                	test   %edx,%edx
80100f7e:	0f 8e a5 00 00 00    	jle    80101029 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f84:	83 ea 01             	sub    $0x1,%edx
80100f87:	89 53 04             	mov    %edx,0x4(%ebx)
80100f8a:	75 44                	jne    80100fd0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f8c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f93:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f9e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fa1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa7:	68 60 ef 10 80       	push   $0x8010ef60
80100fac:	e8 ef 36 00 00       	call   801046a0 <release>

  if(ff.type == FD_PIPE)
80100fb1:	83 c4 10             	add    $0x10,%esp
80100fb4:	83 ff 01             	cmp    $0x1,%edi
80100fb7:	74 57                	je     80101010 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fb9:	83 ff 02             	cmp    $0x2,%edi
80100fbc:	74 2a                	je     80100fe8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
80100fc5:	c3                   	ret
80100fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fcd:	00 
80100fce:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fd0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fda:	5b                   	pop    %ebx
80100fdb:	5e                   	pop    %esi
80100fdc:	5f                   	pop    %edi
80100fdd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fde:	e9 bd 36 00 00       	jmp    801046a0 <release>
80100fe3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fe8:	e8 53 1e 00 00       	call   80102e40 <begin_op>
    iput(ff.ip);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	ff 75 e0             	push   -0x20(%ebp)
80100ff3:	e8 d8 09 00 00       	call   801019d0 <iput>
    end_op();
80100ff8:	83 c4 10             	add    $0x10,%esp
}
80100ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffe:	5b                   	pop    %ebx
80100fff:	5e                   	pop    %esi
80101000:	5f                   	pop    %edi
80101001:	5d                   	pop    %ebp
    end_op();
80101002:	e9 a9 1e 00 00       	jmp    80102eb0 <end_op>
80101007:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010100e:	00 
8010100f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101010:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101014:	83 ec 08             	sub    $0x8,%esp
80101017:	53                   	push   %ebx
80101018:	56                   	push   %esi
80101019:	e8 02 26 00 00       	call   80103620 <pipeclose>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
80101028:	c3                   	ret
    panic("fileclose");
80101029:	83 ec 0c             	sub    $0xc,%esp
8010102c:	68 92 74 10 80       	push   $0x80107492
80101031:	e8 4a f3 ff ff       	call   80100380 <panic>
80101036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010103d:	00 
8010103e:	66 90                	xchg   %ax,%ax

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	push   0x10(%ebx)
80101055:	e8 46 08 00 00       	call   801018a0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	push   0xc(%ebp)
8010105f:	ff 73 10             	push   0x10(%ebx)
80101062:	e8 19 0b 00 00       	call   80101b80 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	push   0x10(%ebx)
8010106b:	e8 10 09 00 00       	call   80101980 <iunlock>
    return 0;
  }
  return -1;
}
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	31 c0                	xor    %eax,%eax
}
80101078:	c9                   	leave
80101079:	c3                   	ret
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	c9                   	leave
80101089:	c3                   	ret
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	0f 84 8c 00 00 00    	je     80101138 <fileread+0xa8>
    return -1;
  if(f->type == FD_PIPE)
801010ac:	8b 03                	mov    (%ebx),%eax
801010ae:	83 f8 01             	cmp    $0x1,%eax
801010b1:	74 6d                	je     80101120 <fileread+0x90>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010b3:	83 f8 02             	cmp    $0x2,%eax
801010b6:	0f 85 83 00 00 00    	jne    8010113f <fileread+0xaf>
    ilock(f->ip);
801010bc:	83 ec 0c             	sub    $0xc,%esp
801010bf:	ff 73 10             	push   0x10(%ebx)
801010c2:	e8 d9 07 00 00       	call   801018a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010c7:	57                   	push   %edi
801010c8:	ff 73 14             	push   0x14(%ebx)
801010cb:	56                   	push   %esi
801010cc:	ff 73 10             	push   0x10(%ebx)
801010cf:	e8 dc 0a 00 00       	call   80101bb0 <readi>
801010d4:	83 c4 20             	add    $0x20,%esp
801010d7:	89 c6                	mov    %eax,%esi
801010d9:	85 c0                	test   %eax,%eax
801010db:	7e 3b                	jle    80101118 <fileread+0x88>
      f->off += r;
801010dd:	01 43 14             	add    %eax,0x14(%ebx)
    if(r > 0 && f->ip->type == T_FILE && f->ip->untrusted == TAINT_UNTRUSTED)
801010e0:	8b 43 10             	mov    0x10(%ebx),%eax
801010e3:	66 83 78 50 02       	cmpw   $0x2,0x50(%eax)
801010e8:	74 16                	je     80101100 <fileread+0x70>
      myproc()->tainted = TAINT_UNTRUSTED;
    iunlock(f->ip);
801010ea:	83 ec 0c             	sub    $0xc,%esp
801010ed:	50                   	push   %eax
801010ee:	e8 8d 08 00 00       	call   80101980 <iunlock>
    return r;
801010f3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	89 f0                	mov    %esi,%eax
801010fb:	5b                   	pop    %ebx
801010fc:	5e                   	pop    %esi
801010fd:	5f                   	pop    %edi
801010fe:	5d                   	pop    %ebp
801010ff:	c3                   	ret
    if(r > 0 && f->ip->type == T_FILE && f->ip->untrusted == TAINT_UNTRUSTED)
80101100:	66 83 78 58 01       	cmpw   $0x1,0x58(%eax)
80101105:	75 e3                	jne    801010ea <fileread+0x5a>
      myproc()->tainted = TAINT_UNTRUSTED;
80101107:	e8 a4 29 00 00       	call   80103ab0 <myproc>
8010110c:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
80101113:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    iunlock(f->ip);
80101118:	8b 43 10             	mov    0x10(%ebx),%eax
8010111b:	eb cd                	jmp    801010ea <fileread+0x5a>
8010111d:	8d 76 00             	lea    0x0(%esi),%esi
    return piperead(f->pipe, addr, n);
80101120:	8b 43 0c             	mov    0xc(%ebx),%eax
80101123:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101129:	5b                   	pop    %ebx
8010112a:	5e                   	pop    %esi
8010112b:	5f                   	pop    %edi
8010112c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010112d:	e9 ae 26 00 00       	jmp    801037e0 <piperead>
80101132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101138:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010113d:	eb b7                	jmp    801010f6 <fileread+0x66>
  panic("fileread");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 9c 74 10 80       	push   $0x8010749c
80101147:	e8 34 f2 ff ff       	call   80100380 <panic>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101150 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	57                   	push   %edi
80101154:	56                   	push   %esi
80101155:	53                   	push   %ebx
80101156:	83 ec 1c             	sub    $0x1c,%esp
80101159:	8b 45 0c             	mov    0xc(%ebp),%eax
8010115c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010115f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101162:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101165:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010116c:	0f 84 f3 00 00 00    	je     80101265 <filewrite+0x115>
    return -1;
  if(f->type == FD_PIPE)
80101172:	8b 03                	mov    (%ebx),%eax
80101174:	83 f8 01             	cmp    $0x1,%eax
80101177:	0f 84 23 01 00 00    	je     801012a0 <filewrite+0x150>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010117d:	83 f8 02             	cmp    $0x2,%eax
80101180:	0f 85 2c 01 00 00    	jne    801012b2 <filewrite+0x162>
    ilock(f->ip);
80101186:	83 ec 0c             	sub    $0xc,%esp
80101189:	ff 73 10             	push   0x10(%ebx)
8010118c:	e8 0f 07 00 00       	call   801018a0 <ilock>
    if(myproc()->tainted == TAINT_UNTRUSTED && f->ip->type == T_FILE && f->ip->untrusted != TAINT_UNTRUSTED){
80101191:	e8 1a 29 00 00       	call   80103ab0 <myproc>
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
8010119d:	8b 43 10             	mov    0x10(%ebx),%eax
801011a0:	75 0b                	jne    801011ad <filewrite+0x5d>
801011a2:	66 83 78 50 02       	cmpw   $0x2,0x50(%eax)
801011a7:	0f 84 cb 00 00 00    	je     80101278 <filewrite+0x128>
      iunlock(f->ip);
      cprintf("filewrite: refused tainted write to clean file\n");
      return -1;
    }
    iunlock(f->ip);
801011ad:	83 ec 0c             	sub    $0xc,%esp
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
801011b0:	31 f6                	xor    %esi,%esi
    iunlock(f->ip);
801011b2:	50                   	push   %eax
801011b3:	e8 c8 07 00 00       	call   80101980 <iunlock>
    while(i < n){
801011b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011bb:	83 c4 10             	add    $0x10,%esp
801011be:	85 c0                	test   %eax,%eax
801011c0:	7f 35                	jg     801011f7 <filewrite+0xa7>
801011c2:	e9 99 00 00 00       	jmp    80101260 <filewrite+0x110>
801011c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801011ce:	00 
801011cf:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011d0:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801011d3:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011d9:	ff 73 10             	push   0x10(%ebx)
801011dc:	e8 9f 07 00 00       	call   80101980 <iunlock>
      end_op();
801011e1:	e8 ca 1c 00 00       	call   80102eb0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801011e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011e9:	83 c4 10             	add    $0x10,%esp
801011ec:	39 c7                	cmp    %eax,%edi
801011ee:	75 5c                	jne    8010124c <filewrite+0xfc>
        panic("short filewrite");
      i += r;
801011f0:	01 fe                	add    %edi,%esi
    while(i < n){
801011f2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011f5:	7e 69                	jle    80101260 <filewrite+0x110>
      int n1 = n - i;
801011f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801011fa:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801011ff:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101201:	39 c7                	cmp    %eax,%edi
80101203:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80101206:	e8 35 1c 00 00       	call   80102e40 <begin_op>
      ilock(f->ip);
8010120b:	83 ec 0c             	sub    $0xc,%esp
8010120e:	ff 73 10             	push   0x10(%ebx)
80101211:	e8 8a 06 00 00       	call   801018a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101216:	57                   	push   %edi
80101217:	ff 73 14             	push   0x14(%ebx)
8010121a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010121d:	01 f0                	add    %esi,%eax
8010121f:	50                   	push   %eax
80101220:	ff 73 10             	push   0x10(%ebx)
80101223:	e8 88 0a 00 00       	call   80101cb0 <writei>
80101228:	83 c4 20             	add    $0x20,%esp
8010122b:	85 c0                	test   %eax,%eax
8010122d:	7f a1                	jg     801011d0 <filewrite+0x80>
8010122f:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101232:	83 ec 0c             	sub    $0xc,%esp
80101235:	ff 73 10             	push   0x10(%ebx)
80101238:	e8 43 07 00 00       	call   80101980 <iunlock>
      end_op();
8010123d:	e8 6e 1c 00 00       	call   80102eb0 <end_op>
      if(r < 0)
80101242:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101245:	83 c4 10             	add    $0x10,%esp
80101248:	85 c0                	test   %eax,%eax
8010124a:	75 14                	jne    80101260 <filewrite+0x110>
        panic("short filewrite");
8010124c:	83 ec 0c             	sub    $0xc,%esp
8010124f:	68 a5 74 10 80       	push   $0x801074a5
80101254:	e8 27 f1 ff ff       	call   80100380 <panic>
80101259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101260:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101263:	74 05                	je     8010126a <filewrite+0x11a>
    return -1;
80101265:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret
80101274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->tainted == TAINT_UNTRUSTED && f->ip->type == T_FILE && f->ip->untrusted != TAINT_UNTRUSTED){
80101278:	66 83 78 58 01       	cmpw   $0x1,0x58(%eax)
8010127d:	0f 84 2a ff ff ff    	je     801011ad <filewrite+0x5d>
      iunlock(f->ip);
80101283:	83 ec 0c             	sub    $0xc,%esp
80101286:	50                   	push   %eax
80101287:	e8 f4 06 00 00       	call   80101980 <iunlock>
      cprintf("filewrite: refused tainted write to clean file\n");
8010128c:	c7 04 24 4c 79 10 80 	movl   $0x8010794c,(%esp)
80101293:	e8 18 f4 ff ff       	call   801006b0 <cprintf>
      return -1;
80101298:	83 c4 10             	add    $0x10,%esp
8010129b:	eb c8                	jmp    80101265 <filewrite+0x115>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
    return pipewrite(f->pipe, addr, n);
801012a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801012a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a9:	5b                   	pop    %ebx
801012aa:	5e                   	pop    %esi
801012ab:	5f                   	pop    %edi
801012ac:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012ad:	e9 0e 24 00 00       	jmp    801036c0 <pipewrite>
  panic("filewrite");
801012b2:	83 ec 0c             	sub    $0xc,%esp
801012b5:	68 ab 74 10 80       	push   $0x801074ab
801012ba:	e8 c1 f0 ff ff       	call   80100380 <panic>
801012bf:	90                   	nop

801012c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012c9:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
801012cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012d2:	85 c9                	test   %ecx,%ecx
801012d4:	0f 84 8c 00 00 00    	je     80101366 <balloc+0xa6>
801012da:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801012dc:	89 f8                	mov    %edi,%eax
801012de:	83 ec 08             	sub    $0x8,%esp
801012e1:	89 fe                	mov    %edi,%esi
801012e3:	c1 f8 0c             	sar    $0xc,%eax
801012e6:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801012ec:	50                   	push   %eax
801012ed:	ff 75 dc             	push   -0x24(%ebp)
801012f0:	e8 db ed ff ff       	call   801000d0 <bread>
801012f5:	83 c4 10             	add    $0x10,%esp
801012f8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801012fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012fe:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101303:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101306:	31 c0                	xor    %eax,%eax
80101308:	eb 32                	jmp    8010133c <balloc+0x7c>
8010130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101310:	89 c1                	mov    %eax,%ecx
80101312:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101317:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010131a:	83 e1 07             	and    $0x7,%ecx
8010131d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010131f:	89 c1                	mov    %eax,%ecx
80101321:	c1 f9 03             	sar    $0x3,%ecx
80101324:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101329:	89 fa                	mov    %edi,%edx
8010132b:	85 df                	test   %ebx,%edi
8010132d:	74 49                	je     80101378 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010132f:	83 c0 01             	add    $0x1,%eax
80101332:	83 c6 01             	add    $0x1,%esi
80101335:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010133a:	74 07                	je     80101343 <balloc+0x83>
8010133c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010133f:	39 d6                	cmp    %edx,%esi
80101341:	72 cd                	jb     80101310 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101343:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101346:	83 ec 0c             	sub    $0xc,%esp
80101349:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010134c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101352:	e8 99 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101357:	83 c4 10             	add    $0x10,%esp
8010135a:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101360:	0f 82 76 ff ff ff    	jb     801012dc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	68 b5 74 10 80       	push   $0x801074b5
8010136e:	e8 0d f0 ff ff       	call   80100380 <panic>
80101373:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010137b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010137e:	09 da                	or     %ebx,%edx
80101380:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101384:	57                   	push   %edi
80101385:	e8 96 1c 00 00       	call   80103020 <log_write>
        brelse(bp);
8010138a:	89 3c 24             	mov    %edi,(%esp)
8010138d:	e8 5e ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101392:	58                   	pop    %eax
80101393:	5a                   	pop    %edx
80101394:	56                   	push   %esi
80101395:	ff 75 dc             	push   -0x24(%ebp)
80101398:	e8 33 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010139d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801013a0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013a2:	8d 40 5c             	lea    0x5c(%eax),%eax
801013a5:	68 00 02 00 00       	push   $0x200
801013aa:	6a 00                	push   $0x0
801013ac:	50                   	push   %eax
801013ad:	e8 4e 34 00 00       	call   80104800 <memset>
  log_write(bp);
801013b2:	89 1c 24             	mov    %ebx,(%esp)
801013b5:	e8 66 1c 00 00       	call   80103020 <log_write>
  brelse(bp);
801013ba:	89 1c 24             	mov    %ebx,(%esp)
801013bd:	e8 2e ee ff ff       	call   801001f0 <brelse>
}
801013c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c5:	89 f0                	mov    %esi,%eax
801013c7:	5b                   	pop    %ebx
801013c8:	5e                   	pop    %esi
801013c9:	5f                   	pop    %edi
801013ca:	5d                   	pop    %ebp
801013cb:	c3                   	ret
801013cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013d4:	31 ff                	xor    %edi,%edi
{
801013d6:	56                   	push   %esi
801013d7:	89 c6                	mov    %eax,%esi
801013d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013da:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801013df:	83 ec 28             	sub    $0x28,%esp
801013e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013e5:	68 60 f9 10 80       	push   $0x8010f960
801013ea:	e8 11 33 00 00       	call   80104700 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013f2:	83 c4 10             	add    $0x10,%esp
801013f5:	eb 1b                	jmp    80101412 <iget+0x42>
801013f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013fe:	00 
801013ff:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 33                	cmp    %esi,(%ebx)
80101402:	74 6c                	je     80101470 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101404:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010140a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101410:	74 26                	je     80101438 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101412:	8b 43 08             	mov    0x8(%ebx),%eax
80101415:	85 c0                	test   %eax,%eax
80101417:	7f e7                	jg     80101400 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101419:	85 ff                	test   %edi,%edi
8010141b:	75 e7                	jne    80101404 <iget+0x34>
8010141d:	85 c0                	test   %eax,%eax
8010141f:	75 76                	jne    80101497 <iget+0xc7>
      empty = ip;
80101421:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101423:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101429:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010142f:	75 e1                	jne    80101412 <iget+0x42>
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101438:	85 ff                	test   %edi,%edi
8010143a:	74 79                	je     801014b5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010143c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010143f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101441:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101444:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010144b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101452:	68 60 f9 10 80       	push   $0x8010f960
80101457:	e8 44 32 00 00       	call   801046a0 <release>

  return ip;
8010145c:	83 c4 10             	add    $0x10,%esp
}
8010145f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101462:	89 f8                	mov    %edi,%eax
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101470:	39 53 04             	cmp    %edx,0x4(%ebx)
80101473:	75 8f                	jne    80101404 <iget+0x34>
      ip->ref++;
80101475:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101478:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010147b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010147d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101480:	68 60 f9 10 80       	push   $0x8010f960
80101485:	e8 16 32 00 00       	call   801046a0 <release>
      return ip;
8010148a:	83 c4 10             	add    $0x10,%esp
}
8010148d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101490:	89 f8                	mov    %edi,%eax
80101492:	5b                   	pop    %ebx
80101493:	5e                   	pop    %esi
80101494:	5f                   	pop    %edi
80101495:	5d                   	pop    %ebp
80101496:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101497:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014a3:	74 10                	je     801014b5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a5:	8b 43 08             	mov    0x8(%ebx),%eax
801014a8:	85 c0                	test   %eax,%eax
801014aa:	0f 8f 50 ff ff ff    	jg     80101400 <iget+0x30>
801014b0:	e9 68 ff ff ff       	jmp    8010141d <iget+0x4d>
    panic("iget: no inodes");
801014b5:	83 ec 0c             	sub    $0xc,%esp
801014b8:	68 cb 74 10 80       	push   $0x801074cb
801014bd:	e8 be ee ff ff       	call   80100380 <panic>
801014c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014c9:	00 
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014d0 <bfree>:
{
801014d0:	55                   	push   %ebp
801014d1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801014d3:	89 d0                	mov    %edx,%eax
801014d5:	c1 e8 0c             	shr    $0xc,%eax
{
801014d8:	89 e5                	mov    %esp,%ebp
801014da:	56                   	push   %esi
801014db:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801014dc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801014e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014e4:	83 ec 08             	sub    $0x8,%esp
801014e7:	50                   	push   %eax
801014e8:	51                   	push   %ecx
801014e9:	e8 e2 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f0:	c1 fb 03             	sar    $0x3,%ebx
801014f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014f8:	83 e1 07             	and    $0x7,%ecx
801014fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101500:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101506:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101508:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010150d:	85 c1                	test   %eax,%ecx
8010150f:	74 23                	je     80101534 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101511:	f7 d0                	not    %eax
  log_write(bp);
80101513:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101516:	21 c8                	and    %ecx,%eax
80101518:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010151c:	56                   	push   %esi
8010151d:	e8 fe 1a 00 00       	call   80103020 <log_write>
  brelse(bp);
80101522:	89 34 24             	mov    %esi,(%esp)
80101525:	e8 c6 ec ff ff       	call   801001f0 <brelse>
}
8010152a:	83 c4 10             	add    $0x10,%esp
8010152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101530:	5b                   	pop    %ebx
80101531:	5e                   	pop    %esi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret
    panic("freeing free block");
80101534:	83 ec 0c             	sub    $0xc,%esp
80101537:	68 db 74 10 80       	push   $0x801074db
8010153c:	e8 3f ee ff ff       	call   80100380 <panic>
80101541:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101548:	00 
80101549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101550 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	89 c6                	mov    %eax,%esi
80101557:	53                   	push   %ebx
80101558:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010155b:	83 fa 0a             	cmp    $0xa,%edx
8010155e:	0f 86 8c 00 00 00    	jbe    801015f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101564:	8d 5a f5             	lea    -0xb(%edx),%ebx

  if(bn < NINDIRECT){
80101567:	83 fb 7f             	cmp    $0x7f,%ebx
8010156a:	0f 87 a0 00 00 00    	ja     80101610 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101570:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101576:	85 c0                	test   %eax,%eax
80101578:	74 5e                	je     801015d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010157a:	83 ec 08             	sub    $0x8,%esp
8010157d:	50                   	push   %eax
8010157e:	ff 36                	push   (%esi)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101585:	83 c4 10             	add    $0x10,%esp
80101588:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010158c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010158e:	8b 3b                	mov    (%ebx),%edi
80101590:	85 ff                	test   %edi,%edi
80101592:	74 1c                	je     801015b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101594:	83 ec 0c             	sub    $0xc,%esp
80101597:	52                   	push   %edx
80101598:	e8 53 ec ff ff       	call   801001f0 <brelse>
8010159d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015a3:	89 f8                	mov    %edi,%eax
801015a5:	5b                   	pop    %ebx
801015a6:	5e                   	pop    %esi
801015a7:	5f                   	pop    %edi
801015a8:	5d                   	pop    %ebp
801015a9:	c3                   	ret
801015aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015b3:	8b 06                	mov    (%esi),%eax
801015b5:	e8 06 fd ff ff       	call   801012c0 <balloc>
      log_write(bp);
801015ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015c0:	89 03                	mov    %eax,(%ebx)
801015c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015c4:	52                   	push   %edx
801015c5:	e8 56 1a 00 00       	call   80103020 <log_write>
801015ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015cd:	83 c4 10             	add    $0x10,%esp
801015d0:	eb c2                	jmp    80101594 <bmap+0x44>
801015d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015d8:	8b 06                	mov    (%esi),%eax
801015da:	e8 e1 fc ff ff       	call   801012c0 <balloc>
801015df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015e5:	eb 93                	jmp    8010157a <bmap+0x2a>
801015e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ee:	00 
801015ef:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801015f0:	8d 5a 18             	lea    0x18(%edx),%ebx
801015f3:	8b 3c 98             	mov    (%eax,%ebx,4),%edi
801015f6:	85 ff                	test   %edi,%edi
801015f8:	75 a6                	jne    801015a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801015fa:	8b 00                	mov    (%eax),%eax
801015fc:	e8 bf fc ff ff       	call   801012c0 <balloc>
80101601:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
80101604:	89 c7                	mov    %eax,%edi
}
80101606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101609:	5b                   	pop    %ebx
8010160a:	89 f8                	mov    %edi,%eax
8010160c:	5e                   	pop    %esi
8010160d:	5f                   	pop    %edi
8010160e:	5d                   	pop    %ebp
8010160f:	c3                   	ret
  panic("bmap: out of range");
80101610:	83 ec 0c             	sub    $0xc,%esp
80101613:	68 ee 74 10 80       	push   $0x801074ee
80101618:	e8 63 ed ff ff       	call   80100380 <panic>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi

80101620 <readsb>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101628:	83 ec 08             	sub    $0x8,%esp
8010162b:	6a 01                	push   $0x1
8010162d:	ff 75 08             	push   0x8(%ebp)
80101630:	e8 9b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101635:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101638:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010163a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010163d:	6a 1c                	push   $0x1c
8010163f:	50                   	push   %eax
80101640:	56                   	push   %esi
80101641:	e8 4a 32 00 00       	call   80104890 <memmove>
  brelse(bp);
80101646:	83 c4 10             	add    $0x10,%esp
80101649:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010164c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010164f:	5b                   	pop    %ebx
80101650:	5e                   	pop    %esi
80101651:	5d                   	pop    %ebp
  brelse(bp);
80101652:	e9 99 eb ff ff       	jmp    801001f0 <brelse>
80101657:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165e:	00 
8010165f:	90                   	nop

80101660 <iinit>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101669:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010166c:	68 01 75 10 80       	push   $0x80107501
80101671:	68 60 f9 10 80       	push   $0x8010f960
80101676:	e8 95 2e 00 00       	call   80104510 <initlock>
  for(i = 0; i < NINODE; i++) {
8010167b:	83 c4 10             	add    $0x10,%esp
8010167e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101680:	83 ec 08             	sub    $0x8,%esp
80101683:	68 08 75 10 80       	push   $0x80107508
80101688:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101689:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010168f:	e8 4c 2d 00 00       	call   801043e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101694:	83 c4 10             	add    $0x10,%esp
80101697:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010169d:	75 e1                	jne    80101680 <iinit+0x20>
  bp = bread(dev, 1);
8010169f:	83 ec 08             	sub    $0x8,%esp
801016a2:	6a 01                	push   $0x1
801016a4:	ff 75 08             	push   0x8(%ebp)
801016a7:	e8 24 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016b4:	6a 1c                	push   $0x1c
801016b6:	50                   	push   %eax
801016b7:	68 b4 15 11 80       	push   $0x801115b4
801016bc:	e8 cf 31 00 00       	call   80104890 <memmove>
  brelse(bp);
801016c1:	89 1c 24             	mov    %ebx,(%esp)
801016c4:	e8 27 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016c9:	ff 35 cc 15 11 80    	push   0x801115cc
801016cf:	ff 35 c8 15 11 80    	push   0x801115c8
801016d5:	ff 35 c4 15 11 80    	push   0x801115c4
801016db:	ff 35 c0 15 11 80    	push   0x801115c0
801016e1:	ff 35 bc 15 11 80    	push   0x801115bc
801016e7:	ff 35 b8 15 11 80    	push   0x801115b8
801016ed:	ff 35 b4 15 11 80    	push   0x801115b4
801016f3:	68 7c 79 10 80       	push   $0x8010797c
801016f8:	e8 b3 ef ff ff       	call   801006b0 <cprintf>
}
801016fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101700:	83 c4 30             	add    $0x30,%esp
80101703:	c9                   	leave
80101704:	c3                   	ret
80101705:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010170c:	00 
8010170d:	8d 76 00             	lea    0x0(%esi),%esi

80101710 <ialloc>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	83 ec 1c             	sub    $0x1c,%esp
80101719:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010171c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101723:	8b 75 08             	mov    0x8(%ebp),%esi
80101726:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101729:	0f 86 97 00 00 00    	jbe    801017c6 <ialloc+0xb6>
8010172f:	bf 01 00 00 00       	mov    $0x1,%edi
80101734:	eb 21                	jmp    80101757 <ialloc+0x47>
80101736:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010173d:	00 
8010173e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101740:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101743:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101746:	53                   	push   %ebx
80101747:	e8 a4 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	83 c4 10             	add    $0x10,%esp
8010174f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101755:	73 6f                	jae    801017c6 <ialloc+0xb6>
    bp = bread(dev, IBLOCK(inum, sb));
80101757:	89 f8                	mov    %edi,%eax
80101759:	83 ec 08             	sub    $0x8,%esp
8010175c:	c1 e8 03             	shr    $0x3,%eax
8010175f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101765:	50                   	push   %eax
80101766:	56                   	push   %esi
80101767:	e8 64 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010176c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010176f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101771:	89 f8                	mov    %edi,%eax
80101773:	83 e0 07             	and    $0x7,%eax
80101776:	c1 e0 06             	shl    $0x6,%eax
80101779:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010177d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101781:	75 bd                	jne    80101740 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101783:	83 ec 04             	sub    $0x4,%esp
80101786:	6a 40                	push   $0x40
80101788:	6a 00                	push   $0x0
8010178a:	51                   	push   %ecx
8010178b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010178e:	e8 6d 30 00 00       	call   80104800 <memset>
      dip->type = type;
80101793:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101796:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010179a:	66 89 01             	mov    %ax,(%ecx)
      dip->untrusted = TAINT_NONE;
8010179d:	31 c0                	xor    %eax,%eax
8010179f:	66 89 41 08          	mov    %ax,0x8(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017a3:	89 1c 24             	mov    %ebx,(%esp)
801017a6:	e8 75 18 00 00       	call   80103020 <log_write>
      brelse(bp);
801017ab:	89 1c 24             	mov    %ebx,(%esp)
801017ae:	e8 3d ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017b3:	83 c4 10             	add    $0x10,%esp
}
801017b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017b9:	89 fa                	mov    %edi,%edx
}
801017bb:	5b                   	pop    %ebx
      return iget(dev, inum);
801017bc:	89 f0                	mov    %esi,%eax
}
801017be:	5e                   	pop    %esi
801017bf:	5f                   	pop    %edi
801017c0:	5d                   	pop    %ebp
      return iget(dev, inum);
801017c1:	e9 0a fc ff ff       	jmp    801013d0 <iget>
  panic("ialloc: no inodes");
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	68 0e 75 10 80       	push   $0x8010750e
801017ce:	e8 ad eb ff ff       	call   80100380 <panic>
801017d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017da:	00 
801017db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017e0 <iupdate>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017eb:	83 c3 60             	add    $0x60,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ee:	83 ec 08             	sub    $0x8,%esp
801017f1:	c1 e8 03             	shr    $0x3,%eax
801017f4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017fa:	50                   	push   %eax
801017fb:	ff 73 a0             	push   -0x60(%ebx)
801017fe:	e8 cd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101803:	0f b7 53 f0          	movzwl -0x10(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101807:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180c:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101819:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010181c:	0f b7 53 f2          	movzwl -0xe(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101820:	83 c0 10             	add    $0x10,%eax
  dip->major = ip->major;
80101823:	66 89 50 f2          	mov    %dx,-0xe(%eax)
  dip->minor = ip->minor;
80101827:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
8010182b:	66 89 50 f4          	mov    %dx,-0xc(%eax)
  dip->nlink = ip->nlink;
8010182f:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
80101833:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->untrusted = ip->untrusted;
80101837:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010183b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->size = ip->size;
8010183f:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101842:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101845:	6a 30                	push   $0x30
80101847:	53                   	push   %ebx
80101848:	50                   	push   %eax
80101849:	e8 42 30 00 00       	call   80104890 <memmove>
  log_write(bp);
8010184e:	89 34 24             	mov    %esi,(%esp)
80101851:	e8 ca 17 00 00       	call   80103020 <log_write>
  brelse(bp);
80101856:	83 c4 10             	add    $0x10,%esp
80101859:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010185c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010185f:	5b                   	pop    %ebx
80101860:	5e                   	pop    %esi
80101861:	5d                   	pop    %ebp
  brelse(bp);
80101862:	e9 89 e9 ff ff       	jmp    801001f0 <brelse>
80101867:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010186e:	00 
8010186f:	90                   	nop

80101870 <idup>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	53                   	push   %ebx
80101874:	83 ec 10             	sub    $0x10,%esp
80101877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010187a:	68 60 f9 10 80       	push   $0x8010f960
8010187f:	e8 7c 2e 00 00       	call   80104700 <acquire>
  ip->ref++;
80101884:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101888:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010188f:	e8 0c 2e 00 00       	call   801046a0 <release>
}
80101894:	89 d8                	mov    %ebx,%eax
80101896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101899:	c9                   	leave
8010189a:	c3                   	ret
8010189b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801018a0 <ilock>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018a8:	85 db                	test   %ebx,%ebx
801018aa:	0f 84 bf 00 00 00    	je     8010196f <ilock+0xcf>
801018b0:	8b 53 08             	mov    0x8(%ebx),%edx
801018b3:	85 d2                	test   %edx,%edx
801018b5:	0f 8e b4 00 00 00    	jle    8010196f <ilock+0xcf>
  acquiresleep(&ip->lock);
801018bb:	83 ec 0c             	sub    $0xc,%esp
801018be:	8d 43 0c             	lea    0xc(%ebx),%eax
801018c1:	50                   	push   %eax
801018c2:	e8 59 2b 00 00       	call   80104420 <acquiresleep>
  if(ip->valid == 0){
801018c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	85 c0                	test   %eax,%eax
801018cf:	74 0f                	je     801018e0 <ilock+0x40>
}
801018d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018d4:	5b                   	pop    %ebx
801018d5:	5e                   	pop    %esi
801018d6:	5d                   	pop    %ebp
801018d7:	c3                   	ret
801018d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018e0:	8b 43 04             	mov    0x4(%ebx),%eax
801018e3:	83 ec 08             	sub    $0x8,%esp
801018e6:	c1 e8 03             	shr    $0x3,%eax
801018e9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801018ef:	50                   	push   %eax
801018f0:	ff 33                	push   (%ebx)
801018f2:	e8 d9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018fc:	8b 43 04             	mov    0x4(%ebx),%eax
801018ff:	83 e0 07             	and    $0x7,%eax
80101902:	c1 e0 06             	shl    $0x6,%eax
80101905:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101909:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010190c:	83 c0 10             	add    $0x10,%eax
    ip->type = dip->type;
8010190f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101913:	0f b7 50 f2          	movzwl -0xe(%eax),%edx
80101917:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010191b:	0f b7 50 f4          	movzwl -0xc(%eax),%edx
8010191f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101923:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101927:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->untrusted = dip->untrusted;
8010192b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010192f:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->size = dip->size;
80101933:	8b 50 fc             	mov    -0x4(%eax),%edx
80101936:	89 53 5c             	mov    %edx,0x5c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101939:	6a 30                	push   $0x30
8010193b:	50                   	push   %eax
8010193c:	8d 43 60             	lea    0x60(%ebx),%eax
8010193f:	50                   	push   %eax
80101940:	e8 4b 2f 00 00       	call   80104890 <memmove>
    brelse(bp);
80101945:	89 34 24             	mov    %esi,(%esp)
80101948:	e8 a3 e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
8010194d:	83 c4 10             	add    $0x10,%esp
80101950:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101955:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010195c:	0f 85 6f ff ff ff    	jne    801018d1 <ilock+0x31>
      panic("ilock: no type");
80101962:	83 ec 0c             	sub    $0xc,%esp
80101965:	68 26 75 10 80       	push   $0x80107526
8010196a:	e8 11 ea ff ff       	call   80100380 <panic>
    panic("ilock");
8010196f:	83 ec 0c             	sub    $0xc,%esp
80101972:	68 20 75 10 80       	push   $0x80107520
80101977:	e8 04 ea ff ff       	call   80100380 <panic>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <iunlock>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	56                   	push   %esi
80101984:	53                   	push   %ebx
80101985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101988:	85 db                	test   %ebx,%ebx
8010198a:	74 28                	je     801019b4 <iunlock+0x34>
8010198c:	83 ec 0c             	sub    $0xc,%esp
8010198f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101992:	56                   	push   %esi
80101993:	e8 28 2b 00 00       	call   801044c0 <holdingsleep>
80101998:	83 c4 10             	add    $0x10,%esp
8010199b:	85 c0                	test   %eax,%eax
8010199d:	74 15                	je     801019b4 <iunlock+0x34>
8010199f:	8b 43 08             	mov    0x8(%ebx),%eax
801019a2:	85 c0                	test   %eax,%eax
801019a4:	7e 0e                	jle    801019b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019ac:	5b                   	pop    %ebx
801019ad:	5e                   	pop    %esi
801019ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019af:	e9 cc 2a 00 00       	jmp    80104480 <releasesleep>
    panic("iunlock");
801019b4:	83 ec 0c             	sub    $0xc,%esp
801019b7:	68 35 75 10 80       	push   $0x80107535
801019bc:	e8 bf e9 ff ff       	call   80100380 <panic>
801019c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019c8:	00 
801019c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801019d0 <iput>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 28             	sub    $0x28,%esp
801019d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019df:	57                   	push   %edi
801019e0:	e8 3b 2a 00 00       	call   80104420 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019e5:	8b 4b 4c             	mov    0x4c(%ebx),%ecx
801019e8:	83 c4 10             	add    $0x10,%esp
801019eb:	85 c9                	test   %ecx,%ecx
801019ed:	74 07                	je     801019f6 <iput+0x26>
801019ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019f4:	74 32                	je     80101a28 <iput+0x58>
  releasesleep(&ip->lock);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	57                   	push   %edi
801019fa:	e8 81 2a 00 00       	call   80104480 <releasesleep>
  acquire(&icache.lock);
801019ff:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a06:	e8 f5 2c 00 00       	call   80104700 <acquire>
  ip->ref--;
80101a0b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a0f:	83 c4 10             	add    $0x10,%esp
80101a12:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1c:	5b                   	pop    %ebx
80101a1d:	5e                   	pop    %esi
80101a1e:	5f                   	pop    %edi
80101a1f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a20:	e9 7b 2c 00 00       	jmp    801046a0 <release>
80101a25:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a28:	83 ec 0c             	sub    $0xc,%esp
80101a2b:	68 60 f9 10 80       	push   $0x8010f960
80101a30:	e8 cb 2c 00 00       	call   80104700 <acquire>
    int r = ip->ref;
80101a35:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a38:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a3f:	e8 5c 2c 00 00       	call   801046a0 <release>
    if(r == 1){
80101a44:	83 c4 10             	add    $0x10,%esp
80101a47:	83 fe 01             	cmp    $0x1,%esi
80101a4a:	75 aa                	jne    801019f6 <iput+0x26>
80101a4c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a52:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a55:	8d 73 60             	lea    0x60(%ebx),%esi
80101a58:	89 df                	mov    %ebx,%edi
80101a5a:	89 cb                	mov    %ecx,%ebx
80101a5c:	eb 09                	jmp    80101a67 <iput+0x97>
80101a5e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a60:	83 c6 04             	add    $0x4,%esi
80101a63:	39 de                	cmp    %ebx,%esi
80101a65:	74 19                	je     80101a80 <iput+0xb0>
    if(ip->addrs[i]){
80101a67:	8b 16                	mov    (%esi),%edx
80101a69:	85 d2                	test   %edx,%edx
80101a6b:	74 f3                	je     80101a60 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a6d:	8b 07                	mov    (%edi),%eax
80101a6f:	e8 5c fa ff ff       	call   801014d0 <bfree>
      ip->addrs[i] = 0;
80101a74:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a7a:	eb e4                	jmp    80101a60 <iput+0x90>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a80:	89 fb                	mov    %edi,%ebx
80101a82:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a85:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a8b:	85 c0                	test   %eax,%eax
80101a8d:	75 33                	jne    80101ac2 <iput+0xf2>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a8f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a92:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  iupdate(ip);
80101a99:	53                   	push   %ebx
80101a9a:	e8 41 fd ff ff       	call   801017e0 <iupdate>
      ip->type = 0;
80101a9f:	31 c0                	xor    %eax,%eax
      ip->untrusted = TAINT_NONE;
80101aa1:	31 d2                	xor    %edx,%edx
      ip->type = 0;
80101aa3:	66 89 43 50          	mov    %ax,0x50(%ebx)
      ip->untrusted = TAINT_NONE;
80101aa7:	66 89 53 58          	mov    %dx,0x58(%ebx)
      iupdate(ip);
80101aab:	89 1c 24             	mov    %ebx,(%esp)
80101aae:	e8 2d fd ff ff       	call   801017e0 <iupdate>
      ip->valid = 0;
80101ab3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	e9 34 ff ff ff       	jmp    801019f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ac2:	83 ec 08             	sub    $0x8,%esp
80101ac5:	50                   	push   %eax
80101ac6:	ff 33                	push   (%ebx)
80101ac8:	e8 03 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101acd:	83 c4 10             	add    $0x10,%esp
80101ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ad3:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ad9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101adc:	8d 70 5c             	lea    0x5c(%eax),%esi
80101adf:	89 cf                	mov    %ecx,%edi
80101ae1:	eb 0c                	jmp    80101aef <iput+0x11f>
80101ae3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ae8:	83 c6 04             	add    $0x4,%esi
80101aeb:	39 fe                	cmp    %edi,%esi
80101aed:	74 0f                	je     80101afe <iput+0x12e>
      if(a[j])
80101aef:	8b 16                	mov    (%esi),%edx
80101af1:	85 d2                	test   %edx,%edx
80101af3:	74 f3                	je     80101ae8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101af5:	8b 03                	mov    (%ebx),%eax
80101af7:	e8 d4 f9 ff ff       	call   801014d0 <bfree>
80101afc:	eb ea                	jmp    80101ae8 <iput+0x118>
    brelse(bp);
80101afe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b01:	83 ec 0c             	sub    $0xc,%esp
80101b04:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b07:	50                   	push   %eax
80101b08:	e8 e3 e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b0d:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b13:	8b 03                	mov    (%ebx),%eax
80101b15:	e8 b6 f9 ff ff       	call   801014d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b24:	00 00 00 
80101b27:	e9 63 ff ff ff       	jmp    80101a8f <iput+0xbf>
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b30 <iunlockput>:
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	56                   	push   %esi
80101b34:	53                   	push   %ebx
80101b35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b38:	85 db                	test   %ebx,%ebx
80101b3a:	74 34                	je     80101b70 <iunlockput+0x40>
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b42:	56                   	push   %esi
80101b43:	e8 78 29 00 00       	call   801044c0 <holdingsleep>
80101b48:	83 c4 10             	add    $0x10,%esp
80101b4b:	85 c0                	test   %eax,%eax
80101b4d:	74 21                	je     80101b70 <iunlockput+0x40>
80101b4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b52:	85 c0                	test   %eax,%eax
80101b54:	7e 1a                	jle    80101b70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	56                   	push   %esi
80101b5a:	e8 21 29 00 00       	call   80104480 <releasesleep>
  iput(ip);
80101b5f:	83 c4 10             	add    $0x10,%esp
80101b62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5d                   	pop    %ebp
  iput(ip);
80101b6b:	e9 60 fe ff ff       	jmp    801019d0 <iput>
    panic("iunlock");
80101b70:	83 ec 0c             	sub    $0xc,%esp
80101b73:	68 35 75 10 80       	push   $0x80107535
80101b78:	e8 03 e8 ff ff       	call   80100380 <panic>
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi

80101b80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	8b 55 08             	mov    0x8(%ebp),%edx
80101b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b89:	8b 0a                	mov    (%edx),%ecx
80101b8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ba3:	8b 52 5c             	mov    0x5c(%edx),%edx
80101ba6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ba9:	5d                   	pop    %ebp
80101baa:	c3                   	ret
80101bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101bb0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 75 08             	mov    0x8(%ebp),%esi
80101bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bbf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101bc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101bca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101bcd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101bd0:	0f 84 aa 00 00 00    	je     80101c80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101bd9:	8b 56 5c             	mov    0x5c(%esi),%edx
80101bdc:	39 fa                	cmp    %edi,%edx
80101bde:	0f 82 bd 00 00 00    	jb     80101ca1 <readi+0xf1>
80101be4:	89 f9                	mov    %edi,%ecx
80101be6:	31 db                	xor    %ebx,%ebx
80101be8:	01 c1                	add    %eax,%ecx
80101bea:	0f 92 c3             	setb   %bl
80101bed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101bf0:	0f 82 ab 00 00 00    	jb     80101ca1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bf6:	89 d3                	mov    %edx,%ebx
80101bf8:	29 fb                	sub    %edi,%ebx
80101bfa:	39 ca                	cmp    %ecx,%edx
80101bfc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bff:	85 c0                	test   %eax,%eax
80101c01:	74 73                	je     80101c76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 d8                	mov    %ebx,%eax
80101c1a:	e8 31 f9 ff ff       	call   80101550 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 33                	push   (%ebx)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	89 f8                	mov    %edi,%eax
80101c36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3b:	29 f3                	sub    %esi,%ebx
80101c3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c43:	39 d9                	cmp    %ebx,%ecx
80101c45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c48:	83 c4 0c             	add    $0xc,%esp
80101c4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c4c:	01 de                	add    %ebx,%esi
80101c4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101c53:	50                   	push   %eax
80101c54:	ff 75 e0             	push   -0x20(%ebp)
80101c57:	e8 34 2c 00 00       	call   80104890 <memmove>
    brelse(bp);
80101c5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c5f:	89 14 24             	mov    %edx,(%esp)
80101c62:	e8 89 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c6d:	83 c4 10             	add    $0x10,%esp
80101c70:	39 de                	cmp    %ebx,%esi
80101c72:	72 9c                	jb     80101c10 <readi+0x60>
80101c74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c79:	5b                   	pop    %ebx
80101c7a:	5e                   	pop    %esi
80101c7b:	5f                   	pop    %edi
80101c7c:	5d                   	pop    %ebp
80101c7d:	c3                   	ret
80101c7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101c84:	66 83 fa 09          	cmp    $0x9,%dx
80101c88:	77 17                	ja     80101ca1 <readi+0xf1>
80101c8a:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101c91:	85 d2                	test   %edx,%edx
80101c93:	74 0c                	je     80101ca1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c9f:	ff e2                	jmp    *%edx
      return -1;
80101ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ca6:	eb ce                	jmp    80101c76 <readi+0xc6>
80101ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101caf:	00 

80101cb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	56                   	push   %esi
80101cb5:	53                   	push   %ebx
80101cb6:	83 ec 1c             	sub    $0x1c,%esp
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101cbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101cca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101ccd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101cd0:	0f 84 ba 00 00 00    	je     80101d90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cd6:	39 78 5c             	cmp    %edi,0x5c(%eax)
80101cd9:	0f 82 ea 00 00 00    	jb     80101dc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101ce2:	89 f2                	mov    %esi,%edx
80101ce4:	01 fa                	add    %edi,%edx
80101ce6:	0f 82 dd 00 00 00    	jb     80101dc9 <writei+0x119>
80101cec:	81 fa 00 16 01 00    	cmp    $0x11600,%edx
80101cf2:	0f 87 d1 00 00 00    	ja     80101dc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf8:	85 f6                	test   %esi,%esi
80101cfa:	0f 84 85 00 00 00    	je     80101d85 <writei+0xd5>
80101d00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101d07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101d13:	89 fa                	mov    %edi,%edx
80101d15:	c1 ea 09             	shr    $0x9,%edx
80101d18:	89 f0                	mov    %esi,%eax
80101d1a:	e8 31 f8 ff ff       	call   80101550 <bmap>
80101d1f:	83 ec 08             	sub    $0x8,%esp
80101d22:	50                   	push   %eax
80101d23:	ff 36                	push   (%esi)
80101d25:	e8 a6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d37:	89 f8                	mov    %edi,%eax
80101d39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d3e:	29 d3                	sub    %edx,%ebx
80101d40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d46:	39 d9                	cmp    %ebx,%ecx
80101d48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d4b:	83 c4 0c             	add    $0xc,%esp
80101d4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101d51:	ff 75 dc             	push   -0x24(%ebp)
80101d54:	50                   	push   %eax
80101d55:	e8 36 2b 00 00       	call   80104890 <memmove>
    log_write(bp);
80101d5a:	89 34 24             	mov    %esi,(%esp)
80101d5d:	e8 be 12 00 00       	call   80103020 <log_write>
    brelse(bp);
80101d62:	89 34 24             	mov    %esi,(%esp)
80101d65:	e8 86 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d70:	83 c4 10             	add    $0x10,%esp
80101d73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d79:	39 d8                	cmp    %ebx,%eax
80101d7b:	72 93                	jb     80101d10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d80:	39 78 5c             	cmp    %edi,0x5c(%eax)
80101d83:	72 33                	jb     80101db8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8b:	5b                   	pop    %ebx
80101d8c:	5e                   	pop    %esi
80101d8d:	5f                   	pop    %edi
80101d8e:	5d                   	pop    %ebp
80101d8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d94:	66 83 f8 09          	cmp    $0x9,%ax
80101d98:	77 2f                	ja     80101dc9 <writei+0x119>
80101d9a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101da1:	85 c0                	test   %eax,%eax
80101da3:	74 24                	je     80101dc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101da5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101daf:	ff e0                	jmp    *%eax
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101db8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dbb:	89 78 5c             	mov    %edi,0x5c(%eax)
    iupdate(ip);
80101dbe:	50                   	push   %eax
80101dbf:	e8 1c fa ff ff       	call   801017e0 <iupdate>
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	eb bc                	jmp    80101d85 <writei+0xd5>
      return -1;
80101dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dce:	eb b8                	jmp    80101d88 <writei+0xd8>

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	push   0xc(%ebp)
80101ddb:	ff 75 08             	push   0x8(%ebp)
80101dde:	e8 1d 2b 00 00       	call   80104900 <strncmp>
}
80101de3:	c9                   	leave
80101de4:	c3                   	ret
80101de5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dec:	00 
80101ded:	8d 76 00             	lea    0x0(%esi),%esi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 85 00 00 00    	jne    80101e8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	74 3e                	je     80101e51 <dirlookup+0x61>
80101e13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e18:	6a 10                	push   $0x10
80101e1a:	57                   	push   %edi
80101e1b:	56                   	push   %esi
80101e1c:	53                   	push   %ebx
80101e1d:	e8 8e fd ff ff       	call   80101bb0 <readi>
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	83 f8 10             	cmp    $0x10,%eax
80101e28:	75 55                	jne    80101e7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e2f:	74 18                	je     80101e49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e31:	83 ec 04             	sub    $0x4,%esp
80101e34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e37:	6a 0e                	push   $0xe
80101e39:	50                   	push   %eax
80101e3a:	ff 75 0c             	push   0xc(%ebp)
80101e3d:	e8 be 2a 00 00       	call   80104900 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	85 c0                	test   %eax,%eax
80101e47:	74 17                	je     80101e60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e49:	83 c7 10             	add    $0x10,%edi
80101e4c:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101e4f:	72 c7                	jb     80101e18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e54:	31 c0                	xor    %eax,%eax
}
80101e56:	5b                   	pop    %ebx
80101e57:	5e                   	pop    %esi
80101e58:	5f                   	pop    %edi
80101e59:	5d                   	pop    %ebp
80101e5a:	c3                   	ret
80101e5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101e60:	8b 45 10             	mov    0x10(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	74 05                	je     80101e6c <dirlookup+0x7c>
        *poff = off;
80101e67:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e70:	8b 03                	mov    (%ebx),%eax
80101e72:	e8 59 f5 ff ff       	call   801013d0 <iget>
}
80101e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7a:	5b                   	pop    %ebx
80101e7b:	5e                   	pop    %esi
80101e7c:	5f                   	pop    %edi
80101e7d:	5d                   	pop    %ebp
80101e7e:	c3                   	ret
      panic("dirlookup read");
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	68 4f 75 10 80       	push   $0x8010754f
80101e87:	e8 f4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	68 3d 75 10 80       	push   $0x8010753d
80101e94:	e8 e7 e4 ff ff       	call   80100380 <panic>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 c3                	mov    %eax,%ebx
80101ea8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101eab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101eae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101eb1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101eb4:	0f 84 9e 01 00 00    	je     80102058 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eba:	e8 f1 1b 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101ebf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ec2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ec5:	68 60 f9 10 80       	push   $0x8010f960
80101eca:	e8 31 28 00 00       	call   80104700 <acquire>
  ip->ref++;
80101ecf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101eda:	e8 c1 27 00 00       	call   801046a0 <release>
80101edf:	83 c4 10             	add    $0x10,%esp
80101ee2:	eb 07                	jmp    80101eeb <namex+0x4b>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 06 01 00 00    	je     80102000 <namex+0x160>
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	84 c0                	test   %al,%al
80101eff:	0f 84 10 01 00 00    	je     80102015 <namex+0x175>
80101f05:	89 df                	mov    %ebx,%edi
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	0f 84 06 01 00 00    	je     80102015 <namex+0x175>
80101f0f:	90                   	nop
80101f10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f17:	3c 2f                	cmp    $0x2f,%al
80101f19:	74 04                	je     80101f1f <namex+0x7f>
80101f1b:	84 c0                	test   %al,%al
80101f1d:	75 f1                	jne    80101f10 <namex+0x70>
  len = path - s;
80101f1f:	89 f8                	mov    %edi,%eax
80101f21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f23:	83 f8 0d             	cmp    $0xd,%eax
80101f26:	0f 8e ac 00 00 00    	jle    80101fd8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	6a 0e                	push   $0xe
80101f31:	53                   	push   %ebx
80101f32:	89 fb                	mov    %edi,%ebx
80101f34:	ff 75 e4             	push   -0x1c(%ebp)
80101f37:	e8 54 29 00 00       	call   80104890 <memmove>
80101f3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f42:	75 0c                	jne    80101f50 <namex+0xb0>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f4e:	74 f8                	je     80101f48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
80101f54:	e8 47 f9 ff ff       	call   801018a0 <ilock>
    if(ip->type != T_DIR){
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f61:	0f 85 b7 00 00 00    	jne    8010201e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	74 09                	je     80101f77 <namex+0xd7>
80101f6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f71:	0f 84 f7 00 00 00    	je     8010206e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f77:	83 ec 04             	sub    $0x4,%esp
80101f7a:	6a 00                	push   $0x0
80101f7c:	ff 75 e4             	push   -0x1c(%ebp)
80101f7f:	56                   	push   %esi
80101f80:	e8 6b fe ff ff       	call   80101df0 <dirlookup>
80101f85:	83 c4 10             	add    $0x10,%esp
80101f88:	89 c7                	mov    %eax,%edi
80101f8a:	85 c0                	test   %eax,%eax
80101f8c:	0f 84 8c 00 00 00    	je     8010201e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f92:	83 ec 0c             	sub    $0xc,%esp
80101f95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f98:	51                   	push   %ecx
80101f99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f9c:	e8 1f 25 00 00       	call   801044c0 <holdingsleep>
80101fa1:	83 c4 10             	add    $0x10,%esp
80101fa4:	85 c0                	test   %eax,%eax
80101fa6:	0f 84 02 01 00 00    	je     801020ae <namex+0x20e>
80101fac:	8b 56 08             	mov    0x8(%esi),%edx
80101faf:	85 d2                	test   %edx,%edx
80101fb1:	0f 8e f7 00 00 00    	jle    801020ae <namex+0x20e>
  releasesleep(&ip->lock);
80101fb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	51                   	push   %ecx
80101fbe:	e8 bd 24 00 00       	call   80104480 <releasesleep>
  iput(ip);
80101fc3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101fc6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101fc8:	e8 03 fa ff ff       	call   801019d0 <iput>
80101fcd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fd0:	e9 16 ff ff ff       	jmp    80101eeb <namex+0x4b>
80101fd5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fdb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101fde:	83 ec 04             	sub    $0x4,%esp
80101fe1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	53                   	push   %ebx
    name[len] = 0;
80101fe6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fe8:	ff 75 e4             	push   -0x1c(%ebp)
80101feb:	e8 a0 28 00 00       	call   80104890 <memmove>
    name[len] = 0;
80101ff0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ff3:	83 c4 10             	add    $0x10,%esp
80101ff6:	c6 01 00             	movb   $0x0,(%ecx)
80101ff9:	e9 41 ff ff ff       	jmp    80101f3f <namex+0x9f>
80101ffe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80102000:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102003:	85 c0                	test   %eax,%eax
80102005:	0f 85 93 00 00 00    	jne    8010209e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
8010200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200e:	89 f0                	mov    %esi,%eax
80102010:	5b                   	pop    %ebx
80102011:	5e                   	pop    %esi
80102012:	5f                   	pop    %edi
80102013:	5d                   	pop    %ebp
80102014:	c3                   	ret
  while(*path != '/' && *path != 0)
80102015:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102018:	89 df                	mov    %ebx,%edi
8010201a:	31 c0                	xor    %eax,%eax
8010201c:	eb c0                	jmp    80101fde <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102024:	53                   	push   %ebx
80102025:	e8 96 24 00 00       	call   801044c0 <holdingsleep>
8010202a:	83 c4 10             	add    $0x10,%esp
8010202d:	85 c0                	test   %eax,%eax
8010202f:	74 7d                	je     801020ae <namex+0x20e>
80102031:	8b 4e 08             	mov    0x8(%esi),%ecx
80102034:	85 c9                	test   %ecx,%ecx
80102036:	7e 76                	jle    801020ae <namex+0x20e>
  releasesleep(&ip->lock);
80102038:	83 ec 0c             	sub    $0xc,%esp
8010203b:	53                   	push   %ebx
8010203c:	e8 3f 24 00 00       	call   80104480 <releasesleep>
  iput(ip);
80102041:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102044:	31 f6                	xor    %esi,%esi
  iput(ip);
80102046:	e8 85 f9 ff ff       	call   801019d0 <iput>
      return 0;
8010204b:	83 c4 10             	add    $0x10,%esp
}
8010204e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102051:	89 f0                	mov    %esi,%eax
80102053:	5b                   	pop    %ebx
80102054:	5e                   	pop    %esi
80102055:	5f                   	pop    %edi
80102056:	5d                   	pop    %ebp
80102057:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102058:	ba 01 00 00 00       	mov    $0x1,%edx
8010205d:	b8 01 00 00 00       	mov    $0x1,%eax
80102062:	e8 69 f3 ff ff       	call   801013d0 <iget>
80102067:	89 c6                	mov    %eax,%esi
80102069:	e9 7d fe ff ff       	jmp    80101eeb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010206e:	83 ec 0c             	sub    $0xc,%esp
80102071:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102074:	53                   	push   %ebx
80102075:	e8 46 24 00 00       	call   801044c0 <holdingsleep>
8010207a:	83 c4 10             	add    $0x10,%esp
8010207d:	85 c0                	test   %eax,%eax
8010207f:	74 2d                	je     801020ae <namex+0x20e>
80102081:	8b 7e 08             	mov    0x8(%esi),%edi
80102084:	85 ff                	test   %edi,%edi
80102086:	7e 26                	jle    801020ae <namex+0x20e>
  releasesleep(&ip->lock);
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	53                   	push   %ebx
8010208c:	e8 ef 23 00 00       	call   80104480 <releasesleep>
}
80102091:	83 c4 10             	add    $0x10,%esp
}
80102094:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102097:	89 f0                	mov    %esi,%eax
80102099:	5b                   	pop    %ebx
8010209a:	5e                   	pop    %esi
8010209b:	5f                   	pop    %edi
8010209c:	5d                   	pop    %ebp
8010209d:	c3                   	ret
    iput(ip);
8010209e:	83 ec 0c             	sub    $0xc,%esp
801020a1:	56                   	push   %esi
      return 0;
801020a2:	31 f6                	xor    %esi,%esi
    iput(ip);
801020a4:	e8 27 f9 ff ff       	call   801019d0 <iput>
    return 0;
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	eb a0                	jmp    8010204e <namex+0x1ae>
    panic("iunlock");
801020ae:	83 ec 0c             	sub    $0xc,%esp
801020b1:	68 35 75 10 80       	push   $0x80107535
801020b6:	e8 c5 e2 ff ff       	call   80100380 <panic>
801020bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801020c0 <dirlink>:
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 20             	sub    $0x20,%esp
801020c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020cc:	6a 00                	push   $0x0
801020ce:	ff 75 0c             	push   0xc(%ebp)
801020d1:	53                   	push   %ebx
801020d2:	e8 19 fd ff ff       	call   80101df0 <dirlookup>
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	85 c0                	test   %eax,%eax
801020dc:	75 67                	jne    80102145 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020de:	8b 7b 5c             	mov    0x5c(%ebx),%edi
801020e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020e4:	85 ff                	test   %edi,%edi
801020e6:	74 29                	je     80102111 <dirlink+0x51>
801020e8:	31 ff                	xor    %edi,%edi
801020ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020ed:	eb 09                	jmp    801020f8 <dirlink+0x38>
801020ef:	90                   	nop
801020f0:	83 c7 10             	add    $0x10,%edi
801020f3:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
801020f6:	73 19                	jae    80102111 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f8:	6a 10                	push   $0x10
801020fa:	57                   	push   %edi
801020fb:	56                   	push   %esi
801020fc:	53                   	push   %ebx
801020fd:	e8 ae fa ff ff       	call   80101bb0 <readi>
80102102:	83 c4 10             	add    $0x10,%esp
80102105:	83 f8 10             	cmp    $0x10,%eax
80102108:	75 4e                	jne    80102158 <dirlink+0x98>
    if(de.inum == 0)
8010210a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010210f:	75 df                	jne    801020f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102111:	83 ec 04             	sub    $0x4,%esp
80102114:	8d 45 da             	lea    -0x26(%ebp),%eax
80102117:	6a 0e                	push   $0xe
80102119:	ff 75 0c             	push   0xc(%ebp)
8010211c:	50                   	push   %eax
8010211d:	e8 2e 28 00 00       	call   80104950 <strncpy>
  de.inum = inum;
80102122:	8b 45 10             	mov    0x10(%ebp),%eax
80102125:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102129:	6a 10                	push   $0x10
8010212b:	57                   	push   %edi
8010212c:	56                   	push   %esi
8010212d:	53                   	push   %ebx
8010212e:	e8 7d fb ff ff       	call   80101cb0 <writei>
80102133:	83 c4 20             	add    $0x20,%esp
80102136:	83 f8 10             	cmp    $0x10,%eax
80102139:	75 2a                	jne    80102165 <dirlink+0xa5>
  return 0;
8010213b:	31 c0                	xor    %eax,%eax
}
8010213d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102140:	5b                   	pop    %ebx
80102141:	5e                   	pop    %esi
80102142:	5f                   	pop    %edi
80102143:	5d                   	pop    %ebp
80102144:	c3                   	ret
    iput(ip);
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	50                   	push   %eax
80102149:	e8 82 f8 ff ff       	call   801019d0 <iput>
    return -1;
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102156:	eb e5                	jmp    8010213d <dirlink+0x7d>
      panic("dirlink read");
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	68 5e 75 10 80       	push   $0x8010755e
80102160:	e8 1b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 b8 77 10 80       	push   $0x801077b8
8010216d:	e8 0e e2 ff ff       	call   80100380 <panic>
80102172:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102179:	00 
8010217a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102180 <namei>:

struct inode*
namei(char *path)
{
80102180:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102181:	31 d2                	xor    %edx,%edx
{
80102183:	89 e5                	mov    %esp,%ebp
80102185:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102188:	8b 45 08             	mov    0x8(%ebp),%eax
8010218b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010218e:	e8 0d fd ff ff       	call   80101ea0 <namex>
}
80102193:	c9                   	leave
80102194:	c3                   	ret
80102195:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010219c:	00 
8010219d:	8d 76 00             	lea    0x0(%esi),%esi

801021a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021a0:	55                   	push   %ebp
  return namex(path, 1, name);
801021a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021af:	e9 ec fc ff ff       	jmp    80101ea0 <namex>
801021b4:	66 90                	xchg   %ax,%ax
801021b6:	66 90                	xchg   %ax,%ax
801021b8:	66 90                	xchg   %ax,%ax
801021ba:	66 90                	xchg   %ax,%ax
801021bc:	66 90                	xchg   %ax,%ax
801021be:	66 90                	xchg   %ax,%ax

801021c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	57                   	push   %edi
801021c4:	56                   	push   %esi
801021c5:	53                   	push   %ebx
801021c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021c9:	85 c0                	test   %eax,%eax
801021cb:	0f 84 b4 00 00 00    	je     80102285 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021d1:	8b 70 08             	mov    0x8(%eax),%esi
801021d4:	89 c3                	mov    %eax,%ebx
801021d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021dc:	0f 87 96 00 00 00    	ja     80102278 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021ee:	00 
801021ef:	90                   	nop
801021f0:	89 ca                	mov    %ecx,%edx
801021f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f3:	83 e0 c0             	and    $0xffffffc0,%eax
801021f6:	3c 40                	cmp    $0x40,%al
801021f8:	75 f6                	jne    801021f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021fa:	31 ff                	xor    %edi,%edi
801021fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102201:	89 f8                	mov    %edi,%eax
80102203:	ee                   	out    %al,(%dx)
80102204:	b8 01 00 00 00       	mov    $0x1,%eax
80102209:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010220e:	ee                   	out    %al,(%dx)
8010220f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102214:	89 f0                	mov    %esi,%eax
80102216:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102217:	89 f0                	mov    %esi,%eax
80102219:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010221e:	c1 f8 08             	sar    $0x8,%eax
80102221:	ee                   	out    %al,(%dx)
80102222:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102227:	89 f8                	mov    %edi,%eax
80102229:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010222a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010222e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102233:	c1 e0 04             	shl    $0x4,%eax
80102236:	83 e0 10             	and    $0x10,%eax
80102239:	83 c8 e0             	or     $0xffffffe0,%eax
8010223c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010223d:	f6 03 04             	testb  $0x4,(%ebx)
80102240:	75 16                	jne    80102258 <idestart+0x98>
80102242:	b8 20 00 00 00       	mov    $0x20,%eax
80102247:	89 ca                	mov    %ecx,%edx
80102249:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010224a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224d:	5b                   	pop    %ebx
8010224e:	5e                   	pop    %esi
8010224f:	5f                   	pop    %edi
80102250:	5d                   	pop    %ebp
80102251:	c3                   	ret
80102252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102258:	b8 30 00 00 00       	mov    $0x30,%eax
8010225d:	89 ca                	mov    %ecx,%edx
8010225f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102260:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102265:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102268:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010226d:	fc                   	cld
8010226e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret
    panic("incorrect blockno");
80102278:	83 ec 0c             	sub    $0xc,%esp
8010227b:	68 74 75 10 80       	push   $0x80107574
80102280:	e8 fb e0 ff ff       	call   80100380 <panic>
    panic("idestart");
80102285:	83 ec 0c             	sub    $0xc,%esp
80102288:	68 6b 75 10 80       	push   $0x8010756b
8010228d:	e8 ee e0 ff ff       	call   80100380 <panic>
80102292:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102299:	00 
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ideinit>:
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022a6:	68 86 75 10 80       	push   $0x80107586
801022ab:	68 00 16 11 80       	push   $0x80111600
801022b0:	e8 5b 22 00 00       	call   80104510 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022b5:	58                   	pop    %eax
801022b6:	a1 84 17 11 80       	mov    0x80111784,%eax
801022bb:	5a                   	pop    %edx
801022bc:	83 e8 01             	sub    $0x1,%eax
801022bf:	50                   	push   %eax
801022c0:	6a 0e                	push   $0xe
801022c2:	e8 99 02 00 00       	call   80102560 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022cf:	90                   	nop
801022d0:	89 ca                	mov    %ecx,%edx
801022d2:	ec                   	in     (%dx),%al
801022d3:	83 e0 c0             	and    $0xffffffc0,%eax
801022d6:	3c 40                	cmp    $0x40,%al
801022d8:	75 f6                	jne    801022d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e5:	89 ca                	mov    %ecx,%edx
801022e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022e8:	84 c0                	test   %al,%al
801022ea:	75 1e                	jne    8010230a <ideinit+0x6a>
801022ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801022f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022fd:	00 
801022fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102300:	83 e9 01             	sub    $0x1,%ecx
80102303:	74 0f                	je     80102314 <ideinit+0x74>
80102305:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102306:	84 c0                	test   %al,%al
80102308:	74 f6                	je     80102300 <ideinit+0x60>
      havedisk1 = 1;
8010230a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102311:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102314:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102319:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010231e:	ee                   	out    %al,(%dx)
}
8010231f:	c9                   	leave
80102320:	c3                   	ret
80102321:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102328:	00 
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102330 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102339:	68 00 16 11 80       	push   $0x80111600
8010233e:	e8 bd 23 00 00       	call   80104700 <acquire>

  if((b = idequeue) == 0){
80102343:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 db                	test   %ebx,%ebx
8010234e:	74 63                	je     801023b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102350:	8b 43 58             	mov    0x58(%ebx),%eax
80102353:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102358:	8b 33                	mov    (%ebx),%esi
8010235a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102360:	75 2f                	jne    80102391 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102362:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010236e:	00 
8010236f:	90                   	nop
80102370:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102371:	89 c1                	mov    %eax,%ecx
80102373:	83 e1 c0             	and    $0xffffffc0,%ecx
80102376:	80 f9 40             	cmp    $0x40,%cl
80102379:	75 f5                	jne    80102370 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010237b:	a8 21                	test   $0x21,%al
8010237d:	75 12                	jne    80102391 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010237f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102382:	b9 80 00 00 00       	mov    $0x80,%ecx
80102387:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010238c:	fc                   	cld
8010238d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010238f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102391:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102394:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102397:	83 ce 02             	or     $0x2,%esi
8010239a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010239c:	53                   	push   %ebx
8010239d:	e8 9e 1e 00 00       	call   80104240 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023a2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
801023ac:	74 05                	je     801023b3 <ideintr+0x83>
    idestart(idequeue);
801023ae:	e8 0d fe ff ff       	call   801021c0 <idestart>
    release(&idelock);
801023b3:	83 ec 0c             	sub    $0xc,%esp
801023b6:	68 00 16 11 80       	push   $0x80111600
801023bb:	e8 e0 22 00 00       	call   801046a0 <release>

  release(&idelock);
}
801023c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c3:	5b                   	pop    %ebx
801023c4:	5e                   	pop    %esi
801023c5:	5f                   	pop    %edi
801023c6:	5d                   	pop    %ebp
801023c7:	c3                   	ret
801023c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023cf:	00 

801023d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 10             	sub    $0x10,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023da:	8d 43 0c             	lea    0xc(%ebx),%eax
801023dd:	50                   	push   %eax
801023de:	e8 dd 20 00 00       	call   801044c0 <holdingsleep>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	85 c0                	test   %eax,%eax
801023e8:	0f 84 c3 00 00 00    	je     801024b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ee:	8b 03                	mov    (%ebx),%eax
801023f0:	83 e0 06             	and    $0x6,%eax
801023f3:	83 f8 02             	cmp    $0x2,%eax
801023f6:	0f 84 a8 00 00 00    	je     801024a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023fc:	8b 53 04             	mov    0x4(%ebx),%edx
801023ff:	85 d2                	test   %edx,%edx
80102401:	74 0d                	je     80102410 <iderw+0x40>
80102403:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102408:	85 c0                	test   %eax,%eax
8010240a:	0f 84 87 00 00 00    	je     80102497 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	68 00 16 11 80       	push   $0x80111600
80102418:	e8 e3 22 00 00       	call   80104700 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102422:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102429:	83 c4 10             	add    $0x10,%esp
8010242c:	85 c0                	test   %eax,%eax
8010242e:	74 60                	je     80102490 <iderw+0xc0>
80102430:	89 c2                	mov    %eax,%edx
80102432:	8b 40 58             	mov    0x58(%eax),%eax
80102435:	85 c0                	test   %eax,%eax
80102437:	75 f7                	jne    80102430 <iderw+0x60>
80102439:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010243c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010243e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102444:	74 3a                	je     80102480 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102446:	8b 03                	mov    (%ebx),%eax
80102448:	83 e0 06             	and    $0x6,%eax
8010244b:	83 f8 02             	cmp    $0x2,%eax
8010244e:	74 1b                	je     8010246b <iderw+0x9b>
    sleep(b, &idelock);
80102450:	83 ec 08             	sub    $0x8,%esp
80102453:	68 00 16 11 80       	push   $0x80111600
80102458:	53                   	push   %ebx
80102459:	e8 22 1d 00 00       	call   80104180 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010245e:	8b 03                	mov    (%ebx),%eax
80102460:	83 c4 10             	add    $0x10,%esp
80102463:	83 e0 06             	and    $0x6,%eax
80102466:	83 f8 02             	cmp    $0x2,%eax
80102469:	75 e5                	jne    80102450 <iderw+0x80>
  }


  release(&idelock);
8010246b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102475:	c9                   	leave
  release(&idelock);
80102476:	e9 25 22 00 00       	jmp    801046a0 <release>
8010247b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102480:	89 d8                	mov    %ebx,%eax
80102482:	e8 39 fd ff ff       	call   801021c0 <idestart>
80102487:	eb bd                	jmp    80102446 <iderw+0x76>
80102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102490:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102495:	eb a5                	jmp    8010243c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102497:	83 ec 0c             	sub    $0xc,%esp
8010249a:	68 b5 75 10 80       	push   $0x801075b5
8010249f:	e8 dc de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	68 a0 75 10 80       	push   $0x801075a0
801024ac:	e8 cf de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024b1:	83 ec 0c             	sub    $0xc,%esp
801024b4:	68 8a 75 10 80       	push   $0x8010758a
801024b9:	e8 c2 de ff ff       	call   80100380 <panic>
801024be:	66 90                	xchg   %ax,%ax

801024c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024c5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801024cc:	00 c0 fe 
  ioapic->reg = reg;
801024cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024d6:	00 00 00 
  return ioapic->data;
801024d9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801024df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024e8:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024ee:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024f5:	c1 ee 10             	shr    $0x10,%esi
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102500:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102503:	39 c2                	cmp    %eax,%edx
80102505:	74 16                	je     8010251d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102507:	83 ec 0c             	sub    $0xc,%esp
8010250a:	68 d0 79 10 80       	push   $0x801079d0
8010250f:	e8 9c e1 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102514:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010251a:	83 c4 10             	add    $0x10,%esp
{
8010251d:	ba 10 00 00 00       	mov    $0x10,%edx
80102522:	31 c0                	xor    %eax,%eax
80102524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102528:	89 13                	mov    %edx,(%ebx)
8010252a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010252d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102533:	83 c0 01             	add    $0x1,%eax
80102536:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010253c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010253f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102542:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102545:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102547:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010254d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102554:	39 c6                	cmp    %eax,%esi
80102556:	7d d0                	jge    80102528 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102558:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010255b:	5b                   	pop    %ebx
8010255c:	5e                   	pop    %esi
8010255d:	5d                   	pop    %ebp
8010255e:	c3                   	ret
8010255f:	90                   	nop

80102560 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102560:	55                   	push   %ebp
  ioapic->reg = reg;
80102561:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102567:	89 e5                	mov    %esp,%ebp
80102569:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010256c:	8d 50 20             	lea    0x20(%eax),%edx
8010256f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102573:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102575:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010257b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010257e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102581:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102584:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102586:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010258b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010258e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret
80102593:	66 90                	xchg   %ax,%ax
80102595:	66 90                	xchg   %ax,%ax
80102597:	66 90                	xchg   %ax,%ax
80102599:	66 90                	xchg   %ax,%ax
8010259b:	66 90                	xchg   %ax,%ax
8010259d:	66 90                	xchg   %ax,%ax
8010259f:	90                   	nop

801025a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 04             	sub    $0x4,%esp
801025a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025b0:	75 76                	jne    80102628 <kfree+0x88>
801025b2:	81 fb d0 55 11 80    	cmp    $0x801155d0,%ebx
801025b8:	72 6e                	jb     80102628 <kfree+0x88>
801025ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025c5:	77 61                	ja     80102628 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025c7:	83 ec 04             	sub    $0x4,%esp
801025ca:	68 00 10 00 00       	push   $0x1000
801025cf:	6a 01                	push   $0x1
801025d1:	53                   	push   %ebx
801025d2:	e8 29 22 00 00       	call   80104800 <memset>

  if(kmem.use_lock)
801025d7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	85 d2                	test   %edx,%edx
801025e2:	75 1c                	jne    80102600 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025e4:	a1 78 16 11 80       	mov    0x80111678,%eax
801025e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025eb:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
801025f0:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
801025f6:	85 c0                	test   %eax,%eax
801025f8:	75 1e                	jne    80102618 <kfree+0x78>
    release(&kmem.lock);
}
801025fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025fd:	c9                   	leave
801025fe:	c3                   	ret
801025ff:	90                   	nop
    acquire(&kmem.lock);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	68 40 16 11 80       	push   $0x80111640
80102608:	e8 f3 20 00 00       	call   80104700 <acquire>
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	eb d2                	jmp    801025e4 <kfree+0x44>
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102618:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010261f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102622:	c9                   	leave
    release(&kmem.lock);
80102623:	e9 78 20 00 00       	jmp    801046a0 <release>
    panic("kfree");
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	68 d3 75 10 80       	push   $0x801075d3
80102630:	e8 4b dd ff ff       	call   80100380 <panic>
80102635:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010263c:	00 
8010263d:	8d 76 00             	lea    0x0(%esi),%esi

80102640 <freerange>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102645:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102648:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010264b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102651:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102657:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265d:	39 de                	cmp    %ebx,%esi
8010265f:	72 23                	jb     80102684 <freerange+0x44>
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102668:	83 ec 0c             	sub    $0xc,%esp
8010266b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102671:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102677:	50                   	push   %eax
80102678:	e8 23 ff ff ff       	call   801025a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	39 de                	cmp    %ebx,%esi
80102682:	73 e4                	jae    80102668 <freerange+0x28>
}
80102684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102687:	5b                   	pop    %ebx
80102688:	5e                   	pop    %esi
80102689:	5d                   	pop    %ebp
8010268a:	c3                   	ret
8010268b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102690 <kinit2>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102695:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102698:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010269b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ad:	39 de                	cmp    %ebx,%esi
801026af:	72 23                	jb     801026d4 <kinit2+0x44>
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026c7:	50                   	push   %eax
801026c8:	e8 d3 fe ff ff       	call   801025a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	39 de                	cmp    %ebx,%esi
801026d2:	73 e4                	jae    801026b8 <kinit2+0x28>
  kmem.use_lock = 1;
801026d4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801026db:	00 00 00 
}
801026de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026e1:	5b                   	pop    %ebx
801026e2:	5e                   	pop    %esi
801026e3:	5d                   	pop    %ebp
801026e4:	c3                   	ret
801026e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ec:	00 
801026ed:	8d 76 00             	lea    0x0(%esi),%esi

801026f0 <kinit1>:
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	56                   	push   %esi
801026f4:	53                   	push   %ebx
801026f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026f8:	83 ec 08             	sub    $0x8,%esp
801026fb:	68 d9 75 10 80       	push   $0x801075d9
80102700:	68 40 16 11 80       	push   $0x80111640
80102705:	e8 06 1e 00 00       	call   80104510 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010270a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102710:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102717:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010271a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102720:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102726:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010272c:	39 de                	cmp    %ebx,%esi
8010272e:	72 1c                	jb     8010274c <kinit1+0x5c>
    kfree(p);
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102739:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010273f:	50                   	push   %eax
80102740:	e8 5b fe ff ff       	call   801025a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102745:	83 c4 10             	add    $0x10,%esp
80102748:	39 de                	cmp    %ebx,%esi
8010274a:	73 e4                	jae    80102730 <kinit1+0x40>
}
8010274c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010274f:	5b                   	pop    %ebx
80102750:	5e                   	pop    %esi
80102751:	5d                   	pop    %ebp
80102752:	c3                   	ret
80102753:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275a:	00 
8010275b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102760 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102767:	a1 74 16 11 80       	mov    0x80111674,%eax
8010276c:	85 c0                	test   %eax,%eax
8010276e:	75 20                	jne    80102790 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102770:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102776:	85 db                	test   %ebx,%ebx
80102778:	74 07                	je     80102781 <kalloc+0x21>
    kmem.freelist = r->next;
8010277a:	8b 03                	mov    (%ebx),%eax
8010277c:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102781:	89 d8                	mov    %ebx,%eax
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave
80102787:	c3                   	ret
80102788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278f:	00 
    acquire(&kmem.lock);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 40 16 11 80       	push   $0x80111640
80102798:	e8 63 1f 00 00       	call   80104700 <acquire>
  r = kmem.freelist;
8010279d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801027a3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801027a8:	83 c4 10             	add    $0x10,%esp
801027ab:	85 db                	test   %ebx,%ebx
801027ad:	74 08                	je     801027b7 <kalloc+0x57>
    kmem.freelist = r->next;
801027af:	8b 13                	mov    (%ebx),%edx
801027b1:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801027b7:	85 c0                	test   %eax,%eax
801027b9:	74 c6                	je     80102781 <kalloc+0x21>
    release(&kmem.lock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 40 16 11 80       	push   $0x80111640
801027c3:	e8 d8 1e 00 00       	call   801046a0 <release>
}
801027c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801027ca:	83 c4 10             	add    $0x10,%esp
}
801027cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d0:	c9                   	leave
801027d1:	c3                   	ret
801027d2:	66 90                	xchg   %ax,%ax
801027d4:	66 90                	xchg   %ax,%ax
801027d6:	66 90                	xchg   %ax,%ax
801027d8:	66 90                	xchg   %ax,%ax
801027da:	66 90                	xchg   %ax,%ax
801027dc:	66 90                	xchg   %ax,%ax
801027de:	66 90                	xchg   %ax,%ax

801027e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e0:	ba 64 00 00 00       	mov    $0x64,%edx
801027e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027e6:	a8 01                	test   $0x1,%al
801027e8:	0f 84 c2 00 00 00    	je     801028b0 <kbdgetc+0xd0>
{
801027ee:	55                   	push   %ebp
801027ef:	ba 60 00 00 00       	mov    $0x60,%edx
801027f4:	89 e5                	mov    %esp,%ebp
801027f6:	53                   	push   %ebx
801027f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027f8:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801027fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102801:	3c e0                	cmp    $0xe0,%al
80102803:	74 5b                	je     80102860 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102805:	89 da                	mov    %ebx,%edx
80102807:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010280a:	84 c0                	test   %al,%al
8010280c:	78 62                	js     80102870 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010280e:	85 d2                	test   %edx,%edx
80102810:	74 09                	je     8010281b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102812:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102815:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102818:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010281b:	0f b6 91 60 7c 10 80 	movzbl -0x7fef83a0(%ecx),%edx
  shift ^= togglecode[data];
80102822:	0f b6 81 60 7b 10 80 	movzbl -0x7fef84a0(%ecx),%eax
  shift |= shiftcode[data];
80102829:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010282b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010282d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010282f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102835:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102838:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010283b:	8b 04 85 40 7b 10 80 	mov    -0x7fef84c0(,%eax,4),%eax
80102842:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102846:	74 0b                	je     80102853 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102848:	8d 50 9f             	lea    -0x61(%eax),%edx
8010284b:	83 fa 19             	cmp    $0x19,%edx
8010284e:	77 48                	ja     80102898 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102850:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102856:	c9                   	leave
80102857:	c3                   	ret
80102858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010285f:	00 
    shift |= E0ESC;
80102860:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102863:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102865:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010286b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286e:	c9                   	leave
8010286f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102870:	83 e0 7f             	and    $0x7f,%eax
80102873:	85 d2                	test   %edx,%edx
80102875:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102878:	0f b6 81 60 7c 10 80 	movzbl -0x7fef83a0(%ecx),%eax
8010287f:	83 c8 40             	or     $0x40,%eax
80102882:	0f b6 c0             	movzbl %al,%eax
80102885:	f7 d0                	not    %eax
80102887:	21 d8                	and    %ebx,%eax
80102889:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010288e:	31 c0                	xor    %eax,%eax
80102890:	eb d9                	jmp    8010286b <kbdgetc+0x8b>
80102892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102898:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010289b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010289e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028a1:	c9                   	leave
      c += 'a' - 'A';
801028a2:	83 f9 1a             	cmp    $0x1a,%ecx
801028a5:	0f 42 c2             	cmovb  %edx,%eax
}
801028a8:	c3                   	ret
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028b5:	c3                   	ret
801028b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028bd:	00 
801028be:	66 90                	xchg   %ax,%ax

801028c0 <kbdintr>:

void
kbdintr(void)
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028c6:	68 e0 27 10 80       	push   $0x801027e0
801028cb:	e8 d0 df ff ff       	call   801008a0 <consoleintr>
}
801028d0:	83 c4 10             	add    $0x10,%esp
801028d3:	c9                   	leave
801028d4:	c3                   	ret
801028d5:	66 90                	xchg   %ax,%ax
801028d7:	66 90                	xchg   %ax,%ax
801028d9:	66 90                	xchg   %ax,%ax
801028db:	66 90                	xchg   %ax,%ax
801028dd:	66 90                	xchg   %ax,%ax
801028df:	90                   	nop

801028e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028e0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028e5:	85 c0                	test   %eax,%eax
801028e7:	0f 84 c3 00 00 00    	je     801029b0 <lapicinit+0xd0>
  lapic[index] = value;
801028ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102901:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102904:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102907:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010290e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102911:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102914:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010291b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010291e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102921:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102928:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102935:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102938:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010293b:	8b 50 30             	mov    0x30(%eax),%edx
8010293e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102944:	75 72                	jne    801029b8 <lapicinit+0xd8>
  lapic[index] = value;
80102946:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010294d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102950:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102953:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010295a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102960:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102967:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102974:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102977:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102981:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102984:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102987:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010298e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102991:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102998:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010299e:	80 e6 10             	and    $0x10,%dh
801029a1:	75 f5                	jne    80102998 <lapicinit+0xb8>
  lapic[index] = value;
801029a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029b0:	c3                   	ret
801029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801029c5:	e9 7c ff ff ff       	jmp    80102946 <lapicinit+0x66>
801029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029d0:	a1 80 16 11 80       	mov    0x80111680,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	74 07                	je     801029e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029d9:	8b 40 20             	mov    0x20(%eax),%eax
801029dc:	c1 e8 18             	shr    $0x18,%eax
801029df:	c3                   	ret
    return 0;
801029e0:	31 c0                	xor    %eax,%eax
}
801029e2:	c3                   	ret
801029e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ea:	00 
801029eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801029f5:	85 c0                	test   %eax,%eax
801029f7:	74 0d                	je     80102a06 <lapiceoi+0x16>
  lapic[index] = value;
801029f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a03:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a06:	c3                   	ret
80102a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a0e:	00 
80102a0f:	90                   	nop

80102a10 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a10:	c3                   	ret
80102a11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a18:	00 
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a26:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	53                   	push   %ebx
80102a2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a34:	ee                   	out    %al,(%dx)
80102a35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a40:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a4d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a50:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a52:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a5e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aad:	c9                   	leave
80102aae:	c3                   	ret
80102aaf:	90                   	nop

80102ab0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ab0:	55                   	push   %ebp
80102ab1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ab6:	ba 70 00 00 00       	mov    $0x70,%edx
80102abb:	89 e5                	mov    %esp,%ebp
80102abd:	57                   	push   %edi
80102abe:	56                   	push   %esi
80102abf:	53                   	push   %ebx
80102ac0:	83 ec 4c             	sub    $0x4c,%esp
80102ac3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ac9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102aca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acd:	bf 70 00 00 00       	mov    $0x70,%edi
80102ad2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ad5:	8d 76 00             	lea    0x0(%esi),%esi
80102ad8:	31 c0                	xor    %eax,%eax
80102ada:	89 fa                	mov    %edi,%edx
80102adc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102add:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ae2:	89 ca                	mov    %ecx,%edx
80102ae4:	ec                   	in     (%dx),%al
80102ae5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae8:	89 fa                	mov    %edi,%edx
80102aea:	b8 02 00 00 00       	mov    $0x2,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 fa                	mov    %edi,%edx
80102af8:	b8 04 00 00 00       	mov    $0x4,%eax
80102afd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afe:	89 ca                	mov    %ecx,%edx
80102b00:	ec                   	in     (%dx),%al
80102b01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b04:	89 fa                	mov    %edi,%edx
80102b06:	b8 07 00 00 00       	mov    $0x7,%eax
80102b0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0c:	89 ca                	mov    %ecx,%edx
80102b0e:	ec                   	in     (%dx),%al
80102b0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b12:	89 fa                	mov    %edi,%edx
80102b14:	b8 08 00 00 00       	mov    $0x8,%eax
80102b19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1a:	89 ca                	mov    %ecx,%edx
80102b1c:	ec                   	in     (%dx),%al
80102b1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1f:	89 fa                	mov    %edi,%edx
80102b21:	b8 09 00 00 00       	mov    $0x9,%eax
80102b26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b27:	89 ca                	mov    %ecx,%edx
80102b29:	ec                   	in     (%dx),%al
80102b2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2d:	89 fa                	mov    %edi,%edx
80102b2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b35:	89 ca                	mov    %ecx,%edx
80102b37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b38:	84 c0                	test   %al,%al
80102b3a:	78 9c                	js     80102ad8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b40:	89 f2                	mov    %esi,%edx
80102b42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b48:	89 fa                	mov    %edi,%edx
80102b4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b65:	31 c0                	xor    %eax,%eax
80102b67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b68:	89 ca                	mov    %ecx,%edx
80102b6a:	ec                   	in     (%dx),%al
80102b6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6e:	89 fa                	mov    %edi,%edx
80102b70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b73:	b8 02 00 00 00       	mov    $0x2,%eax
80102b78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b79:	89 ca                	mov    %ecx,%edx
80102b7b:	ec                   	in     (%dx),%al
80102b7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7f:	89 fa                	mov    %edi,%edx
80102b81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b84:	b8 04 00 00 00       	mov    $0x4,%eax
80102b89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8a:	89 ca                	mov    %ecx,%edx
80102b8c:	ec                   	in     (%dx),%al
80102b8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b90:	89 fa                	mov    %edi,%edx
80102b92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b95:	b8 07 00 00 00       	mov    $0x7,%eax
80102b9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9b:	89 ca                	mov    %ecx,%edx
80102b9d:	ec                   	in     (%dx),%al
80102b9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba1:	89 fa                	mov    %edi,%edx
80102ba3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ba6:	b8 08 00 00 00       	mov    $0x8,%eax
80102bab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bac:	89 ca                	mov    %ecx,%edx
80102bae:	ec                   	in     (%dx),%al
80102baf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb2:	89 fa                	mov    %edi,%edx
80102bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bb7:	b8 09 00 00 00       	mov    $0x9,%eax
80102bbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbd:	89 ca                	mov    %ecx,%edx
80102bbf:	ec                   	in     (%dx),%al
80102bc0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bc3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bc9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bcc:	6a 18                	push   $0x18
80102bce:	50                   	push   %eax
80102bcf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bd2:	50                   	push   %eax
80102bd3:	e8 68 1c 00 00       	call   80104840 <memcmp>
80102bd8:	83 c4 10             	add    $0x10,%esp
80102bdb:	85 c0                	test   %eax,%eax
80102bdd:	0f 85 f5 fe ff ff    	jne    80102ad8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102be3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bea:	89 f0                	mov    %esi,%eax
80102bec:	84 c0                	test   %al,%al
80102bee:	75 78                	jne    80102c68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bf3:	89 c2                	mov    %eax,%edx
80102bf5:	83 e0 0f             	and    $0xf,%eax
80102bf8:	c1 ea 04             	shr    $0x4,%edx
80102bfb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bfe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c07:	89 c2                	mov    %eax,%edx
80102c09:	83 e0 0f             	and    $0xf,%eax
80102c0c:	c1 ea 04             	shr    $0x4,%edx
80102c0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c1b:	89 c2                	mov    %eax,%edx
80102c1d:	83 e0 0f             	and    $0xf,%eax
80102c20:	c1 ea 04             	shr    $0x4,%edx
80102c23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c2f:	89 c2                	mov    %eax,%edx
80102c31:	83 e0 0f             	and    $0xf,%eax
80102c34:	c1 ea 04             	shr    $0x4,%edx
80102c37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c43:	89 c2                	mov    %eax,%edx
80102c45:	83 e0 0f             	and    $0xf,%eax
80102c48:	c1 ea 04             	shr    $0x4,%edx
80102c4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c57:	89 c2                	mov    %eax,%edx
80102c59:	83 e0 0f             	and    $0xf,%eax
80102c5c:	c1 ea 04             	shr    $0x4,%edx
80102c5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c6b:	89 03                	mov    %eax,(%ebx)
80102c6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c70:	89 43 04             	mov    %eax,0x4(%ebx)
80102c73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c76:	89 43 08             	mov    %eax,0x8(%ebx)
80102c79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c82:	89 43 10             	mov    %eax,0x10(%ebx)
80102c85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c95:	5b                   	pop    %ebx
80102c96:	5e                   	pop    %esi
80102c97:	5f                   	pop    %edi
80102c98:	5d                   	pop    %ebp
80102c99:	c3                   	ret
80102c9a:	66 90                	xchg   %ax,%ax
80102c9c:	66 90                	xchg   %ax,%ax
80102c9e:	66 90                	xchg   %ax,%ax

80102ca0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ca0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102ca6:	85 c9                	test   %ecx,%ecx
80102ca8:	0f 8e 8a 00 00 00    	jle    80102d38 <install_trans+0x98>
{
80102cae:	55                   	push   %ebp
80102caf:	89 e5                	mov    %esp,%ebp
80102cb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	31 ff                	xor    %edi,%edi
{
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 0c             	sub    $0xc,%esp
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cc0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	01 f8                	add    %edi,%eax
80102cca:	83 c0 01             	add    $0x1,%eax
80102ccd:	50                   	push   %eax
80102cce:	ff 35 e4 16 11 80    	push   0x801116e4
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
80102cd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cdb:	58                   	pop    %eax
80102cdc:	5a                   	pop    %edx
80102cdd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102ce4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ced:	e8 de d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cfa:	68 00 02 00 00       	push   $0x200
80102cff:	50                   	push   %eax
80102d00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d03:	50                   	push   %eax
80102d04:	e8 87 1b 00 00       	call   80104890 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d09:	89 1c 24             	mov    %ebx,(%esp)
80102d0c:	e8 9f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d11:	89 34 24             	mov    %esi,(%esp)
80102d14:	e8 d7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d19:	89 1c 24             	mov    %ebx,(%esp)
80102d1c:	e8 cf d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d21:	83 c4 10             	add    $0x10,%esp
80102d24:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102d2a:	7f 94                	jg     80102cc0 <install_trans+0x20>
  }
}
80102d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2f:	5b                   	pop    %ebx
80102d30:	5e                   	pop    %esi
80102d31:	5f                   	pop    %edi
80102d32:	5d                   	pop    %ebp
80102d33:	c3                   	ret
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d38:	c3                   	ret
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d47:	ff 35 d4 16 11 80    	push   0x801116d4
80102d4d:	ff 35 e4 16 11 80    	push   0x801116e4
80102d53:	e8 78 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d5d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102d62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d65:	85 c0                	test   %eax,%eax
80102d67:	7e 19                	jle    80102d82 <write_head+0x42>
80102d69:	31 d2                	xor    %edx,%edx
80102d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102d70:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102d77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d0                	cmp    %edx,%eax
80102d80:	75 ee                	jne    80102d70 <write_head+0x30>
  }
  bwrite(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	53                   	push   %ebx
80102d86:	e8 25 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d8b:	89 1c 24             	mov    %ebx,(%esp)
80102d8e:	e8 5d d4 ff ff       	call   801001f0 <brelse>
}
80102d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d96:	83 c4 10             	add    $0x10,%esp
80102d99:	c9                   	leave
80102d9a:	c3                   	ret
80102d9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102da0 <initlog>:
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 2c             	sub    $0x2c,%esp
80102da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102daa:	68 de 75 10 80       	push   $0x801075de
80102daf:	68 a0 16 11 80       	push   $0x801116a0
80102db4:	e8 57 17 00 00       	call   80104510 <initlock>
  readsb(dev, &sb);
80102db9:	58                   	pop    %eax
80102dba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dbd:	5a                   	pop    %edx
80102dbe:	50                   	push   %eax
80102dbf:	53                   	push   %ebx
80102dc0:	e8 5b e8 ff ff       	call   80101620 <readsb>
  log.start = sb.logstart;
80102dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102dc8:	59                   	pop    %ecx
  log.dev = dev;
80102dc9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102dcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dd2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102dd7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102ddd:	5a                   	pop    %edx
80102dde:	50                   	push   %eax
80102ddf:	53                   	push   %ebx
80102de0:	e8 eb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102de5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102de8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102deb:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102df1:	85 db                	test   %ebx,%ebx
80102df3:	7e 1d                	jle    80102e12 <initlog+0x72>
80102df5:	31 d2                	xor    %edx,%edx
80102df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dfe:	00 
80102dff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102e00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e04:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e0b:	83 c2 01             	add    $0x1,%edx
80102e0e:	39 d3                	cmp    %edx,%ebx
80102e10:	75 ee                	jne    80102e00 <initlog+0x60>
  brelse(buf);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	50                   	push   %eax
80102e16:	e8 d5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e1b:	e8 80 fe ff ff       	call   80102ca0 <install_trans>
  log.lh.n = 0;
80102e20:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102e27:	00 00 00 
  write_head(); // clear the log
80102e2a:	e8 11 ff ff ff       	call   80102d40 <write_head>
}
80102e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e32:	83 c4 10             	add    $0x10,%esp
80102e35:	c9                   	leave
80102e36:	c3                   	ret
80102e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e3e:	00 
80102e3f:	90                   	nop

80102e40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e46:	68 a0 16 11 80       	push   $0x801116a0
80102e4b:	e8 b0 18 00 00       	call   80104700 <acquire>
80102e50:	83 c4 10             	add    $0x10,%esp
80102e53:	eb 18                	jmp    80102e6d <begin_op+0x2d>
80102e55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e58:	83 ec 08             	sub    $0x8,%esp
80102e5b:	68 a0 16 11 80       	push   $0x801116a0
80102e60:	68 a0 16 11 80       	push   $0x801116a0
80102e65:	e8 16 13 00 00       	call   80104180 <sleep>
80102e6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e6d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102e72:	85 c0                	test   %eax,%eax
80102e74:	75 e2                	jne    80102e58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e76:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102e7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102e81:	83 c0 01             	add    $0x1,%eax
80102e84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e8a:	83 fa 1e             	cmp    $0x1e,%edx
80102e8d:	7f c9                	jg     80102e58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e92:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102e97:	68 a0 16 11 80       	push   $0x801116a0
80102e9c:	e8 ff 17 00 00       	call   801046a0 <release>
      break;
    }
  }
}
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	c9                   	leave
80102ea5:	c3                   	ret
80102ea6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ead:	00 
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	57                   	push   %edi
80102eb4:	56                   	push   %esi
80102eb5:	53                   	push   %ebx
80102eb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102eb9:	68 a0 16 11 80       	push   $0x801116a0
80102ebe:	e8 3d 18 00 00       	call   80104700 <acquire>
  log.outstanding -= 1;
80102ec3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102ec8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102ece:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ed1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ed4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102eda:	85 f6                	test   %esi,%esi
80102edc:	0f 85 22 01 00 00    	jne    80103004 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ee2:	85 db                	test   %ebx,%ebx
80102ee4:	0f 85 f6 00 00 00    	jne    80102fe0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eea:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102ef1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 a0 16 11 80       	push   $0x801116a0
80102efc:	e8 9f 17 00 00       	call   801046a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f01:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102f07:	83 c4 10             	add    $0x10,%esp
80102f0a:	85 c9                	test   %ecx,%ecx
80102f0c:	7f 42                	jg     80102f50 <end_op+0xa0>
    acquire(&log.lock);
80102f0e:	83 ec 0c             	sub    $0xc,%esp
80102f11:	68 a0 16 11 80       	push   $0x801116a0
80102f16:	e8 e5 17 00 00       	call   80104700 <acquire>
    log.committing = 0;
80102f1b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102f22:	00 00 00 
    wakeup(&log);
80102f25:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f2c:	e8 0f 13 00 00       	call   80104240 <wakeup>
    release(&log.lock);
80102f31:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f38:	e8 63 17 00 00       	call   801046a0 <release>
80102f3d:	83 c4 10             	add    $0x10,%esp
}
80102f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f43:	5b                   	pop    %ebx
80102f44:	5e                   	pop    %esi
80102f45:	5f                   	pop    %edi
80102f46:	5d                   	pop    %ebp
80102f47:	c3                   	ret
80102f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f50:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	01 d8                	add    %ebx,%eax
80102f5a:	83 c0 01             	add    $0x1,%eax
80102f5d:	50                   	push   %eax
80102f5e:	ff 35 e4 16 11 80    	push   0x801116e4
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
80102f69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6b:	58                   	pop    %eax
80102f6c:	5a                   	pop    %edx
80102f6d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102f74:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f7d:	e8 4e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f8a:	68 00 02 00 00       	push   $0x200
80102f8f:	50                   	push   %eax
80102f90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f93:	50                   	push   %eax
80102f94:	e8 f7 18 00 00       	call   80104890 <memmove>
    bwrite(to);  // write the log
80102f99:	89 34 24             	mov    %esi,(%esp)
80102f9c:	e8 0f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fa1:	89 3c 24             	mov    %edi,(%esp)
80102fa4:	e8 47 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fa9:	89 34 24             	mov    %esi,(%esp)
80102fac:	e8 3f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fb1:	83 c4 10             	add    $0x10,%esp
80102fb4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102fba:	7c 94                	jl     80102f50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fbc:	e8 7f fd ff ff       	call   80102d40 <write_head>
    install_trans(); // Now install writes to home locations
80102fc1:	e8 da fc ff ff       	call   80102ca0 <install_trans>
    log.lh.n = 0;
80102fc6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102fcd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd0:	e8 6b fd ff ff       	call   80102d40 <write_head>
80102fd5:	e9 34 ff ff ff       	jmp    80102f0e <end_op+0x5e>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	68 a0 16 11 80       	push   $0x801116a0
80102fe8:	e8 53 12 00 00       	call   80104240 <wakeup>
  release(&log.lock);
80102fed:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ff4:	e8 a7 16 00 00       	call   801046a0 <release>
80102ff9:	83 c4 10             	add    $0x10,%esp
}
80102ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fff:	5b                   	pop    %ebx
80103000:	5e                   	pop    %esi
80103001:	5f                   	pop    %edi
80103002:	5d                   	pop    %ebp
80103003:	c3                   	ret
    panic("log.committing");
80103004:	83 ec 0c             	sub    $0xc,%esp
80103007:	68 e2 75 10 80       	push   $0x801075e2
8010300c:	e8 6f d3 ff ff       	call   80100380 <panic>
80103011:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103018:	00 
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103020 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103027:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010302d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103030:	83 fa 1d             	cmp    $0x1d,%edx
80103033:	7f 7d                	jg     801030b2 <log_write+0x92>
80103035:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010303a:	83 e8 01             	sub    $0x1,%eax
8010303d:	39 c2                	cmp    %eax,%edx
8010303f:	7d 71                	jge    801030b2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103041:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80103046:	85 c0                	test   %eax,%eax
80103048:	7e 75                	jle    801030bf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010304a:	83 ec 0c             	sub    $0xc,%esp
8010304d:	68 a0 16 11 80       	push   $0x801116a0
80103052:	e8 a9 16 00 00       	call   80104700 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103057:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010305a:	83 c4 10             	add    $0x10,%esp
8010305d:	31 c0                	xor    %eax,%eax
8010305f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80103065:	85 d2                	test   %edx,%edx
80103067:	7f 0e                	jg     80103077 <log_write+0x57>
80103069:	eb 15                	jmp    80103080 <log_write+0x60>
8010306b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103070:	83 c0 01             	add    $0x1,%eax
80103073:	39 c2                	cmp    %eax,%edx
80103075:	74 29                	je     801030a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103077:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010307e:	75 f0                	jne    80103070 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103080:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103087:	39 c2                	cmp    %eax,%edx
80103089:	74 1c                	je     801030a7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010308b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010308e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103091:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103098:	c9                   	leave
  release(&log.lock);
80103099:	e9 02 16 00 00       	jmp    801046a0 <release>
8010309e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801030a0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801030a7:	83 c2 01             	add    $0x1,%edx
801030aa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801030b0:	eb d9                	jmp    8010308b <log_write+0x6b>
    panic("too big a transaction");
801030b2:	83 ec 0c             	sub    $0xc,%esp
801030b5:	68 f1 75 10 80       	push   $0x801075f1
801030ba:	e8 c1 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030bf:	83 ec 0c             	sub    $0xc,%esp
801030c2:	68 07 76 10 80       	push   $0x80107607
801030c7:	e8 b4 d2 ff ff       	call   80100380 <panic>
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	53                   	push   %ebx
801030d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030d7:	e8 b4 09 00 00       	call   80103a90 <cpuid>
801030dc:	89 c3                	mov    %eax,%ebx
801030de:	e8 ad 09 00 00       	call   80103a90 <cpuid>
801030e3:	83 ec 04             	sub    $0x4,%esp
801030e6:	53                   	push   %ebx
801030e7:	50                   	push   %eax
801030e8:	68 22 76 10 80       	push   $0x80107622
801030ed:	e8 be d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801030f2:	e8 79 2a 00 00       	call   80105b70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030f7:	e8 34 09 00 00       	call   80103a30 <mycpu>
801030fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103103:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010310a:	e8 61 0c 00 00       	call   80103d70 <scheduler>
8010310f:	90                   	nop

80103110 <mpenter>:
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103116:	e8 55 3b 00 00       	call   80106c70 <switchkvm>
  seginit();
8010311b:	e8 c0 3a 00 00       	call   80106be0 <seginit>
  lapicinit();
80103120:	e8 bb f7 ff ff       	call   801028e0 <lapicinit>
  mpmain();
80103125:	e8 a6 ff ff ff       	call   801030d0 <mpmain>
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <main>:
{
80103130:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103134:	83 e4 f0             	and    $0xfffffff0,%esp
80103137:	ff 71 fc             	push   -0x4(%ecx)
8010313a:	55                   	push   %ebp
8010313b:	89 e5                	mov    %esp,%ebp
8010313d:	53                   	push   %ebx
8010313e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010313f:	83 ec 08             	sub    $0x8,%esp
80103142:	68 00 00 40 80       	push   $0x80400000
80103147:	68 d0 55 11 80       	push   $0x801155d0
8010314c:	e8 9f f5 ff ff       	call   801026f0 <kinit1>
  kvmalloc();      // kernel page table
80103151:	e8 da 3f 00 00       	call   80107130 <kvmalloc>
  mpinit();        // detect other processors
80103156:	e8 85 01 00 00       	call   801032e0 <mpinit>
  lapicinit();     // interrupt controller
8010315b:	e8 80 f7 ff ff       	call   801028e0 <lapicinit>
  seginit();       // segment descriptors
80103160:	e8 7b 3a 00 00       	call   80106be0 <seginit>
  picinit();       // disable pic
80103165:	e8 96 03 00 00       	call   80103500 <picinit>
  ioapicinit();    // another interrupt controller
8010316a:	e8 51 f3 ff ff       	call   801024c0 <ioapicinit>
  consoleinit();   // console hardware
8010316f:	e8 ec d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103174:	e8 d7 2c 00 00       	call   80105e50 <uartinit>
  pinit();         // process table
80103179:	e8 92 08 00 00       	call   80103a10 <pinit>
  tvinit();        // trap vectors
8010317e:	e8 6d 29 00 00       	call   80105af0 <tvinit>
  binit();         // buffer cache
80103183:	e8 b8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103188:	e8 f3 dc ff ff       	call   80100e80 <fileinit>
  ideinit();       // disk 
8010318d:	e8 0e f1 ff ff       	call   801022a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103192:	83 c4 0c             	add    $0xc,%esp
80103195:	68 8a 00 00 00       	push   $0x8a
8010319a:	68 8c a4 10 80       	push   $0x8010a48c
8010319f:	68 00 70 00 80       	push   $0x80007000
801031a4:	e8 e7 16 00 00       	call   80104890 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801031b3:	00 00 00 
801031b6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801031bb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801031c0:	76 7e                	jbe    80103240 <main+0x110>
801031c2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801031c7:	eb 20                	jmp    801031e9 <main+0xb9>
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801031d7:	00 00 00 
801031da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031e0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801031e5:	39 c3                	cmp    %eax,%ebx
801031e7:	73 57                	jae    80103240 <main+0x110>
    if(c == mycpu())  // We've started already.
801031e9:	e8 42 08 00 00       	call   80103a30 <mycpu>
801031ee:	39 c3                	cmp    %eax,%ebx
801031f0:	74 de                	je     801031d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031f2:	e8 69 f5 ff ff       	call   80102760 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103110,0x80006ff8
80103201:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103204:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010320b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010320e:	05 00 10 00 00       	add    $0x1000,%eax
80103213:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103218:	0f b6 03             	movzbl (%ebx),%eax
8010321b:	68 00 70 00 00       	push   $0x7000
80103220:	50                   	push   %eax
80103221:	e8 fa f7 ff ff       	call   80102a20 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103226:	83 c4 10             	add    $0x10,%esp
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103230:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103236:	85 c0                	test   %eax,%eax
80103238:	74 f6                	je     80103230 <main+0x100>
8010323a:	eb 94                	jmp    801031d0 <main+0xa0>
8010323c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103240:	83 ec 08             	sub    $0x8,%esp
80103243:	68 00 00 00 8e       	push   $0x8e000000
80103248:	68 00 00 40 80       	push   $0x80400000
8010324d:	e8 3e f4 ff ff       	call   80102690 <kinit2>
  userinit();      // first user process
80103252:	e8 89 08 00 00       	call   80103ae0 <userinit>
  mpmain();        // finish this processor's setup
80103257:	e8 74 fe ff ff       	call   801030d0 <mpmain>
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103265:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010326b:	53                   	push   %ebx
  e = addr+len;
8010326c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010326f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103272:	39 de                	cmp    %ebx,%esi
80103274:	72 10                	jb     80103286 <mpsearch1+0x26>
80103276:	eb 50                	jmp    801032c8 <mpsearch1+0x68>
80103278:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010327f:	00 
80103280:	89 fe                	mov    %edi,%esi
80103282:	39 df                	cmp    %ebx,%edi
80103284:	73 42                	jae    801032c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103286:	83 ec 04             	sub    $0x4,%esp
80103289:	8d 7e 10             	lea    0x10(%esi),%edi
8010328c:	6a 04                	push   $0x4
8010328e:	68 36 76 10 80       	push   $0x80107636
80103293:	56                   	push   %esi
80103294:	e8 a7 15 00 00       	call   80104840 <memcmp>
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	85 c0                	test   %eax,%eax
8010329e:	75 e0                	jne    80103280 <mpsearch1+0x20>
801032a0:	89 f2                	mov    %esi,%edx
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032b0:	39 fa                	cmp    %edi,%edx
801032b2:	75 f4                	jne    801032a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032b4:	84 c0                	test   %al,%al
801032b6:	75 c8                	jne    80103280 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032bb:	89 f0                	mov    %esi,%eax
801032bd:	5b                   	pop    %ebx
801032be:	5e                   	pop    %esi
801032bf:	5f                   	pop    %edi
801032c0:	5d                   	pop    %ebp
801032c1:	c3                   	ret
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032cb:	31 f6                	xor    %esi,%esi
}
801032cd:	5b                   	pop    %ebx
801032ce:	89 f0                	mov    %esi,%eax
801032d0:	5e                   	pop    %esi
801032d1:	5f                   	pop    %edi
801032d2:	5d                   	pop    %ebp
801032d3:	c3                   	ret
801032d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032db:	00 
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 2c             	sub    $0x2c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032f7:	c1 e0 08             	shl    $0x8,%eax
801032fa:	09 d0                	or     %edx,%eax
801032fc:	c1 e0 04             	shl    $0x4,%eax
801032ff:	75 1b                	jne    8010331c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103301:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103308:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010330f:	c1 e0 08             	shl    $0x8,%eax
80103312:	09 d0                	or     %edx,%eax
80103314:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103317:	2d 00 04 00 00       	sub    $0x400,%eax
8010331c:	ba 00 04 00 00       	mov    $0x400,%edx
80103321:	e8 3a ff ff ff       	call   80103260 <mpsearch1>
80103326:	85 c0                	test   %eax,%eax
80103328:	0f 84 6a 01 00 00    	je     80103498 <mpinit+0x1b8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010332e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103334:	8b 40 04             	mov    0x4(%eax),%eax
80103337:	85 c0                	test   %eax,%eax
80103339:	0f 84 e9 00 00 00    	je     80103428 <mpinit+0x148>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103342:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103345:	8b 40 04             	mov    0x4(%eax),%eax
80103348:	05 00 00 00 80       	add    $0x80000000,%eax
8010334d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103350:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103353:	6a 04                	push   $0x4
80103355:	68 53 76 10 80       	push   $0x80107653
8010335a:	50                   	push   %eax
8010335b:	e8 e0 14 00 00       	call   80104840 <memcmp>
80103360:	83 c4 10             	add    $0x10,%esp
80103363:	85 c0                	test   %eax,%eax
80103365:	0f 85 bd 00 00 00    	jne    80103428 <mpinit+0x148>
  if(conf->version != 1 && conf->version != 4)
8010336b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010336e:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80103372:	74 0d                	je     80103381 <mpinit+0xa1>
80103374:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103377:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
8010337b:	0f 85 a7 00 00 00    	jne    80103428 <mpinit+0x148>
  if(sum((uchar*)conf, conf->length) != 0)
80103381:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103384:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80103388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
8010338b:	66 85 d2             	test   %dx,%dx
8010338e:	74 1c                	je     801033ac <mpinit+0xcc>
80103390:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
  sum = 0;
80103393:	31 d2                	xor    %edx,%edx
80103395:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103398:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
8010339b:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010339e:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033a0:	39 c3                	cmp    %eax,%ebx
801033a2:	75 f4                	jne    80103398 <mpinit+0xb8>
  if(sum((uchar*)conf, conf->length) != 0)
801033a4:	84 d2                	test   %dl,%dl
801033a6:	0f 85 7c 00 00 00    	jne    80103428 <mpinit+0x148>
  *pmp = mp;
801033ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  return conf;
801033af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801033b2:	85 d2                	test   %edx,%edx
801033b4:	74 72                	je     80103428 <mpinit+0x148>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033b6:	8b 42 24             	mov    0x24(%edx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033b9:	0f b7 4a 04          	movzwl 0x4(%edx),%ecx
801033bd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  ismp = 1;
801033c0:	be 01 00 00 00       	mov    $0x1,%esi
  lapic = (uint*)conf->lapicaddr;
801033c5:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033ca:	8d 42 2c             	lea    0x2c(%edx),%eax
801033cd:	01 ca                	add    %ecx,%edx
801033cf:	90                   	nop
801033d0:	39 d0                	cmp    %edx,%eax
801033d2:	73 19                	jae    801033ed <mpinit+0x10d>
    switch(*p){
801033d4:	0f b6 08             	movzbl (%eax),%ecx
801033d7:	80 f9 02             	cmp    $0x2,%cl
801033da:	74 5c                	je     80103438 <mpinit+0x158>
801033dc:	0f 87 9e 00 00 00    	ja     80103480 <mpinit+0x1a0>
801033e2:	84 c9                	test   %cl,%cl
801033e4:	74 6a                	je     80103450 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033e9:	39 d0                	cmp    %edx,%eax
801033eb:	72 e7                	jb     801033d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033ed:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801033f0:	85 f6                	test   %esi,%esi
801033f2:	0f 84 f0 00 00 00    	je     801034e8 <mpinit+0x208>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033fc:	74 15                	je     80103413 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103403:	ba 22 00 00 00       	mov    $0x22,%edx
80103408:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103409:	ba 23 00 00 00       	mov    $0x23,%edx
8010340e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010340f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103412:	ee                   	out    %al,(%dx)
  }
}
80103413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103416:	5b                   	pop    %ebx
80103417:	5e                   	pop    %esi
80103418:	5f                   	pop    %edi
80103419:	5d                   	pop    %ebp
8010341a:	c3                   	ret
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010341b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103428:	83 ec 0c             	sub    $0xc,%esp
8010342b:	68 3b 76 10 80       	push   $0x8010763b
80103430:	e8 4b cf ff ff       	call   80100380 <panic>
80103435:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103438:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010343c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010343f:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
80103445:	eb 89                	jmp    801033d0 <mpinit+0xf0>
80103447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010344e:	00 
8010344f:	90                   	nop
      if(ncpu < NCPU) {
80103450:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103456:	83 f9 07             	cmp    $0x7,%ecx
80103459:	7f 19                	jg     80103474 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010345b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103461:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103465:	83 c1 01             	add    $0x1,%ecx
80103468:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010346e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103474:	83 c0 14             	add    $0x14,%eax
      continue;
80103477:	e9 54 ff ff ff       	jmp    801033d0 <mpinit+0xf0>
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103480:	83 e9 03             	sub    $0x3,%ecx
80103483:	80 f9 01             	cmp    $0x1,%cl
80103486:	0f 86 5a ff ff ff    	jbe    801033e6 <mpinit+0x106>
8010348c:	31 f6                	xor    %esi,%esi
8010348e:	e9 3d ff ff ff       	jmp    801033d0 <mpinit+0xf0>
80103493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
{
80103498:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010349d:	eb 0f                	jmp    801034ae <mpinit+0x1ce>
8010349f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801034a0:	89 f3                	mov    %esi,%ebx
801034a2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034a8:	0f 84 6d ff ff ff    	je     8010341b <mpinit+0x13b>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ae:	83 ec 04             	sub    $0x4,%esp
801034b1:	8d 73 10             	lea    0x10(%ebx),%esi
801034b4:	6a 04                	push   $0x4
801034b6:	68 36 76 10 80       	push   $0x80107636
801034bb:	53                   	push   %ebx
801034bc:	e8 7f 13 00 00       	call   80104840 <memcmp>
801034c1:	83 c4 10             	add    $0x10,%esp
801034c4:	85 c0                	test   %eax,%eax
801034c6:	75 d8                	jne    801034a0 <mpinit+0x1c0>
801034c8:	89 da                	mov    %ebx,%edx
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034d0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034d3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034d6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034d8:	39 f2                	cmp    %esi,%edx
801034da:	75 f4                	jne    801034d0 <mpinit+0x1f0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034dc:	84 c0                	test   %al,%al
801034de:	75 c0                	jne    801034a0 <mpinit+0x1c0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034e3:	e9 49 fe ff ff       	jmp    80103331 <mpinit+0x51>
    panic("Didn't find a suitable machine");
801034e8:	83 ec 0c             	sub    $0xc,%esp
801034eb:	68 04 7a 10 80       	push   $0x80107a04
801034f0:	e8 8b ce ff ff       	call   80100380 <panic>
801034f5:	66 90                	xchg   %ax,%ax
801034f7:	66 90                	xchg   %ax,%ax
801034f9:	66 90                	xchg   %ax,%ax
801034fb:	66 90                	xchg   %ax,%ax
801034fd:	66 90                	xchg   %ax,%ax
801034ff:	90                   	nop

80103500 <picinit>:
80103500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103505:	ba 21 00 00 00       	mov    $0x21,%edx
8010350a:	ee                   	out    %al,(%dx)
8010350b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103510:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103511:	c3                   	ret
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <pipealloc>:
  int tainted;    // data written by tainted process
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	8b 75 08             	mov    0x8(%ebp),%esi
8010352c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010352f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103535:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010353b:	e8 60 d9 ff ff       	call   80100ea0 <filealloc>
80103540:	89 06                	mov    %eax,(%esi)
80103542:	85 c0                	test   %eax,%eax
80103544:	0f 84 af 00 00 00    	je     801035f9 <pipealloc+0xd9>
8010354a:	e8 51 d9 ff ff       	call   80100ea0 <filealloc>
8010354f:	89 07                	mov    %eax,(%edi)
80103551:	85 c0                	test   %eax,%eax
80103553:	0f 84 8e 00 00 00    	je     801035e7 <pipealloc+0xc7>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103559:	e8 02 f2 ff ff       	call   80102760 <kalloc>
8010355e:	89 c3                	mov    %eax,%ebx
80103560:	85 c0                	test   %eax,%eax
80103562:	0f 84 aa 00 00 00    	je     80103612 <pipealloc+0xf2>
    goto bad;
  p->readopen = 1;
80103568:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010356f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  p->tainted = 0;
  initlock(&p->lock, "pipe");
80103572:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103575:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010357c:	00 00 00 
  p->nwrite = 0;
8010357f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103586:	00 00 00 
  p->nread = 0;
80103589:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103590:	00 00 00 
  p->tainted = 0;
80103593:	c7 80 44 02 00 00 00 	movl   $0x0,0x244(%eax)
8010359a:	00 00 00 
  initlock(&p->lock, "pipe");
8010359d:	68 58 76 10 80       	push   $0x80107658
801035a2:	50                   	push   %eax
801035a3:	e8 68 0f 00 00       	call   80104510 <initlock>
  (*f0)->type = FD_PIPE;
801035a8:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035aa:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035ad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035b3:	8b 06                	mov    (%esi),%eax
801035b5:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035b9:	8b 06                	mov    (%esi),%eax
801035bb:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035bf:	8b 06                	mov    (%esi),%eax
801035c1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035c4:	8b 07                	mov    (%edi),%eax
801035c6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035cc:	8b 07                	mov    (%edi),%eax
801035ce:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035d2:	8b 07                	mov    (%edi),%eax
801035d4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035d8:	8b 07                	mov    (%edi),%eax
801035da:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801035dd:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5f                   	pop    %edi
801035e5:	5d                   	pop    %ebp
801035e6:	c3                   	ret
  if(*f0)
801035e7:	8b 06                	mov    (%esi),%eax
801035e9:	85 c0                	test   %eax,%eax
801035eb:	74 1e                	je     8010360b <pipealloc+0xeb>
    fileclose(*f0);
801035ed:	83 ec 0c             	sub    $0xc,%esp
801035f0:	50                   	push   %eax
801035f1:	e8 6a d9 ff ff       	call   80100f60 <fileclose>
801035f6:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035f9:	8b 07                	mov    (%edi),%eax
801035fb:	85 c0                	test   %eax,%eax
801035fd:	74 0c                	je     8010360b <pipealloc+0xeb>
    fileclose(*f1);
801035ff:	83 ec 0c             	sub    $0xc,%esp
80103602:	50                   	push   %eax
80103603:	e8 58 d9 ff ff       	call   80100f60 <fileclose>
80103608:	83 c4 10             	add    $0x10,%esp
  return -1;
8010360b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103610:	eb cd                	jmp    801035df <pipealloc+0xbf>
  if(*f0)
80103612:	8b 06                	mov    (%esi),%eax
80103614:	85 c0                	test   %eax,%eax
80103616:	75 d5                	jne    801035ed <pipealloc+0xcd>
80103618:	eb df                	jmp    801035f9 <pipealloc+0xd9>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103620 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103628:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010362b:	83 ec 0c             	sub    $0xc,%esp
8010362e:	53                   	push   %ebx
8010362f:	e8 cc 10 00 00       	call   80104700 <acquire>
  if(writable){
80103634:	83 c4 10             	add    $0x10,%esp
80103637:	85 f6                	test   %esi,%esi
80103639:	74 65                	je     801036a0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103644:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010364b:	00 00 00 
    wakeup(&p->nread);
8010364e:	50                   	push   %eax
8010364f:	e8 ec 0b 00 00       	call   80104240 <wakeup>
80103654:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103657:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010365d:	85 d2                	test   %edx,%edx
8010365f:	75 0a                	jne    8010366b <pipeclose+0x4b>
80103661:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103667:	85 c0                	test   %eax,%eax
80103669:	74 15                	je     80103680 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010366b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010366e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103671:	5b                   	pop    %ebx
80103672:	5e                   	pop    %esi
80103673:	5d                   	pop    %ebp
    release(&p->lock);
80103674:	e9 27 10 00 00       	jmp    801046a0 <release>
80103679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	53                   	push   %ebx
80103684:	e8 17 10 00 00       	call   801046a0 <release>
    kfree((char*)p);
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010368f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103692:	5b                   	pop    %ebx
80103693:	5e                   	pop    %esi
80103694:	5d                   	pop    %ebp
    kfree((char*)p);
80103695:	e9 06 ef ff ff       	jmp    801025a0 <kfree>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036b0:	00 00 00 
    wakeup(&p->nwrite);
801036b3:	50                   	push   %eax
801036b4:	e8 87 0b 00 00       	call   80104240 <wakeup>
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	eb 99                	jmp    80103657 <pipeclose+0x37>
801036be:	66 90                	xchg   %ax,%ax

801036c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 28             	sub    $0x28,%esp
801036c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036cc:	53                   	push   %ebx
801036cd:	e8 2e 10 00 00       	call   80104700 <acquire>
  for(i = 0; i < n; i++){
801036d2:	8b 45 10             	mov    0x10(%ebp),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	85 c0                	test   %eax,%eax
801036da:	0f 8e da 00 00 00    	jle    801037ba <pipewrite+0xfa>
801036e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036e3:	8b 45 10             	mov    0x10(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036e6:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801036ec:	01 c8                	add    %ecx,%eax
801036ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036f1:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036f7:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036fd:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103703:	05 00 02 00 00       	add    $0x200,%eax
80103708:	39 c2                	cmp    %eax,%edx
8010370a:	75 6f                	jne    8010377b <pipewrite+0xbb>
8010370c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010370f:	eb 3d                	jmp    8010374e <pipewrite+0x8e>
80103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103718:	e8 93 03 00 00       	call   80103ab0 <myproc>
8010371d:	8b 48 24             	mov    0x24(%eax),%ecx
80103720:	85 c9                	test   %ecx,%ecx
80103722:	75 34                	jne    80103758 <pipewrite+0x98>
      wakeup(&p->nread);
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	56                   	push   %esi
80103728:	e8 13 0b 00 00       	call   80104240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010372d:	58                   	pop    %eax
8010372e:	5a                   	pop    %edx
8010372f:	53                   	push   %ebx
80103730:	57                   	push   %edi
80103731:	e8 4a 0a 00 00       	call   80104180 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103736:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010373c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103742:	83 c4 10             	add    $0x10,%esp
80103745:	05 00 02 00 00       	add    $0x200,%eax
8010374a:	39 c2                	cmp    %eax,%edx
8010374c:	75 2a                	jne    80103778 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010374e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103754:	85 c0                	test   %eax,%eax
80103756:	75 c0                	jne    80103718 <pipewrite+0x58>
        release(&p->lock);
80103758:	83 ec 0c             	sub    $0xc,%esp
8010375b:	53                   	push   %ebx
8010375c:	e8 3f 0f 00 00       	call   801046a0 <release>
        return -1;
80103761:	83 c4 10             	add    $0x10,%esp
80103764:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      p->tainted = 1;
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103769:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010376c:	5b                   	pop    %ebx
8010376d:	5e                   	pop    %esi
8010376e:	5f                   	pop    %edi
8010376f:	5d                   	pop    %ebp
80103770:	c3                   	ret
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103778:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010377b:	8d 42 01             	lea    0x1(%edx),%eax
8010377e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103784:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103787:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010378d:	0f b6 01             	movzbl (%ecx),%eax
80103790:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
    if(myproc()->tainted == TAINT_UNTRUSTED)
80103794:	e8 17 03 00 00       	call   80103ab0 <myproc>
80103799:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010379c:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
801037a0:	75 0a                	jne    801037ac <pipewrite+0xec>
      p->tainted = 1;
801037a2:	c7 83 44 02 00 00 01 	movl   $0x1,0x244(%ebx)
801037a9:	00 00 00 
  for(i = 0; i < n; i++){
801037ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801037af:	83 c1 01             	add    $0x1,%ecx
801037b2:	39 c1                	cmp    %eax,%ecx
801037b4:	0f 85 37 ff ff ff    	jne    801036f1 <pipewrite+0x31>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c3:	50                   	push   %eax
801037c4:	e8 77 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
801037c9:	89 1c 24             	mov    %ebx,(%esp)
801037cc:	e8 cf 0e 00 00       	call   801046a0 <release>
  return n;
801037d1:	8b 45 10             	mov    0x10(%ebp),%eax
801037d4:	83 c4 10             	add    $0x10,%esp
801037d7:	eb 90                	jmp    80103769 <pipewrite+0xa9>
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 18             	sub    $0x18,%esp
801037e9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	56                   	push   %esi
801037f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037f6:	e8 05 0f 00 00       	call   80104700 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010380a:	74 2f                	je     8010383b <piperead+0x5b>
8010380c:	eb 37                	jmp    80103845 <piperead+0x65>
8010380e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103810:	e8 9b 02 00 00       	call   80103ab0 <myproc>
80103815:	8b 40 24             	mov    0x24(%eax),%eax
80103818:	85 c0                	test   %eax,%eax
8010381a:	0f 85 90 00 00 00    	jne    801038b0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 56 09 00 00       	call   80104180 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103839:	75 0a                	jne    80103845 <piperead+0x65>
8010383b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103841:	85 d2                	test   %edx,%edx
80103843:	75 cb                	jne    80103810 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	85 c9                	test   %ecx,%ecx
8010384c:	7f 26                	jg     80103874 <piperead+0x94>
8010384e:	eb 3a                	jmp    8010388a <piperead+0xaa>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103850:	8d 48 01             	lea    0x1(%eax),%ecx
80103853:	25 ff 01 00 00       	and    $0x1ff,%eax
80103858:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010385e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103863:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103866:	83 c3 01             	add    $0x1,%ebx
80103869:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386c:	74 0e                	je     8010387c <piperead+0x9c>
8010386e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103874:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010387a:	75 d4                	jne    80103850 <piperead+0x70>
  }
  if(p->tainted && i > 0)
8010387c:	8b 86 44 02 00 00    	mov    0x244(%esi),%eax
80103882:	85 c0                	test   %eax,%eax
80103884:	74 04                	je     8010388a <piperead+0xaa>
80103886:	85 db                	test   %ebx,%ebx
80103888:	75 46                	jne    801038d0 <piperead+0xf0>
    myproc()->tainted = TAINT_UNTRUSTED;
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010388a:	83 ec 0c             	sub    $0xc,%esp
8010388d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103893:	50                   	push   %eax
80103894:	e8 a7 09 00 00       	call   80104240 <wakeup>
  release(&p->lock);
80103899:	89 34 24             	mov    %esi,(%esp)
8010389c:	e8 ff 0d 00 00       	call   801046a0 <release>
  return i;
801038a1:	83 c4 10             	add    $0x10,%esp
}
801038a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a7:	89 d8                	mov    %ebx,%eax
801038a9:	5b                   	pop    %ebx
801038aa:	5e                   	pop    %esi
801038ab:	5f                   	pop    %edi
801038ac:	5d                   	pop    %ebp
801038ad:	c3                   	ret
801038ae:	66 90                	xchg   %ax,%ax
      release(&p->lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038b8:	56                   	push   %esi
801038b9:	e8 e2 0d 00 00       	call   801046a0 <release>
      return -1;
801038be:	83 c4 10             	add    $0x10,%esp
}
801038c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038c4:	89 d8                	mov    %ebx,%eax
801038c6:	5b                   	pop    %ebx
801038c7:	5e                   	pop    %esi
801038c8:	5f                   	pop    %edi
801038c9:	5d                   	pop    %ebp
801038ca:	c3                   	ret
801038cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    myproc()->tainted = TAINT_UNTRUSTED;
801038d0:	e8 db 01 00 00       	call   80103ab0 <myproc>
801038d5:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
801038dc:	eb ac                	jmp    8010388a <piperead+0xaa>
801038de:	66 90                	xchg   %ax,%ax

801038e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801038e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ec:	68 20 1d 11 80       	push   $0x80111d20
801038f1:	e8 0a 0e 00 00       	call   80104700 <acquire>
801038f6:	83 c4 10             	add    $0x10,%esp
801038f9:	eb 14                	jmp    8010390f <allocproc+0x2f>
801038fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103900:	83 eb 80             	sub    $0xffffff80,%ebx
80103903:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103909:	0f 84 81 00 00 00    	je     80103990 <allocproc+0xb0>
    if(p->state == UNUSED)
8010390f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103912:	85 c0                	test   %eax,%eax
80103914:	75 ea                	jne    80103900 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103916:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->tainted = TAINT_NONE;

  release(&ptable.lock);
8010391b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010391e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->tainted = TAINT_NONE;
80103925:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
8010392c:	89 43 10             	mov    %eax,0x10(%ebx)
8010392f:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103932:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103937:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010393d:	e8 5e 0d 00 00       	call   801046a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103942:	e8 19 ee ff ff       	call   80102760 <kalloc>
80103947:	83 c4 10             	add    $0x10,%esp
8010394a:	89 43 08             	mov    %eax,0x8(%ebx)
8010394d:	85 c0                	test   %eax,%eax
8010394f:	74 58                	je     801039a9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103951:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103957:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010395a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010395f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103962:	c7 40 14 d8 5a 10 80 	movl   $0x80105ad8,0x14(%eax)
  p->context = (struct context*)sp;
80103969:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010396c:	6a 14                	push   $0x14
8010396e:	6a 00                	push   $0x0
80103970:	50                   	push   %eax
80103971:	e8 8a 0e 00 00       	call   80104800 <memset>
  p->context->eip = (uint)forkret;
80103976:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103979:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010397c:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
}
80103983:	89 d8                	mov    %ebx,%eax
80103985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103988:	c9                   	leave
80103989:	c3                   	ret
8010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103993:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103995:	68 20 1d 11 80       	push   $0x80111d20
8010399a:	e8 01 0d 00 00       	call   801046a0 <release>
  return 0;
8010399f:	83 c4 10             	add    $0x10,%esp
}
801039a2:	89 d8                	mov    %ebx,%eax
801039a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a7:	c9                   	leave
801039a8:	c3                   	ret
    p->state = UNUSED;
801039a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801039b0:	31 db                	xor    %ebx,%ebx
801039b2:	eb ee                	jmp    801039a2 <allocproc+0xc2>
801039b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039bb:	00 
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039c6:	68 20 1d 11 80       	push   $0x80111d20
801039cb:	e8 d0 0c 00 00       	call   801046a0 <release>

  if (first) {
801039d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	85 c0                	test   %eax,%eax
801039da:	75 04                	jne    801039e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039dc:	c9                   	leave
801039dd:	c3                   	ret
801039de:	66 90                	xchg   %ax,%ax
    first = 0;
801039e0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039e7:	00 00 00 
    iinit(ROOTDEV);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	6a 01                	push   $0x1
801039ef:	e8 6c dc ff ff       	call   80101660 <iinit>
    initlog(ROOTDEV);
801039f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039fb:	e8 a0 f3 ff ff       	call   80102da0 <initlog>
}
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	c9                   	leave
80103a04:	c3                   	ret
80103a05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a0c:	00 
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi

80103a10 <pinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a16:	68 5d 76 10 80       	push   $0x8010765d
80103a1b:	68 20 1d 11 80       	push   $0x80111d20
80103a20:	e8 eb 0a 00 00       	call   80104510 <initlock>
}
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	c9                   	leave
80103a29:	c3                   	ret
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <mycpu>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a35:	9c                   	pushf
80103a36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a37:	f6 c4 02             	test   $0x2,%ah
80103a3a:	75 46                	jne    80103a82 <mycpu+0x52>
  apicid = lapicid();
80103a3c:	e8 8f ef ff ff       	call   801029d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a41:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103a47:	85 f6                	test   %esi,%esi
80103a49:	7e 2a                	jle    80103a75 <mycpu+0x45>
80103a4b:	31 d2                	xor    %edx,%edx
80103a4d:	eb 08                	jmp    80103a57 <mycpu+0x27>
80103a4f:	90                   	nop
80103a50:	83 c2 01             	add    $0x1,%edx
80103a53:	39 f2                	cmp    %esi,%edx
80103a55:	74 1e                	je     80103a75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a5d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103a64:	39 c3                	cmp    %eax,%ebx
80103a66:	75 e8                	jne    80103a50 <mycpu+0x20>
}
80103a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a6b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103a71:	5b                   	pop    %ebx
80103a72:	5e                   	pop    %esi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret
  panic("unknown apicid\n");
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	68 64 76 10 80       	push   $0x80107664
80103a7d:	e8 fe c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 24 7a 10 80       	push   $0x80107a24
80103a8a:	e8 f1 c8 ff ff       	call   80100380 <panic>
80103a8f:	90                   	nop

80103a90 <cpuid>:
cpuid() {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a96:	e8 95 ff ff ff       	call   80103a30 <mycpu>
}
80103a9b:	c9                   	leave
  return mycpu()-cpus;
80103a9c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103aa1:	c1 f8 04             	sar    $0x4,%eax
80103aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aaa:	c3                   	ret
80103aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ab0 <myproc>:
myproc(void) {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ab7:	e8 f4 0a 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103abc:	e8 6f ff ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 34 0b 00 00       	call   80104600 <popcli>
}
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad1:	c9                   	leave
80103ad2:	c3                   	ret
80103ad3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ada:	00 
80103adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ae0 <userinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ae7:	e8 f4 fd ff ff       	call   801038e0 <allocproc>
80103aec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103aee:	a3 54 3d 11 80       	mov    %eax,0x80113d54
  if((p->pgdir = setupkvm()) == 0)
80103af3:	e8 b8 35 00 00       	call   801070b0 <setupkvm>
80103af8:	89 43 04             	mov    %eax,0x4(%ebx)
80103afb:	85 c0                	test   %eax,%eax
80103afd:	0f 84 bd 00 00 00    	je     80103bc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b03:	83 ec 04             	sub    $0x4,%esp
80103b06:	68 2c 00 00 00       	push   $0x2c
80103b0b:	68 60 a4 10 80       	push   $0x8010a460
80103b10:	50                   	push   %eax
80103b11:	e8 7a 32 00 00       	call   80106d90 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b1f:	6a 4c                	push   $0x4c
80103b21:	6a 00                	push   $0x0
80103b23:	ff 73 18             	push   0x18(%ebx)
80103b26:	e8 d5 0c 00 00       	call   80104800 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b51:	8b 43 18             	mov    0x18(%ebx),%eax
80103b54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b66:	8b 43 18             	mov    0x18(%ebx),%eax
80103b69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b70:	8b 43 18             	mov    0x18(%ebx),%eax
80103b73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b7d:	6a 10                	push   $0x10
80103b7f:	68 8d 76 10 80       	push   $0x8010768d
80103b84:	50                   	push   %eax
80103b85:	e8 26 0e 00 00       	call   801049b0 <safestrcpy>
  p->cwd = namei("/");
80103b8a:	c7 04 24 75 74 10 80 	movl   $0x80107475,(%esp)
80103b91:	e8 ea e5 ff ff       	call   80102180 <namei>
80103b96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b99:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ba0:	e8 5b 0b 00 00       	call   80104700 <acquire>
  p->state = RUNNABLE;
80103ba5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bac:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bb3:	e8 e8 0a 00 00       	call   801046a0 <release>
}
80103bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bbb:	83 c4 10             	add    $0x10,%esp
80103bbe:	c9                   	leave
80103bbf:	c3                   	ret
    panic("userinit: out of memory?");
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	68 74 76 10 80       	push   $0x80107674
80103bc8:	e8 b3 c7 ff ff       	call   80100380 <panic>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <growproc>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	56                   	push   %esi
80103bd4:	53                   	push   %ebx
80103bd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bd8:	e8 d3 09 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103bdd:	e8 4e fe ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103be2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be8:	e8 13 0a 00 00       	call   80104600 <popcli>
  sz = curproc->sz;
80103bed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bef:	85 f6                	test   %esi,%esi
80103bf1:	7f 1d                	jg     80103c10 <growproc+0x40>
  } else if(n < 0){
80103bf3:	75 3b                	jne    80103c30 <growproc+0x60>
  switchuvm(curproc);
80103bf5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bf8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bfa:	53                   	push   %ebx
80103bfb:	e8 80 30 00 00       	call   80106c80 <switchuvm>
  return 0;
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	31 c0                	xor    %eax,%eax
}
80103c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c08:	5b                   	pop    %ebx
80103c09:	5e                   	pop    %esi
80103c0a:	5d                   	pop    %ebp
80103c0b:	c3                   	ret
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	push   0x4(%ebx)
80103c1a:	e8 c1 32 00 00       	call   80106ee0 <allocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 cf                	jne    80103bf5 <growproc+0x25>
      return -1;
80103c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c2b:	eb d8                	jmp    80103c05 <growproc+0x35>
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c30:	83 ec 04             	sub    $0x4,%esp
80103c33:	01 c6                	add    %eax,%esi
80103c35:	56                   	push   %esi
80103c36:	50                   	push   %eax
80103c37:	ff 73 04             	push   0x4(%ebx)
80103c3a:	e8 c1 33 00 00       	call   80107000 <deallocuvm>
80103c3f:	83 c4 10             	add    $0x10,%esp
80103c42:	85 c0                	test   %eax,%eax
80103c44:	75 af                	jne    80103bf5 <growproc+0x25>
80103c46:	eb de                	jmp    80103c26 <growproc+0x56>
80103c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c4f:	00 

80103c50 <fork>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c59:	e8 52 09 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103c5e:	e8 cd fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103c63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c69:	e8 92 09 00 00       	call   80104600 <popcli>
  if((np = allocproc()) == 0){
80103c6e:	e8 6d fc ff ff       	call   801038e0 <allocproc>
80103c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c76:	85 c0                	test   %eax,%eax
80103c78:	0f 84 de 00 00 00    	je     80103d5c <fork+0x10c>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c7e:	83 ec 08             	sub    $0x8,%esp
80103c81:	ff 33                	push   (%ebx)
80103c83:	89 c7                	mov    %eax,%edi
80103c85:	ff 73 04             	push   0x4(%ebx)
80103c88:	e8 13 35 00 00       	call   801071a0 <copyuvm>
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	89 47 04             	mov    %eax,0x4(%edi)
80103c93:	85 c0                	test   %eax,%eax
80103c95:	0f 84 a2 00 00 00    	je     80103d3d <fork+0xed>
  np->sz = curproc->sz;
80103c9b:	8b 03                	mov    (%ebx),%eax
80103c9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103ca0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103ca5:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103ca7:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103caa:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103cad:	8b 73 18             	mov    0x18(%ebx),%esi
80103cb0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cb2:	31 f6                	xor    %esi,%esi
  np->tainted = curproc->tainted;
80103cb4:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103cb7:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
80103cba:	8b 42 18             	mov    0x18(%edx),%eax
80103cbd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103cc8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ccc:	85 c0                	test   %eax,%eax
80103cce:	74 13                	je     80103ce3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	50                   	push   %eax
80103cd4:	e8 37 d2 ff ff       	call   80100f10 <filedup>
80103cd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cdc:	83 c4 10             	add    $0x10,%esp
80103cdf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ce3:	83 c6 01             	add    $0x1,%esi
80103ce6:	83 fe 10             	cmp    $0x10,%esi
80103ce9:	75 dd                	jne    80103cc8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103ceb:	83 ec 0c             	sub    $0xc,%esp
80103cee:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cf4:	e8 77 db ff ff       	call   80101870 <idup>
80103cf9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cfc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cff:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d02:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d05:	6a 10                	push   $0x10
80103d07:	53                   	push   %ebx
80103d08:	50                   	push   %eax
80103d09:	e8 a2 0c 00 00       	call   801049b0 <safestrcpy>
  pid = np->pid;
80103d0e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d11:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d18:	e8 e3 09 00 00       	call   80104700 <acquire>
  np->state = RUNNABLE;
80103d1d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d24:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103d2b:	e8 70 09 00 00       	call   801046a0 <release>
  return pid;
80103d30:	83 c4 10             	add    $0x10,%esp
}
80103d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d36:	89 d8                	mov    %ebx,%eax
80103d38:	5b                   	pop    %ebx
80103d39:	5e                   	pop    %esi
80103d3a:	5f                   	pop    %edi
80103d3b:	5d                   	pop    %ebp
80103d3c:	c3                   	ret
    kfree(np->kstack);
80103d3d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	ff 73 08             	push   0x8(%ebx)
80103d46:	e8 55 e8 ff ff       	call   801025a0 <kfree>
    np->kstack = 0;
80103d4b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d52:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d55:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d5c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d61:	eb d0                	jmp    80103d33 <fork+0xe3>
80103d63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d6a:	00 
80103d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d70 <scheduler>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d79:	e8 b2 fc ff ff       	call   80103a30 <mycpu>
  c->proc = 0;
80103d7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d85:	00 00 00 
  struct cpu *c = mycpu();
80103d88:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d8a:	8d 78 04             	lea    0x4(%eax),%edi
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d90:	fb                   	sti
    acquire(&ptable.lock);
80103d91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d94:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103d99:	68 20 1d 11 80       	push   $0x80111d20
80103d9e:	e8 5d 09 00 00       	call   80104700 <acquire>
80103da3:	83 c4 10             	add    $0x10,%esp
80103da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dad:	00 
80103dae:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103db0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103db4:	75 33                	jne    80103de9 <scheduler+0x79>
      switchuvm(p);
80103db6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103db9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dbf:	53                   	push   %ebx
80103dc0:	e8 bb 2e 00 00       	call   80106c80 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dc5:	58                   	pop    %eax
80103dc6:	5a                   	pop    %edx
80103dc7:	ff 73 1c             	push   0x1c(%ebx)
80103dca:	57                   	push   %edi
      p->state = RUNNING;
80103dcb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103dd2:	e8 34 0c 00 00       	call   80104a0b <swtch>
      switchkvm();
80103dd7:	e8 94 2e 00 00       	call   80106c70 <switchkvm>
      c->proc = 0;
80103ddc:	83 c4 10             	add    $0x10,%esp
80103ddf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103de6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de9:	83 eb 80             	sub    $0xffffff80,%ebx
80103dec:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103df2:	75 bc                	jne    80103db0 <scheduler+0x40>
    release(&ptable.lock);
80103df4:	83 ec 0c             	sub    $0xc,%esp
80103df7:	68 20 1d 11 80       	push   $0x80111d20
80103dfc:	e8 9f 08 00 00       	call   801046a0 <release>
    sti();
80103e01:	83 c4 10             	add    $0x10,%esp
80103e04:	eb 8a                	jmp    80103d90 <scheduler+0x20>
80103e06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e0d:	00 
80103e0e:	66 90                	xchg   %ax,%ax

80103e10 <sched>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	56                   	push   %esi
80103e14:	53                   	push   %ebx
  pushcli();
80103e15:	e8 96 07 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80103e1a:	e8 11 fc ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103e1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e25:	e8 d6 07 00 00       	call   80104600 <popcli>
  if(!holding(&ptable.lock))
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 20 1d 11 80       	push   $0x80111d20
80103e32:	e8 29 08 00 00       	call   80104660 <holding>
80103e37:	83 c4 10             	add    $0x10,%esp
80103e3a:	85 c0                	test   %eax,%eax
80103e3c:	74 4f                	je     80103e8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e3e:	e8 ed fb ff ff       	call   80103a30 <mycpu>
80103e43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e4a:	75 68                	jne    80103eb4 <sched+0xa4>
  if(p->state == RUNNING)
80103e4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e50:	74 55                	je     80103ea7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e52:	9c                   	pushf
80103e53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e54:	f6 c4 02             	test   $0x2,%ah
80103e57:	75 41                	jne    80103e9a <sched+0x8a>
  intena = mycpu()->intena;
80103e59:	e8 d2 fb ff ff       	call   80103a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e5e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e67:	e8 c4 fb ff ff       	call   80103a30 <mycpu>
80103e6c:	83 ec 08             	sub    $0x8,%esp
80103e6f:	ff 70 04             	push   0x4(%eax)
80103e72:	53                   	push   %ebx
80103e73:	e8 93 0b 00 00       	call   80104a0b <swtch>
  mycpu()->intena = intena;
80103e78:	e8 b3 fb ff ff       	call   80103a30 <mycpu>
}
80103e7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e89:	5b                   	pop    %ebx
80103e8a:	5e                   	pop    %esi
80103e8b:	5d                   	pop    %ebp
80103e8c:	c3                   	ret
    panic("sched ptable.lock");
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 96 76 10 80       	push   $0x80107696
80103e95:	e8 e6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 c2 76 10 80       	push   $0x801076c2
80103ea2:	e8 d9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103ea7:	83 ec 0c             	sub    $0xc,%esp
80103eaa:	68 b4 76 10 80       	push   $0x801076b4
80103eaf:	e8 cc c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	68 a8 76 10 80       	push   $0x801076a8
80103ebc:	e8 bf c4 ff ff       	call   80100380 <panic>
80103ec1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ec8:	00 
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <exit>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ed9:	e8 d2 fb ff ff       	call   80103ab0 <myproc>
  if(curproc == initproc)
80103ede:	39 05 54 3d 11 80    	cmp    %eax,0x80113d54
80103ee4:	0f 84 fd 00 00 00    	je     80103fe7 <exit+0x117>
80103eea:	89 c3                	mov    %eax,%ebx
80103eec:	8d 70 28             	lea    0x28(%eax),%esi
80103eef:	8d 78 68             	lea    0x68(%eax),%edi
80103ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ef8:	8b 06                	mov    (%esi),%eax
80103efa:	85 c0                	test   %eax,%eax
80103efc:	74 12                	je     80103f10 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	50                   	push   %eax
80103f02:	e8 59 d0 ff ff       	call   80100f60 <fileclose>
      curproc->ofile[fd] = 0;
80103f07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f0d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f10:	83 c6 04             	add    $0x4,%esi
80103f13:	39 f7                	cmp    %esi,%edi
80103f15:	75 e1                	jne    80103ef8 <exit+0x28>
  begin_op();
80103f17:	e8 24 ef ff ff       	call   80102e40 <begin_op>
  iput(curproc->cwd);
80103f1c:	83 ec 0c             	sub    $0xc,%esp
80103f1f:	ff 73 68             	push   0x68(%ebx)
80103f22:	e8 a9 da ff ff       	call   801019d0 <iput>
  end_op();
80103f27:	e8 84 ef ff ff       	call   80102eb0 <end_op>
  curproc->cwd = 0;
80103f2c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f33:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103f3a:	e8 c1 07 00 00       	call   80104700 <acquire>
  wakeup1(curproc->parent);
80103f3f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f42:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f45:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f4a:	eb 0e                	jmp    80103f5a <exit+0x8a>
80103f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f50:	83 e8 80             	sub    $0xffffff80,%eax
80103f53:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103f58:	74 1c                	je     80103f76 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f5e:	75 f0                	jne    80103f50 <exit+0x80>
80103f60:	3b 50 20             	cmp    0x20(%eax),%edx
80103f63:	75 eb                	jne    80103f50 <exit+0x80>
      p->state = RUNNABLE;
80103f65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f6c:	83 e8 80             	sub    $0xffffff80,%eax
80103f6f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103f74:	75 e4                	jne    80103f5a <exit+0x8a>
      p->parent = initproc;
80103f76:	8b 0d 54 3d 11 80    	mov    0x80113d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f81:	eb 10                	jmp    80103f93 <exit+0xc3>
80103f83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f88:	83 ea 80             	sub    $0xffffff80,%edx
80103f8b:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
80103f91:	74 3b                	je     80103fce <exit+0xfe>
    if(p->parent == curproc){
80103f93:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f96:	75 f0                	jne    80103f88 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f98:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f9c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f9f:	75 e7                	jne    80103f88 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa1:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103fa6:	eb 12                	jmp    80103fba <exit+0xea>
80103fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103faf:	00 
80103fb0:	83 e8 80             	sub    $0xffffff80,%eax
80103fb3:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103fb8:	74 ce                	je     80103f88 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fbe:	75 f0                	jne    80103fb0 <exit+0xe0>
80103fc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fc3:	75 eb                	jne    80103fb0 <exit+0xe0>
      p->state = RUNNABLE;
80103fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fcc:	eb e2                	jmp    80103fb0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fd5:	e8 36 fe ff ff       	call   80103e10 <sched>
  panic("zombie exit");
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 e3 76 10 80       	push   $0x801076e3
80103fe2:	e8 99 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 d6 76 10 80       	push   $0x801076d6
80103fef:	e8 8c c3 ff ff       	call   80100380 <panic>
80103ff4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ffb:	00 
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104000 <wait>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  pushcli();
80104005:	e8 a6 05 00 00       	call   801045b0 <pushcli>
  c = mycpu();
8010400a:	e8 21 fa ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010400f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104015:	e8 e6 05 00 00       	call   80104600 <popcli>
  acquire(&ptable.lock);
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 20 1d 11 80       	push   $0x80111d20
80104022:	e8 d9 06 00 00       	call   80104700 <acquire>
80104027:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104031:	eb 10                	jmp    80104043 <wait+0x43>
80104033:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104038:	83 eb 80             	sub    $0xffffff80,%ebx
8010403b:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80104041:	74 1b                	je     8010405e <wait+0x5e>
      if(p->parent != curproc)
80104043:	39 73 14             	cmp    %esi,0x14(%ebx)
80104046:	75 f0                	jne    80104038 <wait+0x38>
      if(p->state == ZOMBIE){
80104048:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010404c:	74 62                	je     801040b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104051:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
8010405c:	75 e5                	jne    80104043 <wait+0x43>
    if(!havekids || curproc->killed){
8010405e:	85 c0                	test   %eax,%eax
80104060:	0f 84 a0 00 00 00    	je     80104106 <wait+0x106>
80104066:	8b 46 24             	mov    0x24(%esi),%eax
80104069:	85 c0                	test   %eax,%eax
8010406b:	0f 85 95 00 00 00    	jne    80104106 <wait+0x106>
  pushcli();
80104071:	e8 3a 05 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80104076:	e8 b5 f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010407b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104081:	e8 7a 05 00 00       	call   80104600 <popcli>
  if(p == 0)
80104086:	85 db                	test   %ebx,%ebx
80104088:	0f 84 8f 00 00 00    	je     8010411d <wait+0x11d>
  p->chan = chan;
8010408e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104091:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104098:	e8 73 fd ff ff       	call   80103e10 <sched>
  p->chan = 0;
8010409d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040a4:	eb 84                	jmp    8010402a <wait+0x2a>
801040a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ad:	00 
801040ae:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801040b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040b6:	ff 73 08             	push   0x8(%ebx)
801040b9:	e8 e2 e4 ff ff       	call   801025a0 <kfree>
        p->kstack = 0;
801040be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040c5:	5a                   	pop    %edx
801040c6:	ff 73 04             	push   0x4(%ebx)
801040c9:	e8 62 2f 00 00       	call   80107030 <freevm>
        p->pid = 0;
801040ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ee:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040f5:	e8 a6 05 00 00       	call   801046a0 <release>
        return pid;
801040fa:	83 c4 10             	add    $0x10,%esp
}
801040fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104100:	89 f0                	mov    %esi,%eax
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret
      release(&ptable.lock);
80104106:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104109:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010410e:	68 20 1d 11 80       	push   $0x80111d20
80104113:	e8 88 05 00 00       	call   801046a0 <release>
      return -1;
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	eb e0                	jmp    801040fd <wait+0xfd>
    panic("sleep");
8010411d:	83 ec 0c             	sub    $0xc,%esp
80104120:	68 ef 76 10 80       	push   $0x801076ef
80104125:	e8 56 c2 ff ff       	call   80100380 <panic>
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <yield>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 20 1d 11 80       	push   $0x80111d20
8010413c:	e8 bf 05 00 00       	call   80104700 <acquire>
  pushcli();
80104141:	e8 6a 04 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80104146:	e8 e5 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 aa 04 00 00       	call   80104600 <popcli>
  myproc()->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 ae fc ff ff       	call   80103e10 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104169:	e8 32 05 00 00       	call   801046a0 <release>
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	83 c4 10             	add    $0x10,%esp
80104174:	c9                   	leave
80104175:	c3                   	ret
80104176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010417d:	00 
8010417e:	66 90                	xchg   %ax,%ax

80104180 <sleep>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010418f:	e8 1c 04 00 00       	call   801045b0 <pushcli>
  c = mycpu();
80104194:	e8 97 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 5c 04 00 00       	call   80104600 <popcli>
  if(p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	0f 84 87 00 00 00    	je     80104233 <sleep+0xb3>
  if(lk == 0)
801041ac:	85 f6                	test   %esi,%esi
801041ae:	74 76                	je     80104226 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041b0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801041b6:	74 50                	je     80104208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 20 1d 11 80       	push   $0x80111d20
801041c0:	e8 3b 05 00 00       	call   80104700 <acquire>
    release(lk);
801041c5:	89 34 24             	mov    %esi,(%esp)
801041c8:	e8 d3 04 00 00       	call   801046a0 <release>
  p->chan = chan;
801041cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041d7:	e8 34 fc ff ff       	call   80103e10 <sched>
  p->chan = 0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041e3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041ea:	e8 b1 04 00 00       	call   801046a0 <release>
    acquire(lk);
801041ef:	83 c4 10             	add    $0x10,%esp
801041f2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5e                   	pop    %esi
801041fa:	5f                   	pop    %edi
801041fb:	5d                   	pop    %ebp
    acquire(lk);
801041fc:	e9 ff 04 00 00       	jmp    80104700 <acquire>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010420b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104212:	e8 f9 fb ff ff       	call   80103e10 <sched>
  p->chan = 0;
80104217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010421e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5f                   	pop    %edi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret
    panic("sleep without lk");
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	68 f5 76 10 80       	push   $0x801076f5
8010422e:	e8 4d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104233:	83 ec 0c             	sub    $0xc,%esp
80104236:	68 ef 76 10 80       	push   $0x801076ef
8010423b:	e8 40 c1 ff ff       	call   80100380 <panic>

80104240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424a:	68 20 1d 11 80       	push   $0x80111d20
8010424f:	e8 ac 04 00 00       	call   80104700 <acquire>
80104254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104257:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010425c:	eb 0c                	jmp    8010426a <wakeup+0x2a>
8010425e:	66 90                	xchg   %ax,%ax
80104260:	83 e8 80             	sub    $0xffffff80,%eax
80104263:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104268:	74 1c                	je     80104286 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010426a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010426e:	75 f0                	jne    80104260 <wakeup+0x20>
80104270:	3b 58 20             	cmp    0x20(%eax),%ebx
80104273:	75 eb                	jne    80104260 <wakeup+0x20>
      p->state = RUNNABLE;
80104275:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427c:	83 e8 80             	sub    $0xffffff80,%eax
8010427f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104284:	75 e4                	jne    8010426a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104286:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104290:	c9                   	leave
  release(&ptable.lock);
80104291:	e9 0a 04 00 00       	jmp    801046a0 <release>
80104296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010429d:	00 
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042aa:	68 20 1d 11 80       	push   $0x80111d20
801042af:	e8 4c 04 00 00       	call   80104700 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801042bc:	eb 0c                	jmp    801042ca <kill+0x2a>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 e8 80             	sub    $0xffffff80,%eax
801042c3:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
801042c8:	74 36                	je     80104300 <kill+0x60>
    if(p->pid == pid){
801042ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801042cd:	75 f1                	jne    801042c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042da:	75 07                	jne    801042e3 <kill+0x43>
        p->state = RUNNABLE;
801042dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	68 20 1d 11 80       	push   $0x80111d20
801042eb:	e8 b0 03 00 00       	call   801046a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042f3:	83 c4 10             	add    $0x10,%esp
801042f6:	31 c0                	xor    %eax,%eax
}
801042f8:	c9                   	leave
801042f9:	c3                   	ret
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 20 1d 11 80       	push   $0x80111d20
80104308:	e8 93 03 00 00       	call   801046a0 <release>
}
8010430d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104318:	c9                   	leave
80104319:	c3                   	ret
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104328:	53                   	push   %ebx
80104329:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010432e:	83 ec 3c             	sub    $0x3c,%esp
80104331:	eb 24                	jmp    80104357 <procdump+0x37>
80104333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 00 78 10 80       	push   $0x80107800
80104340:	e8 6b c3 ff ff       	call   801006b0 <cprintf>
80104345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104348:	83 eb 80             	sub    $0xffffff80,%ebx
8010434b:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
80104351:	0f 84 81 00 00 00    	je     801043d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104357:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 ea                	je     80104348 <procdump+0x28>
      state = "???";
8010435e:	ba 06 77 10 80       	mov    $0x80107706,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104363:	83 f8 05             	cmp    $0x5,%eax
80104366:	77 11                	ja     80104379 <procdump+0x59>
80104368:	8b 14 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%edx
      state = "???";
8010436f:	b8 06 77 10 80       	mov    $0x80107706,%eax
80104374:	85 d2                	test   %edx,%edx
80104376:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104379:	53                   	push   %ebx
8010437a:	52                   	push   %edx
8010437b:	ff 73 a4             	push   -0x5c(%ebx)
8010437e:	68 0a 77 10 80       	push   $0x8010770a
80104383:	e8 28 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010438f:	75 a7                	jne    80104338 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104391:	83 ec 08             	sub    $0x8,%esp
80104394:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104397:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010439a:	50                   	push   %eax
8010439b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010439e:	8b 40 0c             	mov    0xc(%eax),%eax
801043a1:	83 c0 08             	add    $0x8,%eax
801043a4:	50                   	push   %eax
801043a5:	e8 86 01 00 00       	call   80104530 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043aa:	83 c4 10             	add    $0x10,%esp
801043ad:	8d 76 00             	lea    0x0(%esi),%esi
801043b0:	8b 17                	mov    (%edi),%edx
801043b2:	85 d2                	test   %edx,%edx
801043b4:	74 82                	je     80104338 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043bc:	52                   	push   %edx
801043bd:	68 41 74 10 80       	push   $0x80107441
801043c2:	e8 e9 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	39 f7                	cmp    %esi,%edi
801043cc:	75 e2                	jne    801043b0 <procdump+0x90>
801043ce:	e9 65 ff ff ff       	jmp    80104338 <procdump+0x18>
801043d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043db:	5b                   	pop    %ebx
801043dc:	5e                   	pop    %esi
801043dd:	5f                   	pop    %edi
801043de:	5d                   	pop    %ebp
801043df:	c3                   	ret

801043e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ea:	68 3d 77 10 80       	push   $0x8010773d
801043ef:	8d 43 04             	lea    0x4(%ebx),%eax
801043f2:	50                   	push   %eax
801043f3:	e8 18 01 00 00       	call   80104510 <initlock>
  lk->name = name;
801043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104401:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104404:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010440b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010440e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104411:	c9                   	leave
80104412:	c3                   	ret
80104413:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010441a:	00 
8010441b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104428:	8d 73 04             	lea    0x4(%ebx),%esi
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	56                   	push   %esi
8010442f:	e8 cc 02 00 00       	call   80104700 <acquire>
  while (lk->locked) {
80104434:	8b 13                	mov    (%ebx),%edx
80104436:	83 c4 10             	add    $0x10,%esp
80104439:	85 d2                	test   %edx,%edx
8010443b:	74 16                	je     80104453 <acquiresleep+0x33>
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104440:	83 ec 08             	sub    $0x8,%esp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	e8 36 fd ff ff       	call   80104180 <sleep>
  while (lk->locked) {
8010444a:	8b 03                	mov    (%ebx),%eax
8010444c:	83 c4 10             	add    $0x10,%esp
8010444f:	85 c0                	test   %eax,%eax
80104451:	75 ed                	jne    80104440 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104453:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104459:	e8 52 f6 ff ff       	call   80103ab0 <myproc>
8010445e:	8b 40 10             	mov    0x10(%eax),%eax
80104461:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104464:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104467:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010446a:	5b                   	pop    %ebx
8010446b:	5e                   	pop    %esi
8010446c:	5d                   	pop    %ebp
  release(&lk->lk);
8010446d:	e9 2e 02 00 00       	jmp    801046a0 <release>
80104472:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104479:	00 
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104488:	8d 73 04             	lea    0x4(%ebx),%esi
8010448b:	83 ec 0c             	sub    $0xc,%esp
8010448e:	56                   	push   %esi
8010448f:	e8 6c 02 00 00       	call   80104700 <acquire>
  lk->locked = 0;
80104494:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010449a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044a1:	89 1c 24             	mov    %ebx,(%esp)
801044a4:	e8 97 fd ff ff       	call   80104240 <wakeup>
  release(&lk->lk);
801044a9:	83 c4 10             	add    $0x10,%esp
801044ac:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b2:	5b                   	pop    %ebx
801044b3:	5e                   	pop    %esi
801044b4:	5d                   	pop    %ebp
  release(&lk->lk);
801044b5:	e9 e6 01 00 00       	jmp    801046a0 <release>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	31 ff                	xor    %edi,%edi
801044c6:	56                   	push   %esi
801044c7:	53                   	push   %ebx
801044c8:	83 ec 18             	sub    $0x18,%esp
801044cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ce:	8d 73 04             	lea    0x4(%ebx),%esi
801044d1:	56                   	push   %esi
801044d2:	e8 29 02 00 00       	call   80104700 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044d7:	8b 03                	mov    (%ebx),%eax
801044d9:	83 c4 10             	add    $0x10,%esp
801044dc:	85 c0                	test   %eax,%eax
801044de:	75 18                	jne    801044f8 <holdingsleep+0x38>
  release(&lk->lk);
801044e0:	83 ec 0c             	sub    $0xc,%esp
801044e3:	56                   	push   %esi
801044e4:	e8 b7 01 00 00       	call   801046a0 <release>
  return r;
}
801044e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044ec:	89 f8                	mov    %edi,%eax
801044ee:	5b                   	pop    %ebx
801044ef:	5e                   	pop    %esi
801044f0:	5f                   	pop    %edi
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret
801044f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801044f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044fb:	e8 b0 f5 ff ff       	call   80103ab0 <myproc>
80104500:	39 58 10             	cmp    %ebx,0x10(%eax)
80104503:	0f 94 c0             	sete   %al
80104506:	0f b6 c0             	movzbl %al,%eax
80104509:	89 c7                	mov    %eax,%edi
8010450b:	eb d3                	jmp    801044e0 <holdingsleep+0x20>
8010450d:	66 90                	xchg   %ax,%ax
8010450f:	90                   	nop

80104510 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104516:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010451f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret
8010452b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104530 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	8b 45 08             	mov    0x8(%ebp),%eax
80104537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010453a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010453d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104542:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104547:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010454c:	76 10                	jbe    8010455e <getcallerpcs+0x2e>
8010454e:	eb 28                	jmp    80104578 <getcallerpcs+0x48>
80104550:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104556:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010455c:	77 1a                	ja     80104578 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010455e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104561:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104564:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104567:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104569:	83 f8 0a             	cmp    $0xa,%eax
8010456c:	75 e2                	jne    80104550 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010456e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104571:	c9                   	leave
80104572:	c3                   	ret
80104573:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104578:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010457b:	83 c1 28             	add    $0x28,%ecx
8010457e:	89 ca                	mov    %ecx,%edx
80104580:	29 c2                	sub    %eax,%edx
80104582:	83 e2 04             	and    $0x4,%edx
80104585:	74 11                	je     80104598 <getcallerpcs+0x68>
    pcs[i] = 0;
80104587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010458d:	83 c0 04             	add    $0x4,%eax
80104590:	39 c1                	cmp    %eax,%ecx
80104592:	74 da                	je     8010456e <getcallerpcs+0x3e>
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010459e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801045a1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801045a8:	39 c1                	cmp    %eax,%ecx
801045aa:	75 ec                	jne    80104598 <getcallerpcs+0x68>
801045ac:	eb c0                	jmp    8010456e <getcallerpcs+0x3e>
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 04             	sub    $0x4,%esp
801045b7:	9c                   	pushf
801045b8:	5b                   	pop    %ebx
  asm volatile("cli");
801045b9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045ba:	e8 71 f4 ff ff       	call   80103a30 <mycpu>
801045bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045c5:	85 c0                	test   %eax,%eax
801045c7:	74 17                	je     801045e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045c9:	e8 62 f4 ff ff       	call   80103a30 <mycpu>
801045ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d8:	c9                   	leave
801045d9:	c3                   	ret
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045e0:	e8 4b f4 ff ff       	call   80103a30 <mycpu>
801045e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045f1:	eb d6                	jmp    801045c9 <pushcli+0x19>
801045f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045fa:	00 
801045fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104600 <popcli>:

void
popcli(void)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104606:	9c                   	pushf
80104607:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104608:	f6 c4 02             	test   $0x2,%ah
8010460b:	75 35                	jne    80104642 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010460d:	e8 1e f4 ff ff       	call   80103a30 <mycpu>
80104612:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104619:	78 34                	js     8010464f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010461b:	e8 10 f4 ff ff       	call   80103a30 <mycpu>
80104620:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104626:	85 d2                	test   %edx,%edx
80104628:	74 06                	je     80104630 <popcli+0x30>
    sti();
}
8010462a:	c9                   	leave
8010462b:	c3                   	ret
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104630:	e8 fb f3 ff ff       	call   80103a30 <mycpu>
80104635:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010463b:	85 c0                	test   %eax,%eax
8010463d:	74 eb                	je     8010462a <popcli+0x2a>
  asm volatile("sti");
8010463f:	fb                   	sti
}
80104640:	c9                   	leave
80104641:	c3                   	ret
    panic("popcli - interruptible");
80104642:	83 ec 0c             	sub    $0xc,%esp
80104645:	68 48 77 10 80       	push   $0x80107748
8010464a:	e8 31 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010464f:	83 ec 0c             	sub    $0xc,%esp
80104652:	68 5f 77 10 80       	push   $0x8010775f
80104657:	e8 24 bd ff ff       	call   80100380 <panic>
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <holding>:
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	8b 75 08             	mov    0x8(%ebp),%esi
80104668:	31 db                	xor    %ebx,%ebx
  pushcli();
8010466a:	e8 41 ff ff ff       	call   801045b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010466f:	8b 06                	mov    (%esi),%eax
80104671:	85 c0                	test   %eax,%eax
80104673:	75 0b                	jne    80104680 <holding+0x20>
  popcli();
80104675:	e8 86 ff ff ff       	call   80104600 <popcli>
}
8010467a:	89 d8                	mov    %ebx,%eax
8010467c:	5b                   	pop    %ebx
8010467d:	5e                   	pop    %esi
8010467e:	5d                   	pop    %ebp
8010467f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104680:	8b 5e 08             	mov    0x8(%esi),%ebx
80104683:	e8 a8 f3 ff ff       	call   80103a30 <mycpu>
80104688:	39 c3                	cmp    %eax,%ebx
8010468a:	0f 94 c3             	sete   %bl
  popcli();
8010468d:	e8 6e ff ff ff       	call   80104600 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104692:	0f b6 db             	movzbl %bl,%ebx
}
80104695:	89 d8                	mov    %ebx,%eax
80104697:	5b                   	pop    %ebx
80104698:	5e                   	pop    %esi
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret
8010469b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046a0 <release>:
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046a8:	e8 03 ff ff ff       	call   801045b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046ad:	8b 03                	mov    (%ebx),%eax
801046af:	85 c0                	test   %eax,%eax
801046b1:	75 15                	jne    801046c8 <release+0x28>
  popcli();
801046b3:	e8 48 ff ff ff       	call   80104600 <popcli>
    panic("release");
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 66 77 10 80       	push   $0x80107766
801046c0:	e8 bb bc ff ff       	call   80100380 <panic>
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046c8:	8b 73 08             	mov    0x8(%ebx),%esi
801046cb:	e8 60 f3 ff ff       	call   80103a30 <mycpu>
801046d0:	39 c6                	cmp    %eax,%esi
801046d2:	75 df                	jne    801046b3 <release+0x13>
  popcli();
801046d4:	e8 27 ff ff ff       	call   80104600 <popcli>
  lk->pcs[0] = 0;
801046d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046e0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046e7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f5:	5b                   	pop    %ebx
801046f6:	5e                   	pop    %esi
801046f7:	5d                   	pop    %ebp
  popcli();
801046f8:	e9 03 ff ff ff       	jmp    80104600 <popcli>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi

80104700 <acquire>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104707:	e8 a4 fe ff ff       	call   801045b0 <pushcli>
  if(holding(lk))
8010470c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010470f:	e8 9c fe ff ff       	call   801045b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104714:	8b 03                	mov    (%ebx),%eax
80104716:	85 c0                	test   %eax,%eax
80104718:	0f 85 b2 00 00 00    	jne    801047d0 <acquire+0xd0>
  popcli();
8010471e:	e8 dd fe ff ff       	call   80104600 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104723:	b9 01 00 00 00       	mov    $0x1,%ecx
80104728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010472f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104730:	8b 55 08             	mov    0x8(%ebp),%edx
80104733:	89 c8                	mov    %ecx,%eax
80104735:	f0 87 02             	lock xchg %eax,(%edx)
80104738:	85 c0                	test   %eax,%eax
8010473a:	75 f4                	jne    80104730 <acquire+0x30>
  __sync_synchronize();
8010473c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104744:	e8 e7 f2 ff ff       	call   80103a30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010474c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010474e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104751:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104757:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010475c:	77 32                	ja     80104790 <acquire+0x90>
  ebp = (uint*)v - 2;
8010475e:	89 e8                	mov    %ebp,%eax
80104760:	eb 14                	jmp    80104776 <acquire+0x76>
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104768:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010476e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104774:	77 1a                	ja     80104790 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104776:	8b 58 04             	mov    0x4(%eax),%ebx
80104779:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010477d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104780:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104782:	83 fa 0a             	cmp    $0xa,%edx
80104785:	75 e1                	jne    80104768 <acquire+0x68>
}
80104787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010478a:	c9                   	leave
8010478b:	c3                   	ret
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104790:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104794:	83 c1 34             	add    $0x34,%ecx
80104797:	89 ca                	mov    %ecx,%edx
80104799:	29 c2                	sub    %eax,%edx
8010479b:	83 e2 04             	and    $0x4,%edx
8010479e:	74 10                	je     801047b0 <acquire+0xb0>
    pcs[i] = 0;
801047a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047a6:	83 c0 04             	add    $0x4,%eax
801047a9:	39 c1                	cmp    %eax,%ecx
801047ab:	74 da                	je     80104787 <acquire+0x87>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047b6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801047b9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801047c0:	39 c1                	cmp    %eax,%ecx
801047c2:	75 ec                	jne    801047b0 <acquire+0xb0>
801047c4:	eb c1                	jmp    80104787 <acquire+0x87>
801047c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047cd:	00 
801047ce:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801047d0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047d3:	e8 58 f2 ff ff       	call   80103a30 <mycpu>
801047d8:	39 c3                	cmp    %eax,%ebx
801047da:	0f 85 3e ff ff ff    	jne    8010471e <acquire+0x1e>
  popcli();
801047e0:	e8 1b fe ff ff       	call   80104600 <popcli>
    panic("acquire");
801047e5:	83 ec 0c             	sub    $0xc,%esp
801047e8:	68 6e 77 10 80       	push   $0x8010776e
801047ed:	e8 8e bb ff ff       	call   80100380 <panic>
801047f2:	66 90                	xchg   %ax,%ax
801047f4:	66 90                	xchg   %ax,%ax
801047f6:	66 90                	xchg   %ax,%ax
801047f8:	66 90                	xchg   %ax,%ax
801047fa:	66 90                	xchg   %ax,%ax
801047fc:	66 90                	xchg   %ax,%ax
801047fe:	66 90                	xchg   %ax,%ax

80104800 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	8b 55 08             	mov    0x8(%ebp),%edx
80104807:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010480a:	89 d0                	mov    %edx,%eax
8010480c:	09 c8                	or     %ecx,%eax
8010480e:	a8 03                	test   $0x3,%al
80104810:	75 1e                	jne    80104830 <memset+0x30>
    c &= 0xFF;
80104812:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104816:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104819:	89 d7                	mov    %edx,%edi
8010481b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104821:	fc                   	cld
80104822:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104824:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104827:	89 d0                	mov    %edx,%eax
80104829:	c9                   	leave
8010482a:	c3                   	ret
8010482b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104830:	8b 45 0c             	mov    0xc(%ebp),%eax
80104833:	89 d7                	mov    %edx,%edi
80104835:	fc                   	cld
80104836:	f3 aa                	rep stos %al,%es:(%edi)
80104838:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010483b:	89 d0                	mov    %edx,%eax
8010483d:	c9                   	leave
8010483e:	c3                   	ret
8010483f:	90                   	nop

80104840 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	8b 75 10             	mov    0x10(%ebp),%esi
80104847:	8b 45 08             	mov    0x8(%ebp),%eax
8010484a:	53                   	push   %ebx
8010484b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010484e:	85 f6                	test   %esi,%esi
80104850:	74 2e                	je     80104880 <memcmp+0x40>
80104852:	01 c6                	add    %eax,%esi
80104854:	eb 14                	jmp    8010486a <memcmp+0x2a>
80104856:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010485d:	00 
8010485e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104860:	83 c0 01             	add    $0x1,%eax
80104863:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104866:	39 f0                	cmp    %esi,%eax
80104868:	74 16                	je     80104880 <memcmp+0x40>
    if(*s1 != *s2)
8010486a:	0f b6 08             	movzbl (%eax),%ecx
8010486d:	0f b6 1a             	movzbl (%edx),%ebx
80104870:	38 d9                	cmp    %bl,%cl
80104872:	74 ec                	je     80104860 <memcmp+0x20>
      return *s1 - *s2;
80104874:	0f b6 c1             	movzbl %cl,%eax
80104877:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104879:	5b                   	pop    %ebx
8010487a:	5e                   	pop    %esi
8010487b:	5d                   	pop    %ebp
8010487c:	c3                   	ret
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
80104880:	5b                   	pop    %ebx
  return 0;
80104881:	31 c0                	xor    %eax,%eax
}
80104883:	5e                   	pop    %esi
80104884:	5d                   	pop    %ebp
80104885:	c3                   	ret
80104886:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010488d:	00 
8010488e:	66 90                	xchg   %ax,%ax

80104890 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	8b 55 08             	mov    0x8(%ebp),%edx
80104897:	8b 45 10             	mov    0x10(%ebp),%eax
8010489a:	56                   	push   %esi
8010489b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010489e:	39 d6                	cmp    %edx,%esi
801048a0:	73 26                	jae    801048c8 <memmove+0x38>
801048a2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048a5:	39 ca                	cmp    %ecx,%edx
801048a7:	73 1f                	jae    801048c8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801048a9:	85 c0                	test   %eax,%eax
801048ab:	74 0f                	je     801048bc <memmove+0x2c>
801048ad:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801048b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048b4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048b7:	83 e8 01             	sub    $0x1,%eax
801048ba:	73 f4                	jae    801048b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048bc:	5e                   	pop    %esi
801048bd:	89 d0                	mov    %edx,%eax
801048bf:	5f                   	pop    %edi
801048c0:	5d                   	pop    %ebp
801048c1:	c3                   	ret
801048c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048c8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048cb:	89 d7                	mov    %edx,%edi
801048cd:	85 c0                	test   %eax,%eax
801048cf:	74 eb                	je     801048bc <memmove+0x2c>
801048d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048d8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048d9:	39 ce                	cmp    %ecx,%esi
801048db:	75 fb                	jne    801048d8 <memmove+0x48>
}
801048dd:	5e                   	pop    %esi
801048de:	89 d0                	mov    %edx,%eax
801048e0:	5f                   	pop    %edi
801048e1:	5d                   	pop    %ebp
801048e2:	c3                   	ret
801048e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ea:	00 
801048eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801048f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048f0:	eb 9e                	jmp    80104890 <memmove>
801048f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048f9:	00 
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	8b 55 10             	mov    0x10(%ebp),%edx
80104907:	8b 45 08             	mov    0x8(%ebp),%eax
8010490a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010490d:	85 d2                	test   %edx,%edx
8010490f:	75 16                	jne    80104927 <strncmp+0x27>
80104911:	eb 2d                	jmp    80104940 <strncmp+0x40>
80104913:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104918:	3a 19                	cmp    (%ecx),%bl
8010491a:	75 12                	jne    8010492e <strncmp+0x2e>
    n--, p++, q++;
8010491c:	83 c0 01             	add    $0x1,%eax
8010491f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104922:	83 ea 01             	sub    $0x1,%edx
80104925:	74 19                	je     80104940 <strncmp+0x40>
80104927:	0f b6 18             	movzbl (%eax),%ebx
8010492a:	84 db                	test   %bl,%bl
8010492c:	75 ea                	jne    80104918 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010492e:	0f b6 00             	movzbl (%eax),%eax
80104931:	0f b6 11             	movzbl (%ecx),%edx
}
80104934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104937:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104938:	29 d0                	sub    %edx,%eax
}
8010493a:	c3                   	ret
8010493b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104943:	31 c0                	xor    %eax,%eax
}
80104945:	c9                   	leave
80104946:	c3                   	ret
80104947:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010494e:	00 
8010494f:	90                   	nop

80104950 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	56                   	push   %esi
80104955:	8b 75 08             	mov    0x8(%ebp),%esi
80104958:	53                   	push   %ebx
80104959:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010495c:	89 f0                	mov    %esi,%eax
8010495e:	eb 15                	jmp    80104975 <strncpy+0x25>
80104960:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104964:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104967:	83 c0 01             	add    $0x1,%eax
8010496a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010496e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104971:	84 c9                	test   %cl,%cl
80104973:	74 13                	je     80104988 <strncpy+0x38>
80104975:	89 d3                	mov    %edx,%ebx
80104977:	83 ea 01             	sub    $0x1,%edx
8010497a:	85 db                	test   %ebx,%ebx
8010497c:	7f e2                	jg     80104960 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010497e:	5b                   	pop    %ebx
8010497f:	89 f0                	mov    %esi,%eax
80104981:	5e                   	pop    %esi
80104982:	5f                   	pop    %edi
80104983:	5d                   	pop    %ebp
80104984:	c3                   	ret
80104985:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104988:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010498b:	83 e9 01             	sub    $0x1,%ecx
8010498e:	85 d2                	test   %edx,%edx
80104990:	74 ec                	je     8010497e <strncpy+0x2e>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104998:	83 c0 01             	add    $0x1,%eax
8010499b:	89 ca                	mov    %ecx,%edx
8010499d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801049a1:	29 c2                	sub    %eax,%edx
801049a3:	85 d2                	test   %edx,%edx
801049a5:	7f f1                	jg     80104998 <strncpy+0x48>
}
801049a7:	5b                   	pop    %ebx
801049a8:	89 f0                	mov    %esi,%eax
801049aa:	5e                   	pop    %esi
801049ab:	5f                   	pop    %edi
801049ac:	5d                   	pop    %ebp
801049ad:	c3                   	ret
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	8b 55 10             	mov    0x10(%ebp),%edx
801049b7:	8b 75 08             	mov    0x8(%ebp),%esi
801049ba:	53                   	push   %ebx
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049be:	85 d2                	test   %edx,%edx
801049c0:	7e 25                	jle    801049e7 <safestrcpy+0x37>
801049c2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049c6:	89 f2                	mov    %esi,%edx
801049c8:	eb 16                	jmp    801049e0 <safestrcpy+0x30>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049d0:	0f b6 08             	movzbl (%eax),%ecx
801049d3:	83 c0 01             	add    $0x1,%eax
801049d6:	83 c2 01             	add    $0x1,%edx
801049d9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049dc:	84 c9                	test   %cl,%cl
801049de:	74 04                	je     801049e4 <safestrcpy+0x34>
801049e0:	39 d8                	cmp    %ebx,%eax
801049e2:	75 ec                	jne    801049d0 <safestrcpy+0x20>
    ;
  *s = 0;
801049e4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049e7:	89 f0                	mov    %esi,%eax
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret
801049ed:	8d 76 00             	lea    0x0(%esi),%esi

801049f0 <strlen>:

int
strlen(const char *s)
{
801049f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049f1:	31 c0                	xor    %eax,%eax
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049f8:	80 3a 00             	cmpb   $0x0,(%edx)
801049fb:	74 0c                	je     80104a09 <strlen+0x19>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
80104a00:	83 c0 01             	add    $0x1,%eax
80104a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a07:	75 f7                	jne    80104a00 <strlen+0x10>
    ;
  return n;
}
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret

80104a0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a13:	55                   	push   %ebp
  pushl %ebx
80104a14:	53                   	push   %ebx
  pushl %esi
80104a15:	56                   	push   %esi
  pushl %edi
80104a16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a19:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a1b:	5f                   	pop    %edi
  popl %esi
80104a1c:	5e                   	pop    %esi
  popl %ebx
80104a1d:	5b                   	pop    %ebx
  popl %ebp
80104a1e:	5d                   	pop    %ebp
  ret
80104a1f:	c3                   	ret

80104a20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a2a:	e8 81 f0 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a2f:	8b 00                	mov    (%eax),%eax
80104a31:	39 c3                	cmp    %eax,%ebx
80104a33:	73 1b                	jae    80104a50 <fetchint+0x30>
80104a35:	8d 53 04             	lea    0x4(%ebx),%edx
80104a38:	39 d0                	cmp    %edx,%eax
80104a3a:	72 14                	jb     80104a50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a3f:	8b 13                	mov    (%ebx),%edx
80104a41:	89 10                	mov    %edx,(%eax)
  return 0;
80104a43:	31 c0                	xor    %eax,%eax
}
80104a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a48:	c9                   	leave
80104a49:	c3                   	ret
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb ee                	jmp    80104a45 <fetchint+0x25>
80104a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a5e:	00 
80104a5f:	90                   	nop

80104a60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a6a:	e8 41 f0 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
80104a6f:	3b 18                	cmp    (%eax),%ebx
80104a71:	73 2d                	jae    80104aa0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a73:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a76:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a78:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a7a:	39 d3                	cmp    %edx,%ebx
80104a7c:	73 22                	jae    80104aa0 <fetchstr+0x40>
80104a7e:	89 d8                	mov    %ebx,%eax
80104a80:	eb 0d                	jmp    80104a8f <fetchstr+0x2f>
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a88:	83 c0 01             	add    $0x1,%eax
80104a8b:	39 d0                	cmp    %edx,%eax
80104a8d:	73 11                	jae    80104aa0 <fetchstr+0x40>
    if(*s == 0)
80104a8f:	80 38 00             	cmpb   $0x0,(%eax)
80104a92:	75 f4                	jne    80104a88 <fetchstr+0x28>
      return s - *pp;
80104a94:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a99:	c9                   	leave
80104a9a:	c3                   	ret
80104a9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aa8:	c9                   	leave
80104aa9:	c3                   	ret
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ab0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab5:	e8 f6 ef ff ff       	call   80103ab0 <myproc>
80104aba:	8b 55 08             	mov    0x8(%ebp),%edx
80104abd:	8b 40 18             	mov    0x18(%eax),%eax
80104ac0:	8b 40 44             	mov    0x44(%eax),%eax
80104ac3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ac6:	e8 e5 ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104acb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ace:	8b 00                	mov    (%eax),%eax
80104ad0:	39 c6                	cmp    %eax,%esi
80104ad2:	73 1c                	jae    80104af0 <argint+0x40>
80104ad4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ad7:	39 d0                	cmp    %edx,%eax
80104ad9:	72 15                	jb     80104af0 <argint+0x40>
  *ip = *(int*)(addr);
80104adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ade:	8b 53 04             	mov    0x4(%ebx),%edx
80104ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	5b                   	pop    %ebx
80104ae6:	5e                   	pop    %esi
80104ae7:	5d                   	pop    %ebp
80104ae8:	c3                   	ret
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104af5:	eb ee                	jmp    80104ae5 <argint+0x35>
80104af7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104afe:	00 
80104aff:	90                   	nop

80104b00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b09:	e8 a2 ef ff ff       	call   80103ab0 <myproc>
80104b0e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b10:	e8 9b ef ff ff       	call   80103ab0 <myproc>
80104b15:	8b 55 08             	mov    0x8(%ebp),%edx
80104b18:	8b 40 18             	mov    0x18(%eax),%eax
80104b1b:	8b 40 44             	mov    0x44(%eax),%eax
80104b1e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b21:	e8 8a ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b26:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b29:	8b 00                	mov    (%eax),%eax
80104b2b:	39 c7                	cmp    %eax,%edi
80104b2d:	73 31                	jae    80104b60 <argptr+0x60>
80104b2f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b32:	39 c8                	cmp    %ecx,%eax
80104b34:	72 2a                	jb     80104b60 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b36:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b39:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b3c:	85 d2                	test   %edx,%edx
80104b3e:	78 20                	js     80104b60 <argptr+0x60>
80104b40:	8b 16                	mov    (%esi),%edx
80104b42:	39 d0                	cmp    %edx,%eax
80104b44:	73 1a                	jae    80104b60 <argptr+0x60>
80104b46:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b49:	01 c3                	add    %eax,%ebx
80104b4b:	39 da                	cmp    %ebx,%edx
80104b4d:	72 11                	jb     80104b60 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b52:	89 02                	mov    %eax,(%edx)
  return 0;
80104b54:	31 c0                	xor    %eax,%eax
}
80104b56:	83 c4 0c             	add    $0xc,%esp
80104b59:	5b                   	pop    %ebx
80104b5a:	5e                   	pop    %esi
80104b5b:	5f                   	pop    %edi
80104b5c:	5d                   	pop    %ebp
80104b5d:	c3                   	ret
80104b5e:	66 90                	xchg   %ax,%ax
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b65:	eb ef                	jmp    80104b56 <argptr+0x56>
80104b67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b6e:	00 
80104b6f:	90                   	nop

80104b70 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	e8 36 ef ff ff       	call   80103ab0 <myproc>
80104b7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b7d:	8b 40 18             	mov    0x18(%eax),%eax
80104b80:	8b 40 44             	mov    0x44(%eax),%eax
80104b83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b86:	e8 25 ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8e:	8b 00                	mov    (%eax),%eax
80104b90:	39 c6                	cmp    %eax,%esi
80104b92:	73 44                	jae    80104bd8 <argstr+0x68>
80104b94:	8d 53 08             	lea    0x8(%ebx),%edx
80104b97:	39 d0                	cmp    %edx,%eax
80104b99:	72 3d                	jb     80104bd8 <argstr+0x68>
  *ip = *(int*)(addr);
80104b9b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b9e:	e8 0d ef ff ff       	call   80103ab0 <myproc>
  if(addr >= curproc->sz)
80104ba3:	3b 18                	cmp    (%eax),%ebx
80104ba5:	73 31                	jae    80104bd8 <argstr+0x68>
  *pp = (char*)addr;
80104ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104baa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bae:	39 d3                	cmp    %edx,%ebx
80104bb0:	73 26                	jae    80104bd8 <argstr+0x68>
80104bb2:	89 d8                	mov    %ebx,%eax
80104bb4:	eb 11                	jmp    80104bc7 <argstr+0x57>
80104bb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bbd:	00 
80104bbe:	66 90                	xchg   %ax,%ax
80104bc0:	83 c0 01             	add    $0x1,%eax
80104bc3:	39 d0                	cmp    %edx,%eax
80104bc5:	73 11                	jae    80104bd8 <argstr+0x68>
    if(*s == 0)
80104bc7:	80 38 00             	cmpb   $0x0,(%eax)
80104bca:	75 f4                	jne    80104bc0 <argstr+0x50>
      return s - *pp;
80104bcc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bce:	5b                   	pop    %ebx
80104bcf:	5e                   	pop    %esi
80104bd0:	5d                   	pop    %ebp
80104bd1:	c3                   	ret
80104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bd8:	5b                   	pop    %ebx
    return -1;
80104bd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bde:	5e                   	pop    %esi
80104bdf:	5d                   	pop    %ebp
80104be0:	c3                   	ret
80104be1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104be8:	00 
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <syscall>:
[SYS_istainted] sys_istainted
};

void
syscall(void)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104bf7:	e8 b4 ee ff ff       	call   80103ab0 <myproc>
80104bfc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bfe:	8b 40 18             	mov    0x18(%eax),%eax
80104c01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c07:	83 fa 17             	cmp    $0x17,%edx
80104c0a:	77 24                	ja     80104c30 <syscall+0x40>
80104c0c:	8b 14 85 80 7d 10 80 	mov    -0x7fef8280(,%eax,4),%edx
80104c13:	85 d2                	test   %edx,%edx
80104c15:	74 19                	je     80104c30 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c17:	ff d2                	call   *%edx
80104c19:	89 c2                	mov    %eax,%edx
80104c1b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c1e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c24:	c9                   	leave
80104c25:	c3                   	ret
80104c26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c2d:	00 
80104c2e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104c30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c31:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c34:	50                   	push   %eax
80104c35:	ff 73 10             	push   0x10(%ebx)
80104c38:	68 76 77 10 80       	push   $0x80107776
80104c3d:	e8 6e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c42:	8b 43 18             	mov    0x18(%ebx),%eax
80104c45:	83 c4 10             	add    $0x10,%esp
80104c48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c52:	c9                   	leave
80104c53:	c3                   	ret
80104c54:	66 90                	xchg   %ax,%ax
80104c56:	66 90                	xchg   %ax,%ax
80104c58:	66 90                	xchg   %ax,%ax
80104c5a:	66 90                	xchg   %ax,%ax
80104c5c:	66 90                	xchg   %ax,%ax
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c68:	53                   	push   %ebx
80104c69:	83 ec 34             	sub    $0x34,%esp
80104c6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c75:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c78:	57                   	push   %edi
80104c79:	50                   	push   %eax
80104c7a:	e8 21 d5 ff ff       	call   801021a0 <nameiparent>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	85 c0                	test   %eax,%eax
80104c84:	74 5e                	je     80104ce4 <create+0x84>
    return 0;
  ilock(dp);
80104c86:	83 ec 0c             	sub    $0xc,%esp
80104c89:	89 c3                	mov    %eax,%ebx
80104c8b:	50                   	push   %eax
80104c8c:	e8 0f cc ff ff       	call   801018a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c91:	83 c4 0c             	add    $0xc,%esp
80104c94:	6a 00                	push   $0x0
80104c96:	57                   	push   %edi
80104c97:	53                   	push   %ebx
80104c98:	e8 53 d1 ff ff       	call   80101df0 <dirlookup>
80104c9d:	83 c4 10             	add    $0x10,%esp
80104ca0:	89 c6                	mov    %eax,%esi
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	74 4a                	je     80104cf0 <create+0x90>
    iunlockput(dp);
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	53                   	push   %ebx
80104caa:	e8 81 ce ff ff       	call   80101b30 <iunlockput>
    ilock(ip);
80104caf:	89 34 24             	mov    %esi,(%esp)
80104cb2:	e8 e9 cb ff ff       	call   801018a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cb7:	83 c4 10             	add    $0x10,%esp
80104cba:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cbf:	75 17                	jne    80104cd8 <create+0x78>
80104cc1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cc6:	75 10                	jne    80104cd8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ccb:	89 f0                	mov    %esi,%eax
80104ccd:	5b                   	pop    %ebx
80104cce:	5e                   	pop    %esi
80104ccf:	5f                   	pop    %edi
80104cd0:	5d                   	pop    %ebp
80104cd1:	c3                   	ret
80104cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104cd8:	83 ec 0c             	sub    $0xc,%esp
80104cdb:	56                   	push   %esi
80104cdc:	e8 4f ce ff ff       	call   80101b30 <iunlockput>
    return 0;
80104ce1:	83 c4 10             	add    $0x10,%esp
}
80104ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ce7:	31 f6                	xor    %esi,%esi
}
80104ce9:	5b                   	pop    %ebx
80104cea:	89 f0                	mov    %esi,%eax
80104cec:	5e                   	pop    %esi
80104ced:	5f                   	pop    %edi
80104cee:	5d                   	pop    %ebp
80104cef:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104cf0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104cf4:	83 ec 08             	sub    $0x8,%esp
80104cf7:	50                   	push   %eax
80104cf8:	ff 33                	push   (%ebx)
80104cfa:	e8 11 ca ff ff       	call   80101710 <ialloc>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	89 c6                	mov    %eax,%esi
80104d04:	85 c0                	test   %eax,%eax
80104d06:	0f 84 fc 00 00 00    	je     80104e08 <create+0x1a8>
  ilock(ip);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	50                   	push   %eax
80104d10:	e8 8b cb ff ff       	call   801018a0 <ilock>
  ip->major = major;
80104d15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->nlink = 1;
80104d19:	ba 01 00 00 00       	mov    $0x1,%edx
  if(type == T_FILE && myproc()->tainted == TAINT_UNTRUSTED)
80104d1e:	83 c4 10             	add    $0x10,%esp
80104d21:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  ip->nlink = 1;
80104d26:	66 89 56 56          	mov    %dx,0x56(%esi)
  ip->major = major;
80104d2a:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d2e:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d32:	66 89 46 54          	mov    %ax,0x54(%esi)
  if(type == T_FILE && myproc()->tainted == TAINT_UNTRUSTED)
80104d36:	0f 84 94 00 00 00    	je     80104dd0 <create+0x170>
  iupdate(ip);
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	56                   	push   %esi
80104d40:	e8 9b ca ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d4d:	74 31                	je     80104d80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d4f:	83 ec 04             	sub    $0x4,%esp
80104d52:	ff 76 04             	push   0x4(%esi)
80104d55:	57                   	push   %edi
80104d56:	53                   	push   %ebx
80104d57:	e8 64 d3 ff ff       	call   801020c0 <dirlink>
80104d5c:	83 c4 10             	add    $0x10,%esp
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	0f 88 94 00 00 00    	js     80104dfb <create+0x19b>
  iunlockput(dp);
80104d67:	83 ec 0c             	sub    $0xc,%esp
80104d6a:	53                   	push   %ebx
80104d6b:	e8 c0 cd ff ff       	call   80101b30 <iunlockput>
  return ip;
80104d70:	83 c4 10             	add    $0x10,%esp
}
80104d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d76:	89 f0                	mov    %esi,%eax
80104d78:	5b                   	pop    %ebx
80104d79:	5e                   	pop    %esi
80104d7a:	5f                   	pop    %edi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
    iupdate(dp);
80104d80:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d83:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d88:	53                   	push   %ebx
80104d89:	e8 52 ca ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d8e:	83 c4 0c             	add    $0xc,%esp
80104d91:	ff 76 04             	push   0x4(%esi)
80104d94:	68 ae 77 10 80       	push   $0x801077ae
80104d99:	56                   	push   %esi
80104d9a:	e8 21 d3 ff ff       	call   801020c0 <dirlink>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	78 18                	js     80104dbe <create+0x15e>
80104da6:	83 ec 04             	sub    $0x4,%esp
80104da9:	ff 73 04             	push   0x4(%ebx)
80104dac:	68 ad 77 10 80       	push   $0x801077ad
80104db1:	56                   	push   %esi
80104db2:	e8 09 d3 ff ff       	call   801020c0 <dirlink>
80104db7:	83 c4 10             	add    $0x10,%esp
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	79 91                	jns    80104d4f <create+0xef>
      panic("create dots");
80104dbe:	83 ec 0c             	sub    $0xc,%esp
80104dc1:	68 a1 77 10 80       	push   $0x801077a1
80104dc6:	e8 b5 b5 ff ff       	call   80100380 <panic>
80104dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  if(type == T_FILE && myproc()->tainted == TAINT_UNTRUSTED)
80104dd0:	e8 db ec ff ff       	call   80103ab0 <myproc>
80104dd5:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80104dd9:	74 15                	je     80104df0 <create+0x190>
  iupdate(ip);
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	56                   	push   %esi
80104ddf:	e8 fc c9 ff ff       	call   801017e0 <iupdate>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	e9 63 ff ff ff       	jmp    80104d4f <create+0xef>
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip->untrusted = TAINT_UNTRUSTED;
80104df0:	b8 01 00 00 00       	mov    $0x1,%eax
80104df5:	66 89 46 58          	mov    %ax,0x58(%esi)
80104df9:	eb e0                	jmp    80104ddb <create+0x17b>
    panic("create: dirlink");
80104dfb:	83 ec 0c             	sub    $0xc,%esp
80104dfe:	68 b0 77 10 80       	push   $0x801077b0
80104e03:	e8 78 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	68 92 77 10 80       	push   $0x80107792
80104e10:	e8 6b b5 ff ff       	call   80100380 <panic>
80104e15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e1c:	00 
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <sys_marktaint>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104e24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e27:	83 ec 1c             	sub    $0x1c,%esp
  if(argstr(0, &path) < 0)
80104e2a:	50                   	push   %eax
80104e2b:	6a 00                	push   $0x0
80104e2d:	e8 3e fd ff ff       	call   80104b70 <argstr>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 68                	js     80104ea1 <sys_marktaint+0x81>
  begin_op();
80104e39:	e8 02 e0 ff ff       	call   80102e40 <begin_op>
  if((ip = namei(path)) == 0){
80104e3e:	83 ec 0c             	sub    $0xc,%esp
80104e41:	ff 75 f4             	push   -0xc(%ebp)
80104e44:	e8 37 d3 ff ff       	call   80102180 <namei>
80104e49:	83 c4 10             	add    $0x10,%esp
80104e4c:	89 c3                	mov    %eax,%ebx
80104e4e:	85 c0                	test   %eax,%eax
80104e50:	74 56                	je     80104ea8 <sys_marktaint+0x88>
  ilock(ip);
80104e52:	83 ec 0c             	sub    $0xc,%esp
80104e55:	50                   	push   %eax
80104e56:	e8 45 ca ff ff       	call   801018a0 <ilock>
  if(ip->type != T_FILE){
80104e5b:	83 c4 10             	add    $0x10,%esp
80104e5e:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104e63:	75 2b                	jne    80104e90 <sys_marktaint+0x70>
  iupdate(ip);
80104e65:	83 ec 0c             	sub    $0xc,%esp
  ip->untrusted = TAINT_UNTRUSTED;
80104e68:	b8 01 00 00 00       	mov    $0x1,%eax
80104e6d:	66 89 43 58          	mov    %ax,0x58(%ebx)
  iupdate(ip);
80104e71:	53                   	push   %ebx
80104e72:	e8 69 c9 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
80104e77:	89 1c 24             	mov    %ebx,(%esp)
80104e7a:	e8 b1 cc ff ff       	call   80101b30 <iunlockput>
  end_op();
80104e7f:	e8 2c e0 ff ff       	call   80102eb0 <end_op>
  return 0;
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	31 c0                	xor    %eax,%eax
}
80104e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e8c:	c9                   	leave
80104e8d:	c3                   	ret
80104e8e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e90:	83 ec 0c             	sub    $0xc,%esp
80104e93:	53                   	push   %ebx
80104e94:	e8 97 cc ff ff       	call   80101b30 <iunlockput>
    end_op();
80104e99:	e8 12 e0 ff ff       	call   80102eb0 <end_op>
    return -1;
80104e9e:	83 c4 10             	add    $0x10,%esp
    return -1;
80104ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea6:	eb e1                	jmp    80104e89 <sys_marktaint+0x69>
    end_op();
80104ea8:	e8 03 e0 ff ff       	call   80102eb0 <end_op>
    return -1;
80104ead:	eb f2                	jmp    80104ea1 <sys_marktaint+0x81>
80104eaf:	90                   	nop

80104eb0 <sys_dup>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	50                   	push   %eax
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 ed fb ff ff       	call   80104ab0 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 36                	js     80104f00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ece:	77 30                	ja     80104f00 <sys_dup+0x50>
80104ed0:	e8 db eb ff ff       	call   80103ab0 <myproc>
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104edc:	85 f6                	test   %esi,%esi
80104ede:	74 20                	je     80104f00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ee0:	e8 cb eb ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ee5:	31 db                	xor    %ebx,%ebx
80104ee7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104eee:	00 
80104eef:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104ef0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ef4:	85 d2                	test   %edx,%edx
80104ef6:	74 18                	je     80104f10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ef8:	83 c3 01             	add    $0x1,%ebx
80104efb:	83 fb 10             	cmp    $0x10,%ebx
80104efe:	75 f0                	jne    80104ef0 <sys_dup+0x40>
}
80104f00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f08:	89 d8                	mov    %ebx,%eax
80104f0a:	5b                   	pop    %ebx
80104f0b:	5e                   	pop    %esi
80104f0c:	5d                   	pop    %ebp
80104f0d:	c3                   	ret
80104f0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f17:	56                   	push   %esi
80104f18:	e8 f3 bf ff ff       	call   80100f10 <filedup>
  return fd;
80104f1d:	83 c4 10             	add    $0x10,%esp
}
80104f20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f23:	89 d8                	mov    %ebx,%eax
80104f25:	5b                   	pop    %ebx
80104f26:	5e                   	pop    %esi
80104f27:	5d                   	pop    %ebp
80104f28:	c3                   	ret
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f30 <sys_read>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f3b:	53                   	push   %ebx
80104f3c:	6a 00                	push   $0x0
80104f3e:	e8 6d fb ff ff       	call   80104ab0 <argint>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	78 5e                	js     80104fa8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f4e:	77 58                	ja     80104fa8 <sys_read+0x78>
80104f50:	e8 5b eb ff ff       	call   80103ab0 <myproc>
80104f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f5c:	85 f6                	test   %esi,%esi
80104f5e:	74 48                	je     80104fa8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f60:	83 ec 08             	sub    $0x8,%esp
80104f63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f66:	50                   	push   %eax
80104f67:	6a 02                	push   $0x2
80104f69:	e8 42 fb ff ff       	call   80104ab0 <argint>
80104f6e:	83 c4 10             	add    $0x10,%esp
80104f71:	85 c0                	test   %eax,%eax
80104f73:	78 33                	js     80104fa8 <sys_read+0x78>
80104f75:	83 ec 04             	sub    $0x4,%esp
80104f78:	ff 75 f0             	push   -0x10(%ebp)
80104f7b:	53                   	push   %ebx
80104f7c:	6a 01                	push   $0x1
80104f7e:	e8 7d fb ff ff       	call   80104b00 <argptr>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 1e                	js     80104fa8 <sys_read+0x78>
  return fileread(f, p, n);
80104f8a:	83 ec 04             	sub    $0x4,%esp
80104f8d:	ff 75 f0             	push   -0x10(%ebp)
80104f90:	ff 75 f4             	push   -0xc(%ebp)
80104f93:	56                   	push   %esi
80104f94:	e8 f7 c0 ff ff       	call   80101090 <fileread>
80104f99:	83 c4 10             	add    $0x10,%esp
}
80104f9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9f:	5b                   	pop    %ebx
80104fa0:	5e                   	pop    %esi
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret
80104fa3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fad:	eb ed                	jmp    80104f9c <sys_read+0x6c>
80104faf:	90                   	nop

80104fb0 <sys_write>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 00                	push   $0x0
80104fbe:	e8 ed fa ff ff       	call   80104ab0 <argint>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 5e                	js     80105028 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fce:	77 58                	ja     80105028 <sys_write+0x78>
80104fd0:	e8 db ea ff ff       	call   80103ab0 <myproc>
80104fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fdc:	85 f6                	test   %esi,%esi
80104fde:	74 48                	je     80105028 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe0:	83 ec 08             	sub    $0x8,%esp
80104fe3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fe6:	50                   	push   %eax
80104fe7:	6a 02                	push   $0x2
80104fe9:	e8 c2 fa ff ff       	call   80104ab0 <argint>
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	78 33                	js     80105028 <sys_write+0x78>
80104ff5:	83 ec 04             	sub    $0x4,%esp
80104ff8:	ff 75 f0             	push   -0x10(%ebp)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 01                	push   $0x1
80104ffe:	e8 fd fa ff ff       	call   80104b00 <argptr>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 1e                	js     80105028 <sys_write+0x78>
  return filewrite(f, p, n);
8010500a:	83 ec 04             	sub    $0x4,%esp
8010500d:	ff 75 f0             	push   -0x10(%ebp)
80105010:	ff 75 f4             	push   -0xc(%ebp)
80105013:	56                   	push   %esi
80105014:	e8 37 c1 ff ff       	call   80101150 <filewrite>
80105019:	83 c4 10             	add    $0x10,%esp
}
8010501c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010501f:	5b                   	pop    %ebx
80105020:	5e                   	pop    %esi
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret
80105023:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ed                	jmp    8010501c <sys_write+0x6c>
8010502f:	90                   	nop

80105030 <sys_close>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	50                   	push   %eax
8010503c:	6a 00                	push   $0x0
8010503e:	e8 6d fa ff ff       	call   80104ab0 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 3e                	js     80105088 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 38                	ja     80105088 <sys_close+0x58>
80105050:	e8 5b ea ff ff       	call   80103ab0 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8d 5a 08             	lea    0x8(%edx),%ebx
8010505b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010505f:	85 f6                	test   %esi,%esi
80105061:	74 25                	je     80105088 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105063:	e8 48 ea ff ff       	call   80103ab0 <myproc>
  fileclose(f);
80105068:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010506b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105072:	00 
  fileclose(f);
80105073:	56                   	push   %esi
80105074:	e8 e7 be ff ff       	call   80100f60 <fileclose>
  return 0;
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	31 c0                	xor    %eax,%eax
}
8010507e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5d                   	pop    %ebp
80105084:	c3                   	ret
80105085:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb ef                	jmp    8010507e <sys_close+0x4e>
8010508f:	90                   	nop

80105090 <sys_fstat>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105095:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105098:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010509b:	53                   	push   %ebx
8010509c:	6a 00                	push   $0x0
8010509e:	e8 0d fa ff ff       	call   80104ab0 <argint>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 46                	js     801050f0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ae:	77 40                	ja     801050f0 <sys_fstat+0x60>
801050b0:	e8 fb e9 ff ff       	call   80103ab0 <myproc>
801050b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050bc:	85 f6                	test   %esi,%esi
801050be:	74 30                	je     801050f0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050c0:	83 ec 04             	sub    $0x4,%esp
801050c3:	6a 14                	push   $0x14
801050c5:	53                   	push   %ebx
801050c6:	6a 01                	push   $0x1
801050c8:	e8 33 fa ff ff       	call   80104b00 <argptr>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 1c                	js     801050f0 <sys_fstat+0x60>
  return filestat(f, st);
801050d4:	83 ec 08             	sub    $0x8,%esp
801050d7:	ff 75 f4             	push   -0xc(%ebp)
801050da:	56                   	push   %esi
801050db:	e8 60 bf ff ff       	call   80101040 <filestat>
801050e0:	83 c4 10             	add    $0x10,%esp
}
801050e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e6:	5b                   	pop    %ebx
801050e7:	5e                   	pop    %esi
801050e8:	5d                   	pop    %ebp
801050e9:	c3                   	ret
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f5:	eb ec                	jmp    801050e3 <sys_fstat+0x53>
801050f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050fe:	00 
801050ff:	90                   	nop

80105100 <sys_link>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105105:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105108:	53                   	push   %ebx
80105109:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010510c:	50                   	push   %eax
8010510d:	6a 00                	push   $0x0
8010510f:	e8 5c fa ff ff       	call   80104b70 <argstr>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	0f 88 fb 00 00 00    	js     8010521a <sys_link+0x11a>
8010511f:	83 ec 08             	sub    $0x8,%esp
80105122:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105125:	50                   	push   %eax
80105126:	6a 01                	push   $0x1
80105128:	e8 43 fa ff ff       	call   80104b70 <argstr>
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	85 c0                	test   %eax,%eax
80105132:	0f 88 e2 00 00 00    	js     8010521a <sys_link+0x11a>
  begin_op();
80105138:	e8 03 dd ff ff       	call   80102e40 <begin_op>
  if((ip = namei(old)) == 0){
8010513d:	83 ec 0c             	sub    $0xc,%esp
80105140:	ff 75 d4             	push   -0x2c(%ebp)
80105143:	e8 38 d0 ff ff       	call   80102180 <namei>
80105148:	83 c4 10             	add    $0x10,%esp
8010514b:	89 c3                	mov    %eax,%ebx
8010514d:	85 c0                	test   %eax,%eax
8010514f:	0f 84 df 00 00 00    	je     80105234 <sys_link+0x134>
  ilock(ip);
80105155:	83 ec 0c             	sub    $0xc,%esp
80105158:	50                   	push   %eax
80105159:	e8 42 c7 ff ff       	call   801018a0 <ilock>
  if(ip->type == T_DIR){
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105166:	0f 84 b5 00 00 00    	je     80105221 <sys_link+0x121>
  iupdate(ip);
8010516c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010516f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105174:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105177:	53                   	push   %ebx
80105178:	e8 63 c6 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
8010517d:	89 1c 24             	mov    %ebx,(%esp)
80105180:	e8 fb c7 ff ff       	call   80101980 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105185:	58                   	pop    %eax
80105186:	5a                   	pop    %edx
80105187:	57                   	push   %edi
80105188:	ff 75 d0             	push   -0x30(%ebp)
8010518b:	e8 10 d0 ff ff       	call   801021a0 <nameiparent>
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	89 c6                	mov    %eax,%esi
80105195:	85 c0                	test   %eax,%eax
80105197:	74 5b                	je     801051f4 <sys_link+0xf4>
  ilock(dp);
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	50                   	push   %eax
8010519d:	e8 fe c6 ff ff       	call   801018a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051a2:	8b 03                	mov    (%ebx),%eax
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	39 06                	cmp    %eax,(%esi)
801051a9:	75 3d                	jne    801051e8 <sys_link+0xe8>
801051ab:	83 ec 04             	sub    $0x4,%esp
801051ae:	ff 73 04             	push   0x4(%ebx)
801051b1:	57                   	push   %edi
801051b2:	56                   	push   %esi
801051b3:	e8 08 cf ff ff       	call   801020c0 <dirlink>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	85 c0                	test   %eax,%eax
801051bd:	78 29                	js     801051e8 <sys_link+0xe8>
  iunlockput(dp);
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	56                   	push   %esi
801051c3:	e8 68 c9 ff ff       	call   80101b30 <iunlockput>
  iput(ip);
801051c8:	89 1c 24             	mov    %ebx,(%esp)
801051cb:	e8 00 c8 ff ff       	call   801019d0 <iput>
  end_op();
801051d0:	e8 db dc ff ff       	call   80102eb0 <end_op>
  return 0;
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	31 c0                	xor    %eax,%eax
}
801051da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051dd:	5b                   	pop    %ebx
801051de:	5e                   	pop    %esi
801051df:	5f                   	pop    %edi
801051e0:	5d                   	pop    %ebp
801051e1:	c3                   	ret
801051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	56                   	push   %esi
801051ec:	e8 3f c9 ff ff       	call   80101b30 <iunlockput>
    goto bad;
801051f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	53                   	push   %ebx
801051f8:	e8 a3 c6 ff ff       	call   801018a0 <ilock>
  ip->nlink--;
801051fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105202:	89 1c 24             	mov    %ebx,(%esp)
80105205:	e8 d6 c5 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
8010520a:	89 1c 24             	mov    %ebx,(%esp)
8010520d:	e8 1e c9 ff ff       	call   80101b30 <iunlockput>
  end_op();
80105212:	e8 99 dc ff ff       	call   80102eb0 <end_op>
  return -1;
80105217:	83 c4 10             	add    $0x10,%esp
    return -1;
8010521a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521f:	eb b9                	jmp    801051da <sys_link+0xda>
    iunlockput(ip);
80105221:	83 ec 0c             	sub    $0xc,%esp
80105224:	53                   	push   %ebx
80105225:	e8 06 c9 ff ff       	call   80101b30 <iunlockput>
    end_op();
8010522a:	e8 81 dc ff ff       	call   80102eb0 <end_op>
    return -1;
8010522f:	83 c4 10             	add    $0x10,%esp
80105232:	eb e6                	jmp    8010521a <sys_link+0x11a>
    end_op();
80105234:	e8 77 dc ff ff       	call   80102eb0 <end_op>
    return -1;
80105239:	eb df                	jmp    8010521a <sys_link+0x11a>
8010523b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105240 <sys_unlink>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105245:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105248:	53                   	push   %ebx
80105249:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010524c:	50                   	push   %eax
8010524d:	6a 00                	push   $0x0
8010524f:	e8 1c f9 ff ff       	call   80104b70 <argstr>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	0f 88 64 01 00 00    	js     801053c3 <sys_unlink+0x183>
  if(myproc()->tainted == TAINT_UNTRUSTED){
8010525f:	e8 4c e8 ff ff       	call   80103ab0 <myproc>
80105264:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80105268:	0f 84 7b 01 00 00    	je     801053e9 <sys_unlink+0x1a9>
  begin_op();
8010526e:	e8 cd db ff ff       	call   80102e40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105273:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105276:	83 ec 08             	sub    $0x8,%esp
80105279:	53                   	push   %ebx
8010527a:	ff 75 c0             	push   -0x40(%ebp)
8010527d:	e8 1e cf ff ff       	call   801021a0 <nameiparent>
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105288:	85 c0                	test   %eax,%eax
8010528a:	0f 84 6e 01 00 00    	je     801053fe <sys_unlink+0x1be>
  ilock(dp);
80105290:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105293:	83 ec 0c             	sub    $0xc,%esp
80105296:	57                   	push   %edi
80105297:	e8 04 c6 ff ff       	call   801018a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010529c:	58                   	pop    %eax
8010529d:	5a                   	pop    %edx
8010529e:	68 ae 77 10 80       	push   $0x801077ae
801052a3:	53                   	push   %ebx
801052a4:	e8 27 cb ff ff       	call   80101dd0 <namecmp>
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	85 c0                	test   %eax,%eax
801052ae:	0f 84 fc 00 00 00    	je     801053b0 <sys_unlink+0x170>
801052b4:	83 ec 08             	sub    $0x8,%esp
801052b7:	68 ad 77 10 80       	push   $0x801077ad
801052bc:	53                   	push   %ebx
801052bd:	e8 0e cb ff ff       	call   80101dd0 <namecmp>
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	85 c0                	test   %eax,%eax
801052c7:	0f 84 e3 00 00 00    	je     801053b0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052cd:	83 ec 04             	sub    $0x4,%esp
801052d0:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052d3:	50                   	push   %eax
801052d4:	53                   	push   %ebx
801052d5:	57                   	push   %edi
801052d6:	e8 15 cb ff ff       	call   80101df0 <dirlookup>
801052db:	83 c4 10             	add    $0x10,%esp
801052de:	89 c3                	mov    %eax,%ebx
801052e0:	85 c0                	test   %eax,%eax
801052e2:	0f 84 c8 00 00 00    	je     801053b0 <sys_unlink+0x170>
  ilock(ip);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	50                   	push   %eax
801052ec:	e8 af c5 ff ff       	call   801018a0 <ilock>
  if(ip->nlink < 1)
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052f9:	0f 8e 20 01 00 00    	jle    8010541f <sys_unlink+0x1df>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052ff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105304:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105307:	74 67                	je     80105370 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
80105309:	83 ec 04             	sub    $0x4,%esp
8010530c:	6a 10                	push   $0x10
8010530e:	6a 00                	push   $0x0
80105310:	57                   	push   %edi
80105311:	e8 ea f4 ff ff       	call   80104800 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105316:	6a 10                	push   $0x10
80105318:	ff 75 c4             	push   -0x3c(%ebp)
8010531b:	57                   	push   %edi
8010531c:	ff 75 b4             	push   -0x4c(%ebp)
8010531f:	e8 8c c9 ff ff       	call   80101cb0 <writei>
80105324:	83 c4 20             	add    $0x20,%esp
80105327:	83 f8 10             	cmp    $0x10,%eax
8010532a:	0f 85 e2 00 00 00    	jne    80105412 <sys_unlink+0x1d2>
  if(ip->type == T_DIR){
80105330:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105335:	0f 84 95 00 00 00    	je     801053d0 <sys_unlink+0x190>
  iunlockput(dp);
8010533b:	83 ec 0c             	sub    $0xc,%esp
8010533e:	ff 75 b4             	push   -0x4c(%ebp)
80105341:	e8 ea c7 ff ff       	call   80101b30 <iunlockput>
  ip->nlink--;
80105346:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010534b:	89 1c 24             	mov    %ebx,(%esp)
8010534e:	e8 8d c4 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
80105353:	89 1c 24             	mov    %ebx,(%esp)
80105356:	e8 d5 c7 ff ff       	call   80101b30 <iunlockput>
  end_op();
8010535b:	e8 50 db ff ff       	call   80102eb0 <end_op>
  return 0;
80105360:	83 c4 10             	add    $0x10,%esp
80105363:	31 c0                	xor    %eax,%eax
}
80105365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105368:	5b                   	pop    %ebx
80105369:	5e                   	pop    %esi
8010536a:	5f                   	pop    %edi
8010536b:	5d                   	pop    %ebp
8010536c:	c3                   	ret
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105370:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80105374:	76 93                	jbe    80105309 <sys_unlink+0xc9>
80105376:	be 20 00 00 00       	mov    $0x20,%esi
8010537b:	eb 0b                	jmp    80105388 <sys_unlink+0x148>
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
80105380:	83 c6 10             	add    $0x10,%esi
80105383:	3b 73 5c             	cmp    0x5c(%ebx),%esi
80105386:	73 81                	jae    80105309 <sys_unlink+0xc9>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105388:	6a 10                	push   $0x10
8010538a:	56                   	push   %esi
8010538b:	57                   	push   %edi
8010538c:	53                   	push   %ebx
8010538d:	e8 1e c8 ff ff       	call   80101bb0 <readi>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	83 f8 10             	cmp    $0x10,%eax
80105398:	75 6b                	jne    80105405 <sys_unlink+0x1c5>
    if(de.inum != 0)
8010539a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010539f:	74 df                	je     80105380 <sys_unlink+0x140>
    iunlockput(ip);
801053a1:	83 ec 0c             	sub    $0xc,%esp
801053a4:	53                   	push   %ebx
801053a5:	e8 86 c7 ff ff       	call   80101b30 <iunlockput>
    goto bad;
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	ff 75 b4             	push   -0x4c(%ebp)
801053b6:	e8 75 c7 ff ff       	call   80101b30 <iunlockput>
  end_op();
801053bb:	e8 f0 da ff ff       	call   80102eb0 <end_op>
  return -1;
801053c0:	83 c4 10             	add    $0x10,%esp
    return -1;
801053c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c8:	eb 9b                	jmp    80105365 <sys_unlink+0x125>
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053db:	50                   	push   %eax
801053dc:	e8 ff c3 ff ff       	call   801017e0 <iupdate>
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	e9 52 ff ff ff       	jmp    8010533b <sys_unlink+0xfb>
    cprintf("unlink: refused tainted unlink of %s\n", path);
801053e9:	83 ec 08             	sub    $0x8,%esp
801053ec:	ff 75 c0             	push   -0x40(%ebp)
801053ef:	68 4c 7a 10 80       	push   $0x80107a4c
801053f4:	e8 b7 b2 ff ff       	call   801006b0 <cprintf>
    return -1;
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	eb c5                	jmp    801053c3 <sys_unlink+0x183>
    end_op();
801053fe:	e8 ad da ff ff       	call   80102eb0 <end_op>
    return -1;
80105403:	eb be                	jmp    801053c3 <sys_unlink+0x183>
      panic("isdirempty: readi");
80105405:	83 ec 0c             	sub    $0xc,%esp
80105408:	68 d2 77 10 80       	push   $0x801077d2
8010540d:	e8 6e af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105412:	83 ec 0c             	sub    $0xc,%esp
80105415:	68 e4 77 10 80       	push   $0x801077e4
8010541a:	e8 61 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	68 c0 77 10 80       	push   $0x801077c0
80105427:	e8 54 af ff ff       	call   80100380 <panic>
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_open>:

int
sys_open(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105435:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105438:	53                   	push   %ebx
80105439:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 2c f7 ff ff       	call   80104b70 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 8e 00 00 00    	js     801054dd <sys_open+0xad>
8010544f:	83 ec 08             	sub    $0x8,%esp
80105452:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105455:	50                   	push   %eax
80105456:	6a 01                	push   $0x1
80105458:	e8 53 f6 ff ff       	call   80104ab0 <argint>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 79                	js     801054dd <sys_open+0xad>
    return -1;

  begin_op();
80105464:	e8 d7 d9 ff ff       	call   80102e40 <begin_op>

  if(omode & O_CREATE){
80105469:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010546d:	75 79                	jne    801054e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	ff 75 e0             	push   -0x20(%ebp)
80105475:	e8 06 cd ff ff       	call   80102180 <namei>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	89 c6                	mov    %eax,%esi
8010547f:	85 c0                	test   %eax,%eax
80105481:	0f 84 7e 00 00 00    	je     80105505 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105487:	83 ec 0c             	sub    $0xc,%esp
8010548a:	50                   	push   %eax
8010548b:	e8 10 c4 ff ff       	call   801018a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105490:	83 c4 10             	add    $0x10,%esp
80105493:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105498:	0f 84 ba 00 00 00    	je     80105558 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010549e:	e8 fd b9 ff ff       	call   80100ea0 <filealloc>
801054a3:	89 c7                	mov    %eax,%edi
801054a5:	85 c0                	test   %eax,%eax
801054a7:	74 23                	je     801054cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801054a9:	e8 02 e6 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054b4:	85 d2                	test   %edx,%edx
801054b6:	74 58                	je     80105510 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c3 01             	add    $0x1,%ebx
801054bb:	83 fb 10             	cmp    $0x10,%ebx
801054be:	75 f0                	jne    801054b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	57                   	push   %edi
801054c4:	e8 97 ba ff ff       	call   80100f60 <fileclose>
801054c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	56                   	push   %esi
801054d0:	e8 5b c6 ff ff       	call   80101b30 <iunlockput>
    end_op();
801054d5:	e8 d6 d9 ff ff       	call   80102eb0 <end_op>
    return -1;
801054da:	83 c4 10             	add    $0x10,%esp
    return -1;
801054dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054e2:	eb 65                	jmp    80105549 <sys_open+0x119>
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054e8:	83 ec 0c             	sub    $0xc,%esp
801054eb:	31 c9                	xor    %ecx,%ecx
801054ed:	ba 02 00 00 00       	mov    $0x2,%edx
801054f2:	6a 00                	push   $0x0
801054f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054f7:	e8 64 f7 ff ff       	call   80104c60 <create>
    if(ip == 0){
801054fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105501:	85 c0                	test   %eax,%eax
80105503:	75 99                	jne    8010549e <sys_open+0x6e>
      end_op();
80105505:	e8 a6 d9 ff ff       	call   80102eb0 <end_op>
      return -1;
8010550a:	eb d1                	jmp    801054dd <sys_open+0xad>
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105510:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105513:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105517:	56                   	push   %esi
80105518:	e8 63 c4 ff ff       	call   80101980 <iunlock>
  end_op();
8010551d:	e8 8e d9 ff ff       	call   80102eb0 <end_op>

  f->type = FD_INODE;
80105522:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105528:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010552b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010552e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105531:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105533:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010553a:	f7 d0                	not    %eax
8010553c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105542:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105545:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010554c:	89 d8                	mov    %ebx,%eax
8010554e:	5b                   	pop    %ebx
8010554f:	5e                   	pop    %esi
80105550:	5f                   	pop    %edi
80105551:	5d                   	pop    %ebp
80105552:	c3                   	ret
80105553:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105558:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010555b:	85 c9                	test   %ecx,%ecx
8010555d:	0f 84 3b ff ff ff    	je     8010549e <sys_open+0x6e>
80105563:	e9 64 ff ff ff       	jmp    801054cc <sys_open+0x9c>
80105568:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010556f:	00 

80105570 <sys_mkdir>:

int
sys_mkdir(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105576:	e8 c5 d8 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010557b:	83 ec 08             	sub    $0x8,%esp
8010557e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105581:	50                   	push   %eax
80105582:	6a 00                	push   $0x0
80105584:	e8 e7 f5 ff ff       	call   80104b70 <argstr>
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	85 c0                	test   %eax,%eax
8010558e:	78 30                	js     801055c0 <sys_mkdir+0x50>
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105596:	31 c9                	xor    %ecx,%ecx
80105598:	ba 01 00 00 00       	mov    $0x1,%edx
8010559d:	6a 00                	push   $0x0
8010559f:	e8 bc f6 ff ff       	call   80104c60 <create>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	74 15                	je     801055c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ab:	83 ec 0c             	sub    $0xc,%esp
801055ae:	50                   	push   %eax
801055af:	e8 7c c5 ff ff       	call   80101b30 <iunlockput>
  end_op();
801055b4:	e8 f7 d8 ff ff       	call   80102eb0 <end_op>
  return 0;
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	31 c0                	xor    %eax,%eax
}
801055be:	c9                   	leave
801055bf:	c3                   	ret
    end_op();
801055c0:	e8 eb d8 ff ff       	call   80102eb0 <end_op>
    return -1;
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ca:	c9                   	leave
801055cb:	c3                   	ret
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_mknod>:

int
sys_mknod(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055d6:	e8 65 d8 ff ff       	call   80102e40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055e1:	50                   	push   %eax
801055e2:	6a 00                	push   $0x0
801055e4:	e8 87 f5 ff ff       	call   80104b70 <argstr>
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	85 c0                	test   %eax,%eax
801055ee:	78 60                	js     80105650 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055f0:	83 ec 08             	sub    $0x8,%esp
801055f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055f6:	50                   	push   %eax
801055f7:	6a 01                	push   $0x1
801055f9:	e8 b2 f4 ff ff       	call   80104ab0 <argint>
  if((argstr(0, &path)) < 0 ||
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 4b                	js     80105650 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105605:	83 ec 08             	sub    $0x8,%esp
80105608:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560b:	50                   	push   %eax
8010560c:	6a 02                	push   $0x2
8010560e:	e8 9d f4 ff ff       	call   80104ab0 <argint>
     argint(1, &major) < 0 ||
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	78 36                	js     80105650 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010561a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010561e:	83 ec 0c             	sub    $0xc,%esp
80105621:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105625:	ba 03 00 00 00       	mov    $0x3,%edx
8010562a:	50                   	push   %eax
8010562b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010562e:	e8 2d f6 ff ff       	call   80104c60 <create>
     argint(2, &minor) < 0 ||
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	74 16                	je     80105650 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010563a:	83 ec 0c             	sub    $0xc,%esp
8010563d:	50                   	push   %eax
8010563e:	e8 ed c4 ff ff       	call   80101b30 <iunlockput>
  end_op();
80105643:	e8 68 d8 ff ff       	call   80102eb0 <end_op>
  return 0;
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	31 c0                	xor    %eax,%eax
}
8010564d:	c9                   	leave
8010564e:	c3                   	ret
8010564f:	90                   	nop
    end_op();
80105650:	e8 5b d8 ff ff       	call   80102eb0 <end_op>
    return -1;
80105655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565a:	c9                   	leave
8010565b:	c3                   	ret
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_chdir>:

int
sys_chdir(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
80105665:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105668:	e8 43 e4 ff ff       	call   80103ab0 <myproc>
8010566d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010566f:	e8 cc d7 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105674:	83 ec 08             	sub    $0x8,%esp
80105677:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567a:	50                   	push   %eax
8010567b:	6a 00                	push   $0x0
8010567d:	e8 ee f4 ff ff       	call   80104b70 <argstr>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	78 77                	js     80105700 <sys_chdir+0xa0>
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	ff 75 f4             	push   -0xc(%ebp)
8010568f:	e8 ec ca ff ff       	call   80102180 <namei>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	89 c3                	mov    %eax,%ebx
80105699:	85 c0                	test   %eax,%eax
8010569b:	74 63                	je     80105700 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010569d:	83 ec 0c             	sub    $0xc,%esp
801056a0:	50                   	push   %eax
801056a1:	e8 fa c1 ff ff       	call   801018a0 <ilock>
  if(ip->type != T_DIR){
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ae:	75 30                	jne    801056e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	53                   	push   %ebx
801056b4:	e8 c7 c2 ff ff       	call   80101980 <iunlock>
  iput(curproc->cwd);
801056b9:	58                   	pop    %eax
801056ba:	ff 76 68             	push   0x68(%esi)
801056bd:	e8 0e c3 ff ff       	call   801019d0 <iput>
  end_op();
801056c2:	e8 e9 d7 ff ff       	call   80102eb0 <end_op>
  curproc->cwd = ip;
801056c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	31 c0                	xor    %eax,%eax
}
801056cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056d2:	5b                   	pop    %ebx
801056d3:	5e                   	pop    %esi
801056d4:	5d                   	pop    %ebp
801056d5:	c3                   	ret
801056d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056dd:	00 
801056de:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	53                   	push   %ebx
801056e4:	e8 47 c4 ff ff       	call   80101b30 <iunlockput>
    end_op();
801056e9:	e8 c2 d7 ff ff       	call   80102eb0 <end_op>
    return -1;
801056ee:	83 c4 10             	add    $0x10,%esp
    return -1;
801056f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f6:	eb d7                	jmp    801056cf <sys_chdir+0x6f>
801056f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ff:	00 
    end_op();
80105700:	e8 ab d7 ff ff       	call   80102eb0 <end_op>
    return -1;
80105705:	eb ea                	jmp    801056f1 <sys_chdir+0x91>
80105707:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010570e:	00 
8010570f:	90                   	nop

80105710 <sys_exec>:

int
sys_exec(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105715:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010571b:	53                   	push   %ebx
8010571c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105722:	50                   	push   %eax
80105723:	6a 00                	push   $0x0
80105725:	e8 46 f4 ff ff       	call   80104b70 <argstr>
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	85 c0                	test   %eax,%eax
8010572f:	0f 88 87 00 00 00    	js     801057bc <sys_exec+0xac>
80105735:	83 ec 08             	sub    $0x8,%esp
80105738:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010573e:	50                   	push   %eax
8010573f:	6a 01                	push   $0x1
80105741:	e8 6a f3 ff ff       	call   80104ab0 <argint>
80105746:	83 c4 10             	add    $0x10,%esp
80105749:	85 c0                	test   %eax,%eax
8010574b:	78 6f                	js     801057bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010574d:	83 ec 04             	sub    $0x4,%esp
80105750:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105756:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105758:	68 80 00 00 00       	push   $0x80
8010575d:	6a 00                	push   $0x0
8010575f:	56                   	push   %esi
80105760:	e8 9b f0 ff ff       	call   80104800 <memset>
80105765:	83 c4 10             	add    $0x10,%esp
80105768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010576f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105770:	83 ec 08             	sub    $0x8,%esp
80105773:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105779:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105780:	50                   	push   %eax
80105781:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105787:	01 f8                	add    %edi,%eax
80105789:	50                   	push   %eax
8010578a:	e8 91 f2 ff ff       	call   80104a20 <fetchint>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	85 c0                	test   %eax,%eax
80105794:	78 26                	js     801057bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105796:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010579c:	85 c0                	test   %eax,%eax
8010579e:	74 30                	je     801057d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057a6:	52                   	push   %edx
801057a7:	50                   	push   %eax
801057a8:	e8 b3 f2 ff ff       	call   80104a60 <fetchstr>
801057ad:	83 c4 10             	add    $0x10,%esp
801057b0:	85 c0                	test   %eax,%eax
801057b2:	78 08                	js     801057bc <sys_exec+0xac>
  for(i=0;; i++){
801057b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057b7:	83 fb 20             	cmp    $0x20,%ebx
801057ba:	75 b4                	jne    80105770 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c4:	5b                   	pop    %ebx
801057c5:	5e                   	pop    %esi
801057c6:	5f                   	pop    %edi
801057c7:	5d                   	pop    %ebp
801057c8:	c3                   	ret
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057d7:	00 00 00 00 
  return exec(path, argv);
801057db:	83 ec 08             	sub    $0x8,%esp
801057de:	56                   	push   %esi
801057df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057e5:	e8 c6 b2 ff ff       	call   80100ab0 <exec>
801057ea:	83 c4 10             	add    $0x10,%esp
}
801057ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f0:	5b                   	pop    %ebx
801057f1:	5e                   	pop    %esi
801057f2:	5f                   	pop    %edi
801057f3:	5d                   	pop    %ebp
801057f4:	c3                   	ret
801057f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057fc:	00 
801057fd:	8d 76 00             	lea    0x0(%esi),%esi

80105800 <sys_pipe>:

int
sys_pipe(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105805:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105808:	53                   	push   %ebx
80105809:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010580c:	6a 08                	push   $0x8
8010580e:	50                   	push   %eax
8010580f:	6a 00                	push   $0x0
80105811:	e8 ea f2 ff ff       	call   80104b00 <argptr>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	0f 88 8b 00 00 00    	js     801058ac <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105821:	83 ec 08             	sub    $0x8,%esp
80105824:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105827:	50                   	push   %eax
80105828:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010582b:	50                   	push   %eax
8010582c:	e8 ef dc ff ff       	call   80103520 <pipealloc>
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	85 c0                	test   %eax,%eax
80105836:	78 74                	js     801058ac <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105838:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010583b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010583d:	e8 6e e2 ff ff       	call   80103ab0 <myproc>
    if(curproc->ofile[fd] == 0){
80105842:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105846:	85 f6                	test   %esi,%esi
80105848:	74 16                	je     80105860 <sys_pipe+0x60>
8010584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105850:	83 c3 01             	add    $0x1,%ebx
80105853:	83 fb 10             	cmp    $0x10,%ebx
80105856:	74 3d                	je     80105895 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105858:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010585c:	85 f6                	test   %esi,%esi
8010585e:	75 f0                	jne    80105850 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105860:	8d 73 08             	lea    0x8(%ebx),%esi
80105863:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010586a:	e8 41 e2 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010586f:	31 d2                	xor    %edx,%edx
80105871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105878:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010587c:	85 c9                	test   %ecx,%ecx
8010587e:	74 38                	je     801058b8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105880:	83 c2 01             	add    $0x1,%edx
80105883:	83 fa 10             	cmp    $0x10,%edx
80105886:	75 f0                	jne    80105878 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105888:	e8 23 e2 ff ff       	call   80103ab0 <myproc>
8010588d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105894:	00 
    fileclose(rf);
80105895:	83 ec 0c             	sub    $0xc,%esp
80105898:	ff 75 e0             	push   -0x20(%ebp)
8010589b:	e8 c0 b6 ff ff       	call   80100f60 <fileclose>
    fileclose(wf);
801058a0:	58                   	pop    %eax
801058a1:	ff 75 e4             	push   -0x1c(%ebp)
801058a4:	e8 b7 b6 ff ff       	call   80100f60 <fileclose>
    return -1;
801058a9:	83 c4 10             	add    $0x10,%esp
    return -1;
801058ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b1:	eb 16                	jmp    801058c9 <sys_pipe+0xc9>
801058b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801058b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801058bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058c7:	31 c0                	xor    %eax,%eax
}
801058c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058cc:	5b                   	pop    %ebx
801058cd:	5e                   	pop    %esi
801058ce:	5f                   	pop    %edi
801058cf:	5d                   	pop    %ebp
801058d0:	c3                   	ret
801058d1:	66 90                	xchg   %ax,%ax
801058d3:	66 90                	xchg   %ax,%ax
801058d5:	66 90                	xchg   %ax,%ax
801058d7:	66 90                	xchg   %ax,%ax
801058d9:	66 90                	xchg   %ax,%ax
801058db:	66 90                	xchg   %ax,%ax
801058dd:	66 90                	xchg   %ax,%ax
801058df:	90                   	nop

801058e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058e0:	e9 6b e3 ff ff       	jmp    80103c50 <fork>
801058e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ec:	00 
801058ed:	8d 76 00             	lea    0x0(%esi),%esi

801058f0 <sys_exit>:
}

int
sys_exit(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058f6:	e8 d5 e5 ff ff       	call   80103ed0 <exit>
  return 0;  // not reached
}
801058fb:	31 c0                	xor    %eax,%eax
801058fd:	c9                   	leave
801058fe:	c3                   	ret
801058ff:	90                   	nop

80105900 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105900:	e9 fb e6 ff ff       	jmp    80104000 <wait>
80105905:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010590c:	00 
8010590d:	8d 76 00             	lea    0x0(%esi),%esi

80105910 <sys_kill>:
}

int
sys_kill(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105916:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105919:	50                   	push   %eax
8010591a:	6a 00                	push   $0x0
8010591c:	e8 8f f1 ff ff       	call   80104ab0 <argint>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	85 c0                	test   %eax,%eax
80105926:	78 18                	js     80105940 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105928:	83 ec 0c             	sub    $0xc,%esp
8010592b:	ff 75 f4             	push   -0xc(%ebp)
8010592e:	e8 6d e9 ff ff       	call   801042a0 <kill>
80105933:	83 c4 10             	add    $0x10,%esp
}
80105936:	c9                   	leave
80105937:	c3                   	ret
80105938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593f:	00 
80105940:	c9                   	leave
    return -1;
80105941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105946:	c3                   	ret
80105947:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010594e:	00 
8010594f:	90                   	nop

80105950 <sys_getpid>:

int
sys_getpid(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105956:	e8 55 e1 ff ff       	call   80103ab0 <myproc>
8010595b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010595e:	c9                   	leave
8010595f:	c3                   	ret

80105960 <sys_sbrk>:

int
sys_sbrk(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105967:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010596a:	50                   	push   %eax
8010596b:	6a 00                	push   $0x0
8010596d:	e8 3e f1 ff ff       	call   80104ab0 <argint>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	78 27                	js     801059a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105979:	e8 32 e1 ff ff       	call   80103ab0 <myproc>
  if(growproc(n) < 0)
8010597e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105981:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105983:	ff 75 f4             	push   -0xc(%ebp)
80105986:	e8 45 e2 ff ff       	call   80103bd0 <growproc>
8010598b:	83 c4 10             	add    $0x10,%esp
8010598e:	85 c0                	test   %eax,%eax
80105990:	78 0e                	js     801059a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105992:	89 d8                	mov    %ebx,%eax
80105994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105997:	c9                   	leave
80105998:	c3                   	ret
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a5:	eb eb                	jmp    80105992 <sys_sbrk+0x32>
801059a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ae:	00 
801059af:	90                   	nop

801059b0 <sys_sleep>:

int
sys_sleep(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 ee f0 ff ff       	call   80104ab0 <argint>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 64                	js     80105a2d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801059c9:	83 ec 0c             	sub    $0xc,%esp
801059cc:	68 80 3d 11 80       	push   $0x80113d80
801059d1:	e8 2a ed ff ff       	call   80104700 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059d9:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  while(ticks - ticks0 < n){
801059df:	83 c4 10             	add    $0x10,%esp
801059e2:	85 d2                	test   %edx,%edx
801059e4:	75 2b                	jne    80105a11 <sys_sleep+0x61>
801059e6:	eb 58                	jmp    80105a40 <sys_sleep+0x90>
801059e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ef:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059f0:	83 ec 08             	sub    $0x8,%esp
801059f3:	68 80 3d 11 80       	push   $0x80113d80
801059f8:	68 60 3d 11 80       	push   $0x80113d60
801059fd:	e8 7e e7 ff ff       	call   80104180 <sleep>
  while(ticks - ticks0 < n){
80105a02:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	29 d8                	sub    %ebx,%eax
80105a0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a0f:	73 2f                	jae    80105a40 <sys_sleep+0x90>
    if(myproc()->killed){
80105a11:	e8 9a e0 ff ff       	call   80103ab0 <myproc>
80105a16:	8b 40 24             	mov    0x24(%eax),%eax
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	74 d3                	je     801059f0 <sys_sleep+0x40>
      release(&tickslock);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
80105a20:	68 80 3d 11 80       	push   $0x80113d80
80105a25:	e8 76 ec ff ff       	call   801046a0 <release>
      return -1;
80105a2a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105a2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave
80105a36:	c3                   	ret
80105a37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a3e:	00 
80105a3f:	90                   	nop
  release(&tickslock);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	68 80 3d 11 80       	push   $0x80113d80
80105a48:	e8 53 ec ff ff       	call   801046a0 <release>
}
80105a4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105a50:	83 c4 10             	add    $0x10,%esp
80105a53:	31 c0                	xor    %eax,%eax
}
80105a55:	c9                   	leave
80105a56:	c3                   	ret
80105a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a5e:	00 
80105a5f:	90                   	nop

80105a60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
80105a64:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a67:	68 80 3d 11 80       	push   $0x80113d80
80105a6c:	e8 8f ec ff ff       	call   80104700 <acquire>
  xticks = ticks;
80105a71:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  release(&tickslock);
80105a77:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105a7e:	e8 1d ec ff ff       	call   801046a0 <release>
  return xticks;
}
80105a83:	89 d8                	mov    %ebx,%eax
80105a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a88:	c9                   	leave
80105a89:	c3                   	ret
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a90 <sys_hello>:

int
sys_hello(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 14             	sub    $0x14,%esp
    cprintf("Hello, World!\n"); //writes to xv6 console from kernel space // cprintf since we are inside the kernel
80105a96:	68 f3 77 10 80       	push   $0x801077f3
80105a9b:	e8 10 ac ff ff       	call   801006b0 <cprintf>
    return 0;
}
80105aa0:	31 c0                	xor    %eax,%eax
80105aa2:	c9                   	leave
80105aa3:	c3                   	ret
80105aa4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aab:	00 
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_istainted>:

int
sys_istainted(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->tainted;
80105ab6:	e8 f5 df ff ff       	call   80103ab0 <myproc>
80105abb:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80105abe:	c9                   	leave
80105abf:	c3                   	ret

80105ac0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ac0:	1e                   	push   %ds
  pushl %es
80105ac1:	06                   	push   %es
  pushl %fs
80105ac2:	0f a0                	push   %fs
  pushl %gs
80105ac4:	0f a8                	push   %gs
  pushal
80105ac6:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ac7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105acb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105acd:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105acf:	54                   	push   %esp
  call trap
80105ad0:	e8 cb 00 00 00       	call   80105ba0 <trap>
  addl $4, %esp
80105ad5:	83 c4 04             	add    $0x4,%esp

80105ad8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ad8:	61                   	popa
  popl %gs
80105ad9:	0f a9                	pop    %gs
  popl %fs
80105adb:	0f a1                	pop    %fs
  popl %es
80105add:	07                   	pop    %es
  popl %ds
80105ade:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105adf:	83 c4 08             	add    $0x8,%esp
  iret
80105ae2:	cf                   	iret
80105ae3:	66 90                	xchg   %ax,%ax
80105ae5:	66 90                	xchg   %ax,%ax
80105ae7:	66 90                	xchg   %ax,%ax
80105ae9:	66 90                	xchg   %ax,%ax
80105aeb:	66 90                	xchg   %ax,%ax
80105aed:	66 90                	xchg   %ax,%ax
80105aef:	90                   	nop

80105af0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105af0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105af1:	31 c0                	xor    %eax,%eax
{
80105af3:	89 e5                	mov    %esp,%ebp
80105af5:	83 ec 08             	sub    $0x8,%esp
80105af8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aff:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b00:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b07:	c7 04 c5 c2 3d 11 80 	movl   $0x8e000008,-0x7feec23e(,%eax,8)
80105b0e:	08 00 00 8e 
80105b12:	66 89 14 c5 c0 3d 11 	mov    %dx,-0x7feec240(,%eax,8)
80105b19:	80 
80105b1a:	c1 ea 10             	shr    $0x10,%edx
80105b1d:	66 89 14 c5 c6 3d 11 	mov    %dx,-0x7feec23a(,%eax,8)
80105b24:	80 
  for(i = 0; i < 256; i++)
80105b25:	83 c0 01             	add    $0x1,%eax
80105b28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b2d:	75 d1                	jne    80105b00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b32:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b37:	c7 05 c2 3f 11 80 08 	movl   $0xef000008,0x80113fc2
80105b3e:	00 00 ef 
  initlock(&tickslock, "time");
80105b41:	68 02 78 10 80       	push   $0x80107802
80105b46:	68 80 3d 11 80       	push   $0x80113d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b4b:	66 a3 c0 3f 11 80    	mov    %ax,0x80113fc0
80105b51:	c1 e8 10             	shr    $0x10,%eax
80105b54:	66 a3 c6 3f 11 80    	mov    %ax,0x80113fc6
  initlock(&tickslock, "time");
80105b5a:	e8 b1 e9 ff ff       	call   80104510 <initlock>
}
80105b5f:	83 c4 10             	add    $0x10,%esp
80105b62:	c9                   	leave
80105b63:	c3                   	ret
80105b64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6b:	00 
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <idtinit>:

void
idtinit(void)
{
80105b70:	55                   	push   %ebp
  pd[0] = size-1;
80105b71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b76:	89 e5                	mov    %esp,%ebp
80105b78:	83 ec 10             	sub    $0x10,%esp
80105b7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b7f:	b8 c0 3d 11 80       	mov    $0x80113dc0,%eax
80105b84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b88:	c1 e8 10             	shr    $0x10,%eax
80105b8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b95:	c9                   	leave
80105b96:	c3                   	ret
80105b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9e:	00 
80105b9f:	90                   	nop

80105ba0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	57                   	push   %edi
80105ba4:	56                   	push   %esi
80105ba5:	53                   	push   %ebx
80105ba6:	83 ec 1c             	sub    $0x1c,%esp
80105ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105bac:	8b 43 30             	mov    0x30(%ebx),%eax
80105baf:	83 f8 40             	cmp    $0x40,%eax
80105bb2:	0f 84 58 01 00 00    	je     80105d10 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105bb8:	83 e8 20             	sub    $0x20,%eax
80105bbb:	83 f8 1f             	cmp    $0x1f,%eax
80105bbe:	0f 87 7c 00 00 00    	ja     80105c40 <trap+0xa0>
80105bc4:	ff 24 85 e4 7d 10 80 	jmp    *-0x7fef821c(,%eax,4)
80105bcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105bd0:	e8 5b c7 ff ff       	call   80102330 <ideintr>
    lapiceoi();
80105bd5:	e8 16 ce ff ff       	call   801029f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bda:	e8 d1 de ff ff       	call   80103ab0 <myproc>
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	74 1a                	je     80105bfd <trap+0x5d>
80105be3:	e8 c8 de ff ff       	call   80103ab0 <myproc>
80105be8:	8b 50 24             	mov    0x24(%eax),%edx
80105beb:	85 d2                	test   %edx,%edx
80105bed:	74 0e                	je     80105bfd <trap+0x5d>
80105bef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bf3:	f7 d0                	not    %eax
80105bf5:	a8 03                	test   $0x3,%al
80105bf7:	0f 84 db 01 00 00    	je     80105dd8 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105bfd:	e8 ae de ff ff       	call   80103ab0 <myproc>
80105c02:	85 c0                	test   %eax,%eax
80105c04:	74 0f                	je     80105c15 <trap+0x75>
80105c06:	e8 a5 de ff ff       	call   80103ab0 <myproc>
80105c0b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c0f:	0f 84 ab 00 00 00    	je     80105cc0 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c15:	e8 96 de ff ff       	call   80103ab0 <myproc>
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	74 1a                	je     80105c38 <trap+0x98>
80105c1e:	e8 8d de ff ff       	call   80103ab0 <myproc>
80105c23:	8b 40 24             	mov    0x24(%eax),%eax
80105c26:	85 c0                	test   %eax,%eax
80105c28:	74 0e                	je     80105c38 <trap+0x98>
80105c2a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c2e:	f7 d0                	not    %eax
80105c30:	a8 03                	test   $0x3,%al
80105c32:	0f 84 05 01 00 00    	je     80105d3d <trap+0x19d>
    exit();
}
80105c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c3b:	5b                   	pop    %ebx
80105c3c:	5e                   	pop    %esi
80105c3d:	5f                   	pop    %edi
80105c3e:	5d                   	pop    %ebp
80105c3f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c40:	e8 6b de ff ff       	call   80103ab0 <myproc>
80105c45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	0f 84 a2 01 00 00    	je     80105df2 <trap+0x252>
80105c50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c54:	0f 84 98 01 00 00    	je     80105df2 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c5a:	0f 20 d1             	mov    %cr2,%ecx
80105c5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c60:	e8 2b de ff ff       	call   80103a90 <cpuid>
80105c65:	8b 73 30             	mov    0x30(%ebx),%esi
80105c68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c71:	e8 3a de ff ff       	call   80103ab0 <myproc>
80105c76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c79:	e8 32 de ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c81:	51                   	push   %ecx
80105c82:	57                   	push   %edi
80105c83:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c86:	52                   	push   %edx
80105c87:	ff 75 e4             	push   -0x1c(%ebp)
80105c8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c91:	56                   	push   %esi
80105c92:	ff 70 10             	push   0x10(%eax)
80105c95:	68 cc 7a 10 80       	push   $0x80107acc
80105c9a:	e8 11 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105c9f:	83 c4 20             	add    $0x20,%esp
80105ca2:	e8 09 de ff ff       	call   80103ab0 <myproc>
80105ca7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cae:	e8 fd dd ff ff       	call   80103ab0 <myproc>
80105cb3:	85 c0                	test   %eax,%eax
80105cb5:	0f 85 28 ff ff ff    	jne    80105be3 <trap+0x43>
80105cbb:	e9 3d ff ff ff       	jmp    80105bfd <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105cc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105cc4:	0f 85 4b ff ff ff    	jne    80105c15 <trap+0x75>
    yield();
80105cca:	e8 61 e4 ff ff       	call   80104130 <yield>
80105ccf:	e9 41 ff ff ff       	jmp    80105c15 <trap+0x75>
80105cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cd8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cdb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cdf:	e8 ac dd ff ff       	call   80103a90 <cpuid>
80105ce4:	57                   	push   %edi
80105ce5:	56                   	push   %esi
80105ce6:	50                   	push   %eax
80105ce7:	68 74 7a 10 80       	push   $0x80107a74
80105cec:	e8 bf a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105cf1:	e8 fa cc ff ff       	call   801029f0 <lapiceoi>
    break;
80105cf6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cf9:	e8 b2 dd ff ff       	call   80103ab0 <myproc>
80105cfe:	85 c0                	test   %eax,%eax
80105d00:	0f 85 dd fe ff ff    	jne    80105be3 <trap+0x43>
80105d06:	e9 f2 fe ff ff       	jmp    80105bfd <trap+0x5d>
80105d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d10:	e8 9b dd ff ff       	call   80103ab0 <myproc>
80105d15:	8b 70 24             	mov    0x24(%eax),%esi
80105d18:	85 f6                	test   %esi,%esi
80105d1a:	0f 85 c8 00 00 00    	jne    80105de8 <trap+0x248>
    myproc()->tf = tf;
80105d20:	e8 8b dd ff ff       	call   80103ab0 <myproc>
80105d25:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d28:	e8 c3 ee ff ff       	call   80104bf0 <syscall>
    if(myproc()->killed)
80105d2d:	e8 7e dd ff ff       	call   80103ab0 <myproc>
80105d32:	8b 48 24             	mov    0x24(%eax),%ecx
80105d35:	85 c9                	test   %ecx,%ecx
80105d37:	0f 84 fb fe ff ff    	je     80105c38 <trap+0x98>
}
80105d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d40:	5b                   	pop    %ebx
80105d41:	5e                   	pop    %esi
80105d42:	5f                   	pop    %edi
80105d43:	5d                   	pop    %ebp
      exit();
80105d44:	e9 87 e1 ff ff       	jmp    80103ed0 <exit>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d50:	e8 4b 02 00 00       	call   80105fa0 <uartintr>
    lapiceoi();
80105d55:	e8 96 cc ff ff       	call   801029f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d5a:	e8 51 dd ff ff       	call   80103ab0 <myproc>
80105d5f:	85 c0                	test   %eax,%eax
80105d61:	0f 85 7c fe ff ff    	jne    80105be3 <trap+0x43>
80105d67:	e9 91 fe ff ff       	jmp    80105bfd <trap+0x5d>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d70:	e8 4b cb ff ff       	call   801028c0 <kbdintr>
    lapiceoi();
80105d75:	e8 76 cc ff ff       	call   801029f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d7a:	e8 31 dd ff ff       	call   80103ab0 <myproc>
80105d7f:	85 c0                	test   %eax,%eax
80105d81:	0f 85 5c fe ff ff    	jne    80105be3 <trap+0x43>
80105d87:	e9 71 fe ff ff       	jmp    80105bfd <trap+0x5d>
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d90:	e8 fb dc ff ff       	call   80103a90 <cpuid>
80105d95:	85 c0                	test   %eax,%eax
80105d97:	0f 85 38 fe ff ff    	jne    80105bd5 <trap+0x35>
      acquire(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 80 3d 11 80       	push   $0x80113d80
80105da5:	e8 56 e9 ff ff       	call   80104700 <acquire>
      ticks++;
80105daa:	83 05 60 3d 11 80 01 	addl   $0x1,0x80113d60
      wakeup(&ticks);
80105db1:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80105db8:	e8 83 e4 ff ff       	call   80104240 <wakeup>
      release(&tickslock);
80105dbd:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105dc4:	e8 d7 e8 ff ff       	call   801046a0 <release>
80105dc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105dcc:	e9 04 fe ff ff       	jmp    80105bd5 <trap+0x35>
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105dd8:	e8 f3 e0 ff ff       	call   80103ed0 <exit>
80105ddd:	e9 1b fe ff ff       	jmp    80105bfd <trap+0x5d>
80105de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105de8:	e8 e3 e0 ff ff       	call   80103ed0 <exit>
80105ded:	e9 2e ff ff ff       	jmp    80105d20 <trap+0x180>
80105df2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105df5:	e8 96 dc ff ff       	call   80103a90 <cpuid>
80105dfa:	83 ec 0c             	sub    $0xc,%esp
80105dfd:	56                   	push   %esi
80105dfe:	57                   	push   %edi
80105dff:	50                   	push   %eax
80105e00:	ff 73 30             	push   0x30(%ebx)
80105e03:	68 98 7a 10 80       	push   $0x80107a98
80105e08:	e8 a3 a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105e0d:	83 c4 14             	add    $0x14,%esp
80105e10:	68 07 78 10 80       	push   $0x80107807
80105e15:	e8 66 a5 ff ff       	call   80100380 <panic>
80105e1a:	66 90                	xchg   %ax,%ax
80105e1c:	66 90                	xchg   %ax,%ax
80105e1e:	66 90                	xchg   %ax,%ax

80105e20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e20:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105e25:	85 c0                	test   %eax,%eax
80105e27:	74 17                	je     80105e40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e2f:	a8 01                	test   $0x1,%al
80105e31:	74 0d                	je     80105e40 <uartgetc+0x20>
80105e33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e39:	0f b6 c0             	movzbl %al,%eax
80105e3c:	c3                   	ret
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e45:	c3                   	ret
80105e46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e4d:	00 
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <uartinit>:
{
80105e50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e51:	31 c9                	xor    %ecx,%ecx
80105e53:	89 c8                	mov    %ecx,%eax
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	57                   	push   %edi
80105e58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e5d:	56                   	push   %esi
80105e5e:	89 fa                	mov    %edi,%edx
80105e60:	53                   	push   %ebx
80105e61:	83 ec 1c             	sub    $0x1c,%esp
80105e64:	ee                   	out    %al,(%dx)
80105e65:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e6f:	89 f2                	mov    %esi,%edx
80105e71:	ee                   	out    %al,(%dx)
80105e72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e7c:	ee                   	out    %al,(%dx)
80105e7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e82:	89 c8                	mov    %ecx,%eax
80105e84:	89 da                	mov    %ebx,%edx
80105e86:	ee                   	out    %al,(%dx)
80105e87:	b8 03 00 00 00       	mov    $0x3,%eax
80105e8c:	89 f2                	mov    %esi,%edx
80105e8e:	ee                   	out    %al,(%dx)
80105e8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e94:	89 c8                	mov    %ecx,%eax
80105e96:	ee                   	out    %al,(%dx)
80105e97:	b8 01 00 00 00       	mov    $0x1,%eax
80105e9c:	89 da                	mov    %ebx,%edx
80105e9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ea4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ea5:	3c ff                	cmp    $0xff,%al
80105ea7:	0f 84 7c 00 00 00    	je     80105f29 <uartinit+0xd9>
  uart = 1;
80105ead:	c7 05 c0 45 11 80 01 	movl   $0x1,0x801145c0
80105eb4:	00 00 00 
80105eb7:	89 fa                	mov    %edi,%edx
80105eb9:	ec                   	in     (%dx),%al
80105eba:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ec0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105ec3:	bf 0c 78 10 80       	mov    $0x8010780c,%edi
80105ec8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ecd:	6a 00                	push   $0x0
80105ecf:	6a 04                	push   $0x4
80105ed1:	e8 8a c6 ff ff       	call   80102560 <ioapicenable>
80105ed6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ed9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105edd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ee0:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	74 32                	je     80105f1b <uartinit+0xcb>
80105ee9:	89 f2                	mov    %esi,%edx
80105eeb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eec:	a8 20                	test   $0x20,%al
80105eee:	75 21                	jne    80105f11 <uartinit+0xc1>
80105ef0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ef5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105ef8:	83 ec 0c             	sub    $0xc,%esp
80105efb:	6a 0a                	push   $0xa
80105efd:	e8 0e cb ff ff       	call   80102a10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	83 eb 01             	sub    $0x1,%ebx
80105f08:	74 07                	je     80105f11 <uartinit+0xc1>
80105f0a:	89 f2                	mov    %esi,%edx
80105f0c:	ec                   	in     (%dx),%al
80105f0d:	a8 20                	test   $0x20,%al
80105f0f:	74 e7                	je     80105ef8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f11:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f16:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f1a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f1b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f1f:	83 c7 01             	add    $0x1,%edi
80105f22:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f25:	84 c0                	test   %al,%al
80105f27:	75 b7                	jne    80105ee0 <uartinit+0x90>
}
80105f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f2c:	5b                   	pop    %ebx
80105f2d:	5e                   	pop    %esi
80105f2e:	5f                   	pop    %edi
80105f2f:	5d                   	pop    %ebp
80105f30:	c3                   	ret
80105f31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f38:	00 
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f40 <uartputc>:
  if(!uart)
80105f40:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105f45:	85 c0                	test   %eax,%eax
80105f47:	74 4f                	je     80105f98 <uartputc+0x58>
{
80105f49:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f4a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f4f:	89 e5                	mov    %esp,%ebp
80105f51:	56                   	push   %esi
80105f52:	53                   	push   %ebx
80105f53:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f54:	a8 20                	test   $0x20,%al
80105f56:	75 29                	jne    80105f81 <uartputc+0x41>
80105f58:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f68:	83 ec 0c             	sub    $0xc,%esp
80105f6b:	6a 0a                	push   $0xa
80105f6d:	e8 9e ca ff ff       	call   80102a10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f72:	83 c4 10             	add    $0x10,%esp
80105f75:	83 eb 01             	sub    $0x1,%ebx
80105f78:	74 07                	je     80105f81 <uartputc+0x41>
80105f7a:	89 f2                	mov    %esi,%edx
80105f7c:	ec                   	in     (%dx),%al
80105f7d:	a8 20                	test   $0x20,%al
80105f7f:	74 e7                	je     80105f68 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f81:	8b 45 08             	mov    0x8(%ebp),%eax
80105f84:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f89:	ee                   	out    %al,(%dx)
}
80105f8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f8d:	5b                   	pop    %ebx
80105f8e:	5e                   	pop    %esi
80105f8f:	5d                   	pop    %ebp
80105f90:	c3                   	ret
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f98:	c3                   	ret
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <uartintr>:

void
uartintr(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fa6:	68 20 5e 10 80       	push   $0x80105e20
80105fab:	e8 f0 a8 ff ff       	call   801008a0 <consoleintr>
}
80105fb0:	83 c4 10             	add    $0x10,%esp
80105fb3:	c9                   	leave
80105fb4:	c3                   	ret

80105fb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $0
80105fb7:	6a 00                	push   $0x0
  jmp alltraps
80105fb9:	e9 02 fb ff ff       	jmp    80105ac0 <alltraps>

80105fbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $1
80105fc0:	6a 01                	push   $0x1
  jmp alltraps
80105fc2:	e9 f9 fa ff ff       	jmp    80105ac0 <alltraps>

80105fc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $2
80105fc9:	6a 02                	push   $0x2
  jmp alltraps
80105fcb:	e9 f0 fa ff ff       	jmp    80105ac0 <alltraps>

80105fd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $3
80105fd2:	6a 03                	push   $0x3
  jmp alltraps
80105fd4:	e9 e7 fa ff ff       	jmp    80105ac0 <alltraps>

80105fd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $4
80105fdb:	6a 04                	push   $0x4
  jmp alltraps
80105fdd:	e9 de fa ff ff       	jmp    80105ac0 <alltraps>

80105fe2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $5
80105fe4:	6a 05                	push   $0x5
  jmp alltraps
80105fe6:	e9 d5 fa ff ff       	jmp    80105ac0 <alltraps>

80105feb <vector6>:
.globl vector6
vector6:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $6
80105fed:	6a 06                	push   $0x6
  jmp alltraps
80105fef:	e9 cc fa ff ff       	jmp    80105ac0 <alltraps>

80105ff4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $7
80105ff6:	6a 07                	push   $0x7
  jmp alltraps
80105ff8:	e9 c3 fa ff ff       	jmp    80105ac0 <alltraps>

80105ffd <vector8>:
.globl vector8
vector8:
  pushl $8
80105ffd:	6a 08                	push   $0x8
  jmp alltraps
80105fff:	e9 bc fa ff ff       	jmp    80105ac0 <alltraps>

80106004 <vector9>:
.globl vector9
vector9:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $9
80106006:	6a 09                	push   $0x9
  jmp alltraps
80106008:	e9 b3 fa ff ff       	jmp    80105ac0 <alltraps>

8010600d <vector10>:
.globl vector10
vector10:
  pushl $10
8010600d:	6a 0a                	push   $0xa
  jmp alltraps
8010600f:	e9 ac fa ff ff       	jmp    80105ac0 <alltraps>

80106014 <vector11>:
.globl vector11
vector11:
  pushl $11
80106014:	6a 0b                	push   $0xb
  jmp alltraps
80106016:	e9 a5 fa ff ff       	jmp    80105ac0 <alltraps>

8010601b <vector12>:
.globl vector12
vector12:
  pushl $12
8010601b:	6a 0c                	push   $0xc
  jmp alltraps
8010601d:	e9 9e fa ff ff       	jmp    80105ac0 <alltraps>

80106022 <vector13>:
.globl vector13
vector13:
  pushl $13
80106022:	6a 0d                	push   $0xd
  jmp alltraps
80106024:	e9 97 fa ff ff       	jmp    80105ac0 <alltraps>

80106029 <vector14>:
.globl vector14
vector14:
  pushl $14
80106029:	6a 0e                	push   $0xe
  jmp alltraps
8010602b:	e9 90 fa ff ff       	jmp    80105ac0 <alltraps>

80106030 <vector15>:
.globl vector15
vector15:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $15
80106032:	6a 0f                	push   $0xf
  jmp alltraps
80106034:	e9 87 fa ff ff       	jmp    80105ac0 <alltraps>

80106039 <vector16>:
.globl vector16
vector16:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $16
8010603b:	6a 10                	push   $0x10
  jmp alltraps
8010603d:	e9 7e fa ff ff       	jmp    80105ac0 <alltraps>

80106042 <vector17>:
.globl vector17
vector17:
  pushl $17
80106042:	6a 11                	push   $0x11
  jmp alltraps
80106044:	e9 77 fa ff ff       	jmp    80105ac0 <alltraps>

80106049 <vector18>:
.globl vector18
vector18:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $18
8010604b:	6a 12                	push   $0x12
  jmp alltraps
8010604d:	e9 6e fa ff ff       	jmp    80105ac0 <alltraps>

80106052 <vector19>:
.globl vector19
vector19:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $19
80106054:	6a 13                	push   $0x13
  jmp alltraps
80106056:	e9 65 fa ff ff       	jmp    80105ac0 <alltraps>

8010605b <vector20>:
.globl vector20
vector20:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $20
8010605d:	6a 14                	push   $0x14
  jmp alltraps
8010605f:	e9 5c fa ff ff       	jmp    80105ac0 <alltraps>

80106064 <vector21>:
.globl vector21
vector21:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $21
80106066:	6a 15                	push   $0x15
  jmp alltraps
80106068:	e9 53 fa ff ff       	jmp    80105ac0 <alltraps>

8010606d <vector22>:
.globl vector22
vector22:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $22
8010606f:	6a 16                	push   $0x16
  jmp alltraps
80106071:	e9 4a fa ff ff       	jmp    80105ac0 <alltraps>

80106076 <vector23>:
.globl vector23
vector23:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $23
80106078:	6a 17                	push   $0x17
  jmp alltraps
8010607a:	e9 41 fa ff ff       	jmp    80105ac0 <alltraps>

8010607f <vector24>:
.globl vector24
vector24:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $24
80106081:	6a 18                	push   $0x18
  jmp alltraps
80106083:	e9 38 fa ff ff       	jmp    80105ac0 <alltraps>

80106088 <vector25>:
.globl vector25
vector25:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $25
8010608a:	6a 19                	push   $0x19
  jmp alltraps
8010608c:	e9 2f fa ff ff       	jmp    80105ac0 <alltraps>

80106091 <vector26>:
.globl vector26
vector26:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $26
80106093:	6a 1a                	push   $0x1a
  jmp alltraps
80106095:	e9 26 fa ff ff       	jmp    80105ac0 <alltraps>

8010609a <vector27>:
.globl vector27
vector27:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $27
8010609c:	6a 1b                	push   $0x1b
  jmp alltraps
8010609e:	e9 1d fa ff ff       	jmp    80105ac0 <alltraps>

801060a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $28
801060a5:	6a 1c                	push   $0x1c
  jmp alltraps
801060a7:	e9 14 fa ff ff       	jmp    80105ac0 <alltraps>

801060ac <vector29>:
.globl vector29
vector29:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $29
801060ae:	6a 1d                	push   $0x1d
  jmp alltraps
801060b0:	e9 0b fa ff ff       	jmp    80105ac0 <alltraps>

801060b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $30
801060b7:	6a 1e                	push   $0x1e
  jmp alltraps
801060b9:	e9 02 fa ff ff       	jmp    80105ac0 <alltraps>

801060be <vector31>:
.globl vector31
vector31:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $31
801060c0:	6a 1f                	push   $0x1f
  jmp alltraps
801060c2:	e9 f9 f9 ff ff       	jmp    80105ac0 <alltraps>

801060c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $32
801060c9:	6a 20                	push   $0x20
  jmp alltraps
801060cb:	e9 f0 f9 ff ff       	jmp    80105ac0 <alltraps>

801060d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $33
801060d2:	6a 21                	push   $0x21
  jmp alltraps
801060d4:	e9 e7 f9 ff ff       	jmp    80105ac0 <alltraps>

801060d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $34
801060db:	6a 22                	push   $0x22
  jmp alltraps
801060dd:	e9 de f9 ff ff       	jmp    80105ac0 <alltraps>

801060e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $35
801060e4:	6a 23                	push   $0x23
  jmp alltraps
801060e6:	e9 d5 f9 ff ff       	jmp    80105ac0 <alltraps>

801060eb <vector36>:
.globl vector36
vector36:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $36
801060ed:	6a 24                	push   $0x24
  jmp alltraps
801060ef:	e9 cc f9 ff ff       	jmp    80105ac0 <alltraps>

801060f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $37
801060f6:	6a 25                	push   $0x25
  jmp alltraps
801060f8:	e9 c3 f9 ff ff       	jmp    80105ac0 <alltraps>

801060fd <vector38>:
.globl vector38
vector38:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $38
801060ff:	6a 26                	push   $0x26
  jmp alltraps
80106101:	e9 ba f9 ff ff       	jmp    80105ac0 <alltraps>

80106106 <vector39>:
.globl vector39
vector39:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $39
80106108:	6a 27                	push   $0x27
  jmp alltraps
8010610a:	e9 b1 f9 ff ff       	jmp    80105ac0 <alltraps>

8010610f <vector40>:
.globl vector40
vector40:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $40
80106111:	6a 28                	push   $0x28
  jmp alltraps
80106113:	e9 a8 f9 ff ff       	jmp    80105ac0 <alltraps>

80106118 <vector41>:
.globl vector41
vector41:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $41
8010611a:	6a 29                	push   $0x29
  jmp alltraps
8010611c:	e9 9f f9 ff ff       	jmp    80105ac0 <alltraps>

80106121 <vector42>:
.globl vector42
vector42:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $42
80106123:	6a 2a                	push   $0x2a
  jmp alltraps
80106125:	e9 96 f9 ff ff       	jmp    80105ac0 <alltraps>

8010612a <vector43>:
.globl vector43
vector43:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $43
8010612c:	6a 2b                	push   $0x2b
  jmp alltraps
8010612e:	e9 8d f9 ff ff       	jmp    80105ac0 <alltraps>

80106133 <vector44>:
.globl vector44
vector44:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $44
80106135:	6a 2c                	push   $0x2c
  jmp alltraps
80106137:	e9 84 f9 ff ff       	jmp    80105ac0 <alltraps>

8010613c <vector45>:
.globl vector45
vector45:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $45
8010613e:	6a 2d                	push   $0x2d
  jmp alltraps
80106140:	e9 7b f9 ff ff       	jmp    80105ac0 <alltraps>

80106145 <vector46>:
.globl vector46
vector46:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $46
80106147:	6a 2e                	push   $0x2e
  jmp alltraps
80106149:	e9 72 f9 ff ff       	jmp    80105ac0 <alltraps>

8010614e <vector47>:
.globl vector47
vector47:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $47
80106150:	6a 2f                	push   $0x2f
  jmp alltraps
80106152:	e9 69 f9 ff ff       	jmp    80105ac0 <alltraps>

80106157 <vector48>:
.globl vector48
vector48:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $48
80106159:	6a 30                	push   $0x30
  jmp alltraps
8010615b:	e9 60 f9 ff ff       	jmp    80105ac0 <alltraps>

80106160 <vector49>:
.globl vector49
vector49:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $49
80106162:	6a 31                	push   $0x31
  jmp alltraps
80106164:	e9 57 f9 ff ff       	jmp    80105ac0 <alltraps>

80106169 <vector50>:
.globl vector50
vector50:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $50
8010616b:	6a 32                	push   $0x32
  jmp alltraps
8010616d:	e9 4e f9 ff ff       	jmp    80105ac0 <alltraps>

80106172 <vector51>:
.globl vector51
vector51:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $51
80106174:	6a 33                	push   $0x33
  jmp alltraps
80106176:	e9 45 f9 ff ff       	jmp    80105ac0 <alltraps>

8010617b <vector52>:
.globl vector52
vector52:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $52
8010617d:	6a 34                	push   $0x34
  jmp alltraps
8010617f:	e9 3c f9 ff ff       	jmp    80105ac0 <alltraps>

80106184 <vector53>:
.globl vector53
vector53:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $53
80106186:	6a 35                	push   $0x35
  jmp alltraps
80106188:	e9 33 f9 ff ff       	jmp    80105ac0 <alltraps>

8010618d <vector54>:
.globl vector54
vector54:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $54
8010618f:	6a 36                	push   $0x36
  jmp alltraps
80106191:	e9 2a f9 ff ff       	jmp    80105ac0 <alltraps>

80106196 <vector55>:
.globl vector55
vector55:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $55
80106198:	6a 37                	push   $0x37
  jmp alltraps
8010619a:	e9 21 f9 ff ff       	jmp    80105ac0 <alltraps>

8010619f <vector56>:
.globl vector56
vector56:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $56
801061a1:	6a 38                	push   $0x38
  jmp alltraps
801061a3:	e9 18 f9 ff ff       	jmp    80105ac0 <alltraps>

801061a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $57
801061aa:	6a 39                	push   $0x39
  jmp alltraps
801061ac:	e9 0f f9 ff ff       	jmp    80105ac0 <alltraps>

801061b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $58
801061b3:	6a 3a                	push   $0x3a
  jmp alltraps
801061b5:	e9 06 f9 ff ff       	jmp    80105ac0 <alltraps>

801061ba <vector59>:
.globl vector59
vector59:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $59
801061bc:	6a 3b                	push   $0x3b
  jmp alltraps
801061be:	e9 fd f8 ff ff       	jmp    80105ac0 <alltraps>

801061c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $60
801061c5:	6a 3c                	push   $0x3c
  jmp alltraps
801061c7:	e9 f4 f8 ff ff       	jmp    80105ac0 <alltraps>

801061cc <vector61>:
.globl vector61
vector61:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $61
801061ce:	6a 3d                	push   $0x3d
  jmp alltraps
801061d0:	e9 eb f8 ff ff       	jmp    80105ac0 <alltraps>

801061d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $62
801061d7:	6a 3e                	push   $0x3e
  jmp alltraps
801061d9:	e9 e2 f8 ff ff       	jmp    80105ac0 <alltraps>

801061de <vector63>:
.globl vector63
vector63:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $63
801061e0:	6a 3f                	push   $0x3f
  jmp alltraps
801061e2:	e9 d9 f8 ff ff       	jmp    80105ac0 <alltraps>

801061e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $64
801061e9:	6a 40                	push   $0x40
  jmp alltraps
801061eb:	e9 d0 f8 ff ff       	jmp    80105ac0 <alltraps>

801061f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $65
801061f2:	6a 41                	push   $0x41
  jmp alltraps
801061f4:	e9 c7 f8 ff ff       	jmp    80105ac0 <alltraps>

801061f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $66
801061fb:	6a 42                	push   $0x42
  jmp alltraps
801061fd:	e9 be f8 ff ff       	jmp    80105ac0 <alltraps>

80106202 <vector67>:
.globl vector67
vector67:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $67
80106204:	6a 43                	push   $0x43
  jmp alltraps
80106206:	e9 b5 f8 ff ff       	jmp    80105ac0 <alltraps>

8010620b <vector68>:
.globl vector68
vector68:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $68
8010620d:	6a 44                	push   $0x44
  jmp alltraps
8010620f:	e9 ac f8 ff ff       	jmp    80105ac0 <alltraps>

80106214 <vector69>:
.globl vector69
vector69:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $69
80106216:	6a 45                	push   $0x45
  jmp alltraps
80106218:	e9 a3 f8 ff ff       	jmp    80105ac0 <alltraps>

8010621d <vector70>:
.globl vector70
vector70:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $70
8010621f:	6a 46                	push   $0x46
  jmp alltraps
80106221:	e9 9a f8 ff ff       	jmp    80105ac0 <alltraps>

80106226 <vector71>:
.globl vector71
vector71:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $71
80106228:	6a 47                	push   $0x47
  jmp alltraps
8010622a:	e9 91 f8 ff ff       	jmp    80105ac0 <alltraps>

8010622f <vector72>:
.globl vector72
vector72:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $72
80106231:	6a 48                	push   $0x48
  jmp alltraps
80106233:	e9 88 f8 ff ff       	jmp    80105ac0 <alltraps>

80106238 <vector73>:
.globl vector73
vector73:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $73
8010623a:	6a 49                	push   $0x49
  jmp alltraps
8010623c:	e9 7f f8 ff ff       	jmp    80105ac0 <alltraps>

80106241 <vector74>:
.globl vector74
vector74:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $74
80106243:	6a 4a                	push   $0x4a
  jmp alltraps
80106245:	e9 76 f8 ff ff       	jmp    80105ac0 <alltraps>

8010624a <vector75>:
.globl vector75
vector75:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $75
8010624c:	6a 4b                	push   $0x4b
  jmp alltraps
8010624e:	e9 6d f8 ff ff       	jmp    80105ac0 <alltraps>

80106253 <vector76>:
.globl vector76
vector76:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $76
80106255:	6a 4c                	push   $0x4c
  jmp alltraps
80106257:	e9 64 f8 ff ff       	jmp    80105ac0 <alltraps>

8010625c <vector77>:
.globl vector77
vector77:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $77
8010625e:	6a 4d                	push   $0x4d
  jmp alltraps
80106260:	e9 5b f8 ff ff       	jmp    80105ac0 <alltraps>

80106265 <vector78>:
.globl vector78
vector78:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $78
80106267:	6a 4e                	push   $0x4e
  jmp alltraps
80106269:	e9 52 f8 ff ff       	jmp    80105ac0 <alltraps>

8010626e <vector79>:
.globl vector79
vector79:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $79
80106270:	6a 4f                	push   $0x4f
  jmp alltraps
80106272:	e9 49 f8 ff ff       	jmp    80105ac0 <alltraps>

80106277 <vector80>:
.globl vector80
vector80:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $80
80106279:	6a 50                	push   $0x50
  jmp alltraps
8010627b:	e9 40 f8 ff ff       	jmp    80105ac0 <alltraps>

80106280 <vector81>:
.globl vector81
vector81:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $81
80106282:	6a 51                	push   $0x51
  jmp alltraps
80106284:	e9 37 f8 ff ff       	jmp    80105ac0 <alltraps>

80106289 <vector82>:
.globl vector82
vector82:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $82
8010628b:	6a 52                	push   $0x52
  jmp alltraps
8010628d:	e9 2e f8 ff ff       	jmp    80105ac0 <alltraps>

80106292 <vector83>:
.globl vector83
vector83:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $83
80106294:	6a 53                	push   $0x53
  jmp alltraps
80106296:	e9 25 f8 ff ff       	jmp    80105ac0 <alltraps>

8010629b <vector84>:
.globl vector84
vector84:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $84
8010629d:	6a 54                	push   $0x54
  jmp alltraps
8010629f:	e9 1c f8 ff ff       	jmp    80105ac0 <alltraps>

801062a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $85
801062a6:	6a 55                	push   $0x55
  jmp alltraps
801062a8:	e9 13 f8 ff ff       	jmp    80105ac0 <alltraps>

801062ad <vector86>:
.globl vector86
vector86:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $86
801062af:	6a 56                	push   $0x56
  jmp alltraps
801062b1:	e9 0a f8 ff ff       	jmp    80105ac0 <alltraps>

801062b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $87
801062b8:	6a 57                	push   $0x57
  jmp alltraps
801062ba:	e9 01 f8 ff ff       	jmp    80105ac0 <alltraps>

801062bf <vector88>:
.globl vector88
vector88:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $88
801062c1:	6a 58                	push   $0x58
  jmp alltraps
801062c3:	e9 f8 f7 ff ff       	jmp    80105ac0 <alltraps>

801062c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $89
801062ca:	6a 59                	push   $0x59
  jmp alltraps
801062cc:	e9 ef f7 ff ff       	jmp    80105ac0 <alltraps>

801062d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $90
801062d3:	6a 5a                	push   $0x5a
  jmp alltraps
801062d5:	e9 e6 f7 ff ff       	jmp    80105ac0 <alltraps>

801062da <vector91>:
.globl vector91
vector91:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $91
801062dc:	6a 5b                	push   $0x5b
  jmp alltraps
801062de:	e9 dd f7 ff ff       	jmp    80105ac0 <alltraps>

801062e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $92
801062e5:	6a 5c                	push   $0x5c
  jmp alltraps
801062e7:	e9 d4 f7 ff ff       	jmp    80105ac0 <alltraps>

801062ec <vector93>:
.globl vector93
vector93:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $93
801062ee:	6a 5d                	push   $0x5d
  jmp alltraps
801062f0:	e9 cb f7 ff ff       	jmp    80105ac0 <alltraps>

801062f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $94
801062f7:	6a 5e                	push   $0x5e
  jmp alltraps
801062f9:	e9 c2 f7 ff ff       	jmp    80105ac0 <alltraps>

801062fe <vector95>:
.globl vector95
vector95:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $95
80106300:	6a 5f                	push   $0x5f
  jmp alltraps
80106302:	e9 b9 f7 ff ff       	jmp    80105ac0 <alltraps>

80106307 <vector96>:
.globl vector96
vector96:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $96
80106309:	6a 60                	push   $0x60
  jmp alltraps
8010630b:	e9 b0 f7 ff ff       	jmp    80105ac0 <alltraps>

80106310 <vector97>:
.globl vector97
vector97:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $97
80106312:	6a 61                	push   $0x61
  jmp alltraps
80106314:	e9 a7 f7 ff ff       	jmp    80105ac0 <alltraps>

80106319 <vector98>:
.globl vector98
vector98:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $98
8010631b:	6a 62                	push   $0x62
  jmp alltraps
8010631d:	e9 9e f7 ff ff       	jmp    80105ac0 <alltraps>

80106322 <vector99>:
.globl vector99
vector99:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $99
80106324:	6a 63                	push   $0x63
  jmp alltraps
80106326:	e9 95 f7 ff ff       	jmp    80105ac0 <alltraps>

8010632b <vector100>:
.globl vector100
vector100:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $100
8010632d:	6a 64                	push   $0x64
  jmp alltraps
8010632f:	e9 8c f7 ff ff       	jmp    80105ac0 <alltraps>

80106334 <vector101>:
.globl vector101
vector101:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $101
80106336:	6a 65                	push   $0x65
  jmp alltraps
80106338:	e9 83 f7 ff ff       	jmp    80105ac0 <alltraps>

8010633d <vector102>:
.globl vector102
vector102:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $102
8010633f:	6a 66                	push   $0x66
  jmp alltraps
80106341:	e9 7a f7 ff ff       	jmp    80105ac0 <alltraps>

80106346 <vector103>:
.globl vector103
vector103:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $103
80106348:	6a 67                	push   $0x67
  jmp alltraps
8010634a:	e9 71 f7 ff ff       	jmp    80105ac0 <alltraps>

8010634f <vector104>:
.globl vector104
vector104:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $104
80106351:	6a 68                	push   $0x68
  jmp alltraps
80106353:	e9 68 f7 ff ff       	jmp    80105ac0 <alltraps>

80106358 <vector105>:
.globl vector105
vector105:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $105
8010635a:	6a 69                	push   $0x69
  jmp alltraps
8010635c:	e9 5f f7 ff ff       	jmp    80105ac0 <alltraps>

80106361 <vector106>:
.globl vector106
vector106:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $106
80106363:	6a 6a                	push   $0x6a
  jmp alltraps
80106365:	e9 56 f7 ff ff       	jmp    80105ac0 <alltraps>

8010636a <vector107>:
.globl vector107
vector107:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $107
8010636c:	6a 6b                	push   $0x6b
  jmp alltraps
8010636e:	e9 4d f7 ff ff       	jmp    80105ac0 <alltraps>

80106373 <vector108>:
.globl vector108
vector108:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $108
80106375:	6a 6c                	push   $0x6c
  jmp alltraps
80106377:	e9 44 f7 ff ff       	jmp    80105ac0 <alltraps>

8010637c <vector109>:
.globl vector109
vector109:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $109
8010637e:	6a 6d                	push   $0x6d
  jmp alltraps
80106380:	e9 3b f7 ff ff       	jmp    80105ac0 <alltraps>

80106385 <vector110>:
.globl vector110
vector110:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $110
80106387:	6a 6e                	push   $0x6e
  jmp alltraps
80106389:	e9 32 f7 ff ff       	jmp    80105ac0 <alltraps>

8010638e <vector111>:
.globl vector111
vector111:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $111
80106390:	6a 6f                	push   $0x6f
  jmp alltraps
80106392:	e9 29 f7 ff ff       	jmp    80105ac0 <alltraps>

80106397 <vector112>:
.globl vector112
vector112:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $112
80106399:	6a 70                	push   $0x70
  jmp alltraps
8010639b:	e9 20 f7 ff ff       	jmp    80105ac0 <alltraps>

801063a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $113
801063a2:	6a 71                	push   $0x71
  jmp alltraps
801063a4:	e9 17 f7 ff ff       	jmp    80105ac0 <alltraps>

801063a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $114
801063ab:	6a 72                	push   $0x72
  jmp alltraps
801063ad:	e9 0e f7 ff ff       	jmp    80105ac0 <alltraps>

801063b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $115
801063b4:	6a 73                	push   $0x73
  jmp alltraps
801063b6:	e9 05 f7 ff ff       	jmp    80105ac0 <alltraps>

801063bb <vector116>:
.globl vector116
vector116:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $116
801063bd:	6a 74                	push   $0x74
  jmp alltraps
801063bf:	e9 fc f6 ff ff       	jmp    80105ac0 <alltraps>

801063c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $117
801063c6:	6a 75                	push   $0x75
  jmp alltraps
801063c8:	e9 f3 f6 ff ff       	jmp    80105ac0 <alltraps>

801063cd <vector118>:
.globl vector118
vector118:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $118
801063cf:	6a 76                	push   $0x76
  jmp alltraps
801063d1:	e9 ea f6 ff ff       	jmp    80105ac0 <alltraps>

801063d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $119
801063d8:	6a 77                	push   $0x77
  jmp alltraps
801063da:	e9 e1 f6 ff ff       	jmp    80105ac0 <alltraps>

801063df <vector120>:
.globl vector120
vector120:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $120
801063e1:	6a 78                	push   $0x78
  jmp alltraps
801063e3:	e9 d8 f6 ff ff       	jmp    80105ac0 <alltraps>

801063e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $121
801063ea:	6a 79                	push   $0x79
  jmp alltraps
801063ec:	e9 cf f6 ff ff       	jmp    80105ac0 <alltraps>

801063f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $122
801063f3:	6a 7a                	push   $0x7a
  jmp alltraps
801063f5:	e9 c6 f6 ff ff       	jmp    80105ac0 <alltraps>

801063fa <vector123>:
.globl vector123
vector123:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $123
801063fc:	6a 7b                	push   $0x7b
  jmp alltraps
801063fe:	e9 bd f6 ff ff       	jmp    80105ac0 <alltraps>

80106403 <vector124>:
.globl vector124
vector124:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $124
80106405:	6a 7c                	push   $0x7c
  jmp alltraps
80106407:	e9 b4 f6 ff ff       	jmp    80105ac0 <alltraps>

8010640c <vector125>:
.globl vector125
vector125:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $125
8010640e:	6a 7d                	push   $0x7d
  jmp alltraps
80106410:	e9 ab f6 ff ff       	jmp    80105ac0 <alltraps>

80106415 <vector126>:
.globl vector126
vector126:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $126
80106417:	6a 7e                	push   $0x7e
  jmp alltraps
80106419:	e9 a2 f6 ff ff       	jmp    80105ac0 <alltraps>

8010641e <vector127>:
.globl vector127
vector127:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $127
80106420:	6a 7f                	push   $0x7f
  jmp alltraps
80106422:	e9 99 f6 ff ff       	jmp    80105ac0 <alltraps>

80106427 <vector128>:
.globl vector128
vector128:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $128
80106429:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010642e:	e9 8d f6 ff ff       	jmp    80105ac0 <alltraps>

80106433 <vector129>:
.globl vector129
vector129:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $129
80106435:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010643a:	e9 81 f6 ff ff       	jmp    80105ac0 <alltraps>

8010643f <vector130>:
.globl vector130
vector130:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $130
80106441:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106446:	e9 75 f6 ff ff       	jmp    80105ac0 <alltraps>

8010644b <vector131>:
.globl vector131
vector131:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $131
8010644d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106452:	e9 69 f6 ff ff       	jmp    80105ac0 <alltraps>

80106457 <vector132>:
.globl vector132
vector132:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $132
80106459:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010645e:	e9 5d f6 ff ff       	jmp    80105ac0 <alltraps>

80106463 <vector133>:
.globl vector133
vector133:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $133
80106465:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010646a:	e9 51 f6 ff ff       	jmp    80105ac0 <alltraps>

8010646f <vector134>:
.globl vector134
vector134:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $134
80106471:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106476:	e9 45 f6 ff ff       	jmp    80105ac0 <alltraps>

8010647b <vector135>:
.globl vector135
vector135:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $135
8010647d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106482:	e9 39 f6 ff ff       	jmp    80105ac0 <alltraps>

80106487 <vector136>:
.globl vector136
vector136:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $136
80106489:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010648e:	e9 2d f6 ff ff       	jmp    80105ac0 <alltraps>

80106493 <vector137>:
.globl vector137
vector137:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $137
80106495:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010649a:	e9 21 f6 ff ff       	jmp    80105ac0 <alltraps>

8010649f <vector138>:
.globl vector138
vector138:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $138
801064a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064a6:	e9 15 f6 ff ff       	jmp    80105ac0 <alltraps>

801064ab <vector139>:
.globl vector139
vector139:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $139
801064ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064b2:	e9 09 f6 ff ff       	jmp    80105ac0 <alltraps>

801064b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $140
801064b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064be:	e9 fd f5 ff ff       	jmp    80105ac0 <alltraps>

801064c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $141
801064c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ca:	e9 f1 f5 ff ff       	jmp    80105ac0 <alltraps>

801064cf <vector142>:
.globl vector142
vector142:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $142
801064d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064d6:	e9 e5 f5 ff ff       	jmp    80105ac0 <alltraps>

801064db <vector143>:
.globl vector143
vector143:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $143
801064dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064e2:	e9 d9 f5 ff ff       	jmp    80105ac0 <alltraps>

801064e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $144
801064e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064ee:	e9 cd f5 ff ff       	jmp    80105ac0 <alltraps>

801064f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $145
801064f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064fa:	e9 c1 f5 ff ff       	jmp    80105ac0 <alltraps>

801064ff <vector146>:
.globl vector146
vector146:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $146
80106501:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106506:	e9 b5 f5 ff ff       	jmp    80105ac0 <alltraps>

8010650b <vector147>:
.globl vector147
vector147:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $147
8010650d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106512:	e9 a9 f5 ff ff       	jmp    80105ac0 <alltraps>

80106517 <vector148>:
.globl vector148
vector148:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $148
80106519:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010651e:	e9 9d f5 ff ff       	jmp    80105ac0 <alltraps>

80106523 <vector149>:
.globl vector149
vector149:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $149
80106525:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010652a:	e9 91 f5 ff ff       	jmp    80105ac0 <alltraps>

8010652f <vector150>:
.globl vector150
vector150:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $150
80106531:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106536:	e9 85 f5 ff ff       	jmp    80105ac0 <alltraps>

8010653b <vector151>:
.globl vector151
vector151:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $151
8010653d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106542:	e9 79 f5 ff ff       	jmp    80105ac0 <alltraps>

80106547 <vector152>:
.globl vector152
vector152:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $152
80106549:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010654e:	e9 6d f5 ff ff       	jmp    80105ac0 <alltraps>

80106553 <vector153>:
.globl vector153
vector153:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $153
80106555:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010655a:	e9 61 f5 ff ff       	jmp    80105ac0 <alltraps>

8010655f <vector154>:
.globl vector154
vector154:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $154
80106561:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106566:	e9 55 f5 ff ff       	jmp    80105ac0 <alltraps>

8010656b <vector155>:
.globl vector155
vector155:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $155
8010656d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106572:	e9 49 f5 ff ff       	jmp    80105ac0 <alltraps>

80106577 <vector156>:
.globl vector156
vector156:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $156
80106579:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010657e:	e9 3d f5 ff ff       	jmp    80105ac0 <alltraps>

80106583 <vector157>:
.globl vector157
vector157:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $157
80106585:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010658a:	e9 31 f5 ff ff       	jmp    80105ac0 <alltraps>

8010658f <vector158>:
.globl vector158
vector158:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $158
80106591:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106596:	e9 25 f5 ff ff       	jmp    80105ac0 <alltraps>

8010659b <vector159>:
.globl vector159
vector159:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $159
8010659d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065a2:	e9 19 f5 ff ff       	jmp    80105ac0 <alltraps>

801065a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $160
801065a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ae:	e9 0d f5 ff ff       	jmp    80105ac0 <alltraps>

801065b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $161
801065b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065ba:	e9 01 f5 ff ff       	jmp    80105ac0 <alltraps>

801065bf <vector162>:
.globl vector162
vector162:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $162
801065c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065c6:	e9 f5 f4 ff ff       	jmp    80105ac0 <alltraps>

801065cb <vector163>:
.globl vector163
vector163:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $163
801065cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065d2:	e9 e9 f4 ff ff       	jmp    80105ac0 <alltraps>

801065d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $164
801065d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065de:	e9 dd f4 ff ff       	jmp    80105ac0 <alltraps>

801065e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $165
801065e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ea:	e9 d1 f4 ff ff       	jmp    80105ac0 <alltraps>

801065ef <vector166>:
.globl vector166
vector166:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $166
801065f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065f6:	e9 c5 f4 ff ff       	jmp    80105ac0 <alltraps>

801065fb <vector167>:
.globl vector167
vector167:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $167
801065fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106602:	e9 b9 f4 ff ff       	jmp    80105ac0 <alltraps>

80106607 <vector168>:
.globl vector168
vector168:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $168
80106609:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010660e:	e9 ad f4 ff ff       	jmp    80105ac0 <alltraps>

80106613 <vector169>:
.globl vector169
vector169:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $169
80106615:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010661a:	e9 a1 f4 ff ff       	jmp    80105ac0 <alltraps>

8010661f <vector170>:
.globl vector170
vector170:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $170
80106621:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106626:	e9 95 f4 ff ff       	jmp    80105ac0 <alltraps>

8010662b <vector171>:
.globl vector171
vector171:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $171
8010662d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106632:	e9 89 f4 ff ff       	jmp    80105ac0 <alltraps>

80106637 <vector172>:
.globl vector172
vector172:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $172
80106639:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010663e:	e9 7d f4 ff ff       	jmp    80105ac0 <alltraps>

80106643 <vector173>:
.globl vector173
vector173:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $173
80106645:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010664a:	e9 71 f4 ff ff       	jmp    80105ac0 <alltraps>

8010664f <vector174>:
.globl vector174
vector174:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $174
80106651:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106656:	e9 65 f4 ff ff       	jmp    80105ac0 <alltraps>

8010665b <vector175>:
.globl vector175
vector175:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $175
8010665d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106662:	e9 59 f4 ff ff       	jmp    80105ac0 <alltraps>

80106667 <vector176>:
.globl vector176
vector176:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $176
80106669:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010666e:	e9 4d f4 ff ff       	jmp    80105ac0 <alltraps>

80106673 <vector177>:
.globl vector177
vector177:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $177
80106675:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010667a:	e9 41 f4 ff ff       	jmp    80105ac0 <alltraps>

8010667f <vector178>:
.globl vector178
vector178:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $178
80106681:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106686:	e9 35 f4 ff ff       	jmp    80105ac0 <alltraps>

8010668b <vector179>:
.globl vector179
vector179:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $179
8010668d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106692:	e9 29 f4 ff ff       	jmp    80105ac0 <alltraps>

80106697 <vector180>:
.globl vector180
vector180:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $180
80106699:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010669e:	e9 1d f4 ff ff       	jmp    80105ac0 <alltraps>

801066a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $181
801066a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066aa:	e9 11 f4 ff ff       	jmp    80105ac0 <alltraps>

801066af <vector182>:
.globl vector182
vector182:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $182
801066b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066b6:	e9 05 f4 ff ff       	jmp    80105ac0 <alltraps>

801066bb <vector183>:
.globl vector183
vector183:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $183
801066bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066c2:	e9 f9 f3 ff ff       	jmp    80105ac0 <alltraps>

801066c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $184
801066c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ce:	e9 ed f3 ff ff       	jmp    80105ac0 <alltraps>

801066d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $185
801066d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066da:	e9 e1 f3 ff ff       	jmp    80105ac0 <alltraps>

801066df <vector186>:
.globl vector186
vector186:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $186
801066e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066e6:	e9 d5 f3 ff ff       	jmp    80105ac0 <alltraps>

801066eb <vector187>:
.globl vector187
vector187:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $187
801066ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066f2:	e9 c9 f3 ff ff       	jmp    80105ac0 <alltraps>

801066f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $188
801066f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066fe:	e9 bd f3 ff ff       	jmp    80105ac0 <alltraps>

80106703 <vector189>:
.globl vector189
vector189:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $189
80106705:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010670a:	e9 b1 f3 ff ff       	jmp    80105ac0 <alltraps>

8010670f <vector190>:
.globl vector190
vector190:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $190
80106711:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106716:	e9 a5 f3 ff ff       	jmp    80105ac0 <alltraps>

8010671b <vector191>:
.globl vector191
vector191:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $191
8010671d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106722:	e9 99 f3 ff ff       	jmp    80105ac0 <alltraps>

80106727 <vector192>:
.globl vector192
vector192:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $192
80106729:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010672e:	e9 8d f3 ff ff       	jmp    80105ac0 <alltraps>

80106733 <vector193>:
.globl vector193
vector193:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $193
80106735:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010673a:	e9 81 f3 ff ff       	jmp    80105ac0 <alltraps>

8010673f <vector194>:
.globl vector194
vector194:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $194
80106741:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106746:	e9 75 f3 ff ff       	jmp    80105ac0 <alltraps>

8010674b <vector195>:
.globl vector195
vector195:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $195
8010674d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106752:	e9 69 f3 ff ff       	jmp    80105ac0 <alltraps>

80106757 <vector196>:
.globl vector196
vector196:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $196
80106759:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010675e:	e9 5d f3 ff ff       	jmp    80105ac0 <alltraps>

80106763 <vector197>:
.globl vector197
vector197:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $197
80106765:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010676a:	e9 51 f3 ff ff       	jmp    80105ac0 <alltraps>

8010676f <vector198>:
.globl vector198
vector198:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $198
80106771:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106776:	e9 45 f3 ff ff       	jmp    80105ac0 <alltraps>

8010677b <vector199>:
.globl vector199
vector199:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $199
8010677d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106782:	e9 39 f3 ff ff       	jmp    80105ac0 <alltraps>

80106787 <vector200>:
.globl vector200
vector200:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $200
80106789:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010678e:	e9 2d f3 ff ff       	jmp    80105ac0 <alltraps>

80106793 <vector201>:
.globl vector201
vector201:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $201
80106795:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010679a:	e9 21 f3 ff ff       	jmp    80105ac0 <alltraps>

8010679f <vector202>:
.globl vector202
vector202:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $202
801067a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067a6:	e9 15 f3 ff ff       	jmp    80105ac0 <alltraps>

801067ab <vector203>:
.globl vector203
vector203:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $203
801067ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067b2:	e9 09 f3 ff ff       	jmp    80105ac0 <alltraps>

801067b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $204
801067b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067be:	e9 fd f2 ff ff       	jmp    80105ac0 <alltraps>

801067c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $205
801067c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ca:	e9 f1 f2 ff ff       	jmp    80105ac0 <alltraps>

801067cf <vector206>:
.globl vector206
vector206:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $206
801067d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067d6:	e9 e5 f2 ff ff       	jmp    80105ac0 <alltraps>

801067db <vector207>:
.globl vector207
vector207:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $207
801067dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067e2:	e9 d9 f2 ff ff       	jmp    80105ac0 <alltraps>

801067e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $208
801067e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067ee:	e9 cd f2 ff ff       	jmp    80105ac0 <alltraps>

801067f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $209
801067f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067fa:	e9 c1 f2 ff ff       	jmp    80105ac0 <alltraps>

801067ff <vector210>:
.globl vector210
vector210:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $210
80106801:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106806:	e9 b5 f2 ff ff       	jmp    80105ac0 <alltraps>

8010680b <vector211>:
.globl vector211
vector211:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $211
8010680d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106812:	e9 a9 f2 ff ff       	jmp    80105ac0 <alltraps>

80106817 <vector212>:
.globl vector212
vector212:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $212
80106819:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010681e:	e9 9d f2 ff ff       	jmp    80105ac0 <alltraps>

80106823 <vector213>:
.globl vector213
vector213:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $213
80106825:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010682a:	e9 91 f2 ff ff       	jmp    80105ac0 <alltraps>

8010682f <vector214>:
.globl vector214
vector214:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $214
80106831:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106836:	e9 85 f2 ff ff       	jmp    80105ac0 <alltraps>

8010683b <vector215>:
.globl vector215
vector215:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $215
8010683d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106842:	e9 79 f2 ff ff       	jmp    80105ac0 <alltraps>

80106847 <vector216>:
.globl vector216
vector216:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $216
80106849:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010684e:	e9 6d f2 ff ff       	jmp    80105ac0 <alltraps>

80106853 <vector217>:
.globl vector217
vector217:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $217
80106855:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010685a:	e9 61 f2 ff ff       	jmp    80105ac0 <alltraps>

8010685f <vector218>:
.globl vector218
vector218:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $218
80106861:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106866:	e9 55 f2 ff ff       	jmp    80105ac0 <alltraps>

8010686b <vector219>:
.globl vector219
vector219:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $219
8010686d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106872:	e9 49 f2 ff ff       	jmp    80105ac0 <alltraps>

80106877 <vector220>:
.globl vector220
vector220:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $220
80106879:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010687e:	e9 3d f2 ff ff       	jmp    80105ac0 <alltraps>

80106883 <vector221>:
.globl vector221
vector221:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $221
80106885:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010688a:	e9 31 f2 ff ff       	jmp    80105ac0 <alltraps>

8010688f <vector222>:
.globl vector222
vector222:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $222
80106891:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106896:	e9 25 f2 ff ff       	jmp    80105ac0 <alltraps>

8010689b <vector223>:
.globl vector223
vector223:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $223
8010689d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068a2:	e9 19 f2 ff ff       	jmp    80105ac0 <alltraps>

801068a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $224
801068a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ae:	e9 0d f2 ff ff       	jmp    80105ac0 <alltraps>

801068b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $225
801068b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068ba:	e9 01 f2 ff ff       	jmp    80105ac0 <alltraps>

801068bf <vector226>:
.globl vector226
vector226:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $226
801068c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068c6:	e9 f5 f1 ff ff       	jmp    80105ac0 <alltraps>

801068cb <vector227>:
.globl vector227
vector227:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $227
801068cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068d2:	e9 e9 f1 ff ff       	jmp    80105ac0 <alltraps>

801068d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $228
801068d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068de:	e9 dd f1 ff ff       	jmp    80105ac0 <alltraps>

801068e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $229
801068e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ea:	e9 d1 f1 ff ff       	jmp    80105ac0 <alltraps>

801068ef <vector230>:
.globl vector230
vector230:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $230
801068f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068f6:	e9 c5 f1 ff ff       	jmp    80105ac0 <alltraps>

801068fb <vector231>:
.globl vector231
vector231:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $231
801068fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106902:	e9 b9 f1 ff ff       	jmp    80105ac0 <alltraps>

80106907 <vector232>:
.globl vector232
vector232:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $232
80106909:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010690e:	e9 ad f1 ff ff       	jmp    80105ac0 <alltraps>

80106913 <vector233>:
.globl vector233
vector233:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $233
80106915:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010691a:	e9 a1 f1 ff ff       	jmp    80105ac0 <alltraps>

8010691f <vector234>:
.globl vector234
vector234:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $234
80106921:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106926:	e9 95 f1 ff ff       	jmp    80105ac0 <alltraps>

8010692b <vector235>:
.globl vector235
vector235:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $235
8010692d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106932:	e9 89 f1 ff ff       	jmp    80105ac0 <alltraps>

80106937 <vector236>:
.globl vector236
vector236:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $236
80106939:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010693e:	e9 7d f1 ff ff       	jmp    80105ac0 <alltraps>

80106943 <vector237>:
.globl vector237
vector237:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $237
80106945:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010694a:	e9 71 f1 ff ff       	jmp    80105ac0 <alltraps>

8010694f <vector238>:
.globl vector238
vector238:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $238
80106951:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106956:	e9 65 f1 ff ff       	jmp    80105ac0 <alltraps>

8010695b <vector239>:
.globl vector239
vector239:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $239
8010695d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106962:	e9 59 f1 ff ff       	jmp    80105ac0 <alltraps>

80106967 <vector240>:
.globl vector240
vector240:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $240
80106969:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010696e:	e9 4d f1 ff ff       	jmp    80105ac0 <alltraps>

80106973 <vector241>:
.globl vector241
vector241:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $241
80106975:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010697a:	e9 41 f1 ff ff       	jmp    80105ac0 <alltraps>

8010697f <vector242>:
.globl vector242
vector242:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $242
80106981:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106986:	e9 35 f1 ff ff       	jmp    80105ac0 <alltraps>

8010698b <vector243>:
.globl vector243
vector243:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $243
8010698d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106992:	e9 29 f1 ff ff       	jmp    80105ac0 <alltraps>

80106997 <vector244>:
.globl vector244
vector244:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $244
80106999:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010699e:	e9 1d f1 ff ff       	jmp    80105ac0 <alltraps>

801069a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $245
801069a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069aa:	e9 11 f1 ff ff       	jmp    80105ac0 <alltraps>

801069af <vector246>:
.globl vector246
vector246:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $246
801069b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069b6:	e9 05 f1 ff ff       	jmp    80105ac0 <alltraps>

801069bb <vector247>:
.globl vector247
vector247:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $247
801069bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069c2:	e9 f9 f0 ff ff       	jmp    80105ac0 <alltraps>

801069c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $248
801069c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ce:	e9 ed f0 ff ff       	jmp    80105ac0 <alltraps>

801069d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $249
801069d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069da:	e9 e1 f0 ff ff       	jmp    80105ac0 <alltraps>

801069df <vector250>:
.globl vector250
vector250:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $250
801069e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069e6:	e9 d5 f0 ff ff       	jmp    80105ac0 <alltraps>

801069eb <vector251>:
.globl vector251
vector251:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $251
801069ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069f2:	e9 c9 f0 ff ff       	jmp    80105ac0 <alltraps>

801069f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $252
801069f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069fe:	e9 bd f0 ff ff       	jmp    80105ac0 <alltraps>

80106a03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $253
80106a05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a0a:	e9 b1 f0 ff ff       	jmp    80105ac0 <alltraps>

80106a0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $254
80106a11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a16:	e9 a5 f0 ff ff       	jmp    80105ac0 <alltraps>

80106a1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $255
80106a1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a22:	e9 99 f0 ff ff       	jmp    80105ac0 <alltraps>
80106a27:	66 90                	xchg   %ax,%ax
80106a29:	66 90                	xchg   %ax,%ax
80106a2b:	66 90                	xchg   %ax,%ax
80106a2d:	66 90                	xchg   %ax,%ax
80106a2f:	90                   	nop

80106a30 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a36:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a3c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a42:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106a45:	39 d3                	cmp    %edx,%ebx
80106a47:	73 56                	jae    80106a9f <deallocuvm.part.0+0x6f>
80106a49:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106a4c:	89 c6                	mov    %eax,%esi
80106a4e:	89 d7                	mov    %edx,%edi
80106a50:	eb 12                	jmp    80106a64 <deallocuvm.part.0+0x34>
80106a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a58:	83 c2 01             	add    $0x1,%edx
80106a5b:	89 d3                	mov    %edx,%ebx
80106a5d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a60:	39 fb                	cmp    %edi,%ebx
80106a62:	73 38                	jae    80106a9c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106a64:	89 da                	mov    %ebx,%edx
80106a66:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106a69:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106a6c:	a8 01                	test   $0x1,%al
80106a6e:	74 e8                	je     80106a58 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106a70:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a77:	c1 e9 0a             	shr    $0xa,%ecx
80106a7a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106a80:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106a87:	85 c0                	test   %eax,%eax
80106a89:	74 cd                	je     80106a58 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106a8b:	8b 10                	mov    (%eax),%edx
80106a8d:	f6 c2 01             	test   $0x1,%dl
80106a90:	75 1e                	jne    80106ab0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106a92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a98:	39 fb                	cmp    %edi,%ebx
80106a9a:	72 c8                	jb     80106a64 <deallocuvm.part.0+0x34>
80106a9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aa2:	89 c8                	mov    %ecx,%eax
80106aa4:	5b                   	pop    %ebx
80106aa5:	5e                   	pop    %esi
80106aa6:	5f                   	pop    %edi
80106aa7:	5d                   	pop    %ebp
80106aa8:	c3                   	ret
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106ab0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ab6:	74 26                	je     80106ade <deallocuvm.part.0+0xae>
      kfree(v);
80106ab8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106abb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ac4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106aca:	52                   	push   %edx
80106acb:	e8 d0 ba ff ff       	call   801025a0 <kfree>
      *pte = 0;
80106ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106ad3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106ad6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106adc:	eb 82                	jmp    80106a60 <deallocuvm.part.0+0x30>
        panic("kfree");
80106ade:	83 ec 0c             	sub    $0xc,%esp
80106ae1:	68 d3 75 10 80       	push   $0x801075d3
80106ae6:	e8 95 98 ff ff       	call   80100380 <panic>
80106aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106af0 <mappages>:
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106af6:	89 d3                	mov    %edx,%ebx
80106af8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106afe:	83 ec 1c             	sub    $0x1c,%esp
80106b01:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b10:	8b 45 08             	mov    0x8(%ebp),%eax
80106b13:	29 d8                	sub    %ebx,%eax
80106b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b18:	eb 3f                	jmp    80106b59 <mappages+0x69>
80106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106b20:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b27:	c1 ea 0a             	shr    $0xa,%edx
80106b2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b37:	85 c0                	test   %eax,%eax
80106b39:	74 75                	je     80106bb0 <mappages+0xc0>
    if(*pte & PTE_P)
80106b3b:	f6 00 01             	testb  $0x1,(%eax)
80106b3e:	0f 85 86 00 00 00    	jne    80106bca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b44:	0b 75 0c             	or     0xc(%ebp),%esi
80106b47:	83 ce 01             	or     $0x1,%esi
80106b4a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b4f:	39 c3                	cmp    %eax,%ebx
80106b51:	74 6d                	je     80106bc0 <mappages+0xd0>
    a += PGSIZE;
80106b53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b5c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b5f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106b62:	89 d8                	mov    %ebx,%eax
80106b64:	c1 e8 16             	shr    $0x16,%eax
80106b67:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b6a:	8b 07                	mov    (%edi),%eax
80106b6c:	a8 01                	test   $0x1,%al
80106b6e:	75 b0                	jne    80106b20 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b70:	e8 eb bb ff ff       	call   80102760 <kalloc>
80106b75:	85 c0                	test   %eax,%eax
80106b77:	74 37                	je     80106bb0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b79:	83 ec 04             	sub    $0x4,%esp
80106b7c:	68 00 10 00 00       	push   $0x1000
80106b81:	6a 00                	push   $0x0
80106b83:	50                   	push   %eax
80106b84:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b87:	e8 74 dc ff ff       	call   80104800 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b8c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b8f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b92:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b98:	83 c8 07             	or     $0x7,%eax
80106b9b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b9d:	89 d8                	mov    %ebx,%eax
80106b9f:	c1 e8 0a             	shr    $0xa,%eax
80106ba2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ba7:	01 d0                	add    %edx,%eax
80106ba9:	eb 90                	jmp    80106b3b <mappages+0x4b>
80106bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bb8:	5b                   	pop    %ebx
80106bb9:	5e                   	pop    %esi
80106bba:	5f                   	pop    %edi
80106bbb:	5d                   	pop    %ebp
80106bbc:	c3                   	ret
80106bbd:	8d 76 00             	lea    0x0(%esi),%esi
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bc3:	31 c0                	xor    %eax,%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret
      panic("remap");
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	68 14 78 10 80       	push   $0x80107814
80106bd2:	e8 a9 97 ff ff       	call   80100380 <panic>
80106bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bde:	00 
80106bdf:	90                   	nop

80106be0 <seginit>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106be6:	e8 a5 ce ff ff       	call   80103a90 <cpuid>
  pd[0] = size-1;
80106beb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bf0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bf6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106bfa:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106c01:	ff 00 00 
80106c04:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106c0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c0e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106c15:	ff 00 00 
80106c18:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106c1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c22:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106c29:	ff 00 00 
80106c2c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106c33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c36:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106c3d:	ff 00 00 
80106c40:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106c47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c4a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106c4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c53:	c1 e8 10             	shr    $0x10,%eax
80106c56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c5d:	0f 01 10             	lgdtl  (%eax)
}
80106c60:	c9                   	leave
80106c61:	c3                   	ret
80106c62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c69:	00 
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c70:	a1 c4 45 11 80       	mov    0x801145c4,%eax
80106c75:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c7a:	0f 22 d8             	mov    %eax,%cr3
}
80106c7d:	c3                   	ret
80106c7e:	66 90                	xchg   %ax,%ax

80106c80 <switchuvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c8c:	85 f6                	test   %esi,%esi
80106c8e:	0f 84 cb 00 00 00    	je     80106d5f <switchuvm+0xdf>
  if(p->kstack == 0)
80106c94:	8b 46 08             	mov    0x8(%esi),%eax
80106c97:	85 c0                	test   %eax,%eax
80106c99:	0f 84 da 00 00 00    	je     80106d79 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c9f:	8b 46 04             	mov    0x4(%esi),%eax
80106ca2:	85 c0                	test   %eax,%eax
80106ca4:	0f 84 c2 00 00 00    	je     80106d6c <switchuvm+0xec>
  pushcli();
80106caa:	e8 01 d9 ff ff       	call   801045b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106caf:	e8 7c cd ff ff       	call   80103a30 <mycpu>
80106cb4:	89 c3                	mov    %eax,%ebx
80106cb6:	e8 75 cd ff ff       	call   80103a30 <mycpu>
80106cbb:	89 c7                	mov    %eax,%edi
80106cbd:	e8 6e cd ff ff       	call   80103a30 <mycpu>
80106cc2:	83 c7 08             	add    $0x8,%edi
80106cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cc8:	e8 63 cd ff ff       	call   80103a30 <mycpu>
80106ccd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cd0:	ba 67 00 00 00       	mov    $0x67,%edx
80106cd5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cdc:	83 c0 08             	add    $0x8,%eax
80106cdf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ce6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ceb:	83 c1 08             	add    $0x8,%ecx
80106cee:	c1 e8 18             	shr    $0x18,%eax
80106cf1:	c1 e9 10             	shr    $0x10,%ecx
80106cf4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cfa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d00:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d05:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d11:	e8 1a cd ff ff       	call   80103a30 <mycpu>
80106d16:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d1d:	e8 0e cd ff ff       	call   80103a30 <mycpu>
80106d22:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d26:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d2f:	e8 fc cc ff ff       	call   80103a30 <mycpu>
80106d34:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d37:	e8 f4 cc ff ff       	call   80103a30 <mycpu>
80106d3c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d40:	b8 28 00 00 00       	mov    $0x28,%eax
80106d45:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d48:	8b 46 04             	mov    0x4(%esi),%eax
80106d4b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d50:	0f 22 d8             	mov    %eax,%cr3
}
80106d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d56:	5b                   	pop    %ebx
80106d57:	5e                   	pop    %esi
80106d58:	5f                   	pop    %edi
80106d59:	5d                   	pop    %ebp
  popcli();
80106d5a:	e9 a1 d8 ff ff       	jmp    80104600 <popcli>
    panic("switchuvm: no process");
80106d5f:	83 ec 0c             	sub    $0xc,%esp
80106d62:	68 1a 78 10 80       	push   $0x8010781a
80106d67:	e8 14 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d6c:	83 ec 0c             	sub    $0xc,%esp
80106d6f:	68 45 78 10 80       	push   $0x80107845
80106d74:	e8 07 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d79:	83 ec 0c             	sub    $0xc,%esp
80106d7c:	68 30 78 10 80       	push   $0x80107830
80106d81:	e8 fa 95 ff ff       	call   80100380 <panic>
80106d86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d8d:	00 
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <inituvm>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 1c             	sub    $0x1c,%esp
80106d99:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106da2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106da5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dab:	77 49                	ja     80106df6 <inituvm+0x66>
  mem = kalloc();
80106dad:	e8 ae b9 ff ff       	call   80102760 <kalloc>
  memset(mem, 0, PGSIZE);
80106db2:	83 ec 04             	sub    $0x4,%esp
80106db5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106dbc:	6a 00                	push   $0x0
80106dbe:	50                   	push   %eax
80106dbf:	e8 3c da ff ff       	call   80104800 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106dc4:	58                   	pop    %eax
80106dc5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dcb:	5a                   	pop    %edx
80106dcc:	6a 06                	push   $0x6
80106dce:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dd3:	31 d2                	xor    %edx,%edx
80106dd5:	50                   	push   %eax
80106dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dd9:	e8 12 fd ff ff       	call   80106af0 <mappages>
  memmove(mem, init, sz);
80106dde:	83 c4 10             	add    $0x10,%esp
80106de1:	89 75 10             	mov    %esi,0x10(%ebp)
80106de4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106de7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ded:	5b                   	pop    %ebx
80106dee:	5e                   	pop    %esi
80106def:	5f                   	pop    %edi
80106df0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106df1:	e9 9a da ff ff       	jmp    80104890 <memmove>
    panic("inituvm: more than a page");
80106df6:	83 ec 0c             	sub    $0xc,%esp
80106df9:	68 59 78 10 80       	push   $0x80107859
80106dfe:	e8 7d 95 ff ff       	call   80100380 <panic>
80106e03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e0a:	00 
80106e0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106e10 <loaduvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e19:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106e1c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106e1f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106e25:	0f 85 a2 00 00 00    	jne    80106ecd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106e2b:	85 ff                	test   %edi,%edi
80106e2d:	74 7d                	je     80106eac <loaduvm+0x9c>
80106e2f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106e33:	8b 55 08             	mov    0x8(%ebp),%edx
80106e36:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106e38:	89 c1                	mov    %eax,%ecx
80106e3a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106e3d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106e40:	f6 c1 01             	test   $0x1,%cl
80106e43:	75 13                	jne    80106e58 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106e45:	83 ec 0c             	sub    $0xc,%esp
80106e48:	68 73 78 10 80       	push   $0x80107873
80106e4d:	e8 2e 95 ff ff       	call   80100380 <panic>
80106e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e58:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e5b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106e61:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e66:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e6d:	85 c9                	test   %ecx,%ecx
80106e6f:	74 d4                	je     80106e45 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106e71:	89 fb                	mov    %edi,%ebx
80106e73:	b8 00 10 00 00       	mov    $0x1000,%eax
80106e78:	29 f3                	sub    %esi,%ebx
80106e7a:	39 c3                	cmp    %eax,%ebx
80106e7c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e7f:	53                   	push   %ebx
80106e80:	8b 45 14             	mov    0x14(%ebp),%eax
80106e83:	01 f0                	add    %esi,%eax
80106e85:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106e86:	8b 01                	mov    (%ecx),%eax
80106e88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e8d:	05 00 00 00 80       	add    $0x80000000,%eax
80106e92:	50                   	push   %eax
80106e93:	ff 75 10             	push   0x10(%ebp)
80106e96:	e8 15 ad ff ff       	call   80101bb0 <readi>
80106e9b:	83 c4 10             	add    $0x10,%esp
80106e9e:	39 d8                	cmp    %ebx,%eax
80106ea0:	75 1e                	jne    80106ec0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106ea2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ea8:	39 fe                	cmp    %edi,%esi
80106eaa:	72 84                	jb     80106e30 <loaduvm+0x20>
}
80106eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106eaf:	31 c0                	xor    %eax,%eax
}
80106eb1:	5b                   	pop    %ebx
80106eb2:	5e                   	pop    %esi
80106eb3:	5f                   	pop    %edi
80106eb4:	5d                   	pop    %ebp
80106eb5:	c3                   	ret
80106eb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ebd:	00 
80106ebe:	66 90                	xchg   %ax,%ax
80106ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ec8:	5b                   	pop    %ebx
80106ec9:	5e                   	pop    %esi
80106eca:	5f                   	pop    %edi
80106ecb:	5d                   	pop    %ebp
80106ecc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106ecd:	83 ec 0c             	sub    $0xc,%esp
80106ed0:	68 10 7b 10 80       	push   $0x80107b10
80106ed5:	e8 a6 94 ff ff       	call   80100380 <panic>
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ee0 <allocuvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 1c             	sub    $0x1c,%esp
80106ee9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106eec:	85 f6                	test   %esi,%esi
80106eee:	0f 88 98 00 00 00    	js     80106f8c <allocuvm+0xac>
80106ef4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106ef6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106ef9:	0f 82 a1 00 00 00    	jb     80106fa0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f02:	05 ff 0f 00 00       	add    $0xfff,%eax
80106f07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f0c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106f0e:	39 f0                	cmp    %esi,%eax
80106f10:	0f 83 8d 00 00 00    	jae    80106fa3 <allocuvm+0xc3>
80106f16:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106f19:	eb 44                	jmp    80106f5f <allocuvm+0x7f>
80106f1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f20:	83 ec 04             	sub    $0x4,%esp
80106f23:	68 00 10 00 00       	push   $0x1000
80106f28:	6a 00                	push   $0x0
80106f2a:	50                   	push   %eax
80106f2b:	e8 d0 d8 ff ff       	call   80104800 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f30:	58                   	pop    %eax
80106f31:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f37:	5a                   	pop    %edx
80106f38:	6a 06                	push   $0x6
80106f3a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f3f:	89 fa                	mov    %edi,%edx
80106f41:	50                   	push   %eax
80106f42:	8b 45 08             	mov    0x8(%ebp),%eax
80106f45:	e8 a6 fb ff ff       	call   80106af0 <mappages>
80106f4a:	83 c4 10             	add    $0x10,%esp
80106f4d:	85 c0                	test   %eax,%eax
80106f4f:	78 5f                	js     80106fb0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106f51:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f57:	39 f7                	cmp    %esi,%edi
80106f59:	0f 83 89 00 00 00    	jae    80106fe8 <allocuvm+0x108>
    mem = kalloc();
80106f5f:	e8 fc b7 ff ff       	call   80102760 <kalloc>
80106f64:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f66:	85 c0                	test   %eax,%eax
80106f68:	75 b6                	jne    80106f20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f6a:	83 ec 0c             	sub    $0xc,%esp
80106f6d:	68 91 78 10 80       	push   $0x80107891
80106f72:	e8 39 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f77:	83 c4 10             	add    $0x10,%esp
80106f7a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f7d:	74 0d                	je     80106f8c <allocuvm+0xac>
80106f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f82:	8b 45 08             	mov    0x8(%ebp),%eax
80106f85:	89 f2                	mov    %esi,%edx
80106f87:	e8 a4 fa ff ff       	call   80106a30 <deallocuvm.part.0>
    return 0;
80106f8c:	31 d2                	xor    %edx,%edx
}
80106f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f91:	89 d0                	mov    %edx,%eax
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5f                   	pop    %edi
80106f96:	5d                   	pop    %ebp
80106f97:	c3                   	ret
80106f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f9f:	00 
    return oldsz;
80106fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	89 d0                	mov    %edx,%eax
80106fa8:	5b                   	pop    %ebx
80106fa9:	5e                   	pop    %esi
80106faa:	5f                   	pop    %edi
80106fab:	5d                   	pop    %ebp
80106fac:	c3                   	ret
80106fad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fb0:	83 ec 0c             	sub    $0xc,%esp
80106fb3:	68 a9 78 10 80       	push   $0x801078a9
80106fb8:	e8 f3 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106fbd:	83 c4 10             	add    $0x10,%esp
80106fc0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106fc3:	74 0d                	je     80106fd2 <allocuvm+0xf2>
80106fc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcb:	89 f2                	mov    %esi,%edx
80106fcd:	e8 5e fa ff ff       	call   80106a30 <deallocuvm.part.0>
      kfree(mem);
80106fd2:	83 ec 0c             	sub    $0xc,%esp
80106fd5:	53                   	push   %ebx
80106fd6:	e8 c5 b5 ff ff       	call   801025a0 <kfree>
      return 0;
80106fdb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106fde:	31 d2                	xor    %edx,%edx
80106fe0:	eb ac                	jmp    80106f8e <allocuvm+0xae>
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fe8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fee:	5b                   	pop    %ebx
80106fef:	5e                   	pop    %esi
80106ff0:	89 d0                	mov    %edx,%eax
80106ff2:	5f                   	pop    %edi
80106ff3:	5d                   	pop    %ebp
80106ff4:	c3                   	ret
80106ff5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ffc:	00 
80106ffd:	8d 76 00             	lea    0x0(%esi),%esi

80107000 <deallocuvm>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	8b 55 0c             	mov    0xc(%ebp),%edx
80107006:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107009:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010700c:	39 d1                	cmp    %edx,%ecx
8010700e:	73 10                	jae    80107020 <deallocuvm+0x20>
}
80107010:	5d                   	pop    %ebp
80107011:	e9 1a fa ff ff       	jmp    80106a30 <deallocuvm.part.0>
80107016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010701d:	00 
8010701e:	66 90                	xchg   %ax,%ax
80107020:	89 d0                	mov    %edx,%eax
80107022:	5d                   	pop    %ebp
80107023:	c3                   	ret
80107024:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010702b:	00 
8010702c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107030 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010703c:	85 f6                	test   %esi,%esi
8010703e:	74 59                	je     80107099 <freevm+0x69>
  if(newsz >= oldsz)
80107040:	31 c9                	xor    %ecx,%ecx
80107042:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107047:	89 f0                	mov    %esi,%eax
80107049:	89 f3                	mov    %esi,%ebx
8010704b:	e8 e0 f9 ff ff       	call   80106a30 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107050:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107056:	eb 0f                	jmp    80107067 <freevm+0x37>
80107058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010705f:	00 
80107060:	83 c3 04             	add    $0x4,%ebx
80107063:	39 fb                	cmp    %edi,%ebx
80107065:	74 23                	je     8010708a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107067:	8b 03                	mov    (%ebx),%eax
80107069:	a8 01                	test   $0x1,%al
8010706b:	74 f3                	je     80107060 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010706d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107072:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107075:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107078:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010707d:	50                   	push   %eax
8010707e:	e8 1d b5 ff ff       	call   801025a0 <kfree>
80107083:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107086:	39 fb                	cmp    %edi,%ebx
80107088:	75 dd                	jne    80107067 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010708a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010708d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107090:	5b                   	pop    %ebx
80107091:	5e                   	pop    %esi
80107092:	5f                   	pop    %edi
80107093:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107094:	e9 07 b5 ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
80107099:	83 ec 0c             	sub    $0xc,%esp
8010709c:	68 c5 78 10 80       	push   $0x801078c5
801070a1:	e8 da 92 ff ff       	call   80100380 <panic>
801070a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ad:	00 
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <setupkvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	56                   	push   %esi
801070b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070b5:	e8 a6 b6 ff ff       	call   80102760 <kalloc>
801070ba:	85 c0                	test   %eax,%eax
801070bc:	74 5e                	je     8010711c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801070be:	83 ec 04             	sub    $0x4,%esp
801070c1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070c3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070c8:	68 00 10 00 00       	push   $0x1000
801070cd:	6a 00                	push   $0x0
801070cf:	50                   	push   %eax
801070d0:	e8 2b d7 ff ff       	call   80104800 <memset>
801070d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070db:	83 ec 08             	sub    $0x8,%esp
801070de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070e1:	8b 13                	mov    (%ebx),%edx
801070e3:	ff 73 0c             	push   0xc(%ebx)
801070e6:	50                   	push   %eax
801070e7:	29 c1                	sub    %eax,%ecx
801070e9:	89 f0                	mov    %esi,%eax
801070eb:	e8 00 fa ff ff       	call   80106af0 <mappages>
801070f0:	83 c4 10             	add    $0x10,%esp
801070f3:	85 c0                	test   %eax,%eax
801070f5:	78 19                	js     80107110 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070f7:	83 c3 10             	add    $0x10,%ebx
801070fa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107100:	75 d6                	jne    801070d8 <setupkvm+0x28>
}
80107102:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107105:	89 f0                	mov    %esi,%eax
80107107:	5b                   	pop    %ebx
80107108:	5e                   	pop    %esi
80107109:	5d                   	pop    %ebp
8010710a:	c3                   	ret
8010710b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	56                   	push   %esi
80107114:	e8 17 ff ff ff       	call   80107030 <freevm>
      return 0;
80107119:	83 c4 10             	add    $0x10,%esp
}
8010711c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010711f:	31 f6                	xor    %esi,%esi
}
80107121:	89 f0                	mov    %esi,%eax
80107123:	5b                   	pop    %ebx
80107124:	5e                   	pop    %esi
80107125:	5d                   	pop    %ebp
80107126:	c3                   	ret
80107127:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010712e:	00 
8010712f:	90                   	nop

80107130 <kvmalloc>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107136:	e8 75 ff ff ff       	call   801070b0 <setupkvm>
8010713b:	a3 c4 45 11 80       	mov    %eax,0x801145c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107140:	05 00 00 00 80       	add    $0x80000000,%eax
80107145:	0f 22 d8             	mov    %eax,%cr3
}
80107148:	c9                   	leave
80107149:	c3                   	ret
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107150 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	83 ec 08             	sub    $0x8,%esp
80107156:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107159:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010715c:	89 c1                	mov    %eax,%ecx
8010715e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107161:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107164:	f6 c2 01             	test   $0x1,%dl
80107167:	75 17                	jne    80107180 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	68 d6 78 10 80       	push   $0x801078d6
80107171:	e8 0a 92 ff ff       	call   80100380 <panic>
80107176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010717d:	00 
8010717e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107180:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107183:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107189:	25 fc 0f 00 00       	and    $0xffc,%eax
8010718e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107195:	85 c0                	test   %eax,%eax
80107197:	74 d0                	je     80107169 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107199:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010719c:	c9                   	leave
8010719d:	c3                   	ret
8010719e:	66 90                	xchg   %ax,%ax

801071a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071a9:	e8 02 ff ff ff       	call   801070b0 <setupkvm>
801071ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071b1:	85 c0                	test   %eax,%eax
801071b3:	0f 84 e9 00 00 00    	je     801072a2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071bc:	85 c9                	test   %ecx,%ecx
801071be:	0f 84 b2 00 00 00    	je     80107276 <copyuvm+0xd6>
801071c4:	31 f6                	xor    %esi,%esi
801071c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071cd:	00 
801071ce:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801071d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801071d3:	89 f0                	mov    %esi,%eax
801071d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801071db:	a8 01                	test   $0x1,%al
801071dd:	75 11                	jne    801071f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071df:	83 ec 0c             	sub    $0xc,%esp
801071e2:	68 e0 78 10 80       	push   $0x801078e0
801071e7:	e8 94 91 ff ff       	call   80100380 <panic>
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801071f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071f7:	c1 ea 0a             	shr    $0xa,%edx
801071fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107200:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107207:	85 c0                	test   %eax,%eax
80107209:	74 d4                	je     801071df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010720b:	8b 00                	mov    (%eax),%eax
8010720d:	a8 01                	test   $0x1,%al
8010720f:	0f 84 9f 00 00 00    	je     801072b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107215:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107217:	25 ff 0f 00 00       	and    $0xfff,%eax
8010721c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010721f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107225:	e8 36 b5 ff ff       	call   80102760 <kalloc>
8010722a:	89 c3                	mov    %eax,%ebx
8010722c:	85 c0                	test   %eax,%eax
8010722e:	74 64                	je     80107294 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
80107233:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107239:	68 00 10 00 00       	push   $0x1000
8010723e:	57                   	push   %edi
8010723f:	50                   	push   %eax
80107240:	e8 4b d6 ff ff       	call   80104890 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107245:	58                   	pop    %eax
80107246:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010724c:	5a                   	pop    %edx
8010724d:	ff 75 e4             	push   -0x1c(%ebp)
80107250:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107255:	89 f2                	mov    %esi,%edx
80107257:	50                   	push   %eax
80107258:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010725b:	e8 90 f8 ff ff       	call   80106af0 <mappages>
80107260:	83 c4 10             	add    $0x10,%esp
80107263:	85 c0                	test   %eax,%eax
80107265:	78 21                	js     80107288 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107267:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010726d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107270:	0f 82 5a ff ff ff    	jb     801071d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107276:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107279:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010727c:	5b                   	pop    %ebx
8010727d:	5e                   	pop    %esi
8010727e:	5f                   	pop    %edi
8010727f:	5d                   	pop    %ebp
80107280:	c3                   	ret
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	53                   	push   %ebx
8010728c:	e8 0f b3 ff ff       	call   801025a0 <kfree>
      goto bad;
80107291:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107294:	83 ec 0c             	sub    $0xc,%esp
80107297:	ff 75 e0             	push   -0x20(%ebp)
8010729a:	e8 91 fd ff ff       	call   80107030 <freevm>
  return 0;
8010729f:	83 c4 10             	add    $0x10,%esp
    return 0;
801072a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072af:	5b                   	pop    %ebx
801072b0:	5e                   	pop    %esi
801072b1:	5f                   	pop    %edi
801072b2:	5d                   	pop    %ebp
801072b3:	c3                   	ret
      panic("copyuvm: page not present");
801072b4:	83 ec 0c             	sub    $0xc,%esp
801072b7:	68 fa 78 10 80       	push   $0x801078fa
801072bc:	e8 bf 90 ff ff       	call   80100380 <panic>
801072c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072c8:	00 
801072c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072d9:	89 c1                	mov    %eax,%ecx
801072db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072e1:	f6 c2 01             	test   $0x1,%dl
801072e4:	0f 84 f8 00 00 00    	je     801073e2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801072ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801072f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801072f9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107300:	89 d0                	mov    %edx,%eax
80107302:	f7 d2                	not    %edx
80107304:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107309:	05 00 00 00 80       	add    $0x80000000,%eax
8010730e:	83 e2 05             	and    $0x5,%edx
80107311:	ba 00 00 00 00       	mov    $0x0,%edx
80107316:	0f 45 c2             	cmovne %edx,%eax
}
80107319:	c3                   	ret
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 14             	mov    0x14(%ebp),%esi
8010732c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010732f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107332:	85 f6                	test   %esi,%esi
80107334:	75 51                	jne    80107387 <copyout+0x67>
80107336:	e9 9d 00 00 00       	jmp    801073d8 <copyout+0xb8>
8010733b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107340:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107346:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010734c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107352:	74 74                	je     801073c8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107354:	89 fb                	mov    %edi,%ebx
80107356:	29 c3                	sub    %eax,%ebx
80107358:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010735e:	39 f3                	cmp    %esi,%ebx
80107360:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107363:	29 f8                	sub    %edi,%eax
80107365:	83 ec 04             	sub    $0x4,%esp
80107368:	01 c1                	add    %eax,%ecx
8010736a:	53                   	push   %ebx
8010736b:	52                   	push   %edx
8010736c:	89 55 10             	mov    %edx,0x10(%ebp)
8010736f:	51                   	push   %ecx
80107370:	e8 1b d5 ff ff       	call   80104890 <memmove>
    len -= n;
    buf += n;
80107375:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107378:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010737e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107381:	01 da                	add    %ebx,%edx
  while(len > 0){
80107383:	29 de                	sub    %ebx,%esi
80107385:	74 51                	je     801073d8 <copyout+0xb8>
  if(*pde & PTE_P){
80107387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010738a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010738c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010738e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107391:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107397:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010739a:	f6 c1 01             	test   $0x1,%cl
8010739d:	0f 84 46 00 00 00    	je     801073e9 <copyout.cold>
  return &pgtab[PTX(va)];
801073a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801073ab:	c1 eb 0c             	shr    $0xc,%ebx
801073ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801073b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801073bb:	89 d9                	mov    %ebx,%ecx
801073bd:	f7 d1                	not    %ecx
801073bf:	83 e1 05             	and    $0x5,%ecx
801073c2:	0f 84 78 ff ff ff    	je     80107340 <copyout+0x20>
  }
  return 0;
}
801073c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073d0:	5b                   	pop    %ebx
801073d1:	5e                   	pop    %esi
801073d2:	5f                   	pop    %edi
801073d3:	5d                   	pop    %ebp
801073d4:	c3                   	ret
801073d5:	8d 76 00             	lea    0x0(%esi),%esi
801073d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073db:	31 c0                	xor    %eax,%eax
}
801073dd:	5b                   	pop    %ebx
801073de:	5e                   	pop    %esi
801073df:	5f                   	pop    %edi
801073e0:	5d                   	pop    %ebp
801073e1:	c3                   	ret

801073e2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801073e2:	a1 00 00 00 00       	mov    0x0,%eax
801073e7:	0f 0b                	ud2

801073e9 <copyout.cold>:
801073e9:	a1 00 00 00 00       	mov    0x0,%eax
801073ee:	0f 0b                	ud2
