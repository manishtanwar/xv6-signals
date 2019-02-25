
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 2e 10 80       	mov    $0x80102ed0,%eax
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
80100044:	bb 94 c6 10 80       	mov    $0x8010c694,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 79 10 80       	push   $0x80107980
80100051:	68 60 c6 10 80       	push   $0x8010c660
80100056:	e8 65 49 00 00       	call   801049c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 ac 0d 11 80 5c 	movl   $0x80110d5c,0x80110dac
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 b0 0d 11 80 5c 	movl   $0x80110d5c,0x80110db0
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 5c 0d 11 80       	mov    $0x80110d5c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 79 10 80       	push   $0x80107987
80100097:	50                   	push   %eax
80100098:	e8 f3 47 00 00       	call   80104890 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 5c 0d 11 80       	cmp    $0x80110d5c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 60 c6 10 80       	push   $0x8010c660
801000e4:	e8 17 4a 00 00       	call   80104b00 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d b0 0d 11 80    	mov    0x80110db0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d ac 0d 11 80    	mov    0x80110dac,%ebx
80100126:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 60 c6 10 80       	push   $0x8010c660
80100162:	e8 59 4a 00 00       	call   80104bc0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 47 00 00       	call   801048d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 1f 00 00       	call   80102150 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 79 10 80       	push   $0x8010798e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 47 00 00       	call   80104970 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 79 10 80       	push   $0x8010799f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 47 00 00       	call   80104970 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 47 00 00       	call   80104930 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010020b:	e8 f0 48 00 00       	call   80104b00 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 60 c6 10 80 	movl   $0x8010c660,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 49 00 00       	jmp    80104bc0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 79 10 80       	push   $0x801079a6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 0b 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010028c:	e8 6f 48 00 00       	call   80104b00 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 40 60 11 80    	mov    0x80116040,%edx
801002a7:	39 15 44 60 11 80    	cmp    %edx,0x80116044
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 a0 b5 10 80       	push   $0x8010b5a0
801002c0:	68 40 60 11 80       	push   $0x80116040
801002c5:	e8 76 3b 00 00       	call   80103e40 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 60 11 80    	mov    0x80116040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 60 11 80    	cmp    0x80116044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 35 00 00       	call   80103870 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 a0 b5 10 80       	push   $0x8010b5a0
801002ef:	e8 cc 48 00 00       	call   80104bc0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 13 00 00       	call   801016b0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 40 60 11 80       	mov    %eax,0x80116040
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 c0 5f 11 80 	movsbl -0x7feea040(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 a0 b5 10 80       	push   $0x8010b5a0
8010034d:	e8 6e 48 00 00       	call   80104bc0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 13 00 00       	call   801016b0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 40 60 11 80    	mov    %edx,0x80116040
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 23 00 00       	call   80102760 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 79 10 80       	push   $0x801079ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 87 84 10 80 	movl   $0x80108487,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 46 00 00       	call   801049e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 79 10 80       	push   $0x801079c1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 d8 b5 10 80 01 	movl   $0x1,0x8010b5d8
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 51 61 00 00       	call   80106590 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 9f 60 00 00       	call   80106590 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 93 60 00 00       	call   80106590 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 87 60 00 00       	call   80106590 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 47 00 00       	call   80104cc0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 46 00 00       	call   80104c10 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 79 10 80       	push   $0x801079c5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 f0 79 10 80 	movzbl -0x7fef8610(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 7c 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010061b:	e8 e0 44 00 00       	call   80104b00 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 a0 b5 10 80       	push   $0x8010b5a0
80100647:	e8 74 45 00 00       	call   80104bc0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 a0 b5 10 80       	push   $0x8010b5a0
8010071f:	e8 9c 44 00 00       	call   80104bc0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba d8 79 10 80       	mov    $0x801079d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 a0 b5 10 80       	push   $0x8010b5a0
801007f0:	e8 0b 43 00 00       	call   80104b00 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 79 10 80       	push   $0x801079df
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 a0 b5 10 80       	push   $0x8010b5a0
80100823:	e8 d8 42 00 00       	call   80104b00 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 48 60 11 80       	mov    0x80116048,%eax
80100856:	3b 05 44 60 11 80    	cmp    0x80116044,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 48 60 11 80       	mov    %eax,0x80116048
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 a0 b5 10 80       	push   $0x8010b5a0
80100888:	e8 33 43 00 00       	call   80104bc0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 48 60 11 80       	mov    0x80116048,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 40 60 11 80    	sub    0x80116040,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 48 60 11 80    	mov    %edx,0x80116048
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 c0 5f 11 80    	mov    %cl,-0x7feea040(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 40 60 11 80       	mov    0x80116040,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 48 60 11 80    	cmp    %eax,0x80116048
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 44 60 11 80       	mov    %eax,0x80116044
          wakeup(&input.r);
80100911:	68 40 60 11 80       	push   $0x80116040
80100916:	e8 e5 36 00 00       	call   80104000 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 48 60 11 80       	mov    0x80116048,%eax
8010093d:	39 05 44 60 11 80    	cmp    %eax,0x80116044
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 48 60 11 80       	mov    %eax,0x80116048
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 48 60 11 80       	mov    0x80116048,%eax
80100964:	3b 05 44 60 11 80    	cmp    0x80116044,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba c0 5f 11 80 0a 	cmpb   $0xa,-0x7feea040(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 74 38 00 00       	jmp    80104210 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 c0 5f 11 80 0a 	movb   $0xa,-0x7feea040(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 48 60 11 80       	mov    0x80116048,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 e8 79 10 80       	push   $0x801079e8
801009cb:	68 a0 b5 10 80       	push   $0x8010b5a0
801009d0:	e8 eb 3f 00 00       	call   801049c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 0c 6a 11 80 00 	movl   $0x80100600,0x80116a0c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 08 6a 11 80 70 	movl   $0x80100270,0x80116a08
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 02 19 00 00       	call   80102300 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 4f 2e 00 00       	call   80103870 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 a4 21 00 00       	call   80102bd0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 d9 14 00 00       	call   80101f10 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 63 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 32 0f 00 00       	call   80101990 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 d1 0e 00 00       	call   80101940 <iunlockput>
    end_op();
80100a6f:	e8 cc 21 00 00       	call   80102c40 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 47 6c 00 00       	call   801076e0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 b1 02 00 00    	je     80100d70 <exec+0x360>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 05 6a 00 00       	call   80107500 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 13 69 00 00       	call   80107440 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 33 0e 00 00       	call   80101990 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 e9 6a 00 00       	call   80107660 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 a6 0d 00 00       	call   80101940 <iunlockput>
  end_op();
80100b9a:	e8 a1 20 00 00       	call   80102c40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 51 69 00 00       	call   80107500 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 9a 6a 00 00       	call   80107660 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 68 20 00 00       	call   80102c40 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 7a 10 80       	push   $0x80107a01
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 75 6b 00 00       	call   80107780 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 f2 41 00 00       	call   80104e30 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 df 41 00 00       	call   80104e30 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 7e 6c 00 00       	call   801078e0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 14 6c 00 00       	call   801078e0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 e1 40 00 00       	call   80104df0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
    curproc->sig_htable[i] = 0;
80100d31:	c7 41 7c 00 00 00 00 	movl   $0x0,0x7c(%ecx)
80100d38:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
80100d3f:	00 00 00 
80100d42:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
80100d49:	00 00 00 
80100d4c:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80100d53:	00 00 00 
  switchuvm(curproc);
80100d56:	89 0c 24             	mov    %ecx,(%esp)
80100d59:	e8 52 65 00 00       	call   801072b0 <switchuvm>
  freevm(oldpgdir);
80100d5e:	89 3c 24             	mov    %edi,(%esp)
80100d61:	e8 fa 68 00 00       	call   80107660 <freevm>
  return 0;
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	31 c0                	xor    %eax,%eax
80100d6b:	e9 0c fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d70:	be 00 20 00 00       	mov    $0x2000,%esi
80100d75:	e9 17 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d7a:	66 90                	xchg   %ax,%ax
80100d7c:	66 90                	xchg   %ax,%ax
80100d7e:	66 90                	xchg   %ax,%ax

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	68 0d 7a 10 80       	push   $0x80107a0d
80100d8b:	68 60 60 11 80       	push   $0x80116060
80100d90:	e8 2b 3c 00 00       	call   801049c0 <initlock>
}
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	c9                   	leave  
80100d99:	c3                   	ret    
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb 94 60 11 80       	mov    $0x80116094,%ebx
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dac:	68 60 60 11 80       	push   $0x80116060
80100db1:	e8 4a 3d 00 00       	call   80104b00 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb f4 69 11 80    	cmp    $0x801169f4,%ebx
80100dc9:	73 25                	jae    80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100dd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ddc:	68 60 60 11 80       	push   $0x80116060
80100de1:	e8 da 3d 00 00       	call   80104bc0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de6:	89 d8                	mov    %ebx,%eax
      return f;
80100de8:	83 c4 10             	add    $0x10,%esp
}
80100deb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dee:	c9                   	leave  
80100def:	c3                   	ret    
  release(&ftable.lock);
80100df0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100df3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100df5:	68 60 60 11 80       	push   $0x80116060
80100dfa:	e8 c1 3d 00 00       	call   80104bc0 <release>
}
80100dff:	89 d8                	mov    %ebx,%eax
  return 0;
80100e01:	83 c4 10             	add    $0x10,%esp
}
80100e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e07:	c9                   	leave  
80100e08:	c3                   	ret    
80100e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 10             	sub    $0x10,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	68 60 60 11 80       	push   $0x80116060
80100e1f:	e8 dc 3c 00 00       	call   80104b00 <acquire>
  if(f->ref < 1)
80100e24:	8b 43 04             	mov    0x4(%ebx),%eax
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	7e 1a                	jle    80100e48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e37:	68 60 60 11 80       	push   $0x80116060
80100e3c:	e8 7f 3d 00 00       	call   80104bc0 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 14 7a 10 80       	push   $0x80107a14
80100e50:	e8 3b f5 ff ff       	call   80100390 <panic>
80100e55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 28             	sub    $0x28,%esp
80100e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	68 60 60 11 80       	push   $0x80116060
80100e71:	e8 8a 3c 00 00       	call   80104b00 <acquire>
  if(f->ref < 1)
80100e76:	8b 43 04             	mov    0x4(%ebx),%eax
80100e79:	83 c4 10             	add    $0x10,%esp
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	0f 8e 9b 00 00 00    	jle    80100f1f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e84:	83 e8 01             	sub    $0x1,%eax
80100e87:	85 c0                	test   %eax,%eax
80100e89:	89 43 04             	mov    %eax,0x4(%ebx)
80100e8c:	74 1a                	je     80100ea8 <fileclose+0x48>
    release(&ftable.lock);
80100e8e:	c7 45 08 60 60 11 80 	movl   $0x80116060,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e98:	5b                   	pop    %ebx
80100e99:	5e                   	pop    %esi
80100e9a:	5f                   	pop    %edi
80100e9b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e9c:	e9 1f 3d 00 00       	jmp    80104bc0 <release>
80100ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ea8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100eac:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100eae:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100eb1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100eb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eba:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ebd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ec0:	68 60 60 11 80       	push   $0x80116060
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ec8:	e8 f3 3c 00 00       	call   80104bc0 <release>
  if(ff.type == FD_PIPE)
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	83 ff 01             	cmp    $0x1,%edi
80100ed3:	74 13                	je     80100ee8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ed5:	83 ff 02             	cmp    $0x2,%edi
80100ed8:	74 26                	je     80100f00 <fileclose+0xa0>
}
80100eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100edd:	5b                   	pop    %ebx
80100ede:	5e                   	pop    %esi
80100edf:	5f                   	pop    %edi
80100ee0:	5d                   	pop    %ebp
80100ee1:	c3                   	ret    
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eec:	83 ec 08             	sub    $0x8,%esp
80100eef:	53                   	push   %ebx
80100ef0:	56                   	push   %esi
80100ef1:	e8 8a 24 00 00       	call   80103380 <pipeclose>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	eb df                	jmp    80100eda <fileclose+0x7a>
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f00:	e8 cb 1c 00 00       	call   80102bd0 <begin_op>
    iput(ff.ip);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 75 e0             	pushl  -0x20(%ebp)
80100f0b:	e8 d0 08 00 00       	call   801017e0 <iput>
    end_op();
80100f10:	83 c4 10             	add    $0x10,%esp
}
80100f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f16:	5b                   	pop    %ebx
80100f17:	5e                   	pop    %esi
80100f18:	5f                   	pop    %edi
80100f19:	5d                   	pop    %ebp
    end_op();
80100f1a:	e9 21 1d 00 00       	jmp    80102c40 <end_op>
    panic("fileclose");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 1c 7a 10 80       	push   $0x80107a1c
80100f27:	e8 64 f4 ff ff       	call   80100390 <panic>
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	ff 73 10             	pushl  0x10(%ebx)
80100f45:	e8 66 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f4a:	58                   	pop    %eax
80100f4b:	5a                   	pop    %edx
80100f4c:	ff 75 0c             	pushl  0xc(%ebp)
80100f4f:	ff 73 10             	pushl  0x10(%ebx)
80100f52:	e8 09 0a 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f57:	59                   	pop    %ecx
80100f58:	ff 73 10             	pushl  0x10(%ebx)
80100f5b:	e8 30 08 00 00       	call   80101790 <iunlock>
    return 0;
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f75:	eb ee                	jmp    80100f65 <filestat+0x35>
80100f77:	89 f6                	mov    %esi,%esi
80100f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 0c             	sub    $0xc,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 60                	je     80100ff8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 41                	je     80100fe0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 5b                	jne    80100fff <fileread+0x7f>
    ilock(f->ip);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	ff 73 10             	pushl  0x10(%ebx)
80100faa:	e8 01 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	57                   	push   %edi
80100fb0:	ff 73 14             	pushl  0x14(%ebx)
80100fb3:	56                   	push   %esi
80100fb4:	ff 73 10             	pushl  0x10(%ebx)
80100fb7:	e8 d4 09 00 00       	call   80101990 <readi>
80100fbc:	83 c4 20             	add    $0x20,%esp
80100fbf:	85 c0                	test   %eax,%eax
80100fc1:	89 c6                	mov    %eax,%esi
80100fc3:	7e 03                	jle    80100fc8 <fileread+0x48>
      f->off += r;
80100fc5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	ff 73 10             	pushl  0x10(%ebx)
80100fce:	e8 bd 07 00 00       	call   80101790 <iunlock>
    return r;
80100fd3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	89 f0                	mov    %esi,%eax
80100fdb:	5b                   	pop    %ebx
80100fdc:	5e                   	pop    %esi
80100fdd:	5f                   	pop    %edi
80100fde:	5d                   	pop    %ebp
80100fdf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fe0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fe3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	5b                   	pop    %ebx
80100fea:	5e                   	pop    %esi
80100feb:	5f                   	pop    %edi
80100fec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fed:	e9 3e 25 00 00       	jmp    80103530 <piperead>
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100ff8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100ffd:	eb d7                	jmp    80100fd6 <fileread+0x56>
  panic("fileread");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 26 7a 10 80       	push   $0x80107a26
80101007:	e8 84 f3 ff ff       	call   80100390 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 1c             	sub    $0x1c,%esp
80101019:	8b 75 08             	mov    0x8(%ebp),%esi
8010101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010101f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101023:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101026:	8b 45 10             	mov    0x10(%ebp),%eax
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010102c:	0f 84 aa 00 00 00    	je     801010dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 06                	mov    (%esi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c3 00 00 00    	je     80101100 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d9 00 00 00    	jne    8010111f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101049:	31 ff                	xor    %edi,%edi
    while(i < n){
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 34                	jg     80101083 <filewrite+0x73>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101058:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101061:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101064:	e8 27 07 00 00       	call   80101790 <iunlock>
      end_op();
80101069:	e8 d2 1b 00 00       	call   80102c40 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101071:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101074:	39 c3                	cmp    %eax,%ebx
80101076:	0f 85 96 00 00 00    	jne    80101112 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010107c:	01 df                	add    %ebx,%edi
    while(i < n){
8010107e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101081:	7e 6d                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101083:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101086:	b8 00 06 00 00       	mov    $0x600,%eax
8010108b:	29 fb                	sub    %edi,%ebx
8010108d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101093:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101096:	e8 35 1b 00 00       	call   80102bd0 <begin_op>
      ilock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
801010a1:	e8 0a 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a9:	53                   	push   %ebx
801010aa:	ff 76 14             	pushl  0x14(%esi)
801010ad:	01 f8                	add    %edi,%eax
801010af:	50                   	push   %eax
801010b0:	ff 76 10             	pushl  0x10(%esi)
801010b3:	e8 d8 09 00 00       	call   80101a90 <writei>
801010b8:	83 c4 20             	add    $0x20,%esp
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 99                	jg     80101058 <filewrite+0x48>
      iunlock(f->ip);
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	ff 76 10             	pushl  0x10(%esi)
801010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010c8:	e8 c3 06 00 00       	call   80101790 <iunlock>
      end_op();
801010cd:	e8 6e 1b 00 00       	call   80102c40 <end_op>
      if(r < 0)
801010d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	85 c0                	test   %eax,%eax
801010da:	74 98                	je     80101074 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010e4:	89 f8                	mov    %edi,%eax
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
801010ea:	c3                   	ret    
801010eb:	90                   	nop
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010f3:	75 e7                	jne    801010dc <filewrite+0xcc>
}
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	89 f8                	mov    %edi,%eax
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
801010ff:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101100:	8b 46 0c             	mov    0xc(%esi),%eax
80101103:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	5b                   	pop    %ebx
8010110a:	5e                   	pop    %esi
8010110b:	5f                   	pop    %edi
8010110c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010110d:	e9 0e 23 00 00       	jmp    80103420 <pipewrite>
        panic("short filewrite");
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	68 2f 7a 10 80       	push   $0x80107a2f
8010111a:	e8 71 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 35 7a 10 80       	push   $0x80107a35
80101127:	e8 64 f2 ff ff       	call   80100390 <panic>
8010112c:	66 90                	xchg   %ax,%ax
8010112e:	66 90                	xchg   %ax,%ax

80101130 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101139:	8b 0d 60 6a 11 80    	mov    0x80116a60,%ecx
{
8010113f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101142:	85 c9                	test   %ecx,%ecx
80101144:	0f 84 87 00 00 00    	je     801011d1 <balloc+0xa1>
8010114a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101151:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101154:	83 ec 08             	sub    $0x8,%esp
80101157:	89 f0                	mov    %esi,%eax
80101159:	c1 f8 0c             	sar    $0xc,%eax
8010115c:	03 05 78 6a 11 80    	add    0x80116a78,%eax
80101162:	50                   	push   %eax
80101163:	ff 75 d8             	pushl  -0x28(%ebp)
80101166:	e8 65 ef ff ff       	call   801000d0 <bread>
8010116b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116e:	a1 60 6a 11 80       	mov    0x80116a60,%eax
80101173:	83 c4 10             	add    $0x10,%esp
80101176:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101179:	31 c0                	xor    %eax,%eax
8010117b:	eb 2f                	jmp    801011ac <balloc+0x7c>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101180:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101182:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101185:	bb 01 00 00 00       	mov    $0x1,%ebx
8010118a:	83 e1 07             	and    $0x7,%ecx
8010118d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010118f:	89 c1                	mov    %eax,%ecx
80101191:	c1 f9 03             	sar    $0x3,%ecx
80101194:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101199:	85 df                	test   %ebx,%edi
8010119b:	89 fa                	mov    %edi,%edx
8010119d:	74 41                	je     801011e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010119f:	83 c0 01             	add    $0x1,%eax
801011a2:	83 c6 01             	add    $0x1,%esi
801011a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011aa:	74 05                	je     801011b1 <balloc+0x81>
801011ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011af:	77 cf                	ja     80101180 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011b7:	e8 24 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011c9:	39 05 60 6a 11 80    	cmp    %eax,0x80116a60
801011cf:	77 80                	ja     80101151 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011d1:	83 ec 0c             	sub    $0xc,%esp
801011d4:	68 3f 7a 10 80       	push   $0x80107a3f
801011d9:	e8 b2 f1 ff ff       	call   80100390 <panic>
801011de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011e6:	09 da                	or     %ebx,%edx
801011e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011ec:	57                   	push   %edi
801011ed:	e8 ae 1b 00 00       	call   80102da0 <log_write>
        brelse(bp);
801011f2:	89 3c 24             	mov    %edi,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011fa:	58                   	pop    %eax
801011fb:	5a                   	pop    %edx
801011fc:	56                   	push   %esi
801011fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101200:	e8 cb ee ff ff       	call   801000d0 <bread>
80101205:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101207:	8d 40 5c             	lea    0x5c(%eax),%eax
8010120a:	83 c4 0c             	add    $0xc,%esp
8010120d:	68 00 02 00 00       	push   $0x200
80101212:	6a 00                	push   $0x0
80101214:	50                   	push   %eax
80101215:	e8 f6 39 00 00       	call   80104c10 <memset>
  log_write(bp);
8010121a:	89 1c 24             	mov    %ebx,(%esp)
8010121d:	e8 7e 1b 00 00       	call   80102da0 <log_write>
  brelse(bp);
80101222:	89 1c 24             	mov    %ebx,(%esp)
80101225:	e8 b6 ef ff ff       	call   801001e0 <brelse>
}
8010122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122d:	89 f0                	mov    %esi,%eax
8010122f:	5b                   	pop    %ebx
80101230:	5e                   	pop    %esi
80101231:	5f                   	pop    %edi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
80101234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010123a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101240 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101248:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124a:	bb b4 6a 11 80       	mov    $0x80116ab4,%ebx
{
8010124f:	83 ec 28             	sub    $0x28,%esp
80101252:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101255:	68 80 6a 11 80       	push   $0x80116a80
8010125a:	e8 a1 38 00 00       	call   80104b00 <acquire>
8010125f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101265:	eb 17                	jmp    8010127e <iget+0x3e>
80101267:	89 f6                	mov    %esi,%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101270:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101276:	81 fb d4 86 11 80    	cmp    $0x801186d4,%ebx
8010127c:	73 22                	jae    801012a0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010127e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101281:	85 c9                	test   %ecx,%ecx
80101283:	7e 04                	jle    80101289 <iget+0x49>
80101285:	39 3b                	cmp    %edi,(%ebx)
80101287:	74 4f                	je     801012d8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101289:	85 f6                	test   %esi,%esi
8010128b:	75 e3                	jne    80101270 <iget+0x30>
8010128d:	85 c9                	test   %ecx,%ecx
8010128f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101292:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101298:	81 fb d4 86 11 80    	cmp    $0x801186d4,%ebx
8010129e:	72 de                	jb     8010127e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 5b                	je     801012ff <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 80 6a 11 80       	push   $0x80116a80
801012bf:	e8 fc 38 00 00       	call   80104bc0 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
801012d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012db:	75 ac                	jne    80101289 <iget+0x49>
      release(&icache.lock);
801012dd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012e0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012e3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012e5:	68 80 6a 11 80       	push   $0x80116a80
      ip->ref++;
801012ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012ed:	e8 ce 38 00 00       	call   80104bc0 <release>
      return ip;
801012f2:	83 c4 10             	add    $0x10,%esp
}
801012f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f8:	89 f0                	mov    %esi,%eax
801012fa:	5b                   	pop    %ebx
801012fb:	5e                   	pop    %esi
801012fc:	5f                   	pop    %edi
801012fd:	5d                   	pop    %ebp
801012fe:	c3                   	ret    
    panic("iget: no inodes");
801012ff:	83 ec 0c             	sub    $0xc,%esp
80101302:	68 55 7a 10 80       	push   $0x80107a55
80101307:	e8 84 f0 ff ff       	call   80100390 <panic>
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101310 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	89 c6                	mov    %eax,%esi
80101318:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010131b:	83 fa 0b             	cmp    $0xb,%edx
8010131e:	77 18                	ja     80101338 <bmap+0x28>
80101320:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101323:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101326:	85 db                	test   %ebx,%ebx
80101328:	74 76                	je     801013a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 d8                	mov    %ebx,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101338:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010133b:	83 fb 7f             	cmp    $0x7f,%ebx
8010133e:	0f 87 90 00 00 00    	ja     801013d4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101344:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010134a:	8b 00                	mov    (%eax),%eax
8010134c:	85 d2                	test   %edx,%edx
8010134e:	74 70                	je     801013c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101350:	83 ec 08             	sub    $0x8,%esp
80101353:	52                   	push   %edx
80101354:	50                   	push   %eax
80101355:	e8 76 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010135a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010135e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101361:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101363:	8b 1a                	mov    (%edx),%ebx
80101365:	85 db                	test   %ebx,%ebx
80101367:	75 1d                	jne    80101386 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101369:	8b 06                	mov    (%esi),%eax
8010136b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010136e:	e8 bd fd ff ff       	call   80101130 <balloc>
80101373:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101376:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101379:	89 c3                	mov    %eax,%ebx
8010137b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010137d:	57                   	push   %edi
8010137e:	e8 1d 1a 00 00       	call   80102da0 <log_write>
80101383:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	57                   	push   %edi
8010138a:	e8 51 ee ff ff       	call   801001e0 <brelse>
8010138f:	83 c4 10             	add    $0x10,%esp
}
80101392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101395:	89 d8                	mov    %ebx,%eax
80101397:	5b                   	pop    %ebx
80101398:	5e                   	pop    %esi
80101399:	5f                   	pop    %edi
8010139a:	5d                   	pop    %ebp
8010139b:	c3                   	ret    
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013a0:	8b 00                	mov    (%eax),%eax
801013a2:	e8 89 fd ff ff       	call   80101130 <balloc>
801013a7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013ad:	89 c3                	mov    %eax,%ebx
}
801013af:	89 d8                	mov    %ebx,%eax
801013b1:	5b                   	pop    %ebx
801013b2:	5e                   	pop    %esi
801013b3:	5f                   	pop    %edi
801013b4:	5d                   	pop    %ebp
801013b5:	c3                   	ret    
801013b6:	8d 76 00             	lea    0x0(%esi),%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013c0:	e8 6b fd ff ff       	call   80101130 <balloc>
801013c5:	89 c2                	mov    %eax,%edx
801013c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013cd:	8b 06                	mov    (%esi),%eax
801013cf:	e9 7c ff ff ff       	jmp    80101350 <bmap+0x40>
  panic("bmap: out of range");
801013d4:	83 ec 0c             	sub    $0xc,%esp
801013d7:	68 65 7a 10 80       	push   $0x80107a65
801013dc:	e8 af ef ff ff       	call   80100390 <panic>
801013e1:	eb 0d                	jmp    801013f0 <readsb>
801013e3:	90                   	nop
801013e4:	90                   	nop
801013e5:	90                   	nop
801013e6:	90                   	nop
801013e7:	90                   	nop
801013e8:	90                   	nop
801013e9:	90                   	nop
801013ea:	90                   	nop
801013eb:	90                   	nop
801013ec:	90                   	nop
801013ed:	90                   	nop
801013ee:	90                   	nop
801013ef:	90                   	nop

801013f0 <readsb>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013f8:	83 ec 08             	sub    $0x8,%esp
801013fb:	6a 01                	push   $0x1
801013fd:	ff 75 08             	pushl  0x8(%ebp)
80101400:	e8 cb ec ff ff       	call   801000d0 <bread>
80101405:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101407:	8d 40 5c             	lea    0x5c(%eax),%eax
8010140a:	83 c4 0c             	add    $0xc,%esp
8010140d:	6a 1c                	push   $0x1c
8010140f:	50                   	push   %eax
80101410:	56                   	push   %esi
80101411:	e8 aa 38 00 00       	call   80104cc0 <memmove>
  brelse(bp);
80101416:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101419:	83 c4 10             	add    $0x10,%esp
}
8010141c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5d                   	pop    %ebp
  brelse(bp);
80101422:	e9 b9 ed ff ff       	jmp    801001e0 <brelse>
80101427:	89 f6                	mov    %esi,%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <bfree>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	53                   	push   %ebx
80101435:	89 d3                	mov    %edx,%ebx
80101437:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101439:	83 ec 08             	sub    $0x8,%esp
8010143c:	68 60 6a 11 80       	push   $0x80116a60
80101441:	50                   	push   %eax
80101442:	e8 a9 ff ff ff       	call   801013f0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101447:	58                   	pop    %eax
80101448:	5a                   	pop    %edx
80101449:	89 da                	mov    %ebx,%edx
8010144b:	c1 ea 0c             	shr    $0xc,%edx
8010144e:	03 15 78 6a 11 80    	add    0x80116a78,%edx
80101454:	52                   	push   %edx
80101455:	56                   	push   %esi
80101456:	e8 75 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010145b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010145d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101460:	ba 01 00 00 00       	mov    $0x1,%edx
80101465:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101468:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010146e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101471:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101473:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101478:	85 d1                	test   %edx,%ecx
8010147a:	74 25                	je     801014a1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010147c:	f7 d2                	not    %edx
8010147e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101480:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101483:	21 ca                	and    %ecx,%edx
80101485:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101489:	56                   	push   %esi
8010148a:	e8 11 19 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010148f:	89 34 24             	mov    %esi,(%esp)
80101492:	e8 49 ed ff ff       	call   801001e0 <brelse>
}
80101497:	83 c4 10             	add    $0x10,%esp
8010149a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149d:	5b                   	pop    %ebx
8010149e:	5e                   	pop    %esi
8010149f:	5d                   	pop    %ebp
801014a0:	c3                   	ret    
    panic("freeing free block");
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	68 78 7a 10 80       	push   $0x80107a78
801014a9:	e8 e2 ee ff ff       	call   80100390 <panic>
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb c0 6a 11 80       	mov    $0x80116ac0,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 8b 7a 10 80       	push   $0x80107a8b
801014c1:	68 80 6a 11 80       	push   $0x80116a80
801014c6:	e8 f5 34 00 00       	call   801049c0 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 92 7a 10 80       	push   $0x80107a92
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 ac 33 00 00       	call   80104890 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb e0 86 11 80    	cmp    $0x801186e0,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 60 6a 11 80       	push   $0x80116a60
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 f1 fe ff ff       	call   801013f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 78 6a 11 80    	pushl  0x80116a78
80101505:	ff 35 74 6a 11 80    	pushl  0x80116a74
8010150b:	ff 35 70 6a 11 80    	pushl  0x80116a70
80101511:	ff 35 6c 6a 11 80    	pushl  0x80116a6c
80101517:	ff 35 68 6a 11 80    	pushl  0x80116a68
8010151d:	ff 35 64 6a 11 80    	pushl  0x80116a64
80101523:	ff 35 60 6a 11 80    	pushl  0x80116a60
80101529:	68 f8 7a 10 80       	push   $0x80107af8
8010152e:	e8 2d f1 ff ff       	call   80100660 <cprintf>
}
80101533:	83 c4 30             	add    $0x30,%esp
80101536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101539:	c9                   	leave  
8010153a:	c3                   	ret    
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	83 3d 68 6a 11 80 01 	cmpl   $0x1,0x80116a68
{
80101550:	8b 45 0c             	mov    0xc(%ebp),%eax
80101553:	8b 75 08             	mov    0x8(%ebp),%esi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 91 00 00 00    	jbe    801015f0 <ialloc+0xb0>
8010155f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101564:	eb 21                	jmp    80101587 <ialloc+0x47>
80101566:	8d 76 00             	lea    0x0(%esi),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101570:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	57                   	push   %edi
80101577:	e8 64 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	39 1d 68 6a 11 80    	cmp    %ebx,0x80116a68
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 74 6a 11 80    	add    0x80116a74,%eax
80101595:	50                   	push   %eax
80101596:	56                   	push   %esi
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015a3:	83 e0 07             	and    $0x7,%eax
801015a6:	c1 e0 06             	shl    $0x6,%eax
801015a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015b1:	75 bd                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b3:	83 ec 04             	sub    $0x4,%esp
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	6a 40                	push   $0x40
801015bb:	6a 00                	push   $0x0
801015bd:	51                   	push   %ecx
801015be:	e8 4d 36 00 00       	call   80104c10 <memset>
      dip->type = type;
801015c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015cd:	89 3c 24             	mov    %edi,(%esp)
801015d0:	e8 cb 17 00 00       	call   80102da0 <log_write>
      brelse(bp);
801015d5:	89 3c 24             	mov    %edi,(%esp)
801015d8:	e8 03 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015dd:	83 c4 10             	add    $0x10,%esp
}
801015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015e3:	89 da                	mov    %ebx,%edx
801015e5:	89 f0                	mov    %esi,%eax
}
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5f                   	pop    %edi
801015ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801015eb:	e9 50 fc ff ff       	jmp    80101240 <iget>
  panic("ialloc: no inodes");
801015f0:	83 ec 0c             	sub    $0xc,%esp
801015f3:	68 98 7a 10 80       	push   $0x80107a98
801015f8:	e8 93 ed ff ff       	call   80100390 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 74 6a 11 80    	add    0x80116a74,%eax
8010161a:	50                   	push   %eax
8010161b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010161e:	e8 ad ea ff ff       	call   801000d0 <bread>
80101623:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101625:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101628:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101639:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010163c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101640:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101643:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101647:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010164b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010164f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101653:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101657:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010165a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165d:	6a 34                	push   $0x34
8010165f:	53                   	push   %ebx
80101660:	50                   	push   %eax
80101661:	e8 5a 36 00 00       	call   80104cc0 <memmove>
  log_write(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 32 17 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010166e:	89 75 08             	mov    %esi,0x8(%ebp)
80101671:	83 c4 10             	add    $0x10,%esp
}
80101674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5d                   	pop    %ebp
  brelse(bp);
8010167a:	e9 61 eb ff ff       	jmp    801001e0 <brelse>
8010167f:	90                   	nop

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 10             	sub    $0x10,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	68 80 6a 11 80       	push   $0x80116a80
8010168f:	e8 6c 34 00 00       	call   80104b00 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
8010169f:	e8 1c 35 00 00       	call   80104bc0 <release>
}
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a9:	c9                   	leave  
801016aa:	c3                   	ret    
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016b8:	85 db                	test   %ebx,%ebx
801016ba:	0f 84 b7 00 00 00    	je     80101777 <ilock+0xc7>
801016c0:	8b 53 08             	mov    0x8(%ebx),%edx
801016c3:	85 d2                	test   %edx,%edx
801016c5:	0f 8e ac 00 00 00    	jle    80101777 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	50                   	push   %eax
801016d2:	e8 f9 31 00 00       	call   801048d0 <acquiresleep>
  if(ip->valid == 0){
801016d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	85 c0                	test   %eax,%eax
801016df:	74 0f                	je     801016f0 <ilock+0x40>
}
801016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5d                   	pop    %ebp
801016e7:	c3                   	ret    
801016e8:	90                   	nop
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f0:	8b 43 04             	mov    0x4(%ebx),%eax
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	c1 e8 03             	shr    $0x3,%eax
801016f9:	03 05 74 6a 11 80    	add    0x80116a74,%eax
801016ff:	50                   	push   %eax
80101700:	ff 33                	pushl  (%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
80101707:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010171f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	50                   	push   %eax
80101744:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101747:	50                   	push   %eax
80101748:	e8 73 35 00 00       	call   80104cc0 <memmove>
    brelse(bp);
8010174d:	89 34 24             	mov    %esi,(%esp)
80101750:	e8 8b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 77 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	68 b0 7a 10 80       	push   $0x80107ab0
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 aa 7a 10 80       	push   $0x80107aaa
8010177f:	e8 0c ec ff ff       	call   80100390 <panic>
80101784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010178a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	74 28                	je     801017c4 <iunlock+0x34>
8010179c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	56                   	push   %esi
801017a3:	e8 c8 31 00 00       	call   80104970 <holdingsleep>
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 c0                	test   %eax,%eax
801017ad:	74 15                	je     801017c4 <iunlock+0x34>
801017af:	8b 43 08             	mov    0x8(%ebx),%eax
801017b2:	85 c0                	test   %eax,%eax
801017b4:	7e 0e                	jle    801017c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017bc:	5b                   	pop    %ebx
801017bd:	5e                   	pop    %esi
801017be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017bf:	e9 6c 31 00 00       	jmp    80104930 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 bf 7a 10 80       	push   $0x80107abf
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <iput>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 28             	sub    $0x28,%esp
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ef:	57                   	push   %edi
801017f0:	e8 db 30 00 00       	call   801048d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 d2                	test   %edx,%edx
801017fd:	74 07                	je     80101806 <iput+0x26>
801017ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101804:	74 32                	je     80101838 <iput+0x58>
  releasesleep(&ip->lock);
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	57                   	push   %edi
8010180a:	e8 21 31 00 00       	call   80104930 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
80101816:	e8 e5 32 00 00       	call   80104b00 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 80 6a 11 80 	movl   $0x80116a80,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 8b 33 00 00       	jmp    80104bc0 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 80 6a 11 80       	push   $0x80116a80
80101840:	e8 bb 32 00 00       	call   80104b00 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
8010184f:	e8 6c 33 00 00       	call   80104bc0 <release>
    if(r == 1){
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	83 fe 01             	cmp    $0x1,%esi
8010185a:	75 aa                	jne    80101806 <iput+0x26>
8010185c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101862:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101865:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x97>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fe                	cmp    %edi,%esi
80101875:	74 19                	je     80101890 <iput+0xb0>
    if(ip->addrs[i]){
80101877:	8b 16                	mov    (%esi),%edx
80101879:	85 d2                	test   %edx,%edx
8010187b:	74 f3                	je     80101870 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010187d:	8b 03                	mov    (%ebx),%eax
8010187f:	e8 ac fb ff ff       	call   80101430 <bfree>
      ip->addrs[i] = 0;
80101884:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010188a:	eb e4                	jmp    80101870 <iput+0x90>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 33                	jne    801018d0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010189d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018a7:	53                   	push   %ebx
801018a8:	e8 53 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
801018ad:	31 c0                	xor    %eax,%eax
801018af:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018b3:	89 1c 24             	mov    %ebx,(%esp)
801018b6:	e8 45 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018bb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 3c ff ff ff       	jmp    80101806 <iput+0x26>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	ff 33                	pushl  (%ebx)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018e7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	89 cf                	mov    %ecx,%edi
801018ef:	eb 0e                	jmp    801018ff <iput+0x11f>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018fb:	39 fe                	cmp    %edi,%esi
801018fd:	74 0f                	je     8010190e <iput+0x12e>
      if(a[j])
801018ff:	8b 16                	mov    (%esi),%edx
80101901:	85 d2                	test   %edx,%edx
80101903:	74 f3                	je     801018f8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101905:	8b 03                	mov    (%ebx),%eax
80101907:	e8 24 fb ff ff       	call   80101430 <bfree>
8010190c:	eb ea                	jmp    801018f8 <iput+0x118>
    brelse(bp);
8010190e:	83 ec 0c             	sub    $0xc,%esp
80101911:	ff 75 e4             	pushl  -0x1c(%ebp)
80101914:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101917:	e8 c4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010191c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101922:	8b 03                	mov    (%ebx),%eax
80101924:	e8 07 fb ff ff       	call   80101430 <bfree>
    ip->addrs[NDIRECT] = 0;
80101929:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101930:	00 00 00 
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	e9 62 ff ff ff       	jmp    8010189d <iput+0xbd>
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 10             	sub    $0x10,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	53                   	push   %ebx
8010194b:	e8 40 fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101950:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
}
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
  iput(ip);
8010195a:	e9 81 fe ff ff       	jmp    801017e0 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 1c             	sub    $0x1c,%esp
80101999:	8b 45 08             	mov    0x8(%ebp),%eax
8010199c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010199f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019a7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ad:	8b 75 10             	mov    0x10(%ebp),%esi
801019b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b3:	0f 84 a7 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019bc:	8b 40 58             	mov    0x58(%eax),%eax
801019bf:	39 c6                	cmp    %eax,%esi
801019c1:	0f 87 ba 00 00 00    	ja     80101a81 <readi+0xf1>
801019c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ca:	89 f9                	mov    %edi,%ecx
801019cc:	01 f1                	add    %esi,%ecx
801019ce:	0f 82 ad 00 00 00    	jb     80101a81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019d4:	89 c2                	mov    %eax,%edx
801019d6:	29 f2                	sub    %esi,%edx
801019d8:	39 c8                	cmp    %ecx,%eax
801019da:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019dd:	31 ff                	xor    %edi,%edi
801019df:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e4:	74 6c                	je     80101a52 <readi+0xc2>
801019e6:	8d 76 00             	lea    0x0(%esi),%esi
801019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019f3:	89 f2                	mov    %esi,%edx
801019f5:	c1 ea 09             	shr    $0x9,%edx
801019f8:	89 d8                	mov    %ebx,%eax
801019fa:	e8 11 f9 ff ff       	call   80101310 <bmap>
801019ff:	83 ec 08             	sub    $0x8,%esp
80101a02:	50                   	push   %eax
80101a03:	ff 33                	pushl  (%ebx)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0f:	89 f0                	mov    %esi,%eax
80101a11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a1b:	83 c4 0c             	add    $0xc,%esp
80101a1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	29 fb                	sub    %edi,%ebx
80101a29:	39 d9                	cmp    %ebx,%ecx
80101a2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2e:	53                   	push   %ebx
80101a2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a37:	e8 84 32 00 00       	call   80104cc0 <memmove>
    brelse(bp);
80101a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a3f:	89 14 24             	mov    %edx,(%esp)
80101a42:	e8 99 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a50:	77 9e                	ja     801019f0 <readi+0x60>
  }
  return n;
80101a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5f                   	pop    %edi
80101a5b:	5d                   	pop    %ebp
80101a5c:	c3                   	ret    
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 17                	ja     80101a81 <readi+0xf1>
80101a6a:	8b 04 c5 00 6a 11 80 	mov    -0x7fee9600(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 0c                	je     80101a81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7b:	5b                   	pop    %ebx
80101a7c:	5e                   	pop    %esi
80101a7d:	5f                   	pop    %edi
80101a7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a7f:	ff e0                	jmp    *%eax
      return -1;
80101a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a86:	eb cd                	jmp    80101a55 <readi+0xc5>
80101a88:	90                   	nop
80101a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aad:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 eb 00 00 00    	jb     80101bb0 <writei+0x120>
80101ac5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ac8:	31 d2                	xor    %edx,%edx
80101aca:	89 f8                	mov    %edi,%eax
80101acc:	01 f0                	add    %esi,%eax
80101ace:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad6:	0f 87 d4 00 00 00    	ja     80101bb0 <writei+0x120>
80101adc:	85 d2                	test   %edx,%edx
80101ade:	0f 85 cc 00 00 00    	jne    80101bb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae4:	85 ff                	test   %edi,%edi
80101ae6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aed:	74 72                	je     80101b61 <writei+0xd1>
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 f8                	mov    %edi,%eax
80101afa:	e8 11 f8 ff ff       	call   80101310 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 37                	pushl  (%edi)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b12:	89 f0                	mov    %esi,%eax
80101b14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b19:	83 c4 0c             	add    $0xc,%esp
80101b1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	39 d9                	cmp    %ebx,%ecx
80101b29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b2c:	53                   	push   %ebx
80101b2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b32:	50                   	push   %eax
80101b33:	e8 88 31 00 00       	call   80104cc0 <memmove>
    log_write(bp);
80101b38:	89 3c 24             	mov    %edi,(%esp)
80101b3b:	e8 60 12 00 00       	call   80102da0 <log_write>
    brelse(bp);
80101b40:	89 3c 24             	mov    %edi,(%esp)
80101b43:	e8 98 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b57:	77 97                	ja     80101af0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b5f:	77 37                	ja     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b67:	5b                   	pop    %ebx
80101b68:	5e                   	pop    %esi
80101b69:	5f                   	pop    %edi
80101b6a:	5d                   	pop    %ebp
80101b6b:	c3                   	ret    
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 36                	ja     80101bb0 <writei+0x120>
80101b7a:	8b 04 c5 04 6a 11 80 	mov    -0x7fee95fc(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 2b                	je     80101bb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ba1:	50                   	push   %eax
80101ba2:	e8 59 fa ff ff       	call   80101600 <iupdate>
80101ba7:	83 c4 10             	add    $0x10,%esp
80101baa:	eb b5                	jmp    80101b61 <writei+0xd1>
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb5:	eb ad                	jmp    80101b64 <writei+0xd4>
80101bb7:	89 f6                	mov    %esi,%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	6a 0e                	push   $0xe
80101bc8:	ff 75 0c             	pushl  0xc(%ebp)
80101bcb:	ff 75 08             	pushl  0x8(%ebp)
80101bce:	e8 5d 31 00 00       	call   80104d30 <strncmp>
}
80101bd3:	c9                   	leave  
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 85 00 00 00    	jne    80101c7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	74 3e                	je     80101c41 <dirlookup+0x61>
80101c03:	90                   	nop
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c08:	6a 10                	push   $0x10
80101c0a:	57                   	push   %edi
80101c0b:	56                   	push   %esi
80101c0c:	53                   	push   %ebx
80101c0d:	e8 7e fd ff ff       	call   80101990 <readi>
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	83 f8 10             	cmp    $0x10,%eax
80101c18:	75 55                	jne    80101c6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c1f:	74 18                	je     80101c39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c24:	83 ec 04             	sub    $0x4,%esp
80101c27:	6a 0e                	push   $0xe
80101c29:	50                   	push   %eax
80101c2a:	ff 75 0c             	pushl  0xc(%ebp)
80101c2d:	e8 fe 30 00 00       	call   80104d30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 17                	je     80101c50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c39:	83 c7 10             	add    $0x10,%edi
80101c3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c3f:	72 c7                	jb     80101c08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c44:	31 c0                	xor    %eax,%eax
}
80101c46:	5b                   	pop    %ebx
80101c47:	5e                   	pop    %esi
80101c48:	5f                   	pop    %edi
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c50:	8b 45 10             	mov    0x10(%ebp),%eax
80101c53:	85 c0                	test   %eax,%eax
80101c55:	74 05                	je     80101c5c <dirlookup+0x7c>
        *poff = off;
80101c57:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c60:	8b 03                	mov    (%ebx),%eax
80101c62:	e8 d9 f5 ff ff       	call   80101240 <iget>
}
80101c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6a:	5b                   	pop    %ebx
80101c6b:	5e                   	pop    %esi
80101c6c:	5f                   	pop    %edi
80101c6d:	5d                   	pop    %ebp
80101c6e:	c3                   	ret    
      panic("dirlookup read");
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	68 d9 7a 10 80       	push   $0x80107ad9
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 c7 7a 10 80       	push   $0x80107ac7
80101c84:	e8 07 e7 ff ff       	call   80100390 <panic>
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	89 cf                	mov    %ecx,%edi
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 67 01 00 00    	je     80101e10 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 c2 1b 00 00       	call   80103870 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 80 6a 11 80       	push   $0x80116a80
80101cb9:	e8 42 2e 00 00       	call   80104b00 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 80 6a 11 80 	movl   $0x80116a80,(%esp)
80101cc9:	e8 f2 2e 00 00       	call   80104bc0 <release>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	eb 08                	jmp    80101cdb <namex+0x4b>
80101cd3:	90                   	nop
80101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cdb:	0f b6 03             	movzbl (%ebx),%eax
80101cde:	3c 2f                	cmp    $0x2f,%al
80101ce0:	74 f6                	je     80101cd8 <namex+0x48>
  if(*path == 0)
80101ce2:	84 c0                	test   %al,%al
80101ce4:	0f 84 ee 00 00 00    	je     80101dd8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cea:	0f b6 03             	movzbl (%ebx),%eax
80101ced:	3c 2f                	cmp    $0x2f,%al
80101cef:	0f 84 b3 00 00 00    	je     80101da8 <namex+0x118>
80101cf5:	84 c0                	test   %al,%al
80101cf7:	89 da                	mov    %ebx,%edx
80101cf9:	75 09                	jne    80101d04 <namex+0x74>
80101cfb:	e9 a8 00 00 00       	jmp    80101da8 <namex+0x118>
80101d00:	84 c0                	test   %al,%al
80101d02:	74 0a                	je     80101d0e <namex+0x7e>
    path++;
80101d04:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d07:	0f b6 02             	movzbl (%edx),%eax
80101d0a:	3c 2f                	cmp    $0x2f,%al
80101d0c:	75 f2                	jne    80101d00 <namex+0x70>
80101d0e:	89 d1                	mov    %edx,%ecx
80101d10:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d12:	83 f9 0d             	cmp    $0xd,%ecx
80101d15:	0f 8e 91 00 00 00    	jle    80101dac <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d1b:	83 ec 04             	sub    $0x4,%esp
80101d1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d21:	6a 0e                	push   $0xe
80101d23:	53                   	push   %ebx
80101d24:	57                   	push   %edi
80101d25:	e8 96 2f 00 00       	call   80104cc0 <memmove>
    path++;
80101d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d2d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d30:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d32:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d35:	75 11                	jne    80101d48 <namex+0xb8>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	56                   	push   %esi
80101d4c:	e8 5f f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d59:	0f 85 91 00 00 00    	jne    80101df0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d62:	85 d2                	test   %edx,%edx
80101d64:	74 09                	je     80101d6f <namex+0xdf>
80101d66:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d69:	0f 84 b7 00 00 00    	je     80101e26 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6f:	83 ec 04             	sub    $0x4,%esp
80101d72:	6a 00                	push   $0x0
80101d74:	57                   	push   %edi
80101d75:	56                   	push   %esi
80101d76:	e8 65 fe ff ff       	call   80101be0 <dirlookup>
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	85 c0                	test   %eax,%eax
80101d80:	74 6e                	je     80101df0 <namex+0x160>
  iunlock(ip);
80101d82:	83 ec 0c             	sub    $0xc,%esp
80101d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d88:	56                   	push   %esi
80101d89:	e8 02 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	83 c4 10             	add    $0x10,%esp
80101d9c:	89 c6                	mov    %eax,%esi
80101d9e:	e9 38 ff ff ff       	jmp    80101cdb <namex+0x4b>
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101da8:	89 da                	mov    %ebx,%edx
80101daa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dac:	83 ec 04             	sub    $0x4,%esp
80101daf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db5:	51                   	push   %ecx
80101db6:	53                   	push   %ebx
80101db7:	57                   	push   %edi
80101db8:	e8 03 2f 00 00       	call   80104cc0 <memmove>
    name[len] = 0;
80101dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dca:	89 d3                	mov    %edx,%ebx
80101dcc:	e9 61 ff ff ff       	jmp    80101d32 <namex+0xa2>
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	75 5d                	jne    80101e3c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de2:	89 f0                	mov    %esi,%eax
80101de4:	5b                   	pop    %ebx
80101de5:	5e                   	pop    %esi
80101de6:	5f                   	pop    %edi
80101de7:	5d                   	pop    %ebp
80101de8:	c3                   	ret    
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	56                   	push   %esi
80101df4:	e8 97 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101df9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dfc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dfe:	e8 dd f9 ff ff       	call   801017e0 <iput>
      return 0;
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e09:	89 f0                	mov    %esi,%eax
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e10:	ba 01 00 00 00       	mov    $0x1,%edx
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 21 f4 ff ff       	call   80101240 <iget>
80101e1f:	89 c6                	mov    %eax,%esi
80101e21:	e9 b5 fe ff ff       	jmp    80101cdb <namex+0x4b>
      iunlock(ip);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	56                   	push   %esi
80101e2a:	e8 61 f9 ff ff       	call   80101790 <iunlock>
      return ip;
80101e2f:	83 c4 10             	add    $0x10,%esp
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e35:	89 f0                	mov    %esi,%eax
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
    iput(ip);
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	56                   	push   %esi
    return 0;
80101e40:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e42:	e8 99 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	eb 93                	jmp    80101ddf <namex+0x14f>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 20             	sub    $0x20,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	6a 00                	push   $0x0
80101e5e:	ff 75 0c             	pushl  0xc(%ebp)
80101e61:	53                   	push   %ebx
80101e62:	e8 79 fd ff ff       	call   80101be0 <dirlookup>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	75 67                	jne    80101ed5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e74:	85 ff                	test   %edi,%edi
80101e76:	74 29                	je     80101ea1 <dirlink+0x51>
80101e78:	31 ff                	xor    %edi,%edi
80101e7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e7d:	eb 09                	jmp    80101e88 <dirlink+0x38>
80101e7f:	90                   	nop
80101e80:	83 c7 10             	add    $0x10,%edi
80101e83:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e86:	73 19                	jae    80101ea1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e88:	6a 10                	push   $0x10
80101e8a:	57                   	push   %edi
80101e8b:	56                   	push   %esi
80101e8c:	53                   	push   %ebx
80101e8d:	e8 fe fa ff ff       	call   80101990 <readi>
80101e92:	83 c4 10             	add    $0x10,%esp
80101e95:	83 f8 10             	cmp    $0x10,%eax
80101e98:	75 4e                	jne    80101ee8 <dirlink+0x98>
    if(de.inum == 0)
80101e9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9f:	75 df                	jne    80101e80 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ea1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea4:	83 ec 04             	sub    $0x4,%esp
80101ea7:	6a 0e                	push   $0xe
80101ea9:	ff 75 0c             	pushl  0xc(%ebp)
80101eac:	50                   	push   %eax
80101ead:	e8 de 2e 00 00       	call   80104d90 <strncpy>
  de.inum = inum;
80101eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb5:	6a 10                	push   $0x10
80101eb7:	57                   	push   %edi
80101eb8:	56                   	push   %esi
80101eb9:	53                   	push   %ebx
  de.inum = inum;
80101eba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebe:	e8 cd fb ff ff       	call   80101a90 <writei>
80101ec3:	83 c4 20             	add    $0x20,%esp
80101ec6:	83 f8 10             	cmp    $0x10,%eax
80101ec9:	75 2a                	jne    80101ef5 <dirlink+0xa5>
  return 0;
80101ecb:	31 c0                	xor    %eax,%eax
}
80101ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
    iput(ip);
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	50                   	push   %eax
80101ed9:	e8 02 f9 ff ff       	call   801017e0 <iput>
    return -1;
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee6:	eb e5                	jmp    80101ecd <dirlink+0x7d>
      panic("dirlink read");
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 e8 7a 10 80       	push   $0x80107ae8
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 6a 82 10 80       	push   $0x8010826a
80101efd:	e8 8e e4 ff ff       	call   80100390 <panic>
80101f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	0f 84 b4 00 00 00    	je     80102015 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f61:	8b 58 08             	mov    0x8(%eax),%ebx
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f6c:	0f 87 96 00 00 00    	ja     80102008 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f72:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f77:	89 f6                	mov    %esi,%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f80:	89 ca                	mov    %ecx,%edx
80101f82:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f83:	83 e0 c0             	and    $0xffffffc0,%eax
80101f86:	3c 40                	cmp    $0x40,%al
80101f88:	75 f6                	jne    80101f80 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f8a:	31 ff                	xor    %edi,%edi
80101f8c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f91:	89 f8                	mov    %edi,%eax
80101f93:	ee                   	out    %al,(%dx)
80101f94:	b8 01 00 00 00       	mov    $0x1,%eax
80101f99:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9e:	ee                   	out    %al,(%dx)
80101f9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fa4:	89 d8                	mov    %ebx,%eax
80101fa6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fae:	c1 f8 08             	sar    $0x8,%eax
80101fb1:	ee                   	out    %al,(%dx)
80101fb2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fb7:	89 f8                	mov    %edi,%eax
80101fb9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fc3:	c1 e0 04             	shl    $0x4,%eax
80101fc6:	83 e0 10             	and    $0x10,%eax
80101fc9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fcc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fcd:	f6 06 04             	testb  $0x4,(%esi)
80101fd0:	75 16                	jne    80101fe8 <idestart+0x98>
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	89 ca                	mov    %ecx,%edx
80101fd9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdd:	5b                   	pop    %ebx
80101fde:	5e                   	pop    %esi
80101fdf:	5f                   	pop    %edi
80101fe0:	5d                   	pop    %ebp
80101fe1:	c3                   	ret    
80101fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fe8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fed:	89 ca                	mov    %ecx,%edx
80101fef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ff5:	83 c6 5c             	add    $0x5c,%esi
80101ff8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ffd:	fc                   	cld    
80101ffe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102003:	5b                   	pop    %ebx
80102004:	5e                   	pop    %esi
80102005:	5f                   	pop    %edi
80102006:	5d                   	pop    %ebp
80102007:	c3                   	ret    
    panic("incorrect blockno");
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	68 54 7b 10 80       	push   $0x80107b54
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 4b 7b 10 80       	push   $0x80107b4b
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 66 7b 10 80       	push   $0x80107b66
8010203b:	68 00 b6 10 80       	push   $0x8010b600
80102040:	e8 7b 29 00 00       	call   801049c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 a0 8d 11 80       	mov    0x80118da0,%eax
8010204b:	5a                   	pop    %edx
8010204c:	83 e8 01             	sub    $0x1,%eax
8010204f:	50                   	push   %eax
80102050:	6a 0e                	push   $0xe
80102052:	e8 a9 02 00 00       	call   80102300 <ioapicenable>
80102057:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205f:	90                   	nop
80102060:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102061:	83 e0 c0             	and    $0xffffffc0,%eax
80102064:	3c 40                	cmp    $0x40,%al
80102066:	75 f8                	jne    80102060 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102068:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102072:	ee                   	out    %al,(%dx)
80102073:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102078:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207d:	eb 06                	jmp    80102085 <ideinit+0x55>
8010207f:	90                   	nop
  for(i=0; i<1000; i++){
80102080:	83 e9 01             	sub    $0x1,%ecx
80102083:	74 0f                	je     80102094 <ideinit+0x64>
80102085:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102086:	84 c0                	test   %al,%al
80102088:	74 f6                	je     80102080 <ideinit+0x50>
      havedisk1 = 1;
8010208a:	c7 05 e0 b5 10 80 01 	movl   $0x1,0x8010b5e0
80102091:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102094:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102099:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010209e:	ee                   	out    %al,(%dx)
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    
801020a1:	eb 0d                	jmp    801020b0 <ideintr>
801020a3:	90                   	nop
801020a4:	90                   	nop
801020a5:	90                   	nop
801020a6:	90                   	nop
801020a7:	90                   	nop
801020a8:	90                   	nop
801020a9:	90                   	nop
801020aa:	90                   	nop
801020ab:	90                   	nop
801020ac:	90                   	nop
801020ad:	90                   	nop
801020ae:	90                   	nop
801020af:	90                   	nop

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	68 00 b6 10 80       	push   $0x8010b600
801020be:	e8 3d 2a 00 00       	call   80104b00 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d e4 b5 10 80    	mov    0x8010b5e4,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 67                	je     80102137 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 58             	mov    0x58(%ebx),%eax
801020d3:	a3 e4 b5 10 80       	mov    %eax,0x8010b5e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d8:	8b 3b                	mov    (%ebx),%edi
801020da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020e0:	75 31                	jne    80102113 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020e7:	89 f6                	mov    %esi,%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c6                	mov    %eax,%esi
801020f3:	83 e6 c0             	and    $0xffffffc0,%esi
801020f6:	89 f1                	mov    %esi,%ecx
801020f8:	80 f9 40             	cmp    $0x40,%cl
801020fb:	75 f3                	jne    801020f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fd:	a8 21                	test   $0x21,%al
801020ff:	75 12                	jne    80102113 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102101:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102104:	b9 80 00 00 00       	mov    $0x80,%ecx
80102109:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210e:	fc                   	cld    
8010210f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102111:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102113:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102116:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102119:	89 f9                	mov    %edi,%ecx
8010211b:	83 c9 02             	or     $0x2,%ecx
8010211e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102120:	53                   	push   %ebx
80102121:	e8 da 1e 00 00       	call   80104000 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102126:	a1 e4 b5 10 80       	mov    0x8010b5e4,%eax
8010212b:	83 c4 10             	add    $0x10,%esp
8010212e:	85 c0                	test   %eax,%eax
80102130:	74 05                	je     80102137 <ideintr+0x87>
    idestart(idequeue);
80102132:	e8 19 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
80102137:	83 ec 0c             	sub    $0xc,%esp
8010213a:	68 00 b6 10 80       	push   $0x8010b600
8010213f:	e8 7c 2a 00 00       	call   80104bc0 <release>

  release(&idelock);
}
80102144:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102147:	5b                   	pop    %ebx
80102148:	5e                   	pop    %esi
80102149:	5f                   	pop    %edi
8010214a:	5d                   	pop    %ebp
8010214b:	c3                   	ret    
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 10             	sub    $0x10,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	50                   	push   %eax
8010215e:	e8 0d 28 00 00       	call   80104970 <holdingsleep>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	85 c0                	test   %eax,%eax
80102168:	0f 84 c6 00 00 00    	je     80102234 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	0f 84 ab 00 00 00    	je     80102227 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217c:	8b 53 04             	mov    0x4(%ebx),%edx
8010217f:	85 d2                	test   %edx,%edx
80102181:	74 0d                	je     80102190 <iderw+0x40>
80102183:	a1 e0 b5 10 80       	mov    0x8010b5e0,%eax
80102188:	85 c0                	test   %eax,%eax
8010218a:	0f 84 b1 00 00 00    	je     80102241 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	68 00 b6 10 80       	push   $0x8010b600
80102198:	e8 63 29 00 00       	call   80104b00 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 e4 b5 10 80    	mov    0x8010b5e4,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 6d                	jmp    80102220 <iderw+0xd0>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 58             	mov    0x58(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c6:	39 1d e4 b5 10 80    	cmp    %ebx,0x8010b5e4
801021cc:	74 42                	je     80102210 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 e0 06             	and    $0x6,%eax
801021d3:	83 f8 02             	cmp    $0x2,%eax
801021d6:	74 23                	je     801021fb <iderw+0xab>
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	68 00 b6 10 80       	push   $0x8010b600
801021e8:	53                   	push   %ebx
801021e9:	e8 52 1c 00 00       	call   80103e40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	83 e0 06             	and    $0x6,%eax
801021f6:	83 f8 02             	cmp    $0x2,%eax
801021f9:	75 e5                	jne    801021e0 <iderw+0x90>
  }


  release(&idelock);
801021fb:	c7 45 08 00 b6 10 80 	movl   $0x8010b600,0x8(%ebp)
}
80102202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102205:	c9                   	leave  
  release(&idelock);
80102206:	e9 b5 29 00 00       	jmp    80104bc0 <release>
8010220b:	90                   	nop
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102210:	89 d8                	mov    %ebx,%eax
80102212:	e8 39 fd ff ff       	call   80101f50 <idestart>
80102217:	eb b5                	jmp    801021ce <iderw+0x7e>
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102220:	ba e4 b5 10 80       	mov    $0x8010b5e4,%edx
80102225:	eb 9d                	jmp    801021c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 80 7b 10 80       	push   $0x80107b80
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 6a 7b 10 80       	push   $0x80107b6a
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 95 7b 10 80       	push   $0x80107b95
80102249:	e8 42 e1 ff ff       	call   80100390 <panic>
8010224e:	66 90                	xchg   %ax,%ax

80102250 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102251:	c7 05 d4 86 11 80 00 	movl   $0xfec00000,0x801186d4
80102258:	00 c0 fe 
{
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	56                   	push   %esi
8010225e:	53                   	push   %ebx
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	a1 d4 86 11 80       	mov    0x801186d4,%eax
8010226e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102277:	8b 0d d4 86 11 80    	mov    0x801186d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227d:	0f b6 15 00 88 11 80 	movzbl 0x80118800,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102284:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102287:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010228a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010228d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102290:	39 c2                	cmp    %eax,%edx
80102292:	74 16                	je     801022aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102294:	83 ec 0c             	sub    $0xc,%esp
80102297:	68 b4 7b 10 80       	push   $0x80107bb4
8010229c:	e8 bf e3 ff ff       	call   80100660 <cprintf>
801022a1:	8b 0d d4 86 11 80    	mov    0x801186d4,%ecx
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	83 c3 21             	add    $0x21,%ebx
{
801022ad:	ba 10 00 00 00       	mov    $0x10,%edx
801022b2:	b8 20 00 00 00       	mov    $0x20,%eax
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022c2:	8b 0d d4 86 11 80    	mov    0x801186d4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022c8:	89 c6                	mov    %eax,%esi
801022ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022d3:	89 71 10             	mov    %esi,0x10(%ecx)
801022d6:	8d 72 01             	lea    0x1(%edx),%esi
801022d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022e0:	8b 0d d4 86 11 80    	mov    0x801186d4,%ecx
801022e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022ed:	75 d1                	jne    801022c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	8d 76 00             	lea    0x0(%esi),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102300:	55                   	push   %ebp
  ioapic->reg = reg;
80102301:	8b 0d d4 86 11 80    	mov    0x801186d4,%ecx
{
80102307:	89 e5                	mov    %esp,%ebp
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010230c:	8d 50 20             	lea    0x20(%eax),%edx
8010230f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102313:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102315:	8b 0d d4 86 11 80    	mov    0x801186d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010231e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102321:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102324:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102326:	a1 d4 86 11 80       	mov    0x801186d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010232e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102331:	5d                   	pop    %ebp
80102332:	c3                   	ret    
80102333:	66 90                	xchg   %ax,%ax
80102335:	66 90                	xchg   %ax,%ax
80102337:	66 90                	xchg   %ax,%ax
80102339:	66 90                	xchg   %ax,%ax
8010233b:	66 90                	xchg   %ax,%ax
8010233d:	66 90                	xchg   %ax,%ax
8010233f:	90                   	nop

80102340 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 04             	sub    $0x4,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010234a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102350:	75 70                	jne    801023c2 <kfree+0x82>
80102352:	81 fb c8 e1 11 80    	cmp    $0x8011e1c8,%ebx
80102358:	72 68                	jb     801023c2 <kfree+0x82>
8010235a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102360:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102365:	77 5b                	ja     801023c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102367:	83 ec 04             	sub    $0x4,%esp
8010236a:	68 00 10 00 00       	push   $0x1000
8010236f:	6a 01                	push   $0x1
80102371:	53                   	push   %ebx
80102372:	e8 99 28 00 00       	call   80104c10 <memset>

  if(kmem.use_lock)
80102377:	8b 15 14 87 11 80    	mov    0x80118714,%edx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 d2                	test   %edx,%edx
80102382:	75 2c                	jne    801023b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102384:	a1 18 87 11 80       	mov    0x80118718,%eax
80102389:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010238b:	a1 14 87 11 80       	mov    0x80118714,%eax
  kmem.freelist = r;
80102390:	89 1d 18 87 11 80    	mov    %ebx,0x80118718
  if(kmem.use_lock)
80102396:	85 c0                	test   %eax,%eax
80102398:	75 06                	jne    801023a0 <kfree+0x60>
    release(&kmem.lock);
}
8010239a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239d:	c9                   	leave  
8010239e:	c3                   	ret    
8010239f:	90                   	nop
    release(&kmem.lock);
801023a0:	c7 45 08 e0 86 11 80 	movl   $0x801186e0,0x8(%ebp)
}
801023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023aa:	c9                   	leave  
    release(&kmem.lock);
801023ab:	e9 10 28 00 00       	jmp    80104bc0 <release>
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 e0 86 11 80       	push   $0x801186e0
801023b8:	e8 43 27 00 00       	call   80104b00 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 e6 7b 10 80       	push   $0x80107be6
801023ca:	e8 c1 df ff ff       	call   80100390 <panic>
801023cf:	90                   	nop

801023d0 <freerange>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ed:	39 de                	cmp    %ebx,%esi
801023ef:	72 23                	jb     80102414 <freerange+0x44>
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102401:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102407:	50                   	push   %eax
80102408:	e8 33 ff ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	39 f3                	cmp    %esi,%ebx
80102412:	76 e4                	jbe    801023f8 <freerange+0x28>
}
80102414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102417:	5b                   	pop    %ebx
80102418:	5e                   	pop    %esi
80102419:	5d                   	pop    %ebp
8010241a:	c3                   	ret    
8010241b:	90                   	nop
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102420 <kinit1>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102428:	83 ec 08             	sub    $0x8,%esp
8010242b:	68 ec 7b 10 80       	push   $0x80107bec
80102430:	68 e0 86 11 80       	push   $0x801186e0
80102435:	e8 86 25 00 00       	call   801049c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102440:	c7 05 14 87 11 80 00 	movl   $0x0,0x80118714
80102447:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102450:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102456:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245c:	39 de                	cmp    %ebx,%esi
8010245e:	72 1c                	jb     8010247c <kinit1+0x5c>
    kfree(p);
80102460:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102466:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102469:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010246f:	50                   	push   %eax
80102470:	e8 cb fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102475:	83 c4 10             	add    $0x10,%esp
80102478:	39 de                	cmp    %ebx,%esi
8010247a:	73 e4                	jae    80102460 <kinit1+0x40>
}
8010247c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010247f:	5b                   	pop    %ebx
80102480:	5e                   	pop    %esi
80102481:	5d                   	pop    %ebp
80102482:	c3                   	ret    
80102483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102495:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102498:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <kinit2+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 73 fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 de                	cmp    %ebx,%esi
801024d2:	73 e4                	jae    801024b8 <kinit2+0x28>
  kmem.use_lock = 1;
801024d4:	c7 05 14 87 11 80 01 	movl   $0x1,0x80118714
801024db:	00 00 00 
}
801024de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e1:	5b                   	pop    %ebx
801024e2:	5e                   	pop    %esi
801024e3:	5d                   	pop    %ebp
801024e4:	c3                   	ret    
801024e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024f0:	a1 14 87 11 80       	mov    0x80118714,%eax
801024f5:	85 c0                	test   %eax,%eax
801024f7:	75 1f                	jne    80102518 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f9:	a1 18 87 11 80       	mov    0x80118718,%eax
  if(r)
801024fe:	85 c0                	test   %eax,%eax
80102500:	74 0e                	je     80102510 <kalloc+0x20>
    kmem.freelist = r->next;
80102502:	8b 10                	mov    (%eax),%edx
80102504:	89 15 18 87 11 80    	mov    %edx,0x80118718
8010250a:	c3                   	ret    
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102510:	f3 c3                	repz ret 
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102518:	55                   	push   %ebp
80102519:	89 e5                	mov    %esp,%ebp
8010251b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010251e:	68 e0 86 11 80       	push   $0x801186e0
80102523:	e8 d8 25 00 00       	call   80104b00 <acquire>
  r = kmem.freelist;
80102528:	a1 18 87 11 80       	mov    0x80118718,%eax
  if(r)
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	8b 15 14 87 11 80    	mov    0x80118714,%edx
80102536:	85 c0                	test   %eax,%eax
80102538:	74 08                	je     80102542 <kalloc+0x52>
    kmem.freelist = r->next;
8010253a:	8b 08                	mov    (%eax),%ecx
8010253c:	89 0d 18 87 11 80    	mov    %ecx,0x80118718
  if(kmem.use_lock)
80102542:	85 d2                	test   %edx,%edx
80102544:	74 16                	je     8010255c <kalloc+0x6c>
    release(&kmem.lock);
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010254c:	68 e0 86 11 80       	push   $0x801186e0
80102551:	e8 6a 26 00 00       	call   80104bc0 <release>
  return (char*)r;
80102556:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102559:	83 c4 10             	add    $0x10,%esp
}
8010255c:	c9                   	leave  
8010255d:	c3                   	ret    
8010255e:	66 90                	xchg   %ax,%ax

80102560 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba 64 00 00 00       	mov    $0x64,%edx
80102565:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102566:	a8 01                	test   $0x1,%al
80102568:	0f 84 c2 00 00 00    	je     80102630 <kbdgetc+0xd0>
8010256e:	ba 60 00 00 00       	mov    $0x60,%edx
80102573:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102574:	0f b6 d0             	movzbl %al,%edx
80102577:	8b 0d 34 b6 10 80    	mov    0x8010b634,%ecx

  if(data == 0xE0){
8010257d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102583:	0f 84 7f 00 00 00    	je     80102608 <kbdgetc+0xa8>
{
80102589:	55                   	push   %ebp
8010258a:	89 e5                	mov    %esp,%ebp
8010258c:	53                   	push   %ebx
8010258d:	89 cb                	mov    %ecx,%ebx
8010258f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102592:	84 c0                	test   %al,%al
80102594:	78 4a                	js     801025e0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102596:	85 db                	test   %ebx,%ebx
80102598:	74 09                	je     801025a3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010259a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010259d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025a0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025a3:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%eax
801025b3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025b7:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
  c = charcode[shift & (CTL | SHIFT)][data];
801025bd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025c0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c3:	8b 04 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%eax
801025ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ce:	74 31                	je     80102601 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025d0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025d3:	83 fa 19             	cmp    $0x19,%edx
801025d6:	77 40                	ja     80102618 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025d8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025db:	5b                   	pop    %ebx
801025dc:	5d                   	pop    %ebp
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025e0:	83 e0 7f             	and    $0x7f,%eax
801025e3:	85 db                	test   %ebx,%ebx
801025e5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025e8:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
801025ef:	83 c8 40             	or     $0x40,%eax
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	f7 d0                	not    %eax
801025f7:	21 c1                	and    %eax,%ecx
    return 0;
801025f9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025fb:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
}
80102601:	5b                   	pop    %ebx
80102602:	5d                   	pop    %ebp
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102608:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010260b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010260d:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
    return 0;
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102618:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010261b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010261e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010261f:	83 f9 1a             	cmp    $0x1a,%ecx
80102622:	0f 42 c2             	cmovb  %edx,%eax
}
80102625:	5d                   	pop    %ebp
80102626:	c3                   	ret    
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102635:	c3                   	ret    
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <kbdintr>:

void
kbdintr(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102646:	68 60 25 10 80       	push   $0x80102560
8010264b:	e8 c0 e1 ff ff       	call   80100810 <consoleintr>
}
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	c9                   	leave  
80102654:	c3                   	ret    
80102655:	66 90                	xchg   %ax,%ax
80102657:	66 90                	xchg   %ax,%ax
80102659:	66 90                	xchg   %ax,%ax
8010265b:	66 90                	xchg   %ax,%ax
8010265d:	66 90                	xchg   %ax,%ax
8010265f:	90                   	nop

80102660 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 1c 87 11 80       	mov    0x8011871c,%eax
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c8 00 00 00    	je     80102738 <lapicinit+0xd8>
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 77                	ja     80102740 <lapicinit+0xe0>
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102720:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102726:	80 e6 10             	and    $0x10,%dh
80102729:	75 f5                	jne    80102720 <lapicinit+0xc0>
  lapic[index] = value;
8010272b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102732:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102735:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102740:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102747:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
8010274d:	e9 77 ff ff ff       	jmp    801026c9 <lapicinit+0x69>
80102752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102760:	8b 15 1c 87 11 80    	mov    0x8011871c,%edx
{
80102766:	55                   	push   %ebp
80102767:	31 c0                	xor    %eax,%eax
80102769:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010276b:	85 d2                	test   %edx,%edx
8010276d:	74 06                	je     80102775 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010276f:	8b 42 20             	mov    0x20(%edx),%eax
80102772:	c1 e8 18             	shr    $0x18,%eax
}
80102775:	5d                   	pop    %ebp
80102776:	c3                   	ret    
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 1c 87 11 80       	mov    0x8011871c,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027b6:	ba 70 00 00 00       	mov    $0x70,%edx
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	53                   	push   %ebx
801027be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	ba 71 00 00 00       	mov    $0x71,%edx
801027cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027dd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027e0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027e3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ee:	a1 1c 87 11 80       	mov    0x8011871c,%eax
801027f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102803:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102809:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102810:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102813:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102816:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010281f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102828:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	b8 0b 00 00 00       	mov    $0xb,%eax
80102846:	ba 70 00 00 00       	mov    $0x70,%edx
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	ba 71 00 00 00       	mov    $0x71,%edx
80102859:	ec                   	in     (%dx),%al
8010285a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010285d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102862:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102865:	8d 76 00             	lea    0x0(%esi),%esi
80102868:	31 c0                	xor    %eax,%eax
8010286a:	89 da                	mov    %ebx,%edx
8010286c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102872:	89 ca                	mov    %ecx,%edx
80102874:	ec                   	in     (%dx),%al
80102875:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	89 da                	mov    %ebx,%edx
8010287a:	b8 02 00 00 00       	mov    $0x2,%eax
8010287f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	89 ca                	mov    %ecx,%edx
80102882:	ec                   	in     (%dx),%al
80102883:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102886:	89 da                	mov    %ebx,%edx
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
80102891:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 da                	mov    %ebx,%edx
80102896:	b8 07 00 00 00       	mov    $0x7,%eax
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
8010289f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 da                	mov    %ebx,%edx
801028a4:	b8 08 00 00 00       	mov    $0x8,%eax
801028a9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028aa:	89 ca                	mov    %ecx,%edx
801028ac:	ec                   	in     (%dx),%al
801028ad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028af:	89 da                	mov    %ebx,%edx
801028b1:	b8 09 00 00 00       	mov    $0x9,%eax
801028b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b7:	89 ca                	mov    %ecx,%edx
801028b9:	ec                   	in     (%dx),%al
801028ba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	89 ca                	mov    %ecx,%edx
801028c6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028c7:	84 c0                	test   %al,%al
801028c9:	78 9d                	js     80102868 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028cb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028cf:	89 fa                	mov    %edi,%edx
801028d1:	0f b6 fa             	movzbl %dl,%edi
801028d4:	89 f2                	mov    %esi,%edx
801028d6:	0f b6 f2             	movzbl %dl,%esi
801028d9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028dc:	89 da                	mov    %ebx,%edx
801028de:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028e4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028eb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028f2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028f9:	31 c0                	xor    %eax,%eax
801028fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	89 ca                	mov    %ecx,%edx
801028fe:	ec                   	in     (%dx),%al
801028ff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102902:	89 da                	mov    %ebx,%edx
80102904:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102907:	b8 02 00 00 00       	mov    $0x2,%eax
8010290c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	89 ca                	mov    %ecx,%edx
8010290f:	ec                   	in     (%dx),%al
80102910:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102913:	89 da                	mov    %ebx,%edx
80102915:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102918:	b8 04 00 00 00       	mov    $0x4,%eax
8010291d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291e:	89 ca                	mov    %ecx,%edx
80102920:	ec                   	in     (%dx),%al
80102921:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102924:	89 da                	mov    %ebx,%edx
80102926:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102929:	b8 07 00 00 00       	mov    $0x7,%eax
8010292e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292f:	89 ca                	mov    %ecx,%edx
80102931:	ec                   	in     (%dx),%al
80102932:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	89 da                	mov    %ebx,%edx
80102937:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010293a:	b8 08 00 00 00       	mov    $0x8,%eax
8010293f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
80102943:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 da                	mov    %ebx,%edx
80102948:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010294b:	b8 09 00 00 00       	mov    $0x9,%eax
80102950:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102951:	89 ca                	mov    %ecx,%edx
80102953:	ec                   	in     (%dx),%al
80102954:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102957:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010295a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010295d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102960:	6a 18                	push   $0x18
80102962:	50                   	push   %eax
80102963:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102966:	50                   	push   %eax
80102967:	e8 f4 22 00 00       	call   80104c60 <memcmp>
8010296c:	83 c4 10             	add    $0x10,%esp
8010296f:	85 c0                	test   %eax,%eax
80102971:	0f 85 f1 fe ff ff    	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102977:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010297b:	75 78                	jne    801029f5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010297d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102980:	89 c2                	mov    %eax,%edx
80102982:	83 e0 0f             	and    $0xf,%eax
80102985:	c1 ea 04             	shr    $0x4,%edx
80102988:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102991:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102994:	89 c2                	mov    %eax,%edx
80102996:	83 e0 0f             	and    $0xf,%eax
80102999:	c1 ea 04             	shr    $0x4,%edx
8010299c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a8:	89 c2                	mov    %eax,%edx
801029aa:	83 e0 0f             	and    $0xf,%eax
801029ad:	c1 ea 04             	shr    $0x4,%edx
801029b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029bc:	89 c2                	mov    %eax,%edx
801029be:	83 e0 0f             	and    $0xf,%eax
801029c1:	c1 ea 04             	shr    $0x4,%edx
801029c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029d0:	89 c2                	mov    %eax,%edx
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	c1 ea 04             	shr    $0x4,%edx
801029d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029de:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e4:	89 c2                	mov    %eax,%edx
801029e6:	83 e0 0f             	and    $0xf,%eax
801029e9:	c1 ea 04             	shr    $0x4,%edx
801029ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029f5:	8b 75 08             	mov    0x8(%ebp),%esi
801029f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029fb:	89 06                	mov    %eax,(%esi)
801029fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a00:	89 46 04             	mov    %eax,0x4(%esi)
80102a03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a06:	89 46 08             	mov    %eax,0x8(%esi)
80102a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a12:	89 46 10             	mov    %eax,0x10(%esi)
80102a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a25:	5b                   	pop    %ebx
80102a26:	5e                   	pop    %esi
80102a27:	5f                   	pop    %edi
80102a28:	5d                   	pop    %ebp
80102a29:	c3                   	ret    
80102a2a:	66 90                	xchg   %ax,%ax
80102a2c:	66 90                	xchg   %ax,%ax
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a30:	8b 0d 68 87 11 80    	mov    0x80118768,%ecx
80102a36:	85 c9                	test   %ecx,%ecx
80102a38:	0f 8e 8a 00 00 00    	jle    80102ac8 <install_trans+0x98>
{
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	57                   	push   %edi
80102a42:	56                   	push   %esi
80102a43:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a44:	31 db                	xor    %ebx,%ebx
{
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a50:	a1 54 87 11 80       	mov    0x80118754,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 64 87 11 80    	pushl  0x80118764
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d 6c 87 11 80 	pushl  -0x7fee7894(,%ebx,4)
80102a74:	ff 35 64 87 11 80    	pushl  0x80118764
  for (tail = 0; tail < log.lh.n; tail++) {
80102a7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7d:	e8 4e d6 ff ff       	call   801000d0 <bread>
80102a82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a87:	83 c4 0c             	add    $0xc,%esp
80102a8a:	68 00 02 00 00       	push   $0x200
80102a8f:	50                   	push   %eax
80102a90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a93:	50                   	push   %eax
80102a94:	e8 27 22 00 00       	call   80104cc0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 ff d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102aa1:	89 3c 24             	mov    %edi,(%esp)
80102aa4:	e8 37 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 2f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ab1:	83 c4 10             	add    $0x10,%esp
80102ab4:	39 1d 68 87 11 80    	cmp    %ebx,0x80118768
80102aba:	7f 94                	jg     80102a50 <install_trans+0x20>
  }
}
80102abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102abf:	5b                   	pop    %ebx
80102ac0:	5e                   	pop    %esi
80102ac1:	5f                   	pop    %edi
80102ac2:	5d                   	pop    %ebp
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ac8:	f3 c3                	repz ret 
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ad5:	83 ec 08             	sub    $0x8,%esp
80102ad8:	ff 35 54 87 11 80    	pushl  0x80118754
80102ade:	ff 35 64 87 11 80    	pushl  0x80118764
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae9:	8b 1d 68 87 11 80    	mov    0x80118768,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102af2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102af4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102af6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102af9:	7e 16                	jle    80102b11 <write_head+0x41>
80102afb:	c1 e3 02             	shl    $0x2,%ebx
80102afe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b00:	8b 8a 6c 87 11 80    	mov    -0x7fee7894(%edx),%ecx
80102b06:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b0a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <write_head+0x30>
  }
  bwrite(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	56                   	push   %esi
80102b15:	e8 86 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b1a:	89 34 24             	mov    %esi,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>
}
80102b22:	83 c4 10             	add    $0x10,%esp
80102b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b28:	5b                   	pop    %ebx
80102b29:	5e                   	pop    %esi
80102b2a:	5d                   	pop    %ebp
80102b2b:	c3                   	ret    
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <initlog>:
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 2c             	sub    $0x2c,%esp
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b3a:	68 20 7e 10 80       	push   $0x80107e20
80102b3f:	68 20 87 11 80       	push   $0x80118720
80102b44:	e8 77 1e 00 00       	call   801049c0 <initlock>
  readsb(dev, &sb);
80102b49:	58                   	pop    %eax
80102b4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 9b e8 ff ff       	call   801013f0 <readsb>
  log.size = sb.nlog;
80102b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b5b:	59                   	pop    %ecx
  log.dev = dev;
80102b5c:	89 1d 64 87 11 80    	mov    %ebx,0x80118764
  log.size = sb.nlog;
80102b62:	89 15 58 87 11 80    	mov    %edx,0x80118758
  log.start = sb.logstart;
80102b68:	a3 54 87 11 80       	mov    %eax,0x80118754
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	5a                   	pop    %edx
80102b6e:	50                   	push   %eax
80102b6f:	53                   	push   %ebx
80102b70:	e8 5b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b75:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b7d:	89 1d 68 87 11 80    	mov    %ebx,0x80118768
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	c1 e3 02             	shl    $0x2,%ebx
80102b88:	31 d2                	xor    %edx,%edx
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a 68 87 11 80    	mov    %ecx,-0x7fee7898(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b9d:	39 d3                	cmp    %edx,%ebx
80102b9f:	75 ef                	jne    80102b90 <initlog+0x60>
  brelse(buf);
80102ba1:	83 ec 0c             	sub    $0xc,%esp
80102ba4:	50                   	push   %eax
80102ba5:	e8 36 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102baa:	e8 81 fe ff ff       	call   80102a30 <install_trans>
  log.lh.n = 0;
80102baf:	c7 05 68 87 11 80 00 	movl   $0x0,0x80118768
80102bb6:	00 00 00 
  write_head(); // clear the log
80102bb9:	e8 12 ff ff ff       	call   80102ad0 <write_head>
}
80102bbe:	83 c4 10             	add    $0x10,%esp
80102bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc4:	c9                   	leave  
80102bc5:	c3                   	ret    
80102bc6:	8d 76 00             	lea    0x0(%esi),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bd6:	68 20 87 11 80       	push   $0x80118720
80102bdb:	e8 20 1f 00 00       	call   80104b00 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 20 87 11 80       	push   $0x80118720
80102bf0:	68 20 87 11 80       	push   $0x80118720
80102bf5:	e8 46 12 00 00       	call   80103e40 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bfd:	a1 60 87 11 80       	mov    0x80118760,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 5c 87 11 80       	mov    0x8011875c,%eax
80102c0b:	8b 15 68 87 11 80    	mov    0x80118768,%edx
80102c11:	83 c0 01             	add    $0x1,%eax
80102c14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c1a:	83 fa 1e             	cmp    $0x1e,%edx
80102c1d:	7f c9                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c22:	a3 5c 87 11 80       	mov    %eax,0x8011875c
      release(&log.lock);
80102c27:	68 20 87 11 80       	push   $0x80118720
80102c2c:	e8 8f 1f 00 00       	call   80104bc0 <release>
      break;
    }
  }
}
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	68 20 87 11 80       	push   $0x80118720
80102c4e:	e8 ad 1e 00 00       	call   80104b00 <acquire>
  log.outstanding -= 1;
80102c53:	a1 5c 87 11 80       	mov    0x8011875c,%eax
  if(log.committing)
80102c58:	8b 35 60 87 11 80    	mov    0x80118760,%esi
80102c5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c66:	89 1d 5c 87 11 80    	mov    %ebx,0x8011875c
  if(log.committing)
80102c6c:	0f 85 1a 01 00 00    	jne    80102d8c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c72:	85 db                	test   %ebx,%ebx
80102c74:	0f 85 ee 00 00 00    	jne    80102d68 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c7a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c7d:	c7 05 60 87 11 80 01 	movl   $0x1,0x80118760
80102c84:	00 00 00 
  release(&log.lock);
80102c87:	68 20 87 11 80       	push   $0x80118720
80102c8c:	e8 2f 1f 00 00       	call   80104bc0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c91:	8b 0d 68 87 11 80    	mov    0x80118768,%ecx
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	85 c9                	test   %ecx,%ecx
80102c9c:	0f 8e 85 00 00 00    	jle    80102d27 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca2:	a1 54 87 11 80       	mov    0x80118754,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	01 d8                	add    %ebx,%eax
80102cac:	83 c0 01             	add    $0x1,%eax
80102caf:	50                   	push   %eax
80102cb0:	ff 35 64 87 11 80    	pushl  0x80118764
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	58                   	pop    %eax
80102cbe:	5a                   	pop    %edx
80102cbf:	ff 34 9d 6c 87 11 80 	pushl  -0x7fee7894(,%ebx,4)
80102cc6:	ff 35 64 87 11 80    	pushl  0x80118764
  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccf:	e8 fc d3 ff ff       	call   801000d0 <bread>
80102cd4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cd6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cd9:	83 c4 0c             	add    $0xc,%esp
80102cdc:	68 00 02 00 00       	push   $0x200
80102ce1:	50                   	push   %eax
80102ce2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ce5:	50                   	push   %eax
80102ce6:	e8 d5 1f 00 00       	call   80104cc0 <memmove>
    bwrite(to);  // write the log
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ad d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cf3:	89 3c 24             	mov    %edi,(%esp)
80102cf6:	e8 e5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 dd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d03:	83 c4 10             	add    $0x10,%esp
80102d06:	3b 1d 68 87 11 80    	cmp    0x80118768,%ebx
80102d0c:	7c 94                	jl     80102ca2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d0e:	e8 bd fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d13:	e8 18 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d18:	c7 05 68 87 11 80 00 	movl   $0x0,0x80118768
80102d1f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d22:	e8 a9 fd ff ff       	call   80102ad0 <write_head>
    acquire(&log.lock);
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 20 87 11 80       	push   $0x80118720
80102d2f:	e8 cc 1d 00 00       	call   80104b00 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 20 87 11 80 	movl   $0x80118720,(%esp)
    log.committing = 0;
80102d3b:	c7 05 60 87 11 80 00 	movl   $0x0,0x80118760
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 b6 12 00 00       	call   80104000 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 20 87 11 80 	movl   $0x80118720,(%esp)
80102d51:	e8 6a 1e 00 00       	call   80104bc0 <release>
80102d56:	83 c4 10             	add    $0x10,%esp
}
80102d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5c:	5b                   	pop    %ebx
80102d5d:	5e                   	pop    %esi
80102d5e:	5f                   	pop    %edi
80102d5f:	5d                   	pop    %ebp
80102d60:	c3                   	ret    
80102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d68:	83 ec 0c             	sub    $0xc,%esp
80102d6b:	68 20 87 11 80       	push   $0x80118720
80102d70:	e8 8b 12 00 00       	call   80104000 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 20 87 11 80 	movl   $0x80118720,(%esp)
80102d7c:	e8 3f 1e 00 00       	call   80104bc0 <release>
80102d81:	83 c4 10             	add    $0x10,%esp
}
80102d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d87:	5b                   	pop    %ebx
80102d88:	5e                   	pop    %esi
80102d89:	5f                   	pop    %edi
80102d8a:	5d                   	pop    %ebp
80102d8b:	c3                   	ret    
    panic("log.committing");
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 24 7e 10 80       	push   $0x80107e24
80102d94:	e8 f7 d5 ff ff       	call   80100390 <panic>
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102da0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da7:	8b 15 68 87 11 80    	mov    0x80118768,%edx
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 9d 00 00 00    	jg     80102e56 <log_write+0xb6>
80102db9:	a1 58 87 11 80       	mov    0x80118758,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 8d 00 00 00    	jge    80102e56 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 5c 87 11 80       	mov    0x8011875c,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 8d 00 00 00    	jle    80102e63 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 20 87 11 80       	push   $0x80118720
80102dde:	e8 1d 1d 00 00       	call   80104b00 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 0d 68 87 11 80    	mov    0x80118768,%ecx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 f9 00             	cmp    $0x0,%ecx
80102def:	7e 57                	jle    80102e48 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 15 6c 87 11 80    	cmp    0x8011876c,%edx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 14 85 6c 87 11 80 	cmp    %edx,-0x7fee7894(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 c1                	cmp    %eax,%ecx
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 14 85 6c 87 11 80 	mov    %edx,-0x7fee7894(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c0 01             	add    $0x1,%eax
80102e1a:	a3 68 87 11 80       	mov    %eax,0x80118768
  b->flags |= B_DIRTY; // prevent eviction
80102e1f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e22:	c7 45 08 20 87 11 80 	movl   $0x80118720,0x8(%ebp)
}
80102e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2c:	c9                   	leave  
  release(&log.lock);
80102e2d:	e9 8e 1d 00 00       	jmp    80104bc0 <release>
80102e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e38:	89 14 85 6c 87 11 80 	mov    %edx,-0x7fee7894(,%eax,4)
80102e3f:	eb de                	jmp    80102e1f <log_write+0x7f>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8b 43 08             	mov    0x8(%ebx),%eax
80102e4b:	a3 6c 87 11 80       	mov    %eax,0x8011876c
  if (i == log.lh.n)
80102e50:	75 cd                	jne    80102e1f <log_write+0x7f>
80102e52:	31 c0                	xor    %eax,%eax
80102e54:	eb c1                	jmp    80102e17 <log_write+0x77>
    panic("too big a transaction");
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 33 7e 10 80       	push   $0x80107e33
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 49 7e 10 80       	push   $0x80107e49
80102e6b:	e8 20 d5 ff ff       	call   80100390 <panic>

80102e70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e77:	e8 d4 09 00 00       	call   80103850 <cpuid>
80102e7c:	89 c3                	mov    %eax,%ebx
80102e7e:	e8 cd 09 00 00       	call   80103850 <cpuid>
80102e83:	83 ec 04             	sub    $0x4,%esp
80102e86:	53                   	push   %ebx
80102e87:	50                   	push   %eax
80102e88:	68 64 7e 10 80       	push   $0x80107e64
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e92:	e8 09 33 00 00       	call   801061a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e97:	e8 34 09 00 00       	call   801037d0 <mycpu>
80102e9c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e9e:	b8 01 00 00 00       	mov    $0x1,%eax
80102ea3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eaa:	e8 b1 0c 00 00       	call   80103b60 <scheduler>
80102eaf:	90                   	nop

80102eb0 <mpenter>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 d5 43 00 00       	call   80107290 <switchkvm>
  seginit();
80102ebb:	e8 40 43 00 00       	call   80107200 <seginit>
  lapicinit();
80102ec0:	e8 9b f7 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102ec5:	e8 a6 ff ff ff       	call   80102e70 <mpmain>
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <main>:
{
80102ed0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ed4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ed7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	53                   	push   %ebx
80102ede:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102edf:	83 ec 08             	sub    $0x8,%esp
80102ee2:	68 00 00 40 80       	push   $0x80400000
80102ee7:	68 c8 e1 11 80       	push   $0x8011e1c8
80102eec:	e8 2f f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 6a 48 00 00       	call   80107760 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 60 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 fb 42 00 00       	call   80107200 <seginit>
  picinit();       // disable pic
80102f05:	e8 46 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 41 f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 b7 35 00 00       	call   801064d0 <uartinit>
  pinit();         // process table
80102f19:	e8 92 08 00 00       	call   801037b0 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 fd 31 00 00       	call   80106120 <tvinit>
  binit();         // buffer cache
80102f23:	e8 18 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f28:	e8 53 de ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80102f2d:	e8 fe f0 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f32:	83 c4 0c             	add    $0xc,%esp
80102f35:	68 8a 00 00 00       	push   $0x8a
80102f3a:	68 0c b5 10 80       	push   $0x8010b50c
80102f3f:	68 00 70 00 80       	push   $0x80007000
80102f44:	e8 77 1d 00 00       	call   80104cc0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f49:	69 05 a0 8d 11 80 b0 	imul   $0xb0,0x80118da0,%eax
80102f50:	00 00 00 
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	05 20 88 11 80       	add    $0x80118820,%eax
80102f5b:	3d 20 88 11 80       	cmp    $0x80118820,%eax
80102f60:	76 71                	jbe    80102fd3 <main+0x103>
80102f62:	bb 20 88 11 80       	mov    $0x80118820,%ebx
80102f67:	89 f6                	mov    %esi,%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f70:	e8 5b 08 00 00       	call   801037d0 <mycpu>
80102f75:	39 d8                	cmp    %ebx,%eax
80102f77:	74 41                	je     80102fba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f79:	e8 72 f5 ff ff       	call   801024f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f7e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f83:	c7 05 f8 6f 00 80 b0 	movl   $0x80102eb0,0x80006ff8
80102f8a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f8d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f94:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f97:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f9c:	0f b6 03             	movzbl (%ebx),%eax
80102f9f:	83 ec 08             	sub    $0x8,%esp
80102fa2:	68 00 70 00 00       	push   $0x7000
80102fa7:	50                   	push   %eax
80102fa8:	e8 03 f8 ff ff       	call   801027b0 <lapicstartap>
80102fad:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fb0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 f6                	je     80102fb0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fba:	69 05 a0 8d 11 80 b0 	imul   $0xb0,0x80118da0,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fca:	05 20 88 11 80       	add    $0x80118820,%eax
80102fcf:	39 c3                	cmp    %eax,%ebx
80102fd1:	72 9d                	jb     80102f70 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fd3:	83 ec 08             	sub    $0x8,%esp
80102fd6:	68 00 00 00 8e       	push   $0x8e000000
80102fdb:	68 00 00 40 80       	push   $0x80400000
80102fe0:	e8 ab f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102fe5:	e8 b6 08 00 00       	call   801038a0 <userinit>
  mpmain();        // finish this processor's setup
80102fea:	e8 81 fe ff ff       	call   80102e70 <mpmain>
80102fef:	90                   	nop

80102ff0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ff5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102ffb:	53                   	push   %ebx
  e = addr+len;
80102ffc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103002:	39 de                	cmp    %ebx,%esi
80103004:	72 10                	jb     80103016 <mpsearch1+0x26>
80103006:	eb 50                	jmp    80103058 <mpsearch1+0x68>
80103008:	90                   	nop
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	39 fb                	cmp    %edi,%ebx
80103012:	89 fe                	mov    %edi,%esi
80103014:	76 42                	jbe    80103058 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103016:	83 ec 04             	sub    $0x4,%esp
80103019:	8d 7e 10             	lea    0x10(%esi),%edi
8010301c:	6a 04                	push   $0x4
8010301e:	68 78 7e 10 80       	push   $0x80107e78
80103023:	56                   	push   %esi
80103024:	e8 37 1c 00 00       	call   80104c60 <memcmp>
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	85 c0                	test   %eax,%eax
8010302e:	75 e0                	jne    80103010 <mpsearch1+0x20>
80103030:	89 f1                	mov    %esi,%ecx
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103038:	0f b6 11             	movzbl (%ecx),%edx
8010303b:	83 c1 01             	add    $0x1,%ecx
8010303e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103040:	39 f9                	cmp    %edi,%ecx
80103042:	75 f4                	jne    80103038 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103044:	84 c0                	test   %al,%al
80103046:	75 c8                	jne    80103010 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304b:	89 f0                	mov    %esi,%eax
8010304d:	5b                   	pop    %ebx
8010304e:	5e                   	pop    %esi
8010304f:	5f                   	pop    %edi
80103050:	5d                   	pop    %ebp
80103051:	c3                   	ret    
80103052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010305b:	31 f6                	xor    %esi,%esi
}
8010305d:	89 f0                	mov    %esi,%eax
8010305f:	5b                   	pop    %ebx
80103060:	5e                   	pop    %esi
80103061:	5f                   	pop    %edi
80103062:	5d                   	pop    %ebp
80103063:	c3                   	ret    
80103064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010306a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103070 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103079:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103080:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103087:	c1 e0 08             	shl    $0x8,%eax
8010308a:	09 d0                	or     %edx,%eax
8010308c:	c1 e0 04             	shl    $0x4,%eax
8010308f:	85 c0                	test   %eax,%eax
80103091:	75 1b                	jne    801030ae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103093:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010309a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030a1:	c1 e0 08             	shl    $0x8,%eax
801030a4:	09 d0                	or     %edx,%eax
801030a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030a9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ae:	ba 00 04 00 00       	mov    $0x400,%edx
801030b3:	e8 38 ff ff ff       	call   80102ff0 <mpsearch1>
801030b8:	85 c0                	test   %eax,%eax
801030ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030bd:	0f 84 3d 01 00 00    	je     80103200 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030c6:	8b 58 04             	mov    0x4(%eax),%ebx
801030c9:	85 db                	test   %ebx,%ebx
801030cb:	0f 84 4f 01 00 00    	je     80103220 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030d7:	83 ec 04             	sub    $0x4,%esp
801030da:	6a 04                	push   $0x4
801030dc:	68 95 7e 10 80       	push   $0x80107e95
801030e1:	56                   	push   %esi
801030e2:	e8 79 1b 00 00       	call   80104c60 <memcmp>
801030e7:	83 c4 10             	add    $0x10,%esp
801030ea:	85 c0                	test   %eax,%eax
801030ec:	0f 85 2e 01 00 00    	jne    80103220 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030f9:	3c 01                	cmp    $0x1,%al
801030fb:	0f 95 c2             	setne  %dl
801030fe:	3c 04                	cmp    $0x4,%al
80103100:	0f 95 c0             	setne  %al
80103103:	20 c2                	and    %al,%dl
80103105:	0f 85 15 01 00 00    	jne    80103220 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010310b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103112:	66 85 ff             	test   %di,%di
80103115:	74 1a                	je     80103131 <mpinit+0xc1>
80103117:	89 f0                	mov    %esi,%eax
80103119:	01 f7                	add    %esi,%edi
  sum = 0;
8010311b:	31 d2                	xor    %edx,%edx
8010311d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103120:	0f b6 08             	movzbl (%eax),%ecx
80103123:	83 c0 01             	add    $0x1,%eax
80103126:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103128:	39 c7                	cmp    %eax,%edi
8010312a:	75 f4                	jne    80103120 <mpinit+0xb0>
8010312c:	84 d2                	test   %dl,%dl
8010312e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103131:	85 f6                	test   %esi,%esi
80103133:	0f 84 e7 00 00 00    	je     80103220 <mpinit+0x1b0>
80103139:	84 d2                	test   %dl,%dl
8010313b:	0f 85 df 00 00 00    	jne    80103220 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103141:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103147:	a3 1c 87 11 80       	mov    %eax,0x8011871c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103153:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103159:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315e:	01 d6                	add    %edx,%esi
80103160:	39 c6                	cmp    %eax,%esi
80103162:	76 23                	jbe    80103187 <mpinit+0x117>
    switch(*p){
80103164:	0f b6 10             	movzbl (%eax),%edx
80103167:	80 fa 04             	cmp    $0x4,%dl
8010316a:	0f 87 ca 00 00 00    	ja     8010323a <mpinit+0x1ca>
80103170:	ff 24 95 bc 7e 10 80 	jmp    *-0x7fef8144(,%edx,4)
80103177:	89 f6                	mov    %esi,%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103180:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103183:	39 c6                	cmp    %eax,%esi
80103185:	77 dd                	ja     80103164 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103187:	85 db                	test   %ebx,%ebx
80103189:	0f 84 9e 00 00 00    	je     8010322d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010318f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103192:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103196:	74 15                	je     801031ad <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103198:	b8 70 00 00 00       	mov    $0x70,%eax
8010319d:	ba 22 00 00 00       	mov    $0x22,%edx
801031a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a3:	ba 23 00 00 00       	mov    $0x23,%edx
801031a8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031a9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ac:	ee                   	out    %al,(%dx)
  }
}
801031ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b0:	5b                   	pop    %ebx
801031b1:	5e                   	pop    %esi
801031b2:	5f                   	pop    %edi
801031b3:	5d                   	pop    %ebp
801031b4:	c3                   	ret    
801031b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031b8:	8b 0d a0 8d 11 80    	mov    0x80118da0,%ecx
801031be:	83 f9 07             	cmp    $0x7,%ecx
801031c1:	7f 19                	jg     801031dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031cd:	83 c1 01             	add    $0x1,%ecx
801031d0:	89 0d a0 8d 11 80    	mov    %ecx,0x80118da0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d6:	88 97 20 88 11 80    	mov    %dl,-0x7fee77e0(%edi)
      p += sizeof(struct mpproc);
801031dc:	83 c0 14             	add    $0x14,%eax
      continue;
801031df:	e9 7c ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031ec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ef:	88 15 00 88 11 80    	mov    %dl,0x80118800
      continue;
801031f5:	e9 66 ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103200:	ba 00 00 01 00       	mov    $0x10000,%edx
80103205:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010320a:	e8 e1 fd ff ff       	call   80102ff0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010320f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103211:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103214:	0f 85 a9 fe ff ff    	jne    801030c3 <mpinit+0x53>
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103220:	83 ec 0c             	sub    $0xc,%esp
80103223:	68 7d 7e 10 80       	push   $0x80107e7d
80103228:	e8 63 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 9c 7e 10 80       	push   $0x80107e9c
80103235:	e8 56 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010323a:	31 db                	xor    %ebx,%ebx
8010323c:	e9 26 ff ff ff       	jmp    80103167 <mpinit+0xf7>
80103241:	66 90                	xchg   %ax,%ax
80103243:	66 90                	xchg   %ax,%ax
80103245:	66 90                	xchg   %ax,%ax
80103247:	66 90                	xchg   %ax,%ax
80103249:	66 90                	xchg   %ax,%ax
8010324b:	66 90                	xchg   %ax,%ax
8010324d:	66 90                	xchg   %ax,%ax
8010324f:	90                   	nop

80103250 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103250:	55                   	push   %ebp
80103251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103256:	ba 21 00 00 00       	mov    $0x21,%edx
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	ee                   	out    %al,(%dx)
8010325e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103263:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103264:	5d                   	pop    %ebp
80103265:	c3                   	ret    
80103266:	66 90                	xchg   %ax,%ax
80103268:	66 90                	xchg   %ax,%ax
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010327f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010328b:	e8 10 db ff ff       	call   80100da0 <filealloc>
80103290:	85 c0                	test   %eax,%eax
80103292:	89 03                	mov    %eax,(%ebx)
80103294:	74 22                	je     801032b8 <pipealloc+0x48>
80103296:	e8 05 db ff ff       	call   80100da0 <filealloc>
8010329b:	85 c0                	test   %eax,%eax
8010329d:	89 06                	mov    %eax,(%esi)
8010329f:	74 3f                	je     801032e0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032a1:	e8 4a f2 ff ff       	call   801024f0 <kalloc>
801032a6:	85 c0                	test   %eax,%eax
801032a8:	89 c7                	mov    %eax,%edi
801032aa:	75 54                	jne    80103300 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032ac:	8b 03                	mov    (%ebx),%eax
801032ae:	85 c0                	test   %eax,%eax
801032b0:	75 34                	jne    801032e6 <pipealloc+0x76>
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032b8:	8b 06                	mov    (%esi),%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	74 0c                	je     801032ca <pipealloc+0x5a>
    fileclose(*f1);
801032be:	83 ec 0c             	sub    $0xc,%esp
801032c1:	50                   	push   %eax
801032c2:	e8 99 db ff ff       	call   80100e60 <fileclose>
801032c7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032d2:	5b                   	pop    %ebx
801032d3:	5e                   	pop    %esi
801032d4:	5f                   	pop    %edi
801032d5:	5d                   	pop    %ebp
801032d6:	c3                   	ret    
801032d7:	89 f6                	mov    %esi,%esi
801032d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032e0:	8b 03                	mov    (%ebx),%eax
801032e2:	85 c0                	test   %eax,%eax
801032e4:	74 e4                	je     801032ca <pipealloc+0x5a>
    fileclose(*f0);
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	50                   	push   %eax
801032ea:	e8 71 db ff ff       	call   80100e60 <fileclose>
  if(*f1)
801032ef:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032f1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032f4:	85 c0                	test   %eax,%eax
801032f6:	75 c6                	jne    801032be <pipealloc+0x4e>
801032f8:	eb d0                	jmp    801032ca <pipealloc+0x5a>
801032fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103300:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103303:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010330a:	00 00 00 
  p->writeopen = 1;
8010330d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103314:	00 00 00 
  p->nwrite = 0;
80103317:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010331e:	00 00 00 
  p->nread = 0;
80103321:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103328:	00 00 00 
  initlock(&p->lock, "pipe");
8010332b:	68 80 80 10 80       	push   $0x80108080
80103330:	50                   	push   %eax
80103331:	e8 8a 16 00 00       	call   801049c0 <initlock>
  (*f0)->type = FD_PIPE;
80103336:	8b 03                	mov    (%ebx),%eax
  return 0;
80103338:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010333b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103341:	8b 03                	mov    (%ebx),%eax
80103343:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103347:	8b 03                	mov    (%ebx),%eax
80103349:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010334d:	8b 03                	mov    (%ebx),%eax
8010334f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103352:	8b 06                	mov    (%esi),%eax
80103354:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010335a:	8b 06                	mov    (%esi),%eax
8010335c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103360:	8b 06                	mov    (%esi),%eax
80103362:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103366:	8b 06                	mov    (%esi),%eax
80103368:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010336b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010336e:	31 c0                	xor    %eax,%eax
}
80103370:	5b                   	pop    %ebx
80103371:	5e                   	pop    %esi
80103372:	5f                   	pop    %edi
80103373:	5d                   	pop    %ebp
80103374:	c3                   	ret    
80103375:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103380 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	56                   	push   %esi
80103384:	53                   	push   %ebx
80103385:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103388:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010338b:	83 ec 0c             	sub    $0xc,%esp
8010338e:	53                   	push   %ebx
8010338f:	e8 6c 17 00 00       	call   80104b00 <acquire>
  if(writable){
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 f6                	test   %esi,%esi
80103399:	74 45                	je     801033e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010339b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033a1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033ab:	00 00 00 
    wakeup(&p->nread);
801033ae:	50                   	push   %eax
801033af:	e8 4c 0c 00 00       	call   80104000 <wakeup>
801033b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033bd:	85 d2                	test   %edx,%edx
801033bf:	75 0a                	jne    801033cb <pipeclose+0x4b>
801033c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033c7:	85 c0                	test   %eax,%eax
801033c9:	74 35                	je     80103400 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033d1:	5b                   	pop    %ebx
801033d2:	5e                   	pop    %esi
801033d3:	5d                   	pop    %ebp
    release(&p->lock);
801033d4:	e9 e7 17 00 00       	jmp    80104bc0 <release>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033f0:	00 00 00 
    wakeup(&p->nwrite);
801033f3:	50                   	push   %eax
801033f4:	e8 07 0c 00 00       	call   80104000 <wakeup>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	eb b9                	jmp    801033b7 <pipeclose+0x37>
801033fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	53                   	push   %ebx
80103404:	e8 b7 17 00 00       	call   80104bc0 <release>
    kfree((char*)p);
80103409:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010340c:	83 c4 10             	add    $0x10,%esp
}
8010340f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103412:	5b                   	pop    %ebx
80103413:	5e                   	pop    %esi
80103414:	5d                   	pop    %ebp
    kfree((char*)p);
80103415:	e9 26 ef ff ff       	jmp    80102340 <kfree>
8010341a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103420 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 28             	sub    $0x28,%esp
80103429:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010342c:	53                   	push   %ebx
8010342d:	e8 ce 16 00 00       	call   80104b00 <acquire>
  for(i = 0; i < n; i++){
80103432:	8b 45 10             	mov    0x10(%ebp),%eax
80103435:	83 c4 10             	add    $0x10,%esp
80103438:	85 c0                	test   %eax,%eax
8010343a:	0f 8e c9 00 00 00    	jle    80103509 <pipewrite+0xe9>
80103440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103443:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103449:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010344f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103452:	03 4d 10             	add    0x10(%ebp),%ecx
80103455:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103458:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010345e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103464:	39 d0                	cmp    %edx,%eax
80103466:	75 71                	jne    801034d9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103468:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010346e:	85 c0                	test   %eax,%eax
80103470:	74 4e                	je     801034c0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103472:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103478:	eb 3a                	jmp    801034b4 <pipewrite+0x94>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	57                   	push   %edi
80103484:	e8 77 0b 00 00       	call   80104000 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103489:	5a                   	pop    %edx
8010348a:	59                   	pop    %ecx
8010348b:	53                   	push   %ebx
8010348c:	56                   	push   %esi
8010348d:	e8 ae 09 00 00       	call   80103e40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103492:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103498:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010349e:	83 c4 10             	add    $0x10,%esp
801034a1:	05 00 02 00 00       	add    $0x200,%eax
801034a6:	39 c2                	cmp    %eax,%edx
801034a8:	75 36                	jne    801034e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034aa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034b0:	85 c0                	test   %eax,%eax
801034b2:	74 0c                	je     801034c0 <pipewrite+0xa0>
801034b4:	e8 b7 03 00 00       	call   80103870 <myproc>
801034b9:	8b 40 24             	mov    0x24(%eax),%eax
801034bc:	85 c0                	test   %eax,%eax
801034be:	74 c0                	je     80103480 <pipewrite+0x60>
        release(&p->lock);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	53                   	push   %ebx
801034c4:	e8 f7 16 00 00       	call   80104bc0 <release>
        return -1;
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d4:	5b                   	pop    %ebx
801034d5:	5e                   	pop    %esi
801034d6:	5f                   	pop    %edi
801034d7:	5d                   	pop    %ebp
801034d8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d9:	89 c2                	mov    %eax,%edx
801034db:	90                   	nop
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034e3:	8d 42 01             	lea    0x1(%edx),%eax
801034e6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034ec:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034f2:	83 c6 01             	add    $0x1,%esi
801034f5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034f9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034fc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ff:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103503:	0f 85 4f ff ff ff    	jne    80103458 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103509:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	50                   	push   %eax
80103513:	e8 e8 0a 00 00       	call   80104000 <wakeup>
  release(&p->lock);
80103518:	89 1c 24             	mov    %ebx,(%esp)
8010351b:	e8 a0 16 00 00       	call   80104bc0 <release>
  return n;
80103520:	83 c4 10             	add    $0x10,%esp
80103523:	8b 45 10             	mov    0x10(%ebp),%eax
80103526:	eb a9                	jmp    801034d1 <pipewrite+0xb1>
80103528:	90                   	nop
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103530 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 18             	sub    $0x18,%esp
80103539:	8b 75 08             	mov    0x8(%ebp),%esi
8010353c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010353f:	56                   	push   %esi
80103540:	e8 bb 15 00 00       	call   80104b00 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103545:	83 c4 10             	add    $0x10,%esp
80103548:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010354e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103554:	75 6a                	jne    801035c0 <piperead+0x90>
80103556:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010355c:	85 db                	test   %ebx,%ebx
8010355e:	0f 84 c4 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103564:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010356a:	eb 2d                	jmp    80103599 <piperead+0x69>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103570:	83 ec 08             	sub    $0x8,%esp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	e8 c6 08 00 00       	call   80103e40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010357a:	83 c4 10             	add    $0x10,%esp
8010357d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103583:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103589:	75 35                	jne    801035c0 <piperead+0x90>
8010358b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	0f 84 8f 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
80103599:	e8 d2 02 00 00       	call   80103870 <myproc>
8010359e:	8b 48 24             	mov    0x24(%eax),%ecx
801035a1:	85 c9                	test   %ecx,%ecx
801035a3:	74 cb                	je     80103570 <piperead+0x40>
      release(&p->lock);
801035a5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035a8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ad:	56                   	push   %esi
801035ae:	e8 0d 16 00 00       	call   80104bc0 <release>
      return -1;
801035b3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801035b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b9:	89 d8                	mov    %ebx,%eax
801035bb:	5b                   	pop    %ebx
801035bc:	5e                   	pop    %esi
801035bd:	5f                   	pop    %edi
801035be:	5d                   	pop    %ebp
801035bf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c0:	8b 45 10             	mov    0x10(%ebp),%eax
801035c3:	85 c0                	test   %eax,%eax
801035c5:	7e 61                	jle    80103628 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035c7:	31 db                	xor    %ebx,%ebx
801035c9:	eb 13                	jmp    801035de <piperead+0xae>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035d6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035dc:	74 1f                	je     801035fd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035de:	8d 41 01             	lea    0x1(%ecx),%eax
801035e1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035e7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035ed:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035f2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f5:	83 c3 01             	add    $0x1,%ebx
801035f8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035fb:	75 d3                	jne    801035d0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035fd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103603:	83 ec 0c             	sub    $0xc,%esp
80103606:	50                   	push   %eax
80103607:	e8 f4 09 00 00       	call   80104000 <wakeup>
  release(&p->lock);
8010360c:	89 34 24             	mov    %esi,(%esp)
8010360f:	e8 ac 15 00 00       	call   80104bc0 <release>
  return i;
80103614:	83 c4 10             	add    $0x10,%esp
80103617:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361a:	89 d8                	mov    %ebx,%eax
8010361c:	5b                   	pop    %ebx
8010361d:	5e                   	pop    %esi
8010361e:	5f                   	pop    %edi
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103628:	31 db                	xor    %ebx,%ebx
8010362a:	eb d1                	jmp    801035fd <piperead+0xcd>
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
  char *sp;

  acquire(&ptable.lock);

  // ****added**************
  int i = 0;
80103635:	31 f6                	xor    %esi,%esi
  // ****

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++,i++)
80103637:	bb f4 8d 11 80       	mov    $0x80118df4,%ebx
  acquire(&ptable.lock);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	68 c0 8d 11 80       	push   $0x80118dc0
80103644:	e8 b7 14 00 00       	call   80104b00 <acquire>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	eb 17                	jmp    80103665 <allocproc+0x35>
8010364e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++,i++)
80103650:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
80103656:	83 c6 01             	add    $0x1,%esi
80103659:	81 fb f4 d8 11 80    	cmp    $0x8011d8f4,%ebx
8010365f:	0f 83 cb 00 00 00    	jae    80103730 <allocproc+0x100>
    if(p->state == UNUSED)
80103665:	8b 43 0c             	mov    0xc(%ebx),%eax
80103668:	85 c0                	test   %eax,%eax
8010366a:	75 e4                	jne    80103650 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010366c:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103671:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103674:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010367b:	8d 50 01             	lea    0x1(%eax),%edx
8010367e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103681:	68 c0 8d 11 80       	push   $0x80118dc0
  p->pid = nextpid++;
80103686:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010368c:	e8 2f 15 00 00       	call   80104bc0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103691:	e8 5a ee ff ff       	call   801024f0 <kalloc>
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	85 c0                	test   %eax,%eax
8010369b:	89 43 08             	mov    %eax,0x8(%ebx)
8010369e:	0f 84 a7 00 00 00    	je     8010374b <allocproc+0x11b>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036a4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036aa:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036ad:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036b2:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036b5:	c7 40 14 07 61 10 80 	movl   $0x80106107,0x14(%eax)
  p->context = (struct context*)sp;
801036bc:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036bf:	6a 14                	push   $0x14
801036c1:	6a 00                	push   $0x0
801036c3:	50                   	push   %eax
801036c4:	e8 47 15 00 00       	call   80104c10 <memset>
  p->context->eip = (uint)forkret;
801036c9:	8b 43 1c             	mov    0x1c(%ebx),%eax
  MsgQueue[i].start = MsgQueue[i].end = 0;
  MsgQueue[i].lock.locked = 0;

  // ****

  return p;
801036cc:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036cf:	c7 40 10 60 37 10 80 	movl   $0x80103760,0x10(%eax)
  MsgQueue[i].start = MsgQueue[i].end = 0;
801036d6:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  p->sig_handler_busy = 0;
801036d9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801036e0:	00 00 00 
  p->SigQueue.start = p->SigQueue.end = 0;
801036e3:	c7 83 28 01 00 00 00 	movl   $0x0,0x128(%ebx)
801036ea:	00 00 00 
801036ed:	c7 83 24 01 00 00 00 	movl   $0x0,0x124(%ebx)
801036f4:	00 00 00 
  MsgQueue[i].start = MsgQueue[i].end = 0;
801036f7:	c1 e0 06             	shl    $0x6,%eax
  p->SigQueue.lock.locked = 0;
801036fa:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103701:	00 00 00 
  MsgQueue[i].start = MsgQueue[i].end = 0;
80103704:	c7 80 f8 10 11 80 00 	movl   $0x0,-0x7feeef08(%eax)
8010370b:	00 00 00 
8010370e:	c7 80 f4 10 11 80 00 	movl   $0x0,-0x7feeef0c(%eax)
80103715:	00 00 00 
  MsgQueue[i].lock.locked = 0;
80103718:	c7 80 c0 0f 11 80 00 	movl   $0x0,-0x7feef040(%eax)
8010371f:	00 00 00 
}
80103722:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103725:	89 d8                	mov    %ebx,%eax
80103727:	5b                   	pop    %ebx
80103728:	5e                   	pop    %esi
80103729:	5d                   	pop    %ebp
8010372a:	c3                   	ret    
8010372b:	90                   	nop
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103733:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103735:	68 c0 8d 11 80       	push   $0x80118dc0
8010373a:	e8 81 14 00 00       	call   80104bc0 <release>
  return 0;
8010373f:	83 c4 10             	add    $0x10,%esp
}
80103742:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103745:	89 d8                	mov    %ebx,%eax
80103747:	5b                   	pop    %ebx
80103748:	5e                   	pop    %esi
80103749:	5d                   	pop    %ebp
8010374a:	c3                   	ret    
    p->state = UNUSED;
8010374b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103752:	31 db                	xor    %ebx,%ebx
80103754:	eb cc                	jmp    80103722 <allocproc+0xf2>
80103756:	8d 76 00             	lea    0x0(%esi),%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103760 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103766:	68 c0 8d 11 80       	push   $0x80118dc0
8010376b:	e8 50 14 00 00       	call   80104bc0 <release>

  if (first) {
80103770:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 c0                	test   %eax,%eax
8010377a:	75 04                	jne    80103780 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010377c:	c9                   	leave  
8010377d:	c3                   	ret    
8010377e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103780:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103783:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010378a:	00 00 00 
    iinit(ROOTDEV);
8010378d:	6a 01                	push   $0x1
8010378f:	e8 1c dd ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103794:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010379b:	e8 90 f3 ff ff       	call   80102b30 <initlog>
801037a0:	83 c4 10             	add    $0x10,%esp
}
801037a3:	c9                   	leave  
801037a4:	c3                   	ret    
801037a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037b0 <pinit>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037b6:	68 d0 7e 10 80       	push   $0x80107ed0
801037bb:	68 c0 8d 11 80       	push   $0x80118dc0
801037c0:	e8 fb 11 00 00       	call   801049c0 <initlock>
}
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	c9                   	leave  
801037c9:	c3                   	ret    
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037d0 <mycpu>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037d5:	9c                   	pushf  
801037d6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037d7:	f6 c4 02             	test   $0x2,%ah
801037da:	75 5e                	jne    8010383a <mycpu+0x6a>
  apicid = lapicid();
801037dc:	e8 7f ef ff ff       	call   80102760 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037e1:	8b 35 a0 8d 11 80    	mov    0x80118da0,%esi
801037e7:	85 f6                	test   %esi,%esi
801037e9:	7e 42                	jle    8010382d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037eb:	0f b6 15 20 88 11 80 	movzbl 0x80118820,%edx
801037f2:	39 d0                	cmp    %edx,%eax
801037f4:	74 30                	je     80103826 <mycpu+0x56>
801037f6:	b9 d0 88 11 80       	mov    $0x801188d0,%ecx
  for (i = 0; i < ncpu; ++i) {
801037fb:	31 d2                	xor    %edx,%edx
801037fd:	8d 76 00             	lea    0x0(%esi),%esi
80103800:	83 c2 01             	add    $0x1,%edx
80103803:	39 f2                	cmp    %esi,%edx
80103805:	74 26                	je     8010382d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103807:	0f b6 19             	movzbl (%ecx),%ebx
8010380a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103810:	39 c3                	cmp    %eax,%ebx
80103812:	75 ec                	jne    80103800 <mycpu+0x30>
80103814:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010381a:	05 20 88 11 80       	add    $0x80118820,%eax
}
8010381f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5d                   	pop    %ebp
80103825:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103826:	b8 20 88 11 80       	mov    $0x80118820,%eax
      return &cpus[i];
8010382b:	eb f2                	jmp    8010381f <mycpu+0x4f>
  panic("unknown apicid\n");
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 d7 7e 10 80       	push   $0x80107ed7
80103835:	e8 56 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010383a:	83 ec 0c             	sub    $0xc,%esp
8010383d:	68 cc 7f 10 80       	push   $0x80107fcc
80103842:	e8 49 cb ff ff       	call   80100390 <panic>
80103847:	89 f6                	mov    %esi,%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <cpuid>:
cpuid() {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103856:	e8 75 ff ff ff       	call   801037d0 <mycpu>
8010385b:	2d 20 88 11 80       	sub    $0x80118820,%eax
}
80103860:	c9                   	leave  
  return mycpu()-cpus;
80103861:	c1 f8 04             	sar    $0x4,%eax
80103864:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010386a:	c3                   	ret    
8010386b:	90                   	nop
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <myproc>:
myproc(void) {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
80103874:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103877:	e8 b4 11 00 00       	call   80104a30 <pushcli>
  c = mycpu();
8010387c:	e8 4f ff ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103881:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103887:	e8 e4 11 00 00       	call   80104a70 <popcli>
}
8010388c:	83 c4 04             	add    $0x4,%esp
8010388f:	89 d8                	mov    %ebx,%eax
80103891:	5b                   	pop    %ebx
80103892:	5d                   	pop    %ebp
80103893:	c3                   	ret    
80103894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010389a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038a0 <userinit>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801038a7:	e8 84 fd ff ff       	call   80103630 <allocproc>
801038ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801038ae:	a3 38 b6 10 80       	mov    %eax,0x8010b638
  if((p->pgdir = setupkvm()) == 0)
801038b3:	e8 28 3e 00 00       	call   801076e0 <setupkvm>
801038b8:	85 c0                	test   %eax,%eax
801038ba:	89 43 04             	mov    %eax,0x4(%ebx)
801038bd:	0f 84 bd 00 00 00    	je     80103980 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038c3:	83 ec 04             	sub    $0x4,%esp
801038c6:	68 2c 00 00 00       	push   $0x2c
801038cb:	68 e0 b4 10 80       	push   $0x8010b4e0
801038d0:	50                   	push   %eax
801038d1:	e8 ea 3a 00 00       	call   801073c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038df:	6a 4c                	push   $0x4c
801038e1:	6a 00                	push   $0x0
801038e3:	ff 73 18             	pushl  0x18(%ebx)
801038e6:	e8 25 13 00 00       	call   80104c10 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038eb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038f3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038f8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103902:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010390d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103911:	8b 43 18             	mov    0x18(%ebx),%eax
80103914:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103918:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010391c:	8b 43 18             	mov    0x18(%ebx),%eax
8010391f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103926:	8b 43 18             	mov    0x18(%ebx),%eax
80103929:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103930:	8b 43 18             	mov    0x18(%ebx),%eax
80103933:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010393a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010393d:	6a 10                	push   $0x10
8010393f:	68 00 7f 10 80       	push   $0x80107f00
80103944:	50                   	push   %eax
80103945:	e8 a6 14 00 00       	call   80104df0 <safestrcpy>
  p->cwd = namei("/");
8010394a:	c7 04 24 09 7f 10 80 	movl   $0x80107f09,(%esp)
80103951:	e8 ba e5 ff ff       	call   80101f10 <namei>
80103956:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103959:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103960:	e8 9b 11 00 00       	call   80104b00 <acquire>
  p->state = RUNNABLE;
80103965:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010396c:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103973:	e8 48 12 00 00       	call   80104bc0 <release>
}
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397e:	c9                   	leave  
8010397f:	c3                   	ret    
    panic("userinit: out of memory?");
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	68 e7 7e 10 80       	push   $0x80107ee7
80103988:	e8 03 ca ff ff       	call   80100390 <panic>
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <growproc>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
80103995:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103998:	e8 93 10 00 00       	call   80104a30 <pushcli>
  c = mycpu();
8010399d:	e8 2e fe ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801039a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a8:	e8 c3 10 00 00       	call   80104a70 <popcli>
  if(n > 0){
801039ad:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801039b0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039b2:	7f 1c                	jg     801039d0 <growproc+0x40>
  } else if(n < 0){
801039b4:	75 3a                	jne    801039f0 <growproc+0x60>
  switchuvm(curproc);
801039b6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039b9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039bb:	53                   	push   %ebx
801039bc:	e8 ef 38 00 00       	call   801072b0 <switchuvm>
  return 0;
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	31 c0                	xor    %eax,%eax
}
801039c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039c9:	5b                   	pop    %ebx
801039ca:	5e                   	pop    %esi
801039cb:	5d                   	pop    %ebp
801039cc:	c3                   	ret    
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039d0:	83 ec 04             	sub    $0x4,%esp
801039d3:	01 c6                	add    %eax,%esi
801039d5:	56                   	push   %esi
801039d6:	50                   	push   %eax
801039d7:	ff 73 04             	pushl  0x4(%ebx)
801039da:	e8 21 3b 00 00       	call   80107500 <allocuvm>
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 d0                	jne    801039b6 <growproc+0x26>
      return -1;
801039e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039eb:	eb d9                	jmp    801039c6 <growproc+0x36>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039f0:	83 ec 04             	sub    $0x4,%esp
801039f3:	01 c6                	add    %eax,%esi
801039f5:	56                   	push   %esi
801039f6:	50                   	push   %eax
801039f7:	ff 73 04             	pushl  0x4(%ebx)
801039fa:	e8 31 3c 00 00       	call   80107630 <deallocuvm>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	85 c0                	test   %eax,%eax
80103a04:	75 b0                	jne    801039b6 <growproc+0x26>
80103a06:	eb de                	jmp    801039e6 <growproc+0x56>
80103a08:	90                   	nop
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a10 <fork>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a19:	e8 12 10 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80103a1e:	e8 ad fd ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103a23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a29:	e8 42 10 00 00       	call   80104a70 <popcli>
  if((np = allocproc()) == 0){
80103a2e:	e8 fd fb ff ff       	call   80103630 <allocproc>
80103a33:	85 c0                	test   %eax,%eax
80103a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a38:	0f 84 f3 00 00 00    	je     80103b31 <fork+0x121>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a3e:	83 ec 08             	sub    $0x8,%esp
80103a41:	ff 33                	pushl  (%ebx)
80103a43:	ff 73 04             	pushl  0x4(%ebx)
80103a46:	e8 65 3d 00 00       	call   801077b0 <copyuvm>
80103a4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a4e:	83 c4 10             	add    $0x10,%esp
80103a51:	85 c0                	test   %eax,%eax
80103a53:	89 42 04             	mov    %eax,0x4(%edx)
80103a56:	0f 84 dc 00 00 00    	je     80103b38 <fork+0x128>
  np->sz = curproc->sz;
80103a5c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103a5e:	8b 7a 18             	mov    0x18(%edx),%edi
80103a61:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103a66:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80103a69:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103a6b:	8b 73 18             	mov    0x18(%ebx),%esi
80103a6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a70:	31 f6                	xor    %esi,%esi
    np->sig_htable[i] = curproc->sig_htable[i];
80103a72:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103a75:	89 42 7c             	mov    %eax,0x7c(%edx)
80103a78:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103a7e:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
80103a84:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103a8a:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
80103a90:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103a96:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  np->tf->eax = 0;
80103a9c:	8b 42 18             	mov    0x18(%edx),%eax
80103a9f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103aa6:	8d 76 00             	lea    0x0(%esi),%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
80103ab0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ab4:	85 c0                	test   %eax,%eax
80103ab6:	74 16                	je     80103ace <fork+0xbe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ab8:	83 ec 0c             	sub    $0xc,%esp
80103abb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103abe:	50                   	push   %eax
80103abf:	e8 4c d3 ff ff       	call   80100e10 <filedup>
80103ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ac7:	83 c4 10             	add    $0x10,%esp
80103aca:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ace:	83 c6 01             	add    $0x1,%esi
80103ad1:	83 fe 10             	cmp    $0x10,%esi
80103ad4:	75 da                	jne    80103ab0 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103ad6:	83 ec 0c             	sub    $0xc,%esp
80103ad9:	ff 73 68             	pushl  0x68(%ebx)
80103adc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103adf:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103ae2:	e8 99 db ff ff       	call   80101680 <idup>
80103ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aea:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103aed:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103af0:	8d 42 6c             	lea    0x6c(%edx),%eax
80103af3:	6a 10                	push   $0x10
80103af5:	53                   	push   %ebx
80103af6:	50                   	push   %eax
80103af7:	e8 f4 12 00 00       	call   80104df0 <safestrcpy>
  pid = np->pid;
80103afc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103aff:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80103b02:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103b09:	e8 f2 0f 00 00       	call   80104b00 <acquire>
  np->state = RUNNABLE;
80103b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b11:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80103b18:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103b1f:	e8 9c 10 00 00       	call   80104bc0 <release>
  return pid;
80103b24:	83 c4 10             	add    $0x10,%esp
}
80103b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b2a:	89 d8                	mov    %ebx,%eax
80103b2c:	5b                   	pop    %ebx
80103b2d:	5e                   	pop    %esi
80103b2e:	5f                   	pop    %edi
80103b2f:	5d                   	pop    %ebp
80103b30:	c3                   	ret    
    return -1;
80103b31:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b36:	eb ef                	jmp    80103b27 <fork+0x117>
    kfree(np->kstack);
80103b38:	83 ec 0c             	sub    $0xc,%esp
80103b3b:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80103b3e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103b43:	e8 f8 e7 ff ff       	call   80102340 <kfree>
    np->kstack = 0;
80103b48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80103b4b:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103b4e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80103b55:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80103b5c:	eb c9                	jmp    80103b27 <fork+0x117>
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <scheduler>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b69:	e8 62 fc ff ff       	call   801037d0 <mycpu>
80103b6e:	8d 78 04             	lea    0x4(%eax),%edi
80103b71:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b73:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b7a:	00 00 00 
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b80:	fb                   	sti    
    acquire(&ptable.lock);
80103b81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b84:	bb f4 8d 11 80       	mov    $0x80118df4,%ebx
    acquire(&ptable.lock);
80103b89:	68 c0 8d 11 80       	push   $0x80118dc0
80103b8e:	e8 6d 0f 00 00       	call   80104b00 <acquire>
80103b93:	83 c4 10             	add    $0x10,%esp
80103b96:	8d 76 00             	lea    0x0(%esi),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103ba0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ba4:	75 33                	jne    80103bd9 <scheduler+0x79>
      switchuvm(p);
80103ba6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ba9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103baf:	53                   	push   %ebx
80103bb0:	e8 fb 36 00 00       	call   801072b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103bb5:	58                   	pop    %eax
80103bb6:	5a                   	pop    %edx
80103bb7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bba:	57                   	push   %edi
      p->state = RUNNING;
80103bbb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103bc2:	e8 84 12 00 00       	call   80104e4b <swtch>
      switchkvm();
80103bc7:	e8 c4 36 00 00       	call   80107290 <switchkvm>
      c->proc = 0;
80103bcc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103bd3:	00 00 00 
80103bd6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bd9:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
80103bdf:	81 fb f4 d8 11 80    	cmp    $0x8011d8f4,%ebx
80103be5:	72 b9                	jb     80103ba0 <scheduler+0x40>
    release(&ptable.lock);
80103be7:	83 ec 0c             	sub    $0xc,%esp
80103bea:	68 c0 8d 11 80       	push   $0x80118dc0
80103bef:	e8 cc 0f 00 00       	call   80104bc0 <release>
    sti();
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	eb 87                	jmp    80103b80 <scheduler+0x20>
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c00 <sched>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
  pushcli();
80103c05:	e8 26 0e 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80103c0a:	e8 c1 fb ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103c0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c15:	e8 56 0e 00 00       	call   80104a70 <popcli>
  if(!holding(&ptable.lock))
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 c0 8d 11 80       	push   $0x80118dc0
80103c22:	e8 a9 0e 00 00       	call   80104ad0 <holding>
80103c27:	83 c4 10             	add    $0x10,%esp
80103c2a:	85 c0                	test   %eax,%eax
80103c2c:	74 4f                	je     80103c7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c2e:	e8 9d fb ff ff       	call   801037d0 <mycpu>
80103c33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c3a:	75 68                	jne    80103ca4 <sched+0xa4>
  if(p->state == RUNNING)
80103c3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c40:	74 55                	je     80103c97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c42:	9c                   	pushf  
80103c43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c44:	f6 c4 02             	test   $0x2,%ah
80103c47:	75 41                	jne    80103c8a <sched+0x8a>
  intena = mycpu()->intena;
80103c49:	e8 82 fb ff ff       	call   801037d0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c57:	e8 74 fb ff ff       	call   801037d0 <mycpu>
80103c5c:	83 ec 08             	sub    $0x8,%esp
80103c5f:	ff 70 04             	pushl  0x4(%eax)
80103c62:	53                   	push   %ebx
80103c63:	e8 e3 11 00 00       	call   80104e4b <swtch>
  mycpu()->intena = intena;
80103c68:	e8 63 fb ff ff       	call   801037d0 <mycpu>
}
80103c6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c79:	5b                   	pop    %ebx
80103c7a:	5e                   	pop    %esi
80103c7b:	5d                   	pop    %ebp
80103c7c:	c3                   	ret    
    panic("sched ptable.lock");
80103c7d:	83 ec 0c             	sub    $0xc,%esp
80103c80:	68 0b 7f 10 80       	push   $0x80107f0b
80103c85:	e8 06 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c8a:	83 ec 0c             	sub    $0xc,%esp
80103c8d:	68 37 7f 10 80       	push   $0x80107f37
80103c92:	e8 f9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c97:	83 ec 0c             	sub    $0xc,%esp
80103c9a:	68 29 7f 10 80       	push   $0x80107f29
80103c9f:	e8 ec c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	68 1d 7f 10 80       	push   $0x80107f1d
80103cac:	e8 df c6 ff ff       	call   80100390 <panic>
80103cb1:	eb 0d                	jmp    80103cc0 <exit>
80103cb3:	90                   	nop
80103cb4:	90                   	nop
80103cb5:	90                   	nop
80103cb6:	90                   	nop
80103cb7:	90                   	nop
80103cb8:	90                   	nop
80103cb9:	90                   	nop
80103cba:	90                   	nop
80103cbb:	90                   	nop
80103cbc:	90                   	nop
80103cbd:	90                   	nop
80103cbe:	90                   	nop
80103cbf:	90                   	nop

80103cc0 <exit>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103cc9:	e8 62 0d 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80103cce:	e8 fd fa ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103cd3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cd9:	e8 92 0d 00 00       	call   80104a70 <popcli>
  if(curproc == initproc)
80103cde:	39 35 38 b6 10 80    	cmp    %esi,0x8010b638
80103ce4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ce7:	8d 7e 68             	lea    0x68(%esi),%edi
80103cea:	0f 84 f1 00 00 00    	je     80103de1 <exit+0x121>
    if(curproc->ofile[fd]){
80103cf0:	8b 03                	mov    (%ebx),%eax
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	74 12                	je     80103d08 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103cf6:	83 ec 0c             	sub    $0xc,%esp
80103cf9:	50                   	push   %eax
80103cfa:	e8 61 d1 ff ff       	call   80100e60 <fileclose>
      curproc->ofile[fd] = 0;
80103cff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d05:	83 c4 10             	add    $0x10,%esp
80103d08:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d0b:	39 fb                	cmp    %edi,%ebx
80103d0d:	75 e1                	jne    80103cf0 <exit+0x30>
  begin_op();
80103d0f:	e8 bc ee ff ff       	call   80102bd0 <begin_op>
  iput(curproc->cwd);
80103d14:	83 ec 0c             	sub    $0xc,%esp
80103d17:	ff 76 68             	pushl  0x68(%esi)
80103d1a:	e8 c1 da ff ff       	call   801017e0 <iput>
  end_op();
80103d1f:	e8 1c ef ff ff       	call   80102c40 <end_op>
  curproc->cwd = 0;
80103d24:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d2b:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103d32:	e8 c9 0d 00 00       	call   80104b00 <acquire>
  wakeup1(curproc->parent);
80103d37:	8b 56 14             	mov    0x14(%esi),%edx
80103d3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d3d:	b8 f4 8d 11 80       	mov    $0x80118df4,%eax
80103d42:	eb 10                	jmp    80103d54 <exit+0x94>
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d48:	05 2c 01 00 00       	add    $0x12c,%eax
80103d4d:	3d f4 d8 11 80       	cmp    $0x8011d8f4,%eax
80103d52:	73 1e                	jae    80103d72 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103d54:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d58:	75 ee                	jne    80103d48 <exit+0x88>
80103d5a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d5d:	75 e9                	jne    80103d48 <exit+0x88>
      p->state = RUNNABLE;
80103d5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d66:	05 2c 01 00 00       	add    $0x12c,%eax
80103d6b:	3d f4 d8 11 80       	cmp    $0x8011d8f4,%eax
80103d70:	72 e2                	jb     80103d54 <exit+0x94>
      p->parent = initproc;
80103d72:	8b 0d 38 b6 10 80    	mov    0x8010b638,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d78:	ba f4 8d 11 80       	mov    $0x80118df4,%edx
80103d7d:	eb 0f                	jmp    80103d8e <exit+0xce>
80103d7f:	90                   	nop
80103d80:	81 c2 2c 01 00 00    	add    $0x12c,%edx
80103d86:	81 fa f4 d8 11 80    	cmp    $0x8011d8f4,%edx
80103d8c:	73 3a                	jae    80103dc8 <exit+0x108>
    if(p->parent == curproc){
80103d8e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d91:	75 ed                	jne    80103d80 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d93:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d97:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d9a:	75 e4                	jne    80103d80 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d9c:	b8 f4 8d 11 80       	mov    $0x80118df4,%eax
80103da1:	eb 11                	jmp    80103db4 <exit+0xf4>
80103da3:	90                   	nop
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103da8:	05 2c 01 00 00       	add    $0x12c,%eax
80103dad:	3d f4 d8 11 80       	cmp    $0x8011d8f4,%eax
80103db2:	73 cc                	jae    80103d80 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103db4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103db8:	75 ee                	jne    80103da8 <exit+0xe8>
80103dba:	3b 48 20             	cmp    0x20(%eax),%ecx
80103dbd:	75 e9                	jne    80103da8 <exit+0xe8>
      p->state = RUNNABLE;
80103dbf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dc6:	eb e0                	jmp    80103da8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103dc8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103dcf:	e8 2c fe ff ff       	call   80103c00 <sched>
  panic("zombie exit");
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 58 7f 10 80       	push   $0x80107f58
80103ddc:	e8 af c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103de1:	83 ec 0c             	sub    $0xc,%esp
80103de4:	68 4b 7f 10 80       	push   $0x80107f4b
80103de9:	e8 a2 c5 ff ff       	call   80100390 <panic>
80103dee:	66 90                	xchg   %ax,%ax

80103df0 <yield>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103df7:	68 c0 8d 11 80       	push   $0x80118dc0
80103dfc:	e8 ff 0c 00 00       	call   80104b00 <acquire>
  pushcli();
80103e01:	e8 2a 0c 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80103e06:	e8 c5 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103e0b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e11:	e8 5a 0c 00 00       	call   80104a70 <popcli>
  myproc()->state = RUNNABLE;
80103e16:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e1d:	e8 de fd ff ff       	call   80103c00 <sched>
  release(&ptable.lock);
80103e22:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103e29:	e8 92 0d 00 00       	call   80104bc0 <release>
}
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e34:	c9                   	leave  
80103e35:	c3                   	ret    
80103e36:	8d 76 00             	lea    0x0(%esi),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <sleep>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
80103e49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e4f:	e8 dc 0b 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80103e54:	e8 77 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103e59:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e5f:	e8 0c 0c 00 00       	call   80104a70 <popcli>
  if(p == 0)
80103e64:	85 db                	test   %ebx,%ebx
80103e66:	0f 84 87 00 00 00    	je     80103ef3 <sleep+0xb3>
  if(lk == 0)
80103e6c:	85 f6                	test   %esi,%esi
80103e6e:	74 76                	je     80103ee6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e70:	81 fe c0 8d 11 80    	cmp    $0x80118dc0,%esi
80103e76:	74 50                	je     80103ec8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	68 c0 8d 11 80       	push   $0x80118dc0
80103e80:	e8 7b 0c 00 00       	call   80104b00 <acquire>
    release(lk);
80103e85:	89 34 24             	mov    %esi,(%esp)
80103e88:	e8 33 0d 00 00       	call   80104bc0 <release>
  p->chan = chan;
80103e8d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e90:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e97:	e8 64 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103e9c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ea3:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
80103eaa:	e8 11 0d 00 00       	call   80104bc0 <release>
    acquire(lk);
80103eaf:	89 75 08             	mov    %esi,0x8(%ebp)
80103eb2:	83 c4 10             	add    $0x10,%esp
}
80103eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eb8:	5b                   	pop    %ebx
80103eb9:	5e                   	pop    %esi
80103eba:	5f                   	pop    %edi
80103ebb:	5d                   	pop    %ebp
    acquire(lk);
80103ebc:	e9 3f 0c 00 00       	jmp    80104b00 <acquire>
80103ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103ec8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ecb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ed2:	e8 29 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103ed7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee1:	5b                   	pop    %ebx
80103ee2:	5e                   	pop    %esi
80103ee3:	5f                   	pop    %edi
80103ee4:	5d                   	pop    %ebp
80103ee5:	c3                   	ret    
    panic("sleep without lk");
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	68 64 7f 10 80       	push   $0x80107f64
80103eee:	e8 9d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ef3:	83 ec 0c             	sub    $0xc,%esp
80103ef6:	68 d4 80 10 80       	push   $0x801080d4
80103efb:	e8 90 c4 ff ff       	call   80100390 <panic>

80103f00 <wait>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
  pushcli();
80103f05:	e8 26 0b 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80103f0a:	e8 c1 f8 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103f0f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f15:	e8 56 0b 00 00       	call   80104a70 <popcli>
  acquire(&ptable.lock);
80103f1a:	83 ec 0c             	sub    $0xc,%esp
80103f1d:	68 c0 8d 11 80       	push   $0x80118dc0
80103f22:	e8 d9 0b 00 00       	call   80104b00 <acquire>
80103f27:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f2a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2c:	bb f4 8d 11 80       	mov    $0x80118df4,%ebx
80103f31:	eb 13                	jmp    80103f46 <wait+0x46>
80103f33:	90                   	nop
80103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f38:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
80103f3e:	81 fb f4 d8 11 80    	cmp    $0x8011d8f4,%ebx
80103f44:	73 1e                	jae    80103f64 <wait+0x64>
      if(p->parent != curproc)
80103f46:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f49:	75 ed                	jne    80103f38 <wait+0x38>
      if(p->state == ZOMBIE){
80103f4b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f4f:	74 37                	je     80103f88 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f51:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
      havekids = 1;
80103f57:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	81 fb f4 d8 11 80    	cmp    $0x8011d8f4,%ebx
80103f62:	72 e2                	jb     80103f46 <wait+0x46>
    if(!havekids || curproc->killed){
80103f64:	85 c0                	test   %eax,%eax
80103f66:	74 76                	je     80103fde <wait+0xde>
80103f68:	8b 46 24             	mov    0x24(%esi),%eax
80103f6b:	85 c0                	test   %eax,%eax
80103f6d:	75 6f                	jne    80103fde <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f6f:	83 ec 08             	sub    $0x8,%esp
80103f72:	68 c0 8d 11 80       	push   $0x80118dc0
80103f77:	56                   	push   %esi
80103f78:	e8 c3 fe ff ff       	call   80103e40 <sleep>
    havekids = 0;
80103f7d:	83 c4 10             	add    $0x10,%esp
80103f80:	eb a8                	jmp    80103f2a <wait+0x2a>
80103f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f88:	83 ec 0c             	sub    $0xc,%esp
80103f8b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f8e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f91:	e8 aa e3 ff ff       	call   80102340 <kfree>
        freevm(p->pgdir);
80103f96:	5a                   	pop    %edx
80103f97:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fa1:	e8 ba 36 00 00       	call   80107660 <freevm>
        release(&ptable.lock);
80103fa6:	c7 04 24 c0 8d 11 80 	movl   $0x80118dc0,(%esp)
        p->pid = 0;
80103fad:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fb4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fbb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fbf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fc6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fcd:	e8 ee 0b 00 00       	call   80104bc0 <release>
        return pid;
80103fd2:	83 c4 10             	add    $0x10,%esp
}
80103fd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd8:	89 f0                	mov    %esi,%eax
80103fda:	5b                   	pop    %ebx
80103fdb:	5e                   	pop    %esi
80103fdc:	5d                   	pop    %ebp
80103fdd:	c3                   	ret    
      release(&ptable.lock);
80103fde:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fe1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fe6:	68 c0 8d 11 80       	push   $0x80118dc0
80103feb:	e8 d0 0b 00 00       	call   80104bc0 <release>
      return -1;
80103ff0:	83 c4 10             	add    $0x10,%esp
80103ff3:	eb e0                	jmp    80103fd5 <wait+0xd5>
80103ff5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010400a:	68 c0 8d 11 80       	push   $0x80118dc0
8010400f:	e8 ec 0a 00 00       	call   80104b00 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104017:	b8 f4 8d 11 80       	mov    $0x80118df4,%eax
8010401c:	eb 0e                	jmp    8010402c <wakeup+0x2c>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	05 2c 01 00 00       	add    $0x12c,%eax
80104025:	3d f4 d8 11 80       	cmp    $0x8011d8f4,%eax
8010402a:	73 1e                	jae    8010404a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010402c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104030:	75 ee                	jne    80104020 <wakeup+0x20>
80104032:	3b 58 20             	cmp    0x20(%eax),%ebx
80104035:	75 e9                	jne    80104020 <wakeup+0x20>
      p->state = RUNNABLE;
80104037:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403e:	05 2c 01 00 00       	add    $0x12c,%eax
80104043:	3d f4 d8 11 80       	cmp    $0x8011d8f4,%eax
80104048:	72 e2                	jb     8010402c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010404a:	c7 45 08 c0 8d 11 80 	movl   $0x80118dc0,0x8(%ebp)
}
80104051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104054:	c9                   	leave  
  release(&ptable.lock);
80104055:	e9 66 0b 00 00       	jmp    80104bc0 <release>
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104060 <sig_send.part.2>:
    return -1;
  myproc()->sig_htable[sig_num] = handler;
  return 0;
}

int sig_send(int dest_pid, int sig_num, char *sig_arg){
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	bf 04 8e 11 80       	mov    $0x80118e04,%edi
  for(i = 0 ; i < NPROC; i++){
8010406b:	31 db                	xor    %ebx,%ebx
int sig_send(int dest_pid, int sig_num, char *sig_arg){
8010406d:	83 ec 1c             	sub    $0x1c,%esp
80104070:	eb 18                	jmp    8010408a <sig_send.part.2+0x2a>
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0 ; i < NPROC; i++){
80104078:	83 c3 01             	add    $0x1,%ebx
8010407b:	81 c7 2c 01 00 00    	add    $0x12c,%edi
80104081:	83 fb 40             	cmp    $0x40,%ebx
80104084:	0f 84 db 00 00 00    	je     80104165 <sig_send.part.2+0x105>
    if(ptable.proc[i].pid == pid)
8010408a:	39 07                	cmp    %eax,(%edi)
8010408c:	75 ea                	jne    80104078 <sig_send.part.2+0x18>
8010408e:	69 fb 2c 01 00 00    	imul   $0x12c,%ebx,%edi
  // b = (uint)ptable.proc[id].sig_htable[sig_num];

  // debug:
  // cprintf("sigh : %d\n",b);

  acquire(&SigQueue->lock);
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	89 d6                	mov    %edx,%esi
80104099:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010409c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010409f:	8d 87 84 8e 11 80    	lea    -0x7fee717c(%edi),%eax
801040a5:	50                   	push   %eax
801040a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040a9:	e8 52 0a 00 00       	call   80104b00 <acquire>
  if(ptable.proc[id].sig_htable[sig_num] == 0){
801040ae:	6b c3 4b             	imul   $0x4b,%ebx,%eax
801040b1:	83 c4 10             	add    $0x10,%esp
801040b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801040b7:	8d 44 06 28          	lea    0x28(%esi,%eax,1),%eax
801040bb:	8b 04 85 d0 8d 11 80 	mov    -0x7fee7230(,%eax,4),%eax
801040c2:	85 c0                	test   %eax,%eax
801040c4:	0f 84 ae 00 00 00    	je     80104178 <sig_send.part.2+0x118>
    release(&SigQueue->lock);
    return 0;
  }

  if((SigQueue->end + 1) % SIG_QUE_SIZE == SigQueue->start){
801040ca:	8b 8f 1c 8f 11 80    	mov    -0x7fee70e4(%edi),%ecx
801040d0:	8d 87 c0 8d 11 80    	lea    -0x7fee7240(%edi),%eax
801040d6:	89 c6                	mov    %eax,%esi
801040d8:	8d 41 01             	lea    0x1(%ecx),%eax
801040db:	99                   	cltd   
801040dc:	c1 ea 1d             	shr    $0x1d,%edx
801040df:	01 d0                	add    %edx,%eax
801040e1:	83 e0 07             	and    $0x7,%eax
801040e4:	29 d0                	sub    %edx,%eax
801040e6:	3b 86 58 01 00 00    	cmp    0x158(%esi),%eax
801040ec:	74 69                	je     80104157 <sig_send.part.2+0xf7>
    release(&SigQueue->lock);
    return -1;
  }

  // copy the data in queue
  SigQueue->sig_num_list[SigQueue->end] = sig_num;
801040ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
801040f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
  int i;
  for(i = 0; i < MSGSIZE; i++)
801040f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  SigQueue->sig_num_list[SigQueue->end] = sig_num;
801040f7:	8d 54 11 4c          	lea    0x4c(%ecx,%edx,1),%edx
801040fb:	8d 0c cf             	lea    (%edi,%ecx,8),%ecx
801040fe:	89 34 95 c8 8d 11 80 	mov    %esi,-0x7fee7238(,%edx,4)
  for(i = 0; i < MSGSIZE; i++)
80104105:	8b 75 d8             	mov    -0x28(%ebp),%esi
80104108:	31 d2                	xor    %edx,%edx
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SigQueue->sig_arg[SigQueue->end][i] = sig_arg[i];
80104110:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80104114:	88 84 11 b8 8e 11 80 	mov    %al,-0x7fee7148(%ecx,%edx,1)
  for(i = 0; i < MSGSIZE; i++)
8010411b:	83 c2 01             	add    $0x1,%edx
8010411e:	83 fa 08             	cmp    $0x8,%edx
80104121:	75 ed                	jne    80104110 <sig_send.part.2+0xb0>
80104123:	8b 45 e0             	mov    -0x20(%ebp),%eax
  SigQueue->end %= SIG_QUE_SIZE;

  // wakeup if the signal reciever process is waiting for it
  // debug:
  // cprintf("Channel in send : %p\n",(uint)(&SigQueue->start));
  wakeup(&SigQueue->start);
80104126:	83 ec 0c             	sub    $0xc,%esp
  SigQueue->end %= SIG_QUE_SIZE;
80104129:	69 db 2c 01 00 00    	imul   $0x12c,%ebx,%ebx
8010412f:	89 83 1c 8f 11 80    	mov    %eax,-0x7fee70e4(%ebx)
  wakeup(&SigQueue->start);
80104135:	8d 87 18 8f 11 80    	lea    -0x7fee70e8(%edi),%eax
8010413b:	50                   	push   %eax
8010413c:	e8 bf fe ff ff       	call   80104000 <wakeup>

  release(&SigQueue->lock);
80104141:	5a                   	pop    %edx
80104142:	ff 75 e4             	pushl  -0x1c(%ebp)
80104145:	e8 76 0a 00 00       	call   80104bc0 <release>
8010414a:	83 c4 10             	add    $0x10,%esp
  return 0;
}
8010414d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80104150:	31 c0                	xor    %eax,%eax
}
80104152:	5b                   	pop    %ebx
80104153:	5e                   	pop    %esi
80104154:	5f                   	pop    %edi
80104155:	5d                   	pop    %ebp
80104156:	c3                   	ret    
    release(&SigQueue->lock);
80104157:	83 ec 0c             	sub    $0xc,%esp
8010415a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010415d:	e8 5e 0a 00 00       	call   80104bc0 <release>
80104162:	83 c4 10             	add    $0x10,%esp
}
80104165:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80104168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010416d:	5b                   	pop    %ebx
8010416e:	5e                   	pop    %esi
8010416f:	5f                   	pop    %edi
80104170:	5d                   	pop    %ebp
80104171:	c3                   	ret    
80104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&SigQueue->lock);
80104178:	83 ec 0c             	sub    $0xc,%esp
8010417b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010417e:	e8 3d 0a 00 00       	call   80104bc0 <release>
80104183:	83 c4 10             	add    $0x10,%esp
}
80104186:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104189:	31 c0                	xor    %eax,%eax
}
8010418b:	5b                   	pop    %ebx
8010418c:	5e                   	pop    %esi
8010418d:	5f                   	pop    %edi
8010418e:	5d                   	pop    %ebp
8010418f:	c3                   	ret    

80104190 <kill>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
80104197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010419a:	68 c0 8d 11 80       	push   $0x80118dc0
8010419f:	e8 5c 09 00 00       	call   80104b00 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a7:	b8 f4 8d 11 80       	mov    $0x80118df4,%eax
801041ac:	eb 0e                	jmp    801041bc <kill+0x2c>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	05 2c 01 00 00       	add    $0x12c,%eax
801041b5:	3d f4 d8 11 80       	cmp    $0x8011d8f4,%eax
801041ba:	73 34                	jae    801041f0 <kill+0x60>
    if(p->pid == pid){
801041bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801041bf:	75 ef                	jne    801041b0 <kill+0x20>
      if(p->state == SLEEPING)
801041c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041cc:	75 07                	jne    801041d5 <kill+0x45>
        p->state = RUNNABLE;
801041ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041d5:	83 ec 0c             	sub    $0xc,%esp
801041d8:	68 c0 8d 11 80       	push   $0x80118dc0
801041dd:	e8 de 09 00 00       	call   80104bc0 <release>
      return 0;
801041e2:	83 c4 10             	add    $0x10,%esp
801041e5:	31 c0                	xor    %eax,%eax
}
801041e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041ea:	c9                   	leave  
801041eb:	c3                   	ret    
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	68 c0 8d 11 80       	push   $0x80118dc0
801041f8:	e8 c3 09 00 00       	call   80104bc0 <release>
  return -1;
801041fd:	83 c4 10             	add    $0x10,%esp
80104200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <procdump>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104219:	bb f4 8d 11 80       	mov    $0x80118df4,%ebx
{
8010421e:	83 ec 3c             	sub    $0x3c,%esp
80104221:	eb 27                	jmp    8010424a <procdump+0x3a>
80104223:	90                   	nop
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 87 84 10 80       	push   $0x80108487
80104230:	e8 2b c4 ff ff       	call   80100660 <cprintf>
80104235:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104238:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
8010423e:	81 fb f4 d8 11 80    	cmp    $0x8011d8f4,%ebx
80104244:	0f 83 86 00 00 00    	jae    801042d0 <procdump+0xc0>
    if(p->state == UNUSED)
8010424a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010424d:	85 c0                	test   %eax,%eax
8010424f:	74 e7                	je     80104238 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104251:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104254:	ba 75 7f 10 80       	mov    $0x80107f75,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104259:	77 11                	ja     8010426c <procdump+0x5c>
8010425b:	8b 14 85 f4 7f 10 80 	mov    -0x7fef800c(,%eax,4),%edx
      state = "???";
80104262:	b8 75 7f 10 80       	mov    $0x80107f75,%eax
80104267:	85 d2                	test   %edx,%edx
80104269:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010426c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010426f:	50                   	push   %eax
80104270:	52                   	push   %edx
80104271:	ff 73 10             	pushl  0x10(%ebx)
80104274:	68 79 7f 10 80       	push   $0x80107f79
80104279:	e8 e2 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010427e:	83 c4 10             	add    $0x10,%esp
80104281:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104285:	75 a1                	jne    80104228 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104287:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010428a:	83 ec 08             	sub    $0x8,%esp
8010428d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104290:	50                   	push   %eax
80104291:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104294:	8b 40 0c             	mov    0xc(%eax),%eax
80104297:	83 c0 08             	add    $0x8,%eax
8010429a:	50                   	push   %eax
8010429b:	e8 40 07 00 00       	call   801049e0 <getcallerpcs>
801042a0:	83 c4 10             	add    $0x10,%esp
801042a3:	90                   	nop
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801042a8:	8b 17                	mov    (%edi),%edx
801042aa:	85 d2                	test   %edx,%edx
801042ac:	0f 84 76 ff ff ff    	je     80104228 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042b2:	83 ec 08             	sub    $0x8,%esp
801042b5:	83 c7 04             	add    $0x4,%edi
801042b8:	52                   	push   %edx
801042b9:	68 c1 79 10 80       	push   $0x801079c1
801042be:	e8 9d c3 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042c3:	83 c4 10             	add    $0x10,%esp
801042c6:	39 fe                	cmp    %edi,%esi
801042c8:	75 de                	jne    801042a8 <procdump+0x98>
801042ca:	e9 59 ff ff ff       	jmp    80104228 <procdump+0x18>
801042cf:	90                   	nop
}
801042d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d3:	5b                   	pop    %ebx
801042d4:	5e                   	pop    %esi
801042d5:	5f                   	pop    %edi
801042d6:	5d                   	pop    %ebp
801042d7:	c3                   	ret    
801042d8:	90                   	nop
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042e0 <ps_print_list>:
ps_print_list(){
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	bb 60 8e 11 80       	mov    $0x80118e60,%ebx
801042e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801042ec:	68 c0 8d 11 80       	push   $0x80118dc0
801042f1:	e8 0a 08 00 00       	call   80104b00 <acquire>
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	eb 13                	jmp    8010430e <ps_print_list+0x2e>
801042fb:	90                   	nop
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104300:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; i < NPROC; i++){
80104306:	81 fb 60 d9 11 80    	cmp    $0x8011d960,%ebx
8010430c:	74 29                	je     80104337 <ps_print_list+0x57>
    if(ptable.proc[i].state != UNUSED){
8010430e:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104311:	85 c0                	test   %eax,%eax
80104313:	74 eb                	je     80104300 <ps_print_list+0x20>
      cprintf("pid:%d name:%s\n", ptable.proc[i].pid, ptable.proc[i].name);
80104315:	83 ec 04             	sub    $0x4,%esp
80104318:	53                   	push   %ebx
80104319:	ff 73 a4             	pushl  -0x5c(%ebx)
8010431c:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
80104322:	68 82 7f 10 80       	push   $0x80107f82
80104327:	e8 34 c3 ff ff       	call   80100660 <cprintf>
8010432c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPROC; i++){
8010432f:	81 fb 60 d9 11 80    	cmp    $0x8011d960,%ebx
80104335:	75 d7                	jne    8010430e <ps_print_list+0x2e>
  release(&ptable.lock);
80104337:	83 ec 0c             	sub    $0xc,%esp
8010433a:	68 c0 8d 11 80       	push   $0x80118dc0
8010433f:	e8 7c 08 00 00       	call   80104bc0 <release>
}
80104344:	83 c4 10             	add    $0x10,%esp
80104347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010434a:	c9                   	leave  
8010434b:	c3                   	ret    
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104350 <get_process_id>:
get_process_id(int pid){
80104350:	55                   	push   %ebp
80104351:	ba 04 8e 11 80       	mov    $0x80118e04,%edx
  for(i = 0 ; i < NPROC; i++){
80104356:	31 c0                	xor    %eax,%eax
get_process_id(int pid){
80104358:	89 e5                	mov    %esp,%ebp
8010435a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010435d:	eb 0f                	jmp    8010436e <get_process_id+0x1e>
8010435f:	90                   	nop
  for(i = 0 ; i < NPROC; i++){
80104360:	83 c0 01             	add    $0x1,%eax
80104363:	81 c2 2c 01 00 00    	add    $0x12c,%edx
80104369:	83 f8 40             	cmp    $0x40,%eax
8010436c:	74 0a                	je     80104378 <get_process_id+0x28>
    if(ptable.proc[i].pid == pid)
8010436e:	39 0a                	cmp    %ecx,(%edx)
80104370:	75 ee                	jne    80104360 <get_process_id+0x10>
}
80104372:	5d                   	pop    %ebp
80104373:	c3                   	ret    
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80104378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010437d:	5d                   	pop    %ebp
8010437e:	c3                   	ret    
8010437f:	90                   	nop

80104380 <send_msg>:
send_msg(int sender_pid, int rec_pid, char *msg){
80104380:	55                   	push   %ebp
80104381:	b8 04 8e 11 80       	mov    $0x80118e04,%eax
80104386:	89 e5                	mov    %esp,%ebp
80104388:	57                   	push   %edi
80104389:	56                   	push   %esi
8010438a:	53                   	push   %ebx
  for(i = 0 ; i < NPROC; i++){
8010438b:	31 db                	xor    %ebx,%ebx
send_msg(int sender_pid, int rec_pid, char *msg){
8010438d:	83 ec 1c             	sub    $0x1c,%esp
80104390:	8b 55 0c             	mov    0xc(%ebp),%edx
80104393:	8b 75 10             	mov    0x10(%ebp),%esi
80104396:	eb 19                	jmp    801043b1 <send_msg+0x31>
80104398:	90                   	nop
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0 ; i < NPROC; i++){
801043a0:	83 c3 01             	add    $0x1,%ebx
801043a3:	05 2c 01 00 00       	add    $0x12c,%eax
801043a8:	83 fb 40             	cmp    $0x40,%ebx
801043ab:	0f 84 a3 00 00 00    	je     80104454 <send_msg+0xd4>
    if(ptable.proc[i].pid == pid)
801043b1:	3b 10                	cmp    (%eax),%edx
801043b3:	75 eb                	jne    801043a0 <send_msg+0x20>
801043b5:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  acquire(&MsgQueue[id].lock);
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801043be:	c1 e0 06             	shl    $0x6,%eax
801043c1:	8d b8 c0 0f 11 80    	lea    -0x7feef040(%eax),%edi
801043c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043ca:	57                   	push   %edi
801043cb:	e8 30 07 00 00       	call   80104b00 <acquire>
  if((MsgQueue[id].end + 1) % BUFFER_SIZE == MsgQueue[id].start){
801043d0:	8b 8f 38 01 00 00    	mov    0x138(%edi),%ecx
801043d6:	83 c4 10             	add    $0x10,%esp
801043d9:	8d 41 01             	lea    0x1(%ecx),%eax
801043dc:	99                   	cltd   
801043dd:	c1 ea 1b             	shr    $0x1b,%edx
801043e0:	01 d0                	add    %edx,%eax
801043e2:	83 e0 1f             	and    $0x1f,%eax
801043e5:	29 d0                	sub    %edx,%eax
801043e7:	3b 87 34 01 00 00    	cmp    0x134(%edi),%eax
801043ed:	74 59                	je     80104448 <send_msg+0xc8>
801043ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  for(i = 0; i < MSGSIZE; i++){
801043f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801043f5:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
801043f8:	31 d2                	xor    %edx,%edx
801043fa:	c1 e1 03             	shl    $0x3,%ecx
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
    MsgQueue[id].data[MsgQueue[id].end][i] = msg[i];
80104400:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80104404:	88 84 11 f4 0f 11 80 	mov    %al,-0x7feef00c(%ecx,%edx,1)
  for(i = 0; i < MSGSIZE; i++){
8010440b:	83 c2 01             	add    $0x1,%edx
8010440e:	83 fa 08             	cmp    $0x8,%edx
80104411:	75 ed                	jne    80104400 <send_msg+0x80>
80104413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  MsgQueue[id].end %= BUFFER_SIZE;
80104416:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
  wakeup(&MsgQueue[id].channel);
80104419:	83 ec 0c             	sub    $0xc,%esp
  MsgQueue[id].end %= BUFFER_SIZE;
8010441c:	c1 e2 06             	shl    $0x6,%edx
8010441f:	89 82 f8 10 11 80    	mov    %eax,-0x7feeef08(%edx)
  wakeup(&MsgQueue[id].channel);
80104425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104428:	05 fc 10 11 80       	add    $0x801110fc,%eax
8010442d:	50                   	push   %eax
8010442e:	e8 cd fb ff ff       	call   80104000 <wakeup>
  release(&MsgQueue[id].lock);
80104433:	89 3c 24             	mov    %edi,(%esp)
80104436:	e8 85 07 00 00       	call   80104bc0 <release>
  return 0;
8010443b:	83 c4 10             	add    $0x10,%esp
}
8010443e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80104441:	31 c0                	xor    %eax,%eax
}
80104443:	5b                   	pop    %ebx
80104444:	5e                   	pop    %esi
80104445:	5f                   	pop    %edi
80104446:	5d                   	pop    %ebp
80104447:	c3                   	ret    
    release(&MsgQueue[id].lock);
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	57                   	push   %edi
8010444c:	e8 6f 07 00 00       	call   80104bc0 <release>
    return -1;
80104451:	83 c4 10             	add    $0x10,%esp
}
80104454:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80104457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010445c:	5b                   	pop    %ebx
8010445d:	5e                   	pop    %esi
8010445e:	5f                   	pop    %edi
8010445f:	5d                   	pop    %ebp
80104460:	c3                   	ret    
80104461:	eb 0d                	jmp    80104470 <recv_msg>
80104463:	90                   	nop
80104464:	90                   	nop
80104465:	90                   	nop
80104466:	90                   	nop
80104467:	90                   	nop
80104468:	90                   	nop
80104469:	90                   	nop
8010446a:	90                   	nop
8010446b:	90                   	nop
8010446c:	90                   	nop
8010446d:	90                   	nop
8010446e:	90                   	nop
8010446f:	90                   	nop

80104470 <recv_msg>:
recv_msg(char* msg){
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
  for(i = 0 ; i < NPROC; i++){
80104476:	31 f6                	xor    %esi,%esi
recv_msg(char* msg){
80104478:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010447b:	e8 b0 05 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80104480:	e8 4b f3 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104485:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448b:	e8 e0 05 00 00       	call   80104a70 <popcli>
80104490:	b8 04 8e 11 80       	mov    $0x80118e04,%eax
  int rec_id = myproc()->pid;
80104495:	8b 53 10             	mov    0x10(%ebx),%edx
80104498:	eb 17                	jmp    801044b1 <recv_msg+0x41>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0 ; i < NPROC; i++){
801044a0:	83 c6 01             	add    $0x1,%esi
801044a3:	05 2c 01 00 00       	add    $0x12c,%eax
801044a8:	83 fe 40             	cmp    $0x40,%esi
801044ab:	0f 84 c7 00 00 00    	je     80104578 <recv_msg+0x108>
    if(ptable.proc[i].pid == pid)
801044b1:	3b 10                	cmp    (%eax),%edx
801044b3:	75 eb                	jne    801044a0 <recv_msg+0x30>
801044b5:	8d 3c b6             	lea    (%esi,%esi,4),%edi
  acquire(&MsgQueue[id].lock);
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	c1 e7 06             	shl    $0x6,%edi
801044be:	8d 9f c0 0f 11 80    	lea    -0x7feef040(%edi),%ebx
801044c4:	53                   	push   %ebx
801044c5:	e8 36 06 00 00       	call   80104b00 <acquire>
    if(MsgQueue[id].end == MsgQueue[id].start){
801044ca:	8b 93 34 01 00 00    	mov    0x134(%ebx),%edx
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	3b 93 38 01 00 00    	cmp    0x138(%ebx),%edx
      sleep(&MsgQueue[id].channel, &MsgQueue[id].lock);
801044d9:	8d 87 fc 10 11 80    	lea    -0x7feeef04(%edi),%eax
    if(MsgQueue[id].end == MsgQueue[id].start){
801044df:	89 df                	mov    %ebx,%edi
      sleep(&MsgQueue[id].channel, &MsgQueue[id].lock);
801044e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(MsgQueue[id].end == MsgQueue[id].start){
801044e4:	75 27                	jne    8010450d <recv_msg+0x9d>
801044e6:	8d 76 00             	lea    0x0(%esi),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      sleep(&MsgQueue[id].channel, &MsgQueue[id].lock);
801044f0:	83 ec 08             	sub    $0x8,%esp
801044f3:	53                   	push   %ebx
801044f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801044f7:	e8 44 f9 ff ff       	call   80103e40 <sleep>
    if(MsgQueue[id].end == MsgQueue[id].start){
801044fc:	8b 97 34 01 00 00    	mov    0x134(%edi),%edx
80104502:	83 c4 10             	add    $0x10,%esp
80104505:	39 97 38 01 00 00    	cmp    %edx,0x138(%edi)
8010450b:	74 e3                	je     801044f0 <recv_msg+0x80>
        msg[i] = MsgQueue[id].data[MsgQueue[id].start][i];
8010450d:	8d 3c b6             	lea    (%esi,%esi,4),%edi
      for(i = 0; i < MSGSIZE; i++){
80104510:	31 c0                	xor    %eax,%eax
        msg[i] = MsgQueue[id].data[MsgQueue[id].start][i];
80104512:	89 f9                	mov    %edi,%ecx
80104514:	c1 e1 06             	shl    $0x6,%ecx
80104517:	eb 0d                	jmp    80104526 <recv_msg+0xb6>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104520:	8b 91 f4 10 11 80    	mov    -0x7feeef0c(%ecx),%edx
80104526:	8d 94 d1 c0 0f 11 80 	lea    -0x7feef040(%ecx,%edx,8),%edx
8010452d:	8b 75 08             	mov    0x8(%ebp),%esi
80104530:	0f b6 54 02 34       	movzbl 0x34(%edx,%eax,1),%edx
80104535:	88 14 06             	mov    %dl,(%esi,%eax,1)
      for(i = 0; i < MSGSIZE; i++){
80104538:	83 c0 01             	add    $0x1,%eax
8010453b:	83 f8 08             	cmp    $0x8,%eax
8010453e:	75 e0                	jne    80104520 <recv_msg+0xb0>
      MsgQueue[id].start %= BUFFER_SIZE;
80104540:	c1 e7 06             	shl    $0x6,%edi
      release(&MsgQueue[id].lock);
80104543:	83 ec 0c             	sub    $0xc,%esp
      MsgQueue[id].start++;
80104546:	8b 87 f4 10 11 80    	mov    -0x7feeef0c(%edi),%eax
      release(&MsgQueue[id].lock);
8010454c:	53                   	push   %ebx
      MsgQueue[id].start++;
8010454d:	83 c0 01             	add    $0x1,%eax
      MsgQueue[id].start %= BUFFER_SIZE;
80104550:	99                   	cltd   
80104551:	c1 ea 1b             	shr    $0x1b,%edx
80104554:	01 d0                	add    %edx,%eax
80104556:	83 e0 1f             	and    $0x1f,%eax
80104559:	29 d0                	sub    %edx,%eax
8010455b:	89 87 f4 10 11 80    	mov    %eax,-0x7feeef0c(%edi)
      release(&MsgQueue[id].lock);
80104561:	e8 5a 06 00 00       	call   80104bc0 <release>
  return 0;
80104566:	83 c4 10             	add    $0x10,%esp
}
80104569:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010456c:	31 c0                	xor    %eax,%eax
}
8010456e:	5b                   	pop    %ebx
8010456f:	5e                   	pop    %esi
80104570:	5f                   	pop    %edi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret    
80104573:	90                   	nop
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(id == -1) return -1;
8010457b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104580:	5b                   	pop    %ebx
80104581:	5e                   	pop    %esi
80104582:	5f                   	pop    %edi
80104583:	5d                   	pop    %ebp
80104584:	c3                   	ret    
80104585:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <sig_set>:
int sig_set(int sig_num, sighandler_t handler){
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(sig_num < 0 || sig_num >= NoSigHandlers)
80104598:	83 fb 03             	cmp    $0x3,%ebx
8010459b:	77 23                	ja     801045c0 <sig_set+0x30>
  pushcli();
8010459d:	e8 8e 04 00 00       	call   80104a30 <pushcli>
  c = mycpu();
801045a2:	e8 29 f2 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801045a7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045ad:	e8 be 04 00 00       	call   80104a70 <popcli>
  myproc()->sig_htable[sig_num] = handler;
801045b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801045b5:	89 44 9e 7c          	mov    %eax,0x7c(%esi,%ebx,4)
  return 0;
801045b9:	31 c0                	xor    %eax,%eax
}
801045bb:	5b                   	pop    %ebx
801045bc:	5e                   	pop    %esi
801045bd:	5d                   	pop    %ebp
801045be:	c3                   	ret    
801045bf:	90                   	nop
    return -1;
801045c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c5:	eb f4                	jmp    801045bb <sig_set+0x2b>
801045c7:	89 f6                	mov    %esi,%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <sig_send>:
int sig_send(int dest_pid, int sig_num, char *sig_arg){
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801045d6:	8b 45 08             	mov    0x8(%ebp),%eax
801045d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(sig_num < 0 || sig_num >= NoSigHandlers)
801045dc:	83 fa 03             	cmp    $0x3,%edx
801045df:	77 06                	ja     801045e7 <sig_send+0x17>
}
801045e1:	5d                   	pop    %ebp
801045e2:	e9 79 fa ff ff       	jmp    80104060 <sig_send.part.2>
801045e7:	83 c8 ff             	or     $0xffffffff,%eax
801045ea:	5d                   	pop    %ebp
801045eb:	c3                   	ret    
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <sig_pause>:

int sig_pause(void){
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
  pushcli();
801045f5:	e8 36 04 00 00       	call   80104a30 <pushcli>
  c = mycpu();
801045fa:	e8 d1 f1 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801045ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104605:	e8 66 04 00 00       	call   80104a70 <popcli>
8010460a:	ba 04 8e 11 80       	mov    $0x80118e04,%edx
  for(i = 0 ; i < NPROC; i++){
8010460f:	31 c0                	xor    %eax,%eax
  int pid = myproc()->pid;
80104611:	8b 4b 10             	mov    0x10(%ebx),%ecx
80104614:	eb 18                	jmp    8010462e <sig_pause+0x3e>
80104616:	8d 76 00             	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i = 0 ; i < NPROC; i++){
80104620:	83 c0 01             	add    $0x1,%eax
80104623:	81 c2 2c 01 00 00    	add    $0x12c,%edx
80104629:	83 f8 40             	cmp    $0x40,%eax
8010462c:	74 5a                	je     80104688 <sig_pause+0x98>
    if(ptable.proc[i].pid == pid)
8010462e:	3b 0a                	cmp    (%edx),%ecx
80104630:	75 ee                	jne    80104620 <sig_pause+0x30>
80104632:	69 d8 2c 01 00 00    	imul   $0x12c,%eax,%ebx
  int id = get_process_id(pid);
  if(id == -1) return -1;

  acquire(&ptable.proc[id].SigQueue.lock);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d b3 84 8e 11 80    	lea    -0x7fee717c(%ebx),%esi
80104641:	56                   	push   %esi
80104642:	e8 b9 04 00 00       	call   80104b00 <acquire>

  if(ptable.proc[id].SigQueue.end == ptable.proc[id].SigQueue.start){
80104647:	83 c4 10             	add    $0x10,%esp
8010464a:	8b 83 18 8f 11 80    	mov    -0x7fee70e8(%ebx),%eax
80104650:	39 83 1c 8f 11 80    	cmp    %eax,-0x7fee70e4(%ebx)
80104656:	74 18                	je     80104670 <sig_pause+0x80>
    sleep(&ptable.proc[id].SigQueue.start, &ptable.proc[id].SigQueue.lock);
    // debug:
    // cprintf("Pause : Sleep done\n");
  }

  release(&ptable.proc[id].SigQueue.lock);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	56                   	push   %esi
8010465c:	e8 5f 05 00 00       	call   80104bc0 <release>
  return 0;
80104661:	83 c4 10             	add    $0x10,%esp
}
80104664:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
80104667:	31 c0                	xor    %eax,%eax
}
80104669:	5b                   	pop    %ebx
8010466a:	5e                   	pop    %esi
8010466b:	5d                   	pop    %ebp
8010466c:	c3                   	ret    
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(&ptable.proc[id].SigQueue.start, &ptable.proc[id].SigQueue.lock);
80104670:	8d 83 18 8f 11 80    	lea    -0x7fee70e8(%ebx),%eax
80104676:	83 ec 08             	sub    $0x8,%esp
80104679:	56                   	push   %esi
8010467a:	50                   	push   %eax
8010467b:	e8 c0 f7 ff ff       	call   80103e40 <sleep>
80104680:	83 c4 10             	add    $0x10,%esp
80104683:	eb d3                	jmp    80104658 <sig_pause+0x68>
80104685:	8d 76 00             	lea    0x0(%esi),%esi
}
80104688:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(id == -1) return -1;
8010468b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104690:	5b                   	pop    %ebx
80104691:	5e                   	pop    %esi
80104692:	5d                   	pop    %ebp
80104693:	c3                   	ret    
80104694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010469a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801046a0 <sig_ret>:

int sig_ret(void){
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801046a7:	e8 84 03 00 00       	call   80104a30 <pushcli>
  c = mycpu();
801046ac:	e8 1f f1 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801046b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046b7:	e8 b4 03 00 00       	call   80104a70 <popcli>
  uint ustack_esp = curproc->tf->esp;
  
  uint sig_ret_code_size = ((uint)&execute_sigret_syscall_end - (uint)&execute_sigret_syscall_start);
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
  // copy back the trapframe to kernel stack
  memmove((void *)curproc->tf, (void *)ustack_esp, sizeof(struct trapframe));
801046bc:	83 ec 04             	sub    $0x4,%esp
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
801046bf:	b8 90 48 10 80       	mov    $0x80104890,%eax
  uint ustack_esp = curproc->tf->esp;
801046c4:	8b 53 18             	mov    0x18(%ebx),%edx
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
801046c7:	2d 7c 48 10 80       	sub    $0x8010487c,%eax
  memmove((void *)curproc->tf, (void *)ustack_esp, sizeof(struct trapframe));
801046cc:	6a 4c                	push   $0x4c
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
801046ce:	03 42 44             	add    0x44(%edx),%eax
  memmove((void *)curproc->tf, (void *)ustack_esp, sizeof(struct trapframe));
801046d1:	50                   	push   %eax
801046d2:	52                   	push   %edx
801046d3:	e8 e8 05 00 00       	call   80104cc0 <memmove>
  return 0;
}
801046d8:	31 c0                	xor    %eax,%eax
801046da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046dd:	c9                   	leave  
801046de:	c3                   	ret    
801046df:	90                   	nop

801046e0 <execute_signal_handler>:

void execute_signal_handler(void){
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
801046e9:	e8 42 03 00 00       	call   80104a30 <pushcli>
  c = mycpu();
801046ee:	e8 dd f0 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801046f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046f9:	e8 72 03 00 00       	call   80104a70 <popcli>
  pushcli();
801046fe:	e8 2d 03 00 00       	call   80104a30 <pushcli>
  c = mycpu();
80104703:	e8 c8 f0 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104708:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010470e:	e8 5d 03 00 00       	call   80104a70 <popcli>
  struct proc *curproc = myproc();
  struct sig_queue *SigQueue = &curproc->SigQueue;

  if(myproc() == 0 || (curproc->tf->cs & 3) != DPL_USER)
80104713:	85 f6                	test   %esi,%esi
80104715:	74 10                	je     80104727 <execute_signal_handler+0x47>
80104717:	8b 43 18             	mov    0x18(%ebx),%eax
8010471a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010471e:	83 e0 03             	and    $0x3,%eax
80104721:	66 83 f8 03          	cmp    $0x3,%ax
80104725:	74 09                	je     80104730 <execute_signal_handler+0x50>
  curproc->tf->esp = ustack_esp;
  // cprintf("esp : %d, uesp : %d\n", curproc->tf->esp, ustack_esp);

  release(&SigQueue->lock);
  return;
}
80104727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010472a:	5b                   	pop    %ebx
8010472b:	5e                   	pop    %esi
8010472c:	5f                   	pop    %edi
8010472d:	5d                   	pop    %ebp
8010472e:	c3                   	ret    
8010472f:	90                   	nop
  acquire(&SigQueue->lock);
80104730:	8d bb 90 00 00 00    	lea    0x90(%ebx),%edi
80104736:	83 ec 0c             	sub    $0xc,%esp
80104739:	57                   	push   %edi
8010473a:	e8 c1 03 00 00       	call   80104b00 <acquire>
  if(SigQueue->start == SigQueue->end){
8010473f:	8b 83 24 01 00 00    	mov    0x124(%ebx),%eax
80104745:	83 c4 10             	add    $0x10,%esp
80104748:	3b 83 28 01 00 00    	cmp    0x128(%ebx),%eax
8010474e:	0f 84 c4 00 00 00    	je     80104818 <execute_signal_handler+0x138>
  int sig_num = SigQueue->sig_num_list[SigQueue->start];
80104754:	8b b4 83 04 01 00 00 	mov    0x104(%ebx,%eax,4),%esi
  char* msg = SigQueue->sig_arg[SigQueue->start];
8010475b:	8d 54 c7 34          	lea    0x34(%edi,%eax,8),%edx
  SigQueue->start++;
8010475f:	83 c0 01             	add    $0x1,%eax
  SigQueue->start %= SIG_QUE_SIZE;
80104762:	89 c1                	mov    %eax,%ecx
  memmove((void *)ustack_esp, (void *)curproc->tf, sizeof(struct trapframe));
80104764:	83 ec 04             	sub    $0x4,%esp
  SigQueue->start %= SIG_QUE_SIZE;
80104767:	c1 f9 1f             	sar    $0x1f,%ecx
  char* msg = SigQueue->sig_arg[SigQueue->start];
8010476a:	89 55 d0             	mov    %edx,-0x30(%ebp)
  SigQueue->start %= SIG_QUE_SIZE;
8010476d:	c1 e9 1d             	shr    $0x1d,%ecx
80104770:	01 c8                	add    %ecx,%eax
80104772:	83 e0 07             	and    $0x7,%eax
80104775:	29 c8                	sub    %ecx,%eax
80104777:	89 83 24 01 00 00    	mov    %eax,0x124(%ebx)
  uint ustack_esp = curproc->tf->esp;
8010477d:	8b 43 18             	mov    0x18(%ebx),%eax
  ustack_esp -= sizeof(struct trapframe);
80104780:	8b 50 44             	mov    0x44(%eax),%edx
  memmove((void *)ustack_esp, (void *)curproc->tf, sizeof(struct trapframe));
80104783:	6a 4c                	push   $0x4c
80104785:	50                   	push   %eax
  ustack_esp -= sizeof(struct trapframe);
80104786:	8d 4a b4             	lea    -0x4c(%edx),%ecx
  memmove((void *)ustack_esp, (void *)curproc->tf, sizeof(struct trapframe));
80104789:	51                   	push   %ecx
8010478a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
8010478d:	e8 2e 05 00 00       	call   80104cc0 <memmove>
  curproc->tf->eip = (uint)curproc->sig_htable[sig_num];
80104792:	8b 43 18             	mov    0x18(%ebx),%eax
80104795:	8b 74 b3 7c          	mov    0x7c(%ebx,%esi,4),%esi
  memmove((void *)ustack_esp, sig_ret_code_addr, sig_ret_code_size);
80104799:	83 c4 0c             	add    $0xc,%esp
  ustack_esp -= sig_ret_code_size;
8010479c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  curproc->tf->eip = (uint)curproc->sig_htable[sig_num];
8010479f:	89 70 38             	mov    %esi,0x38(%eax)
  uint sig_ret_code_size = ((uint)&execute_sigret_syscall_end - (uint)&execute_sigret_syscall_start);
801047a2:	b8 84 48 10 80       	mov    $0x80104884,%eax
801047a7:	2d 7c 48 10 80       	sub    $0x8010487c,%eax
  ustack_esp -= sig_ret_code_size;
801047ac:	29 c1                	sub    %eax,%ecx
  memmove((void *)ustack_esp, sig_ret_code_addr, sig_ret_code_size);
801047ae:	50                   	push   %eax
801047af:	68 7c 48 10 80       	push   $0x8010487c
801047b4:	51                   	push   %ecx
  ustack_esp -= sig_ret_code_size;
801047b5:	89 ce                	mov    %ecx,%esi
  uint handler_ret_addr = ustack_esp;
801047b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  memmove((void *)ustack_esp, sig_ret_code_addr, sig_ret_code_size);
801047ba:	e8 01 05 00 00       	call   80104cc0 <memmove>
  memmove((void *)ustack_esp, (void *)msg, MSGSIZE); 
801047bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  ustack_esp -= MSGSIZE;
801047c2:	8d 46 f8             	lea    -0x8(%esi),%eax
  memmove((void *)ustack_esp, (void *)msg, MSGSIZE); 
801047c5:	83 c4 0c             	add    $0xc,%esp
801047c8:	6a 08                	push   $0x8
  uint para1 = ustack_esp;
801047ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memmove((void *)ustack_esp, (void *)msg, MSGSIZE); 
801047cd:	52                   	push   %edx
801047ce:	50                   	push   %eax
801047cf:	e8 ec 04 00 00       	call   80104cc0 <memmove>
  memmove((void *)ustack_esp, (void *)&para1, sizeof(uint));
801047d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801047d7:	83 c4 0c             	add    $0xc,%esp
801047da:	6a 04                	push   $0x4
801047dc:	50                   	push   %eax
  ustack_esp -= sizeof(uint);
801047dd:	8d 46 f4             	lea    -0xc(%esi),%eax
  ustack_esp -= sizeof(uint);
801047e0:	83 ee 10             	sub    $0x10,%esi
  memmove((void *)ustack_esp, (void *)&para1, sizeof(uint));
801047e3:	50                   	push   %eax
801047e4:	e8 d7 04 00 00       	call   80104cc0 <memmove>
  memmove((void *)ustack_esp, (void *)&handler_ret_addr, sizeof(uint));
801047e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801047ec:	83 c4 0c             	add    $0xc,%esp
801047ef:	6a 04                	push   $0x4
801047f1:	50                   	push   %eax
801047f2:	56                   	push   %esi
801047f3:	e8 c8 04 00 00       	call   80104cc0 <memmove>
  curproc->tf->esp = ustack_esp;
801047f8:	8b 43 18             	mov    0x18(%ebx),%eax
801047fb:	89 70 44             	mov    %esi,0x44(%eax)
  release(&SigQueue->lock);
801047fe:	89 3c 24             	mov    %edi,(%esp)
80104801:	e8 ba 03 00 00       	call   80104bc0 <release>
  return;
80104806:	83 c4 10             	add    $0x10,%esp
}
80104809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480c:	5b                   	pop    %ebx
8010480d:	5e                   	pop    %esi
8010480e:	5f                   	pop    %edi
8010480f:	5d                   	pop    %ebp
80104810:	c3                   	ret    
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&SigQueue->lock);
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	57                   	push   %edi
8010481c:	e8 9f 03 00 00       	call   80104bc0 <release>
    return;
80104821:	83 c4 10             	add    $0x10,%esp
80104824:	e9 fe fe ff ff       	jmp    80104727 <execute_signal_handler+0x47>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <send_multi>:

// ********** multicasting ***************

int send_multi(int sender_pid, int rec_pids[], char *msg, int rec_length){
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	53                   	push   %ebx
80104836:	83 ec 14             	sub    $0x14,%esp
80104839:	8b 7d 14             	mov    0x14(%ebp),%edi
8010483c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;
  cprintf("rec_length %d\n",rec_length);
8010483f:	57                   	push   %edi
80104840:	68 92 7f 10 80       	push   $0x80107f92
80104845:	e8 16 be ff ff       	call   80100660 <cprintf>
  for(i = 0; i < rec_length; i++){
8010484a:	83 c4 10             	add    $0x10,%esp
8010484d:	85 ff                	test   %edi,%edi
8010484f:	7e 21                	jle    80104872 <send_multi+0x42>
80104851:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104854:	8d 3c bb             	lea    (%ebx,%edi,4),%edi
80104857:	89 f6                	mov    %esi,%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104860:	8b 03                	mov    (%ebx),%eax
80104862:	31 d2                	xor    %edx,%edx
80104864:	89 f1                	mov    %esi,%ecx
80104866:	83 c3 04             	add    $0x4,%ebx
80104869:	e8 f2 f7 ff ff       	call   80104060 <sig_send.part.2>
8010486e:	39 df                	cmp    %ebx,%edi
80104870:	75 ee                	jne    80104860 <send_multi+0x30>
    sig_send(rec_pids[i], 0, msg);
  }
  return 0;
80104872:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104875:	31 c0                	xor    %eax,%eax
80104877:	5b                   	pop    %ebx
80104878:	5e                   	pop    %esi
80104879:	5f                   	pop    %edi
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    

8010487c <execute_sigret_syscall_start>:

.globl execute_sigret_syscall_start;
.globl execute_sigret_syscall_end;

execute_sigret_syscall_start:
	movl $SYS_sig_ret, %eax;
8010487c:	b8 1f 00 00 00       	mov    $0x1f,%eax
	int $T_SYSCALL;
80104881:	cd 40                	int    $0x40
	ret
80104883:	c3                   	ret    

80104884 <execute_sigret_syscall_end>:
80104884:	66 90                	xchg   %ax,%ax
80104886:	66 90                	xchg   %ax,%ax
80104888:	66 90                	xchg   %ax,%ax
8010488a:	66 90                	xchg   %ax,%ax
8010488c:	66 90                	xchg   %ax,%ax
8010488e:	66 90                	xchg   %ax,%ax

80104890 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 0c             	sub    $0xc,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010489a:	68 0c 80 10 80       	push   $0x8010800c
8010489f:	8d 43 04             	lea    0x4(%ebx),%eax
801048a2:	50                   	push   %eax
801048a3:	e8 18 01 00 00       	call   801049c0 <initlock>
  lk->name = name;
801048a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801048b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801048b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801048bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801048be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c1:	c9                   	leave  
801048c2:	c3                   	ret    
801048c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	8d 73 04             	lea    0x4(%ebx),%esi
801048de:	56                   	push   %esi
801048df:	e8 1c 02 00 00       	call   80104b00 <acquire>
  while (lk->locked) {
801048e4:	8b 13                	mov    (%ebx),%edx
801048e6:	83 c4 10             	add    $0x10,%esp
801048e9:	85 d2                	test   %edx,%edx
801048eb:	74 16                	je     80104903 <acquiresleep+0x33>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801048f0:	83 ec 08             	sub    $0x8,%esp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	e8 46 f5 ff ff       	call   80103e40 <sleep>
  while (lk->locked) {
801048fa:	8b 03                	mov    (%ebx),%eax
801048fc:	83 c4 10             	add    $0x10,%esp
801048ff:	85 c0                	test   %eax,%eax
80104901:	75 ed                	jne    801048f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104903:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104909:	e8 62 ef ff ff       	call   80103870 <myproc>
8010490e:	8b 40 10             	mov    0x10(%eax),%eax
80104911:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104914:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104917:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010491a:	5b                   	pop    %ebx
8010491b:	5e                   	pop    %esi
8010491c:	5d                   	pop    %ebp
  release(&lk->lk);
8010491d:	e9 9e 02 00 00       	jmp    80104bc0 <release>
80104922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104938:	83 ec 0c             	sub    $0xc,%esp
8010493b:	8d 73 04             	lea    0x4(%ebx),%esi
8010493e:	56                   	push   %esi
8010493f:	e8 bc 01 00 00       	call   80104b00 <acquire>
  lk->locked = 0;
80104944:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010494a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104951:	89 1c 24             	mov    %ebx,(%esp)
80104954:	e8 a7 f6 ff ff       	call   80104000 <wakeup>
  release(&lk->lk);
80104959:	89 75 08             	mov    %esi,0x8(%ebp)
8010495c:	83 c4 10             	add    $0x10,%esp
}
8010495f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104962:	5b                   	pop    %ebx
80104963:	5e                   	pop    %esi
80104964:	5d                   	pop    %ebp
  release(&lk->lk);
80104965:	e9 56 02 00 00       	jmp    80104bc0 <release>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	53                   	push   %ebx
80104976:	31 ff                	xor    %edi,%edi
80104978:	83 ec 18             	sub    $0x18,%esp
8010497b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010497e:	8d 73 04             	lea    0x4(%ebx),%esi
80104981:	56                   	push   %esi
80104982:	e8 79 01 00 00       	call   80104b00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104987:	8b 03                	mov    (%ebx),%eax
80104989:	83 c4 10             	add    $0x10,%esp
8010498c:	85 c0                	test   %eax,%eax
8010498e:	74 13                	je     801049a3 <holdingsleep+0x33>
80104990:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104993:	e8 d8 ee ff ff       	call   80103870 <myproc>
80104998:	39 58 10             	cmp    %ebx,0x10(%eax)
8010499b:	0f 94 c0             	sete   %al
8010499e:	0f b6 c0             	movzbl %al,%eax
801049a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801049a3:	83 ec 0c             	sub    $0xc,%esp
801049a6:	56                   	push   %esi
801049a7:	e8 14 02 00 00       	call   80104bc0 <release>
  return r;
}
801049ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049af:	89 f8                	mov    %edi,%eax
801049b1:	5b                   	pop    %ebx
801049b2:	5e                   	pop    %esi
801049b3:	5f                   	pop    %edi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
801049b6:	66 90                	xchg   %ax,%ax
801049b8:	66 90                	xchg   %ax,%ax
801049ba:	66 90                	xchg   %ax,%ax
801049bc:	66 90                	xchg   %ax,%ax
801049be:	66 90                	xchg   %ax,%ax

801049c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801049c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801049c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801049cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801049d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049d9:	5d                   	pop    %ebp
801049da:	c3                   	ret    
801049db:	90                   	nop
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801049e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049e1:	31 d2                	xor    %edx,%edx
{
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801049e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801049e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801049ec:	83 e8 08             	sub    $0x8,%eax
801049ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801049f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049fc:	77 1a                	ja     80104a18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104a01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a09:	83 fa 0a             	cmp    $0xa,%edx
80104a0c:	75 e2                	jne    801049f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a0e:	5b                   	pop    %ebx
80104a0f:	5d                   	pop    %ebp
80104a10:	c3                   	ret    
80104a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a1b:	83 c1 28             	add    $0x28,%ecx
80104a1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a26:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a29:	39 c1                	cmp    %eax,%ecx
80104a2b:	75 f3                	jne    80104a20 <getcallerpcs+0x40>
}
80104a2d:	5b                   	pop    %ebx
80104a2e:	5d                   	pop    %ebp
80104a2f:	c3                   	ret    

80104a30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 04             	sub    $0x4,%esp
80104a37:	9c                   	pushf  
80104a38:	5b                   	pop    %ebx
  asm volatile("cli");
80104a39:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a3a:	e8 91 ed ff ff       	call   801037d0 <mycpu>
80104a3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a45:	85 c0                	test   %eax,%eax
80104a47:	75 11                	jne    80104a5a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a49:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a4f:	e8 7c ed ff ff       	call   801037d0 <mycpu>
80104a54:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a5a:	e8 71 ed ff ff       	call   801037d0 <mycpu>
80104a5f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a66:	83 c4 04             	add    $0x4,%esp
80104a69:	5b                   	pop    %ebx
80104a6a:	5d                   	pop    %ebp
80104a6b:	c3                   	ret    
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <popcli>:

void
popcli(void)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a76:	9c                   	pushf  
80104a77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a78:	f6 c4 02             	test   $0x2,%ah
80104a7b:	75 35                	jne    80104ab2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a7d:	e8 4e ed ff ff       	call   801037d0 <mycpu>
80104a82:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a89:	78 34                	js     80104abf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a8b:	e8 40 ed ff ff       	call   801037d0 <mycpu>
80104a90:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a96:	85 d2                	test   %edx,%edx
80104a98:	74 06                	je     80104aa0 <popcli+0x30>
    sti();
}
80104a9a:	c9                   	leave  
80104a9b:	c3                   	ret    
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104aa0:	e8 2b ed ff ff       	call   801037d0 <mycpu>
80104aa5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104aab:	85 c0                	test   %eax,%eax
80104aad:	74 eb                	je     80104a9a <popcli+0x2a>
  asm volatile("sti");
80104aaf:	fb                   	sti    
}
80104ab0:	c9                   	leave  
80104ab1:	c3                   	ret    
    panic("popcli - interruptible");
80104ab2:	83 ec 0c             	sub    $0xc,%esp
80104ab5:	68 17 80 10 80       	push   $0x80108017
80104aba:	e8 d1 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104abf:	83 ec 0c             	sub    $0xc,%esp
80104ac2:	68 2e 80 10 80       	push   $0x8010802e
80104ac7:	e8 c4 b8 ff ff       	call   80100390 <panic>
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <holding>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ad8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104ada:	e8 51 ff ff ff       	call   80104a30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104adf:	8b 06                	mov    (%esi),%eax
80104ae1:	85 c0                	test   %eax,%eax
80104ae3:	74 10                	je     80104af5 <holding+0x25>
80104ae5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ae8:	e8 e3 ec ff ff       	call   801037d0 <mycpu>
80104aed:	39 c3                	cmp    %eax,%ebx
80104aef:	0f 94 c3             	sete   %bl
80104af2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104af5:	e8 76 ff ff ff       	call   80104a70 <popcli>
}
80104afa:	89 d8                	mov    %ebx,%eax
80104afc:	5b                   	pop    %ebx
80104afd:	5e                   	pop    %esi
80104afe:	5d                   	pop    %ebp
80104aff:	c3                   	ret    

80104b00 <acquire>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b05:	e8 26 ff ff ff       	call   80104a30 <pushcli>
  if(holding(lk))
80104b0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b0d:	83 ec 0c             	sub    $0xc,%esp
80104b10:	53                   	push   %ebx
80104b11:	e8 ba ff ff ff       	call   80104ad0 <holding>
80104b16:	83 c4 10             	add    $0x10,%esp
80104b19:	85 c0                	test   %eax,%eax
80104b1b:	0f 85 83 00 00 00    	jne    80104ba4 <acquire+0xa4>
80104b21:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b23:	ba 01 00 00 00       	mov    $0x1,%edx
80104b28:	eb 09                	jmp    80104b33 <acquire+0x33>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b30:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b33:	89 d0                	mov    %edx,%eax
80104b35:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b38:	85 c0                	test   %eax,%eax
80104b3a:	75 f4                	jne    80104b30 <acquire+0x30>
  __sync_synchronize();
80104b3c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b44:	e8 87 ec ff ff       	call   801037d0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b49:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104b4c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b4f:	89 e8                	mov    %ebp,%eax
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b58:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104b5e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104b64:	77 1a                	ja     80104b80 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b66:	8b 48 04             	mov    0x4(%eax),%ecx
80104b69:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104b6c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b71:	83 fe 0a             	cmp    $0xa,%esi
80104b74:	75 e2                	jne    80104b58 <acquire+0x58>
}
80104b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5d                   	pop    %ebp
80104b7c:	c3                   	ret    
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
80104b80:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104b83:	83 c2 28             	add    $0x28,%edx
80104b86:	8d 76 00             	lea    0x0(%esi),%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b96:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b99:	39 d0                	cmp    %edx,%eax
80104b9b:	75 f3                	jne    80104b90 <acquire+0x90>
}
80104b9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ba0:	5b                   	pop    %ebx
80104ba1:	5e                   	pop    %esi
80104ba2:	5d                   	pop    %ebp
80104ba3:	c3                   	ret    
    panic("acquire");
80104ba4:	83 ec 0c             	sub    $0xc,%esp
80104ba7:	68 35 80 10 80       	push   $0x80108035
80104bac:	e8 df b7 ff ff       	call   80100390 <panic>
80104bb1:	eb 0d                	jmp    80104bc0 <release>
80104bb3:	90                   	nop
80104bb4:	90                   	nop
80104bb5:	90                   	nop
80104bb6:	90                   	nop
80104bb7:	90                   	nop
80104bb8:	90                   	nop
80104bb9:	90                   	nop
80104bba:	90                   	nop
80104bbb:	90                   	nop
80104bbc:	90                   	nop
80104bbd:	90                   	nop
80104bbe:	90                   	nop
80104bbf:	90                   	nop

80104bc0 <release>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 10             	sub    $0x10,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104bca:	53                   	push   %ebx
80104bcb:	e8 00 ff ff ff       	call   80104ad0 <holding>
80104bd0:	83 c4 10             	add    $0x10,%esp
80104bd3:	85 c0                	test   %eax,%eax
80104bd5:	74 22                	je     80104bf9 <release+0x39>
  lk->pcs[0] = 0;
80104bd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bde:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104be5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf3:	c9                   	leave  
  popcli();
80104bf4:	e9 77 fe ff ff       	jmp    80104a70 <popcli>
    panic("release");
80104bf9:	83 ec 0c             	sub    $0xc,%esp
80104bfc:	68 3d 80 10 80       	push   $0x8010803d
80104c01:	e8 8a b7 ff ff       	call   80100390 <panic>
80104c06:	66 90                	xchg   %ax,%ax
80104c08:	66 90                	xchg   %ax,%ax
80104c0a:	66 90                	xchg   %ax,%ax
80104c0c:	66 90                	xchg   %ax,%ax
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	53                   	push   %ebx
80104c15:	8b 55 08             	mov    0x8(%ebp),%edx
80104c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c1b:	f6 c2 03             	test   $0x3,%dl
80104c1e:	75 05                	jne    80104c25 <memset+0x15>
80104c20:	f6 c1 03             	test   $0x3,%cl
80104c23:	74 13                	je     80104c38 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104c25:	89 d7                	mov    %edx,%edi
80104c27:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c2a:	fc                   	cld    
80104c2b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c2d:	5b                   	pop    %ebx
80104c2e:	89 d0                	mov    %edx,%eax
80104c30:	5f                   	pop    %edi
80104c31:	5d                   	pop    %ebp
80104c32:	c3                   	ret    
80104c33:	90                   	nop
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104c38:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c3c:	c1 e9 02             	shr    $0x2,%ecx
80104c3f:	89 f8                	mov    %edi,%eax
80104c41:	89 fb                	mov    %edi,%ebx
80104c43:	c1 e0 18             	shl    $0x18,%eax
80104c46:	c1 e3 10             	shl    $0x10,%ebx
80104c49:	09 d8                	or     %ebx,%eax
80104c4b:	09 f8                	or     %edi,%eax
80104c4d:	c1 e7 08             	shl    $0x8,%edi
80104c50:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c52:	89 d7                	mov    %edx,%edi
80104c54:	fc                   	cld    
80104c55:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104c57:	5b                   	pop    %ebx
80104c58:	89 d0                	mov    %edx,%eax
80104c5a:	5f                   	pop    %edi
80104c5b:	5d                   	pop    %ebp
80104c5c:	c3                   	ret    
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi

80104c60 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
80104c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c69:	8b 75 08             	mov    0x8(%ebp),%esi
80104c6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c6f:	85 db                	test   %ebx,%ebx
80104c71:	74 29                	je     80104c9c <memcmp+0x3c>
    if(*s1 != *s2)
80104c73:	0f b6 16             	movzbl (%esi),%edx
80104c76:	0f b6 0f             	movzbl (%edi),%ecx
80104c79:	38 d1                	cmp    %dl,%cl
80104c7b:	75 2b                	jne    80104ca8 <memcmp+0x48>
80104c7d:	b8 01 00 00 00       	mov    $0x1,%eax
80104c82:	eb 14                	jmp    80104c98 <memcmp+0x38>
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c88:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104c8c:	83 c0 01             	add    $0x1,%eax
80104c8f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104c94:	38 ca                	cmp    %cl,%dl
80104c96:	75 10                	jne    80104ca8 <memcmp+0x48>
  while(n-- > 0){
80104c98:	39 d8                	cmp    %ebx,%eax
80104c9a:	75 ec                	jne    80104c88 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104c9c:	5b                   	pop    %ebx
  return 0;
80104c9d:	31 c0                	xor    %eax,%eax
}
80104c9f:	5e                   	pop    %esi
80104ca0:	5f                   	pop    %edi
80104ca1:	5d                   	pop    %ebp
80104ca2:	c3                   	ret    
80104ca3:	90                   	nop
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104ca8:	0f b6 c2             	movzbl %dl,%eax
}
80104cab:	5b                   	pop    %ebx
      return *s1 - *s2;
80104cac:	29 c8                	sub    %ecx,%eax
}
80104cae:	5e                   	pop    %esi
80104caf:	5f                   	pop    %edi
80104cb0:	5d                   	pop    %ebp
80104cb1:	c3                   	ret    
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ccb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cce:	39 c3                	cmp    %eax,%ebx
80104cd0:	73 26                	jae    80104cf8 <memmove+0x38>
80104cd2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104cd5:	39 c8                	cmp    %ecx,%eax
80104cd7:	73 1f                	jae    80104cf8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104cd9:	85 f6                	test   %esi,%esi
80104cdb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104cde:	74 0f                	je     80104cef <memmove+0x2f>
      *--d = *--s;
80104ce0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ce4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ce7:	83 ea 01             	sub    $0x1,%edx
80104cea:	83 fa ff             	cmp    $0xffffffff,%edx
80104ced:	75 f1                	jne    80104ce0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cef:	5b                   	pop    %ebx
80104cf0:	5e                   	pop    %esi
80104cf1:	5d                   	pop    %ebp
80104cf2:	c3                   	ret    
80104cf3:	90                   	nop
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104cf8:	31 d2                	xor    %edx,%edx
80104cfa:	85 f6                	test   %esi,%esi
80104cfc:	74 f1                	je     80104cef <memmove+0x2f>
80104cfe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d00:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d04:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d07:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d0a:	39 d6                	cmp    %edx,%esi
80104d0c:	75 f2                	jne    80104d00 <memmove+0x40>
}
80104d0e:	5b                   	pop    %ebx
80104d0f:	5e                   	pop    %esi
80104d10:	5d                   	pop    %ebp
80104d11:	c3                   	ret    
80104d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d23:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104d24:	eb 9a                	jmp    80104cc0 <memmove>
80104d26:	8d 76 00             	lea    0x0(%esi),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	8b 7d 10             	mov    0x10(%ebp),%edi
80104d38:	53                   	push   %ebx
80104d39:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d3f:	85 ff                	test   %edi,%edi
80104d41:	74 2f                	je     80104d72 <strncmp+0x42>
80104d43:	0f b6 01             	movzbl (%ecx),%eax
80104d46:	0f b6 1e             	movzbl (%esi),%ebx
80104d49:	84 c0                	test   %al,%al
80104d4b:	74 37                	je     80104d84 <strncmp+0x54>
80104d4d:	38 c3                	cmp    %al,%bl
80104d4f:	75 33                	jne    80104d84 <strncmp+0x54>
80104d51:	01 f7                	add    %esi,%edi
80104d53:	eb 13                	jmp    80104d68 <strncmp+0x38>
80104d55:	8d 76 00             	lea    0x0(%esi),%esi
80104d58:	0f b6 01             	movzbl (%ecx),%eax
80104d5b:	84 c0                	test   %al,%al
80104d5d:	74 21                	je     80104d80 <strncmp+0x50>
80104d5f:	0f b6 1a             	movzbl (%edx),%ebx
80104d62:	89 d6                	mov    %edx,%esi
80104d64:	38 d8                	cmp    %bl,%al
80104d66:	75 1c                	jne    80104d84 <strncmp+0x54>
    n--, p++, q++;
80104d68:	8d 56 01             	lea    0x1(%esi),%edx
80104d6b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d6e:	39 fa                	cmp    %edi,%edx
80104d70:	75 e6                	jne    80104d58 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104d72:	5b                   	pop    %ebx
    return 0;
80104d73:	31 c0                	xor    %eax,%eax
}
80104d75:	5e                   	pop    %esi
80104d76:	5f                   	pop    %edi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d80:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104d84:	29 d8                	sub    %ebx,%eax
}
80104d86:	5b                   	pop    %ebx
80104d87:	5e                   	pop    %esi
80104d88:	5f                   	pop    %edi
80104d89:	5d                   	pop    %ebp
80104d8a:	c3                   	ret    
80104d8b:	90                   	nop
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d90 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 45 08             	mov    0x8(%ebp),%eax
80104d98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d9e:	89 c2                	mov    %eax,%edx
80104da0:	eb 19                	jmp    80104dbb <strncpy+0x2b>
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104da8:	83 c3 01             	add    $0x1,%ebx
80104dab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104daf:	83 c2 01             	add    $0x1,%edx
80104db2:	84 c9                	test   %cl,%cl
80104db4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104db7:	74 09                	je     80104dc2 <strncpy+0x32>
80104db9:	89 f1                	mov    %esi,%ecx
80104dbb:	85 c9                	test   %ecx,%ecx
80104dbd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104dc0:	7f e6                	jg     80104da8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104dc2:	31 c9                	xor    %ecx,%ecx
80104dc4:	85 f6                	test   %esi,%esi
80104dc6:	7e 17                	jle    80104ddf <strncpy+0x4f>
80104dc8:	90                   	nop
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104dd0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104dd4:	89 f3                	mov    %esi,%ebx
80104dd6:	83 c1 01             	add    $0x1,%ecx
80104dd9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104ddb:	85 db                	test   %ebx,%ebx
80104ddd:	7f f1                	jg     80104dd0 <strncpy+0x40>
  return os;
}
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104df8:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104dfe:	85 c9                	test   %ecx,%ecx
80104e00:	7e 26                	jle    80104e28 <safestrcpy+0x38>
80104e02:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e06:	89 c1                	mov    %eax,%ecx
80104e08:	eb 17                	jmp    80104e21 <safestrcpy+0x31>
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e10:	83 c2 01             	add    $0x1,%edx
80104e13:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e17:	83 c1 01             	add    $0x1,%ecx
80104e1a:	84 db                	test   %bl,%bl
80104e1c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e1f:	74 04                	je     80104e25 <safestrcpy+0x35>
80104e21:	39 f2                	cmp    %esi,%edx
80104e23:	75 eb                	jne    80104e10 <safestrcpy+0x20>
    ;
  *s = 0;
80104e25:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e28:	5b                   	pop    %ebx
80104e29:	5e                   	pop    %esi
80104e2a:	5d                   	pop    %ebp
80104e2b:	c3                   	ret    
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e30 <strlen>:

int
strlen(const char *s)
{
80104e30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e31:	31 c0                	xor    %eax,%eax
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e38:	80 3a 00             	cmpb   $0x0,(%edx)
80104e3b:	74 0c                	je     80104e49 <strlen+0x19>
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
80104e40:	83 c0 01             	add    $0x1,%eax
80104e43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e47:	75 f7                	jne    80104e40 <strlen+0x10>
    ;
  return n;
}
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    

80104e4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e53:	55                   	push   %ebp
  pushl %ebx
80104e54:	53                   	push   %ebx
  pushl %esi
80104e55:	56                   	push   %esi
  pushl %edi
80104e56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e5b:	5f                   	pop    %edi
  popl %esi
80104e5c:	5e                   	pop    %esi
  popl %ebx
80104e5d:	5b                   	pop    %ebx
  popl %ebp
80104e5e:	5d                   	pop    %ebp
  ret
80104e5f:	c3                   	ret    

80104e60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 04             	sub    $0x4,%esp
80104e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e6a:	e8 01 ea ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e6f:	8b 00                	mov    (%eax),%eax
80104e71:	39 d8                	cmp    %ebx,%eax
80104e73:	76 1b                	jbe    80104e90 <fetchint+0x30>
80104e75:	8d 53 04             	lea    0x4(%ebx),%edx
80104e78:	39 d0                	cmp    %edx,%eax
80104e7a:	72 14                	jb     80104e90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7f:	8b 13                	mov    (%ebx),%edx
80104e81:	89 10                	mov    %edx,(%eax)
  return 0;
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	83 c4 04             	add    $0x4,%esp
80104e88:	5b                   	pop    %ebx
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	90                   	nop
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb ee                	jmp    80104e85 <fetchint+0x25>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
80104ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eaa:	e8 c1 e9 ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz)
80104eaf:	39 18                	cmp    %ebx,(%eax)
80104eb1:	76 29                	jbe    80104edc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104eb6:	89 da                	mov    %ebx,%edx
80104eb8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104eba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104ebc:	39 c3                	cmp    %eax,%ebx
80104ebe:	73 1c                	jae    80104edc <fetchstr+0x3c>
    if(*s == 0)
80104ec0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ec3:	75 10                	jne    80104ed5 <fetchstr+0x35>
80104ec5:	eb 39                	jmp    80104f00 <fetchstr+0x60>
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ed0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ed3:	74 1b                	je     80104ef0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ed5:	83 c2 01             	add    $0x1,%edx
80104ed8:	39 d0                	cmp    %edx,%eax
80104eda:	77 f4                	ja     80104ed0 <fetchstr+0x30>
    return -1;
80104edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ee1:	83 c4 04             	add    $0x4,%esp
80104ee4:	5b                   	pop    %ebx
80104ee5:	5d                   	pop    %ebp
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ef0:	83 c4 04             	add    $0x4,%esp
80104ef3:	89 d0                	mov    %edx,%eax
80104ef5:	29 d8                	sub    %ebx,%eax
80104ef7:	5b                   	pop    %ebx
80104ef8:	5d                   	pop    %ebp
80104ef9:	c3                   	ret    
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f00:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f02:	eb dd                	jmp    80104ee1 <fetchstr+0x41>
80104f04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f15:	e8 56 e9 ff ff       	call   80103870 <myproc>
80104f1a:	8b 40 18             	mov    0x18(%eax),%eax
80104f1d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f20:	8b 40 44             	mov    0x44(%eax),%eax
80104f23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f26:	e8 45 e9 ff ff       	call   80103870 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f2b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f2d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f30:	39 c6                	cmp    %eax,%esi
80104f32:	73 1c                	jae    80104f50 <argint+0x40>
80104f34:	8d 53 08             	lea    0x8(%ebx),%edx
80104f37:	39 d0                	cmp    %edx,%eax
80104f39:	72 15                	jb     80104f50 <argint+0x40>
  *ip = *(int*)(addr);
80104f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f41:	89 10                	mov    %edx,(%eax)
  return 0;
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	5b                   	pop    %ebx
80104f46:	5e                   	pop    %esi
80104f47:	5d                   	pop    %ebp
80104f48:	c3                   	ret    
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f55:	eb ee                	jmp    80104f45 <argint+0x35>
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
80104f65:	83 ec 10             	sub    $0x10,%esp
80104f68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f6b:	e8 00 e9 ff ff       	call   80103870 <myproc>
80104f70:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f75:	83 ec 08             	sub    $0x8,%esp
80104f78:	50                   	push   %eax
80104f79:	ff 75 08             	pushl  0x8(%ebp)
80104f7c:	e8 8f ff ff ff       	call   80104f10 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f81:	83 c4 10             	add    $0x10,%esp
80104f84:	85 c0                	test   %eax,%eax
80104f86:	78 28                	js     80104fb0 <argptr+0x50>
80104f88:	85 db                	test   %ebx,%ebx
80104f8a:	78 24                	js     80104fb0 <argptr+0x50>
80104f8c:	8b 16                	mov    (%esi),%edx
80104f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f91:	39 c2                	cmp    %eax,%edx
80104f93:	76 1b                	jbe    80104fb0 <argptr+0x50>
80104f95:	01 c3                	add    %eax,%ebx
80104f97:	39 da                	cmp    %ebx,%edx
80104f99:	72 15                	jb     80104fb0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f9e:	89 02                	mov    %eax,(%edx)
  return 0;
80104fa0:	31 c0                	xor    %eax,%eax
}
80104fa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa5:	5b                   	pop    %ebx
80104fa6:	5e                   	pop    %esi
80104fa7:	5d                   	pop    %ebp
80104fa8:	c3                   	ret    
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb5:	eb eb                	jmp    80104fa2 <argptr+0x42>
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fc9:	50                   	push   %eax
80104fca:	ff 75 08             	pushl  0x8(%ebp)
80104fcd:	e8 3e ff ff ff       	call   80104f10 <argint>
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	78 17                	js     80104ff0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104fd9:	83 ec 08             	sub    $0x8,%esp
80104fdc:	ff 75 0c             	pushl  0xc(%ebp)
80104fdf:	ff 75 f4             	pushl  -0xc(%ebp)
80104fe2:	e8 b9 fe ff ff       	call   80104ea0 <fetchstr>
80104fe7:	83 c4 10             	add    $0x10,%esp
}
80104fea:	c9                   	leave  
80104feb:	c3                   	ret    
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff5:	c9                   	leave  
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <syscall>:
"sys_toggle", "sys_add", "sys_ps", "sys_send", "sys_recv", 
"sys_sig_set", "sys_sig_send", "sys_sig_pause", "sys_sig_ret", "sys_send_multi"};

void
syscall(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	53                   	push   %ebx
80105004:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105007:	e8 64 e8 ff ff       	call   80103870 <myproc>
8010500c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010500e:	8b 40 18             	mov    0x18(%eax),%eax
80105011:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105014:	8d 50 ff             	lea    -0x1(%eax),%edx
80105017:	83 fa 1f             	cmp    $0x1f,%edx
8010501a:	77 2c                	ja     80105048 <syscall+0x48>
8010501c:	8b 0c 85 c0 81 10 80 	mov    -0x7fef7e40(,%eax,4),%ecx
80105023:	85 c9                	test   %ecx,%ecx
80105025:	74 21                	je     80105048 <syscall+0x48>
    
    if(toggle_flag)
80105027:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
8010502c:	85 c0                	test   %eax,%eax
8010502e:	74 08                	je     80105038 <syscall+0x38>
      system_call_count[num-1]++;
80105030:	83 04 95 00 d9 11 80 	addl   $0x1,-0x7fee2700(,%edx,4)
80105037:	01 

    curproc->tf->eax = syscalls[num]();
80105038:	ff d1                	call   *%ecx
8010503a:	8b 53 18             	mov    0x18(%ebx),%edx
8010503d:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
80105040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105043:	c9                   	leave  
80105044:	c3                   	ret    
80105045:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105048:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105049:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010504c:	50                   	push   %eax
8010504d:	ff 73 10             	pushl  0x10(%ebx)
80105050:	68 45 80 10 80       	push   $0x80108045
80105055:	e8 06 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010505a:	8b 43 18             	mov    0x18(%ebx),%eax
8010505d:	83 c4 10             	add    $0x10,%esp
80105060:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80105067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	66 90                	xchg   %ax,%ax
8010506e:	66 90                	xchg   %ax,%ax

80105070 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105076:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105079:	83 ec 44             	sub    $0x44,%esp
8010507c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010507f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105082:	56                   	push   %esi
80105083:	50                   	push   %eax
{
80105084:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105087:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010508a:	e8 a1 ce ff ff       	call   80101f30 <nameiparent>
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	85 c0                	test   %eax,%eax
80105094:	0f 84 46 01 00 00    	je     801051e0 <create+0x170>
    return 0;
  ilock(dp);
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	89 c3                	mov    %eax,%ebx
8010509f:	50                   	push   %eax
801050a0:	e8 0b c6 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801050a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801050a8:	83 c4 0c             	add    $0xc,%esp
801050ab:	50                   	push   %eax
801050ac:	56                   	push   %esi
801050ad:	53                   	push   %ebx
801050ae:	e8 2d cb ff ff       	call   80101be0 <dirlookup>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	89 c7                	mov    %eax,%edi
801050ba:	74 34                	je     801050f0 <create+0x80>
    iunlockput(dp);
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	53                   	push   %ebx
801050c0:	e8 7b c8 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
801050c5:	89 3c 24             	mov    %edi,(%esp)
801050c8:	e8 e3 c5 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801050d5:	0f 85 95 00 00 00    	jne    80105170 <create+0x100>
801050db:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801050e0:	0f 85 8a 00 00 00    	jne    80105170 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050e9:	89 f8                	mov    %edi,%eax
801050eb:	5b                   	pop    %ebx
801050ec:	5e                   	pop    %esi
801050ed:	5f                   	pop    %edi
801050ee:	5d                   	pop    %ebp
801050ef:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801050f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	50                   	push   %eax
801050f8:	ff 33                	pushl  (%ebx)
801050fa:	e8 41 c4 ff ff       	call   80101540 <ialloc>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	85 c0                	test   %eax,%eax
80105104:	89 c7                	mov    %eax,%edi
80105106:	0f 84 e8 00 00 00    	je     801051f4 <create+0x184>
  ilock(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	50                   	push   %eax
80105110:	e8 9b c5 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105115:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105119:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010511d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105121:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105125:	b8 01 00 00 00       	mov    $0x1,%eax
8010512a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010512e:	89 3c 24             	mov    %edi,(%esp)
80105131:	e8 ca c4 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010513e:	74 50                	je     80105190 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	ff 77 04             	pushl  0x4(%edi)
80105146:	56                   	push   %esi
80105147:	53                   	push   %ebx
80105148:	e8 03 cd ff ff       	call   80101e50 <dirlink>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	0f 88 8f 00 00 00    	js     801051e7 <create+0x177>
  iunlockput(dp);
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	53                   	push   %ebx
8010515c:	e8 df c7 ff ff       	call   80101940 <iunlockput>
  return ip;
80105161:	83 c4 10             	add    $0x10,%esp
}
80105164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105167:	89 f8                	mov    %edi,%eax
80105169:	5b                   	pop    %ebx
8010516a:	5e                   	pop    %esi
8010516b:	5f                   	pop    %edi
8010516c:	5d                   	pop    %ebp
8010516d:	c3                   	ret    
8010516e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105170:	83 ec 0c             	sub    $0xc,%esp
80105173:	57                   	push   %edi
    return 0;
80105174:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105176:	e8 c5 c7 ff ff       	call   80101940 <iunlockput>
    return 0;
8010517b:	83 c4 10             	add    $0x10,%esp
}
8010517e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105181:	89 f8                	mov    %edi,%eax
80105183:	5b                   	pop    %ebx
80105184:	5e                   	pop    %esi
80105185:	5f                   	pop    %edi
80105186:	5d                   	pop    %ebp
80105187:	c3                   	ret    
80105188:	90                   	nop
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105190:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	53                   	push   %ebx
80105199:	e8 62 c4 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010519e:	83 c4 0c             	add    $0xc,%esp
801051a1:	ff 77 04             	pushl  0x4(%edi)
801051a4:	68 60 82 10 80       	push   $0x80108260
801051a9:	57                   	push   %edi
801051aa:	e8 a1 cc ff ff       	call   80101e50 <dirlink>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	78 1c                	js     801051d2 <create+0x162>
801051b6:	83 ec 04             	sub    $0x4,%esp
801051b9:	ff 73 04             	pushl  0x4(%ebx)
801051bc:	68 5f 82 10 80       	push   $0x8010825f
801051c1:	57                   	push   %edi
801051c2:	e8 89 cc ff ff       	call   80101e50 <dirlink>
801051c7:	83 c4 10             	add    $0x10,%esp
801051ca:	85 c0                	test   %eax,%eax
801051cc:	0f 89 6e ff ff ff    	jns    80105140 <create+0xd0>
      panic("create dots");
801051d2:	83 ec 0c             	sub    $0xc,%esp
801051d5:	68 53 82 10 80       	push   $0x80108253
801051da:	e8 b1 b1 ff ff       	call   80100390 <panic>
801051df:	90                   	nop
    return 0;
801051e0:	31 ff                	xor    %edi,%edi
801051e2:	e9 ff fe ff ff       	jmp    801050e6 <create+0x76>
    panic("create: dirlink");
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	68 62 82 10 80       	push   $0x80108262
801051ef:	e8 9c b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 44 82 10 80       	push   $0x80108244
801051fc:	e8 8f b1 ff ff       	call   80100390 <panic>
80105201:	eb 0d                	jmp    80105210 <argfd.constprop.0>
80105203:	90                   	nop
80105204:	90                   	nop
80105205:	90                   	nop
80105206:	90                   	nop
80105207:	90                   	nop
80105208:	90                   	nop
80105209:	90                   	nop
8010520a:	90                   	nop
8010520b:	90                   	nop
8010520c:	90                   	nop
8010520d:	90                   	nop
8010520e:	90                   	nop
8010520f:	90                   	nop

80105210 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
80105215:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105217:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010521a:	89 d6                	mov    %edx,%esi
8010521c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010521f:	50                   	push   %eax
80105220:	6a 00                	push   $0x0
80105222:	e8 e9 fc ff ff       	call   80104f10 <argint>
80105227:	83 c4 10             	add    $0x10,%esp
8010522a:	85 c0                	test   %eax,%eax
8010522c:	78 2a                	js     80105258 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010522e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105232:	77 24                	ja     80105258 <argfd.constprop.0+0x48>
80105234:	e8 37 e6 ff ff       	call   80103870 <myproc>
80105239:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010523c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105240:	85 c0                	test   %eax,%eax
80105242:	74 14                	je     80105258 <argfd.constprop.0+0x48>
  if(pfd)
80105244:	85 db                	test   %ebx,%ebx
80105246:	74 02                	je     8010524a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105248:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010524a:	89 06                	mov    %eax,(%esi)
  return 0;
8010524c:	31 c0                	xor    %eax,%eax
}
8010524e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105251:	5b                   	pop    %ebx
80105252:	5e                   	pop    %esi
80105253:	5d                   	pop    %ebp
80105254:	c3                   	ret    
80105255:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525d:	eb ef                	jmp    8010524e <argfd.constprop.0+0x3e>
8010525f:	90                   	nop

80105260 <sys_dup>:
{
80105260:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105261:	31 c0                	xor    %eax,%eax
{
80105263:	89 e5                	mov    %esp,%ebp
80105265:	56                   	push   %esi
80105266:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105267:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010526a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010526d:	e8 9e ff ff ff       	call   80105210 <argfd.constprop.0>
80105272:	85 c0                	test   %eax,%eax
80105274:	78 42                	js     801052b8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105276:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105279:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010527b:	e8 f0 e5 ff ff       	call   80103870 <myproc>
80105280:	eb 0e                	jmp    80105290 <sys_dup+0x30>
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c3 01             	add    $0x1,%ebx
8010528b:	83 fb 10             	cmp    $0x10,%ebx
8010528e:	74 28                	je     801052b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105290:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105294:	85 d2                	test   %edx,%edx
80105296:	75 f0                	jne    80105288 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105298:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	ff 75 f4             	pushl  -0xc(%ebp)
801052a2:	e8 69 bb ff ff       	call   80100e10 <filedup>
  return fd;
801052a7:	83 c4 10             	add    $0x10,%esp
}
801052aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052ad:	89 d8                	mov    %ebx,%eax
801052af:	5b                   	pop    %ebx
801052b0:	5e                   	pop    %esi
801052b1:	5d                   	pop    %ebp
801052b2:	c3                   	ret    
801052b3:	90                   	nop
801052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801052bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801052c0:	89 d8                	mov    %ebx,%eax
801052c2:	5b                   	pop    %ebx
801052c3:	5e                   	pop    %esi
801052c4:	5d                   	pop    %ebp
801052c5:	c3                   	ret    
801052c6:	8d 76 00             	lea    0x0(%esi),%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_read>:
{
801052d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052d1:	31 c0                	xor    %eax,%eax
{
801052d3:	89 e5                	mov    %esp,%ebp
801052d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052db:	e8 30 ff ff ff       	call   80105210 <argfd.constprop.0>
801052e0:	85 c0                	test   %eax,%eax
801052e2:	78 4c                	js     80105330 <sys_read+0x60>
801052e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	50                   	push   %eax
801052eb:	6a 02                	push   $0x2
801052ed:	e8 1e fc ff ff       	call   80104f10 <argint>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	78 37                	js     80105330 <sys_read+0x60>
801052f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fc:	83 ec 04             	sub    $0x4,%esp
801052ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105302:	50                   	push   %eax
80105303:	6a 01                	push   $0x1
80105305:	e8 56 fc ff ff       	call   80104f60 <argptr>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	85 c0                	test   %eax,%eax
8010530f:	78 1f                	js     80105330 <sys_read+0x60>
  return fileread(f, p, n);
80105311:	83 ec 04             	sub    $0x4,%esp
80105314:	ff 75 f0             	pushl  -0x10(%ebp)
80105317:	ff 75 f4             	pushl  -0xc(%ebp)
8010531a:	ff 75 ec             	pushl  -0x14(%ebp)
8010531d:	e8 5e bc ff ff       	call   80100f80 <fileread>
80105322:	83 c4 10             	add    $0x10,%esp
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_write>:
{
80105340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105341:	31 c0                	xor    %eax,%eax
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105348:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010534b:	e8 c0 fe ff ff       	call   80105210 <argfd.constprop.0>
80105350:	85 c0                	test   %eax,%eax
80105352:	78 4c                	js     801053a0 <sys_write+0x60>
80105354:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105357:	83 ec 08             	sub    $0x8,%esp
8010535a:	50                   	push   %eax
8010535b:	6a 02                	push   $0x2
8010535d:	e8 ae fb ff ff       	call   80104f10 <argint>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	78 37                	js     801053a0 <sys_write+0x60>
80105369:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536c:	83 ec 04             	sub    $0x4,%esp
8010536f:	ff 75 f0             	pushl  -0x10(%ebp)
80105372:	50                   	push   %eax
80105373:	6a 01                	push   $0x1
80105375:	e8 e6 fb ff ff       	call   80104f60 <argptr>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 1f                	js     801053a0 <sys_write+0x60>
  return filewrite(f, p, n);
80105381:	83 ec 04             	sub    $0x4,%esp
80105384:	ff 75 f0             	pushl  -0x10(%ebp)
80105387:	ff 75 f4             	pushl  -0xc(%ebp)
8010538a:	ff 75 ec             	pushl  -0x14(%ebp)
8010538d:	e8 7e bc ff ff       	call   80101010 <filewrite>
80105392:	83 c4 10             	add    $0x10,%esp
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_close>:
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801053b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801053b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053bc:	e8 4f fe ff ff       	call   80105210 <argfd.constprop.0>
801053c1:	85 c0                	test   %eax,%eax
801053c3:	78 2b                	js     801053f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801053c5:	e8 a6 e4 ff ff       	call   80103870 <myproc>
801053ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801053cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053d7:	00 
  fileclose(f);
801053d8:	ff 75 f4             	pushl  -0xc(%ebp)
801053db:	e8 80 ba ff ff       	call   80100e60 <fileclose>
  return 0;
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	31 c0                	xor    %eax,%eax
}
801053e5:	c9                   	leave  
801053e6:	c3                   	ret    
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <sys_fstat>:
{
80105400:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105401:	31 c0                	xor    %eax,%eax
{
80105403:	89 e5                	mov    %esp,%ebp
80105405:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105408:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010540b:	e8 00 fe ff ff       	call   80105210 <argfd.constprop.0>
80105410:	85 c0                	test   %eax,%eax
80105412:	78 2c                	js     80105440 <sys_fstat+0x40>
80105414:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105417:	83 ec 04             	sub    $0x4,%esp
8010541a:	6a 14                	push   $0x14
8010541c:	50                   	push   %eax
8010541d:	6a 01                	push   $0x1
8010541f:	e8 3c fb ff ff       	call   80104f60 <argptr>
80105424:	83 c4 10             	add    $0x10,%esp
80105427:	85 c0                	test   %eax,%eax
80105429:	78 15                	js     80105440 <sys_fstat+0x40>
  return filestat(f, st);
8010542b:	83 ec 08             	sub    $0x8,%esp
8010542e:	ff 75 f4             	pushl  -0xc(%ebp)
80105431:	ff 75 f0             	pushl  -0x10(%ebp)
80105434:	e8 f7 ba ff ff       	call   80100f30 <filestat>
80105439:	83 c4 10             	add    $0x10,%esp
}
8010543c:	c9                   	leave  
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_link>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105456:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105459:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 5c fb ff ff       	call   80104fc0 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 fb 00 00 00    	js     8010556a <sys_link+0x11a>
8010546f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105472:	83 ec 08             	sub    $0x8,%esp
80105475:	50                   	push   %eax
80105476:	6a 01                	push   $0x1
80105478:	e8 43 fb ff ff       	call   80104fc0 <argstr>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	0f 88 e2 00 00 00    	js     8010556a <sys_link+0x11a>
  begin_op();
80105488:	e8 43 d7 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	ff 75 d4             	pushl  -0x2c(%ebp)
80105493:	e8 78 ca ff ff       	call   80101f10 <namei>
80105498:	83 c4 10             	add    $0x10,%esp
8010549b:	85 c0                	test   %eax,%eax
8010549d:	89 c3                	mov    %eax,%ebx
8010549f:	0f 84 ea 00 00 00    	je     8010558f <sys_link+0x13f>
  ilock(ip);
801054a5:	83 ec 0c             	sub    $0xc,%esp
801054a8:	50                   	push   %eax
801054a9:	e8 02 c2 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054b6:	0f 84 bb 00 00 00    	je     80105577 <sys_link+0x127>
  ip->nlink++;
801054bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801054c1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801054c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054c7:	53                   	push   %ebx
801054c8:	e8 33 c1 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
801054cd:	89 1c 24             	mov    %ebx,(%esp)
801054d0:	e8 bb c2 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054d5:	58                   	pop    %eax
801054d6:	5a                   	pop    %edx
801054d7:	57                   	push   %edi
801054d8:	ff 75 d0             	pushl  -0x30(%ebp)
801054db:	e8 50 ca ff ff       	call   80101f30 <nameiparent>
801054e0:	83 c4 10             	add    $0x10,%esp
801054e3:	85 c0                	test   %eax,%eax
801054e5:	89 c6                	mov    %eax,%esi
801054e7:	74 5b                	je     80105544 <sys_link+0xf4>
  ilock(dp);
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	50                   	push   %eax
801054ed:	e8 be c1 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	8b 03                	mov    (%ebx),%eax
801054f7:	39 06                	cmp    %eax,(%esi)
801054f9:	75 3d                	jne    80105538 <sys_link+0xe8>
801054fb:	83 ec 04             	sub    $0x4,%esp
801054fe:	ff 73 04             	pushl  0x4(%ebx)
80105501:	57                   	push   %edi
80105502:	56                   	push   %esi
80105503:	e8 48 c9 ff ff       	call   80101e50 <dirlink>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	78 29                	js     80105538 <sys_link+0xe8>
  iunlockput(dp);
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	56                   	push   %esi
80105513:	e8 28 c4 ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105518:	89 1c 24             	mov    %ebx,(%esp)
8010551b:	e8 c0 c2 ff ff       	call   801017e0 <iput>
  end_op();
80105520:	e8 1b d7 ff ff       	call   80102c40 <end_op>
  return 0;
80105525:	83 c4 10             	add    $0x10,%esp
80105528:	31 c0                	xor    %eax,%eax
}
8010552a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010552d:	5b                   	pop    %ebx
8010552e:	5e                   	pop    %esi
8010552f:	5f                   	pop    %edi
80105530:	5d                   	pop    %ebp
80105531:	c3                   	ret    
80105532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	56                   	push   %esi
8010553c:	e8 ff c3 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105541:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	53                   	push   %ebx
80105548:	e8 63 c1 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
8010554d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105552:	89 1c 24             	mov    %ebx,(%esp)
80105555:	e8 a6 c0 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010555a:	89 1c 24             	mov    %ebx,(%esp)
8010555d:	e8 de c3 ff ff       	call   80101940 <iunlockput>
  end_op();
80105562:	e8 d9 d6 ff ff       	call   80102c40 <end_op>
  return -1;
80105567:	83 c4 10             	add    $0x10,%esp
}
8010556a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010556d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5f                   	pop    %edi
80105575:	5d                   	pop    %ebp
80105576:	c3                   	ret    
    iunlockput(ip);
80105577:	83 ec 0c             	sub    $0xc,%esp
8010557a:	53                   	push   %ebx
8010557b:	e8 c0 c3 ff ff       	call   80101940 <iunlockput>
    end_op();
80105580:	e8 bb d6 ff ff       	call   80102c40 <end_op>
    return -1;
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558d:	eb 9b                	jmp    8010552a <sys_link+0xda>
    end_op();
8010558f:	e8 ac d6 ff ff       	call   80102c40 <end_op>
    return -1;
80105594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105599:	eb 8f                	jmp    8010552a <sys_link+0xda>
8010559b:	90                   	nop
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_unlink>:
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
801055a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801055a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801055a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801055ac:	50                   	push   %eax
801055ad:	6a 00                	push   $0x0
801055af:	e8 0c fa ff ff       	call   80104fc0 <argstr>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 88 77 01 00 00    	js     80105736 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801055bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801055c2:	e8 09 d6 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055c7:	83 ec 08             	sub    $0x8,%esp
801055ca:	53                   	push   %ebx
801055cb:	ff 75 c0             	pushl  -0x40(%ebp)
801055ce:	e8 5d c9 ff ff       	call   80101f30 <nameiparent>
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	89 c6                	mov    %eax,%esi
801055da:	0f 84 60 01 00 00    	je     80105740 <sys_unlink+0x1a0>
  ilock(dp);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	50                   	push   %eax
801055e4:	e8 c7 c0 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055e9:	58                   	pop    %eax
801055ea:	5a                   	pop    %edx
801055eb:	68 60 82 10 80       	push   $0x80108260
801055f0:	53                   	push   %ebx
801055f1:	e8 ca c5 ff ff       	call   80101bc0 <namecmp>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	0f 84 03 01 00 00    	je     80105704 <sys_unlink+0x164>
80105601:	83 ec 08             	sub    $0x8,%esp
80105604:	68 5f 82 10 80       	push   $0x8010825f
80105609:	53                   	push   %ebx
8010560a:	e8 b1 c5 ff ff       	call   80101bc0 <namecmp>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	85 c0                	test   %eax,%eax
80105614:	0f 84 ea 00 00 00    	je     80105704 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010561a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010561d:	83 ec 04             	sub    $0x4,%esp
80105620:	50                   	push   %eax
80105621:	53                   	push   %ebx
80105622:	56                   	push   %esi
80105623:	e8 b8 c5 ff ff       	call   80101be0 <dirlookup>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	85 c0                	test   %eax,%eax
8010562d:	89 c3                	mov    %eax,%ebx
8010562f:	0f 84 cf 00 00 00    	je     80105704 <sys_unlink+0x164>
  ilock(ip);
80105635:	83 ec 0c             	sub    $0xc,%esp
80105638:	50                   	push   %eax
80105639:	e8 72 c0 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105646:	0f 8e 10 01 00 00    	jle    8010575c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010564c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105651:	74 6d                	je     801056c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105653:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105656:	83 ec 04             	sub    $0x4,%esp
80105659:	6a 10                	push   $0x10
8010565b:	6a 00                	push   $0x0
8010565d:	50                   	push   %eax
8010565e:	e8 ad f5 ff ff       	call   80104c10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105663:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105666:	6a 10                	push   $0x10
80105668:	ff 75 c4             	pushl  -0x3c(%ebp)
8010566b:	50                   	push   %eax
8010566c:	56                   	push   %esi
8010566d:	e8 1e c4 ff ff       	call   80101a90 <writei>
80105672:	83 c4 20             	add    $0x20,%esp
80105675:	83 f8 10             	cmp    $0x10,%eax
80105678:	0f 85 eb 00 00 00    	jne    80105769 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010567e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105683:	0f 84 97 00 00 00    	je     80105720 <sys_unlink+0x180>
  iunlockput(dp);
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	56                   	push   %esi
8010568d:	e8 ae c2 ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105692:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105697:	89 1c 24             	mov    %ebx,(%esp)
8010569a:	e8 61 bf ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010569f:	89 1c 24             	mov    %ebx,(%esp)
801056a2:	e8 99 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
801056a7:	e8 94 d5 ff ff       	call   80102c40 <end_op>
  return 0;
801056ac:	83 c4 10             	add    $0x10,%esp
801056af:	31 c0                	xor    %eax,%eax
}
801056b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b4:	5b                   	pop    %ebx
801056b5:	5e                   	pop    %esi
801056b6:	5f                   	pop    %edi
801056b7:	5d                   	pop    %ebp
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056c4:	76 8d                	jbe    80105653 <sys_unlink+0xb3>
801056c6:	bf 20 00 00 00       	mov    $0x20,%edi
801056cb:	eb 0f                	jmp    801056dc <sys_unlink+0x13c>
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
801056d0:	83 c7 10             	add    $0x10,%edi
801056d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801056d6:	0f 83 77 ff ff ff    	jae    80105653 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056df:	6a 10                	push   $0x10
801056e1:	57                   	push   %edi
801056e2:	50                   	push   %eax
801056e3:	53                   	push   %ebx
801056e4:	e8 a7 c2 ff ff       	call   80101990 <readi>
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	83 f8 10             	cmp    $0x10,%eax
801056ef:	75 5e                	jne    8010574f <sys_unlink+0x1af>
    if(de.inum != 0)
801056f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056f6:	74 d8                	je     801056d0 <sys_unlink+0x130>
    iunlockput(ip);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	53                   	push   %ebx
801056fc:	e8 3f c2 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105701:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	56                   	push   %esi
80105708:	e8 33 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
8010570d:	e8 2e d5 ff ff       	call   80102c40 <end_op>
  return -1;
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571a:	eb 95                	jmp    801056b1 <sys_unlink+0x111>
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105720:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105725:	83 ec 0c             	sub    $0xc,%esp
80105728:	56                   	push   %esi
80105729:	e8 d2 be ff ff       	call   80101600 <iupdate>
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	e9 53 ff ff ff       	jmp    80105689 <sys_unlink+0xe9>
    return -1;
80105736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573b:	e9 71 ff ff ff       	jmp    801056b1 <sys_unlink+0x111>
    end_op();
80105740:	e8 fb d4 ff ff       	call   80102c40 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574a:	e9 62 ff ff ff       	jmp    801056b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010574f:	83 ec 0c             	sub    $0xc,%esp
80105752:	68 84 82 10 80       	push   $0x80108284
80105757:	e8 34 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	68 72 82 10 80       	push   $0x80108272
80105764:	e8 27 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	68 96 82 10 80       	push   $0x80108296
80105771:	e8 1a ac ff ff       	call   80100390 <panic>
80105776:	8d 76 00             	lea    0x0(%esi),%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_open>:

int
sys_open(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
80105785:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105786:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105789:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010578c:	50                   	push   %eax
8010578d:	6a 00                	push   $0x0
8010578f:	e8 2c f8 ff ff       	call   80104fc0 <argstr>
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	85 c0                	test   %eax,%eax
80105799:	0f 88 1d 01 00 00    	js     801058bc <sys_open+0x13c>
8010579f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057a2:	83 ec 08             	sub    $0x8,%esp
801057a5:	50                   	push   %eax
801057a6:	6a 01                	push   $0x1
801057a8:	e8 63 f7 ff ff       	call   80104f10 <argint>
801057ad:	83 c4 10             	add    $0x10,%esp
801057b0:	85 c0                	test   %eax,%eax
801057b2:	0f 88 04 01 00 00    	js     801058bc <sys_open+0x13c>
    return -1;

  begin_op();
801057b8:	e8 13 d4 ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
801057bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057c1:	0f 85 a9 00 00 00    	jne    80105870 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057c7:	83 ec 0c             	sub    $0xc,%esp
801057ca:	ff 75 e0             	pushl  -0x20(%ebp)
801057cd:	e8 3e c7 ff ff       	call   80101f10 <namei>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	89 c6                	mov    %eax,%esi
801057d9:	0f 84 b2 00 00 00    	je     80105891 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801057df:	83 ec 0c             	sub    $0xc,%esp
801057e2:	50                   	push   %eax
801057e3:	e8 c8 be ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057f0:	0f 84 aa 00 00 00    	je     801058a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057f6:	e8 a5 b5 ff ff       	call   80100da0 <filealloc>
801057fb:	85 c0                	test   %eax,%eax
801057fd:	89 c7                	mov    %eax,%edi
801057ff:	0f 84 a6 00 00 00    	je     801058ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105805:	e8 66 e0 ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010580a:	31 db                	xor    %ebx,%ebx
8010580c:	eb 0e                	jmp    8010581c <sys_open+0x9c>
8010580e:	66 90                	xchg   %ax,%ax
80105810:	83 c3 01             	add    $0x1,%ebx
80105813:	83 fb 10             	cmp    $0x10,%ebx
80105816:	0f 84 ac 00 00 00    	je     801058c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010581c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105820:	85 d2                	test   %edx,%edx
80105822:	75 ec                	jne    80105810 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105824:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105827:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010582b:	56                   	push   %esi
8010582c:	e8 5f bf ff ff       	call   80101790 <iunlock>
  end_op();
80105831:	e8 0a d4 ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105836:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010583c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010583f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105842:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105845:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010584c:	89 d0                	mov    %edx,%eax
8010584e:	f7 d0                	not    %eax
80105850:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105853:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105856:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105859:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010585d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105860:	89 d8                	mov    %ebx,%eax
80105862:	5b                   	pop    %ebx
80105863:	5e                   	pop    %esi
80105864:	5f                   	pop    %edi
80105865:	5d                   	pop    %ebp
80105866:	c3                   	ret    
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105876:	31 c9                	xor    %ecx,%ecx
80105878:	6a 00                	push   $0x0
8010587a:	ba 02 00 00 00       	mov    $0x2,%edx
8010587f:	e8 ec f7 ff ff       	call   80105070 <create>
    if(ip == 0){
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105889:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010588b:	0f 85 65 ff ff ff    	jne    801057f6 <sys_open+0x76>
      end_op();
80105891:	e8 aa d3 ff ff       	call   80102c40 <end_op>
      return -1;
80105896:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010589b:	eb c0                	jmp    8010585d <sys_open+0xdd>
8010589d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801058a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058a3:	85 c9                	test   %ecx,%ecx
801058a5:	0f 84 4b ff ff ff    	je     801057f6 <sys_open+0x76>
    iunlockput(ip);
801058ab:	83 ec 0c             	sub    $0xc,%esp
801058ae:	56                   	push   %esi
801058af:	e8 8c c0 ff ff       	call   80101940 <iunlockput>
    end_op();
801058b4:	e8 87 d3 ff ff       	call   80102c40 <end_op>
    return -1;
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058c1:	eb 9a                	jmp    8010585d <sys_open+0xdd>
801058c3:	90                   	nop
801058c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	57                   	push   %edi
801058cc:	e8 8f b5 ff ff       	call   80100e60 <fileclose>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	eb d5                	jmp    801058ab <sys_open+0x12b>
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058e6:	e8 e5 d2 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ee:	83 ec 08             	sub    $0x8,%esp
801058f1:	50                   	push   %eax
801058f2:	6a 00                	push   $0x0
801058f4:	e8 c7 f6 ff ff       	call   80104fc0 <argstr>
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	85 c0                	test   %eax,%eax
801058fe:	78 30                	js     80105930 <sys_mkdir+0x50>
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105906:	31 c9                	xor    %ecx,%ecx
80105908:	6a 00                	push   $0x0
8010590a:	ba 01 00 00 00       	mov    $0x1,%edx
8010590f:	e8 5c f7 ff ff       	call   80105070 <create>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	85 c0                	test   %eax,%eax
80105919:	74 15                	je     80105930 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010591b:	83 ec 0c             	sub    $0xc,%esp
8010591e:	50                   	push   %eax
8010591f:	e8 1c c0 ff ff       	call   80101940 <iunlockput>
  end_op();
80105924:	e8 17 d3 ff ff       	call   80102c40 <end_op>
  return 0;
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	31 c0                	xor    %eax,%eax
}
8010592e:	c9                   	leave  
8010592f:	c3                   	ret    
    end_op();
80105930:	e8 0b d3 ff ff       	call   80102c40 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_mknod>:

int
sys_mknod(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105946:	e8 85 d2 ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010594b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010594e:	83 ec 08             	sub    $0x8,%esp
80105951:	50                   	push   %eax
80105952:	6a 00                	push   $0x0
80105954:	e8 67 f6 ff ff       	call   80104fc0 <argstr>
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	85 c0                	test   %eax,%eax
8010595e:	78 60                	js     801059c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105960:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105963:	83 ec 08             	sub    $0x8,%esp
80105966:	50                   	push   %eax
80105967:	6a 01                	push   $0x1
80105969:	e8 a2 f5 ff ff       	call   80104f10 <argint>
  if((argstr(0, &path)) < 0 ||
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	85 c0                	test   %eax,%eax
80105973:	78 4b                	js     801059c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105975:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105978:	83 ec 08             	sub    $0x8,%esp
8010597b:	50                   	push   %eax
8010597c:	6a 02                	push   $0x2
8010597e:	e8 8d f5 ff ff       	call   80104f10 <argint>
     argint(1, &major) < 0 ||
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	78 36                	js     801059c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010598a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010598e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105991:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105995:	ba 03 00 00 00       	mov    $0x3,%edx
8010599a:	50                   	push   %eax
8010599b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010599e:	e8 cd f6 ff ff       	call   80105070 <create>
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 c0                	test   %eax,%eax
801059a8:	74 16                	je     801059c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059aa:	83 ec 0c             	sub    $0xc,%esp
801059ad:	50                   	push   %eax
801059ae:	e8 8d bf ff ff       	call   80101940 <iunlockput>
  end_op();
801059b3:	e8 88 d2 ff ff       	call   80102c40 <end_op>
  return 0;
801059b8:	83 c4 10             	add    $0x10,%esp
801059bb:	31 c0                	xor    %eax,%eax
}
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop
    end_op();
801059c0:	e8 7b d2 ff ff       	call   80102c40 <end_op>
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ca:	c9                   	leave  
801059cb:	c3                   	ret    
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_chdir>:

int
sys_chdir(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	56                   	push   %esi
801059d4:	53                   	push   %ebx
801059d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059d8:	e8 93 de ff ff       	call   80103870 <myproc>
801059dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059df:	e8 ec d1 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e7:	83 ec 08             	sub    $0x8,%esp
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 ce f5 ff ff       	call   80104fc0 <argstr>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 77                	js     80105a70 <sys_chdir+0xa0>
801059f9:	83 ec 0c             	sub    $0xc,%esp
801059fc:	ff 75 f4             	pushl  -0xc(%ebp)
801059ff:	e8 0c c5 ff ff       	call   80101f10 <namei>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	89 c3                	mov    %eax,%ebx
80105a0b:	74 63                	je     80105a70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	50                   	push   %eax
80105a11:	e8 9a bc ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a1e:	75 30                	jne    80105a50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	53                   	push   %ebx
80105a24:	e8 67 bd ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105a29:	58                   	pop    %eax
80105a2a:	ff 76 68             	pushl  0x68(%esi)
80105a2d:	e8 ae bd ff ff       	call   801017e0 <iput>
  end_op();
80105a32:	e8 09 d2 ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
80105a37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	31 c0                	xor    %eax,%eax
}
80105a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a42:	5b                   	pop    %ebx
80105a43:	5e                   	pop    %esi
80105a44:	5d                   	pop    %ebp
80105a45:	c3                   	ret    
80105a46:	8d 76 00             	lea    0x0(%esi),%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	53                   	push   %ebx
80105a54:	e8 e7 be ff ff       	call   80101940 <iunlockput>
    end_op();
80105a59:	e8 e2 d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a66:	eb d7                	jmp    80105a3f <sys_chdir+0x6f>
80105a68:	90                   	nop
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a70:	e8 cb d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7a:	eb c3                	jmp    80105a3f <sys_chdir+0x6f>
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_exec>:

int
sys_exec(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
80105a85:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a86:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a92:	50                   	push   %eax
80105a93:	6a 00                	push   $0x0
80105a95:	e8 26 f5 ff ff       	call   80104fc0 <argstr>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	0f 88 87 00 00 00    	js     80105b2c <sys_exec+0xac>
80105aa5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105aab:	83 ec 08             	sub    $0x8,%esp
80105aae:	50                   	push   %eax
80105aaf:	6a 01                	push   $0x1
80105ab1:	e8 5a f4 ff ff       	call   80104f10 <argint>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	78 6f                	js     80105b2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105abd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ac3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ac6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ac8:	68 80 00 00 00       	push   $0x80
80105acd:	6a 00                	push   $0x0
80105acf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ad5:	50                   	push   %eax
80105ad6:	e8 35 f1 ff ff       	call   80104c10 <memset>
80105adb:	83 c4 10             	add    $0x10,%esp
80105ade:	eb 2c                	jmp    80105b0c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105ae0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ae6:	85 c0                	test   %eax,%eax
80105ae8:	74 56                	je     80105b40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105aea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105af6:	52                   	push   %edx
80105af7:	50                   	push   %eax
80105af8:	e8 a3 f3 ff ff       	call   80104ea0 <fetchstr>
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	85 c0                	test   %eax,%eax
80105b02:	78 28                	js     80105b2c <sys_exec+0xac>
  for(i=0;; i++){
80105b04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b07:	83 fb 20             	cmp    $0x20,%ebx
80105b0a:	74 20                	je     80105b2c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b0c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b12:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b19:	83 ec 08             	sub    $0x8,%esp
80105b1c:	57                   	push   %edi
80105b1d:	01 f0                	add    %esi,%eax
80105b1f:	50                   	push   %eax
80105b20:	e8 3b f3 ff ff       	call   80104e60 <fetchint>
80105b25:	83 c4 10             	add    $0x10,%esp
80105b28:	85 c0                	test   %eax,%eax
80105b2a:	79 b4                	jns    80105ae0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b34:	5b                   	pop    %ebx
80105b35:	5e                   	pop    %esi
80105b36:	5f                   	pop    %edi
80105b37:	5d                   	pop    %ebp
80105b38:	c3                   	ret    
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b46:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105b49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b50:	00 00 00 00 
  return exec(path, argv);
80105b54:	50                   	push   %eax
80105b55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b5b:	e8 b0 ae ff ff       	call   80100a10 <exec>
80105b60:	83 c4 10             	add    $0x10,%esp
}
80105b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5f                   	pop    %edi
80105b69:	5d                   	pop    %ebp
80105b6a:	c3                   	ret    
80105b6b:	90                   	nop
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_pipe>:

int
sys_pipe(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b76:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b7c:	6a 08                	push   $0x8
80105b7e:	50                   	push   %eax
80105b7f:	6a 00                	push   $0x0
80105b81:	e8 da f3 ff ff       	call   80104f60 <argptr>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	0f 88 ae 00 00 00    	js     80105c3f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b94:	83 ec 08             	sub    $0x8,%esp
80105b97:	50                   	push   %eax
80105b98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b9b:	50                   	push   %eax
80105b9c:	e8 cf d6 ff ff       	call   80103270 <pipealloc>
80105ba1:	83 c4 10             	add    $0x10,%esp
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	0f 88 93 00 00 00    	js     80105c3f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105baf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105bb1:	e8 ba dc ff ff       	call   80103870 <myproc>
80105bb6:	eb 10                	jmp    80105bc8 <sys_pipe+0x58>
80105bb8:	90                   	nop
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105bc0:	83 c3 01             	add    $0x1,%ebx
80105bc3:	83 fb 10             	cmp    $0x10,%ebx
80105bc6:	74 60                	je     80105c28 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105bc8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bcc:	85 f6                	test   %esi,%esi
80105bce:	75 f0                	jne    80105bc0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105bd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105bd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bda:	e8 91 dc ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bdf:	31 d2                	xor    %edx,%edx
80105be1:	eb 0d                	jmp    80105bf0 <sys_pipe+0x80>
80105be3:	90                   	nop
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be8:	83 c2 01             	add    $0x1,%edx
80105beb:	83 fa 10             	cmp    $0x10,%edx
80105bee:	74 28                	je     80105c18 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105bf0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bf4:	85 c9                	test   %ecx,%ecx
80105bf6:	75 f0                	jne    80105be8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105bf8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105bfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c07:	31 c0                	xor    %eax,%eax
}
80105c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c0c:	5b                   	pop    %ebx
80105c0d:	5e                   	pop    %esi
80105c0e:	5f                   	pop    %edi
80105c0f:	5d                   	pop    %ebp
80105c10:	c3                   	ret    
80105c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105c18:	e8 53 dc ff ff       	call   80103870 <myproc>
80105c1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c24:	00 
80105c25:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c2e:	e8 2d b2 ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80105c33:	58                   	pop    %eax
80105c34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c37:	e8 24 b2 ff ff       	call   80100e60 <fileclose>
    return -1;
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c44:	eb c3                	jmp    80105c09 <sys_pipe+0x99>
80105c46:	66 90                	xchg   %ax,%ax
80105c48:	66 90                	xchg   %ax,%ax
80105c4a:	66 90                	xchg   %ax,%ax
80105c4c:	66 90                	xchg   %ax,%ax
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105c53:	5d                   	pop    %ebp
  return fork();
80105c54:	e9 b7 dd ff ff       	jmp    80103a10 <fork>
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_exit>:

int
sys_exit(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c66:	e8 55 e0 ff ff       	call   80103cc0 <exit>
  return 0;  // not reached
}
80105c6b:	31 c0                	xor    %eax,%eax
80105c6d:	c9                   	leave  
80105c6e:	c3                   	ret    
80105c6f:	90                   	nop

80105c70 <sys_wait>:

int
sys_wait(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c73:	5d                   	pop    %ebp
  return wait();
80105c74:	e9 87 e2 ff ff       	jmp    80103f00 <wait>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_kill>:

int
sys_kill(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 00                	push   $0x0
80105c8c:	e8 7f f2 ff ff       	call   80104f10 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 18                	js     80105cb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c9e:	e8 ed e4 ff ff       	call   80104190 <kill>
80105ca3:	83 c4 10             	add    $0x10,%esp
}
80105ca6:	c9                   	leave  
80105ca7:	c3                   	ret    
80105ca8:	90                   	nop
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    
80105cb7:	89 f6                	mov    %esi,%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cc0 <sys_getpid>:

int
sys_getpid(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105cc6:	e8 a5 db ff ff       	call   80103870 <myproc>
80105ccb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cce:	c9                   	leave  
80105ccf:	c3                   	ret    

80105cd0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cda:	50                   	push   %eax
80105cdb:	6a 00                	push   $0x0
80105cdd:	e8 2e f2 ff ff       	call   80104f10 <argint>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 27                	js     80105d10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ce9:	e8 82 db ff ff       	call   80103870 <myproc>
  if(growproc(n) < 0)
80105cee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105cf1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105cf3:	ff 75 f4             	pushl  -0xc(%ebp)
80105cf6:	e8 95 dc ff ff       	call   80103990 <growproc>
80105cfb:	83 c4 10             	add    $0x10,%esp
80105cfe:	85 c0                	test   %eax,%eax
80105d00:	78 0e                	js     80105d10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d02:	89 d8                	mov    %ebx,%eax
80105d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d07:	c9                   	leave  
80105d08:	c3                   	ret    
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d15:	eb eb                	jmp    80105d02 <sys_sbrk+0x32>
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d20 <sys_sleep>:

int
sys_sleep(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 de f1 ff ff       	call   80104f10 <argint>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	0f 88 8a 00 00 00    	js     80105dc7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	68 80 d9 11 80       	push   $0x8011d980
80105d45:	e8 b6 ed ff ff       	call   80104b00 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d4d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105d50:	8b 1d c0 e1 11 80    	mov    0x8011e1c0,%ebx
  while(ticks - ticks0 < n){
80105d56:	85 d2                	test   %edx,%edx
80105d58:	75 27                	jne    80105d81 <sys_sleep+0x61>
80105d5a:	eb 54                	jmp    80105db0 <sys_sleep+0x90>
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d60:	83 ec 08             	sub    $0x8,%esp
80105d63:	68 80 d9 11 80       	push   $0x8011d980
80105d68:	68 c0 e1 11 80       	push   $0x8011e1c0
80105d6d:	e8 ce e0 ff ff       	call   80103e40 <sleep>
  while(ticks - ticks0 < n){
80105d72:	a1 c0 e1 11 80       	mov    0x8011e1c0,%eax
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	29 d8                	sub    %ebx,%eax
80105d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d7f:	73 2f                	jae    80105db0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d81:	e8 ea da ff ff       	call   80103870 <myproc>
80105d86:	8b 40 24             	mov    0x24(%eax),%eax
80105d89:	85 c0                	test   %eax,%eax
80105d8b:	74 d3                	je     80105d60 <sys_sleep+0x40>
      release(&tickslock);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	68 80 d9 11 80       	push   $0x8011d980
80105d95:	e8 26 ee ff ff       	call   80104bc0 <release>
      return -1;
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105da2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	68 80 d9 11 80       	push   $0x8011d980
80105db8:	e8 03 ee ff ff       	call   80104bc0 <release>
  return 0;
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	31 c0                	xor    %eax,%eax
}
80105dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dc5:	c9                   	leave  
80105dc6:	c3                   	ret    
    return -1;
80105dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dcc:	eb f4                	jmp    80105dc2 <sys_sleep+0xa2>
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	53                   	push   %ebx
80105dd4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105dd7:	68 80 d9 11 80       	push   $0x8011d980
80105ddc:	e8 1f ed ff ff       	call   80104b00 <acquire>
  xticks = ticks;
80105de1:	8b 1d c0 e1 11 80    	mov    0x8011e1c0,%ebx
  release(&tickslock);
80105de7:	c7 04 24 80 d9 11 80 	movl   $0x8011d980,(%esp)
80105dee:	e8 cd ed ff ff       	call   80104bc0 <release>
  return xticks;
}
80105df3:	89 d8                	mov    %ebx,%eax
80105df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df8:	c9                   	leave  
80105df9:	c3                   	ret    
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e00 <sys_print_count>:

extern int system_call_count[NoSysCalls];
extern char *system_call_names[NoSysCalls];

int
sys_print_count(void){
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
80105e04:	31 db                	xor    %ebx,%ebx
80105e06:	83 ec 04             	sub    $0x4,%esp
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int i;
  for(i = 0 ; i < NoSysCalls; i++){
    if(system_call_count[i] > 0)
80105e10:	8b 83 00 d9 11 80    	mov    -0x7fee2700(%ebx),%eax
80105e16:	85 c0                	test   %eax,%eax
80105e18:	7e 17                	jle    80105e31 <sys_print_count+0x31>
    cprintf("%s %d\n", system_call_names[i], system_call_count[i]);
80105e1a:	83 ec 04             	sub    $0x4,%esp
80105e1d:	50                   	push   %eax
80105e1e:	ff b3 20 b0 10 80    	pushl  -0x7fef4fe0(%ebx)
80105e24:	68 a5 82 10 80       	push   $0x801082a5
80105e29:	e8 32 a8 ff ff       	call   80100660 <cprintf>
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	83 c3 04             	add    $0x4,%ebx
  for(i = 0 ; i < NoSysCalls; i++){
80105e34:	83 fb 6c             	cmp    $0x6c,%ebx
80105e37:	75 d7                	jne    80105e10 <sys_print_count+0x10>
  }
  return 1;
}
80105e39:	b8 01 00 00 00       	mov    $0x1,%eax
80105e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e41:	c9                   	leave  
80105e42:	c3                   	ret    
80105e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e50 <sys_toggle>:

int 
sys_toggle(void)
{
  if(toggle_flag == 0){
80105e50:	8b 15 3c b6 10 80    	mov    0x8010b63c,%edx
{
80105e56:	55                   	push   %ebp
80105e57:	89 e5                	mov    %esp,%ebp
  if(toggle_flag == 0){
80105e59:	85 d2                	test   %edx,%edx
80105e5b:	75 1b                	jne    80105e78 <sys_toggle+0x28>
80105e5d:	b8 00 d9 11 80       	mov    $0x8011d900,%eax
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int i;
    for(i = 0; i < NoSysCalls; i++)
      system_call_count[i] = 0;
80105e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105e6e:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < NoSysCalls; i++)
80105e71:	3d 6c d9 11 80       	cmp    $0x8011d96c,%eax
80105e76:	75 f0                	jne    80105e68 <sys_toggle+0x18>
  }
  toggle_flag ^= 1;
80105e78:	83 f2 01             	xor    $0x1,%edx
  return 1;
}
80105e7b:	b8 01 00 00 00       	mov    $0x1,%eax
  toggle_flag ^= 1;
80105e80:	89 15 3c b6 10 80    	mov    %edx,0x8010b63c
}
80105e86:	5d                   	pop    %ebp
80105e87:	c3                   	ret    
80105e88:	90                   	nop
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_add>:

int
sys_add(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 20             	sub    $0x20,%esp
  int a,b;
  
  // return error if can't fetch the arguments
  if(argint(0, &a) < 0 || argint(1, &b) < 0)
80105e96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e99:	50                   	push   %eax
80105e9a:	6a 00                	push   $0x0
80105e9c:	e8 6f f0 ff ff       	call   80104f10 <argint>
80105ea1:	83 c4 10             	add    $0x10,%esp
80105ea4:	85 c0                	test   %eax,%eax
80105ea6:	78 20                	js     80105ec8 <sys_add+0x38>
80105ea8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eab:	83 ec 08             	sub    $0x8,%esp
80105eae:	50                   	push   %eax
80105eaf:	6a 01                	push   $0x1
80105eb1:	e8 5a f0 ff ff       	call   80104f10 <argint>
80105eb6:	83 c4 10             	add    $0x10,%esp
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	78 0b                	js     80105ec8 <sys_add+0x38>
    return -1;

  return (a+b);
80105ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec0:	03 45 f0             	add    -0x10(%ebp),%eax
}
80105ec3:	c9                   	leave  
80105ec4:	c3                   	ret    
80105ec5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ecd:	c9                   	leave  
80105ece:	c3                   	ret    
80105ecf:	90                   	nop

80105ed0 <sys_ps>:

int 
sys_ps(void){
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 08             	sub    $0x8,%esp
  ps_print_list();
80105ed6:	e8 05 e4 ff ff       	call   801042e0 <ps_print_list>
  return 1;
}
80105edb:	b8 01 00 00 00       	mov    $0x1,%eax
80105ee0:	c9                   	leave  
80105ee1:	c3                   	ret    
80105ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ef0 <sys_send>:

// IPC unicast:

int 
sys_send(void){
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 20             	sub    $0x20,%esp
  int sender_pid, rec_pid;
  char* msg;
  // fetch the arguments
  if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSGSIZE) < 0)
80105ef6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ef9:	50                   	push   %eax
80105efa:	6a 00                	push   $0x0
80105efc:	e8 0f f0 ff ff       	call   80104f10 <argint>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	85 c0                	test   %eax,%eax
80105f06:	78 48                	js     80105f50 <sys_send+0x60>
80105f08:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f0b:	83 ec 08             	sub    $0x8,%esp
80105f0e:	50                   	push   %eax
80105f0f:	6a 01                	push   $0x1
80105f11:	e8 fa ef ff ff       	call   80104f10 <argint>
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 33                	js     80105f50 <sys_send+0x60>
80105f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f20:	83 ec 04             	sub    $0x4,%esp
80105f23:	6a 08                	push   $0x8
80105f25:	50                   	push   %eax
80105f26:	6a 02                	push   $0x2
80105f28:	e8 33 f0 ff ff       	call   80104f60 <argptr>
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	85 c0                	test   %eax,%eax
80105f32:	78 1c                	js     80105f50 <sys_send+0x60>
    return -1;
  return send_msg(sender_pid, rec_pid, msg);
80105f34:	83 ec 04             	sub    $0x4,%esp
80105f37:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3a:	ff 75 f0             	pushl  -0x10(%ebp)
80105f3d:	ff 75 ec             	pushl  -0x14(%ebp)
80105f40:	e8 3b e4 ff ff       	call   80104380 <send_msg>
80105f45:	83 c4 10             	add    $0x10,%esp
}
80105f48:	c9                   	leave  
80105f49:	c3                   	ret    
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_recv>:

int 
sys_recv(void){
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 1c             	sub    $0x1c,%esp
  char* msg;
  // fetch the arguments
  if(argptr(0, &msg, MSGSIZE) < 0)
80105f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f69:	6a 08                	push   $0x8
80105f6b:	50                   	push   %eax
80105f6c:	6a 00                	push   $0x0
80105f6e:	e8 ed ef ff ff       	call   80104f60 <argptr>
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 c0                	test   %eax,%eax
80105f78:	78 16                	js     80105f90 <sys_recv+0x30>
    return -1;
  return recv_msg(msg);
80105f7a:	83 ec 0c             	sub    $0xc,%esp
80105f7d:	ff 75 f4             	pushl  -0xc(%ebp)
80105f80:	e8 eb e4 ff ff       	call   80104470 <recv_msg>
80105f85:	83 c4 10             	add    $0x10,%esp
}
80105f88:	c9                   	leave  
80105f89:	c3                   	ret    
80105f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fa0 <sys_sig_set>:

// Signals:

int
sys_sig_set(void){
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 20             	sub    $0x20,%esp
  int sig_num;
  char* handler_char;
  sighandler_t handler;
  // fetch the arguments
  if(argint(0, &sig_num) < 0 || argptr(1, &handler_char, 4) < 0)
80105fa6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fa9:	50                   	push   %eax
80105faa:	6a 00                	push   $0x0
80105fac:	e8 5f ef ff ff       	call   80104f10 <argint>
80105fb1:	83 c4 10             	add    $0x10,%esp
80105fb4:	85 c0                	test   %eax,%eax
80105fb6:	78 30                	js     80105fe8 <sys_sig_set+0x48>
80105fb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fbb:	83 ec 04             	sub    $0x4,%esp
80105fbe:	6a 04                	push   $0x4
80105fc0:	50                   	push   %eax
80105fc1:	6a 01                	push   $0x1
80105fc3:	e8 98 ef ff ff       	call   80104f60 <argptr>
80105fc8:	83 c4 10             	add    $0x10,%esp
80105fcb:	85 c0                	test   %eax,%eax
80105fcd:	78 19                	js     80105fe8 <sys_sig_set+0x48>
    return -1;
  handler = (sighandler_t) handler_char;
  return sig_set(sig_num, handler);
80105fcf:	83 ec 08             	sub    $0x8,%esp
80105fd2:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fd8:	e8 b3 e5 ff ff       	call   80104590 <sig_set>
80105fdd:	83 c4 10             	add    $0x10,%esp
}
80105fe0:	c9                   	leave  
80105fe1:	c3                   	ret    
80105fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fed:	c9                   	leave  
80105fee:	c3                   	ret    
80105fef:	90                   	nop

80105ff0 <sys_sig_send>:

int
sys_sig_send(void){
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	83 ec 20             	sub    $0x20,%esp
  int sig_num, dest_pid;
  char *sig_arg;
  // fetch the arguments
  if(argint(0, &dest_pid), argint(1, &sig_num) < 0 || argptr(2, &sig_arg, MSGSIZE) < 0)
80105ff6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ff9:	50                   	push   %eax
80105ffa:	6a 00                	push   $0x0
80105ffc:	e8 0f ef ff ff       	call   80104f10 <argint>
80106001:	58                   	pop    %eax
80106002:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106005:	5a                   	pop    %edx
80106006:	50                   	push   %eax
80106007:	6a 01                	push   $0x1
80106009:	e8 02 ef ff ff       	call   80104f10 <argint>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	85 c0                	test   %eax,%eax
80106013:	78 33                	js     80106048 <sys_sig_send+0x58>
80106015:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106018:	83 ec 04             	sub    $0x4,%esp
8010601b:	6a 08                	push   $0x8
8010601d:	50                   	push   %eax
8010601e:	6a 02                	push   $0x2
80106020:	e8 3b ef ff ff       	call   80104f60 <argptr>
80106025:	83 c4 10             	add    $0x10,%esp
80106028:	85 c0                	test   %eax,%eax
8010602a:	78 1c                	js     80106048 <sys_sig_send+0x58>
    return -1;
  return sig_send(dest_pid, sig_num, sig_arg);
8010602c:	83 ec 04             	sub    $0x4,%esp
8010602f:	ff 75 f4             	pushl  -0xc(%ebp)
80106032:	ff 75 ec             	pushl  -0x14(%ebp)
80106035:	ff 75 f0             	pushl  -0x10(%ebp)
80106038:	e8 93 e5 ff ff       	call   801045d0 <sig_send>
8010603d:	83 c4 10             	add    $0x10,%esp
}
80106040:	c9                   	leave  
80106041:	c3                   	ret    
80106042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010604d:	c9                   	leave  
8010604e:	c3                   	ret    
8010604f:	90                   	nop

80106050 <sys_sig_pause>:

int
sys_sig_pause(void){
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
  return sig_pause();
}
80106053:	5d                   	pop    %ebp
  return sig_pause();
80106054:	e9 97 e5 ff ff       	jmp    801045f0 <sig_pause>
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <sys_sig_ret>:

int
sys_sig_ret(void){
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
  return sig_ret();
}
80106063:	5d                   	pop    %ebp
  return sig_ret();
80106064:	e9 37 e6 ff ff       	jmp    801046a0 <sig_ret>
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_send_multi>:

// IPC multicast:
int
sys_send_multi(void){
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 20             	sub    $0x20,%esp
  char *rec_pids_char;
  int sender_pid, *rec_pids, rec_length;
  char* msg;

  // fetch the arguments
  if(argint(3, &rec_length) < 0)
80106076:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106079:	50                   	push   %eax
8010607a:	6a 03                	push   $0x3
8010607c:	e8 8f ee ff ff       	call   80104f10 <argint>
80106081:	83 c4 10             	add    $0x10,%esp
80106084:	85 c0                	test   %eax,%eax
80106086:	78 60                	js     801060e8 <sys_send_multi+0x78>
    return -1;
  if(argint(0, &sender_pid) < 0 || argptr(1, &rec_pids_char, rec_length) < 0
80106088:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010608b:	83 ec 08             	sub    $0x8,%esp
8010608e:	50                   	push   %eax
8010608f:	6a 00                	push   $0x0
80106091:	e8 7a ee ff ff       	call   80104f10 <argint>
80106096:	83 c4 10             	add    $0x10,%esp
80106099:	85 c0                	test   %eax,%eax
8010609b:	78 4b                	js     801060e8 <sys_send_multi+0x78>
8010609d:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060a0:	83 ec 04             	sub    $0x4,%esp
801060a3:	ff 75 f0             	pushl  -0x10(%ebp)
801060a6:	50                   	push   %eax
801060a7:	6a 01                	push   $0x1
801060a9:	e8 b2 ee ff ff       	call   80104f60 <argptr>
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	85 c0                	test   %eax,%eax
801060b3:	78 33                	js     801060e8 <sys_send_multi+0x78>
   || argptr(2, &msg, MSGSIZE) < 0)
801060b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060b8:	83 ec 04             	sub    $0x4,%esp
801060bb:	6a 08                	push   $0x8
801060bd:	50                   	push   %eax
801060be:	6a 02                	push   $0x2
801060c0:	e8 9b ee ff ff       	call   80104f60 <argptr>
801060c5:	83 c4 10             	add    $0x10,%esp
801060c8:	85 c0                	test   %eax,%eax
801060ca:	78 1c                	js     801060e8 <sys_send_multi+0x78>
    return -1;

  rec_pids = (int *)rec_pids_char;
  return send_multi(sender_pid, rec_pids, msg, rec_length);
801060cc:	ff 75 f0             	pushl  -0x10(%ebp)
801060cf:	ff 75 f4             	pushl  -0xc(%ebp)
801060d2:	ff 75 e8             	pushl  -0x18(%ebp)
801060d5:	ff 75 ec             	pushl  -0x14(%ebp)
801060d8:	e8 53 e7 ff ff       	call   80104830 <send_multi>
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	c9                   	leave  
801060e1:	c3                   	ret    
801060e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801060e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ed:	c9                   	leave  
801060ee:	c3                   	ret    

801060ef <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801060ef:	1e                   	push   %ds
  pushl %es
801060f0:	06                   	push   %es
  pushl %fs
801060f1:	0f a0                	push   %fs
  pushl %gs
801060f3:	0f a8                	push   %gs
  pushal
801060f5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801060f6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801060fa:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801060fc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801060fe:	54                   	push   %esp
  call trap
801060ff:	e8 cc 00 00 00       	call   801061d0 <trap>
  addl $4, %esp
80106104:	83 c4 04             	add    $0x4,%esp

80106107 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  # ****added**************
  call execute_signal_handler
80106107:	e8 d4 e5 ff ff       	call   801046e0 <execute_signal_handler>
  # ****
  popal
8010610c:	61                   	popa   
  popl %gs
8010610d:	0f a9                	pop    %gs
  popl %fs
8010610f:	0f a1                	pop    %fs
  popl %es
80106111:	07                   	pop    %es
  popl %ds
80106112:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106113:	83 c4 08             	add    $0x8,%esp
  iret
80106116:	cf                   	iret   
80106117:	66 90                	xchg   %ax,%ax
80106119:	66 90                	xchg   %ax,%ax
8010611b:	66 90                	xchg   %ax,%ax
8010611d:	66 90                	xchg   %ax,%ax
8010611f:	90                   	nop

80106120 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106120:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106121:	31 c0                	xor    %eax,%eax
{
80106123:	89 e5                	mov    %esp,%ebp
80106125:	83 ec 08             	sub    $0x8,%esp
80106128:	90                   	nop
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106130:	8b 14 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%edx
80106137:	c7 04 c5 c2 d9 11 80 	movl   $0x8e000008,-0x7fee263e(,%eax,8)
8010613e:	08 00 00 8e 
80106142:	66 89 14 c5 c0 d9 11 	mov    %dx,-0x7fee2640(,%eax,8)
80106149:	80 
8010614a:	c1 ea 10             	shr    $0x10,%edx
8010614d:	66 89 14 c5 c6 d9 11 	mov    %dx,-0x7fee263a(,%eax,8)
80106154:	80 
  for(i = 0; i < 256; i++)
80106155:	83 c0 01             	add    $0x1,%eax
80106158:	3d 00 01 00 00       	cmp    $0x100,%eax
8010615d:	75 d1                	jne    80106130 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010615f:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax

  initlock(&tickslock, "time");
80106164:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106167:	c7 05 c2 db 11 80 08 	movl   $0xef000008,0x8011dbc2
8010616e:	00 00 ef 
  initlock(&tickslock, "time");
80106171:	68 e0 80 10 80       	push   $0x801080e0
80106176:	68 80 d9 11 80       	push   $0x8011d980
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010617b:	66 a3 c0 db 11 80    	mov    %ax,0x8011dbc0
80106181:	c1 e8 10             	shr    $0x10,%eax
80106184:	66 a3 c6 db 11 80    	mov    %ax,0x8011dbc6
  initlock(&tickslock, "time");
8010618a:	e8 31 e8 ff ff       	call   801049c0 <initlock>
}
8010618f:	83 c4 10             	add    $0x10,%esp
80106192:	c9                   	leave  
80106193:	c3                   	ret    
80106194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010619a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801061a0 <idtinit>:

void
idtinit(void)
{
801061a0:	55                   	push   %ebp
  pd[0] = size-1;
801061a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061a6:	89 e5                	mov    %esp,%ebp
801061a8:	83 ec 10             	sub    $0x10,%esp
801061ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061af:	b8 c0 d9 11 80       	mov    $0x8011d9c0,%eax
801061b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061b8:	c1 e8 10             	shr    $0x10,%eax
801061bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061c2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061c5:	c9                   	leave  
801061c6:	c3                   	ret    
801061c7:	89 f6                	mov    %esi,%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	57                   	push   %edi
801061d4:	56                   	push   %esi
801061d5:	53                   	push   %ebx
801061d6:	83 ec 1c             	sub    $0x1c,%esp
801061d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801061dc:	8b 47 30             	mov    0x30(%edi),%eax
801061df:	83 f8 40             	cmp    $0x40,%eax
801061e2:	0f 84 f0 00 00 00    	je     801062d8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061e8:	83 e8 20             	sub    $0x20,%eax
801061eb:	83 f8 1f             	cmp    $0x1f,%eax
801061ee:	77 10                	ja     80106200 <trap+0x30>
801061f0:	ff 24 85 50 83 10 80 	jmp    *-0x7fef7cb0(,%eax,4)
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106200:	e8 6b d6 ff ff       	call   80103870 <myproc>
80106205:	85 c0                	test   %eax,%eax
80106207:	8b 5f 38             	mov    0x38(%edi),%ebx
8010620a:	0f 84 14 02 00 00    	je     80106424 <trap+0x254>
80106210:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106214:	0f 84 0a 02 00 00    	je     80106424 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010621a:	0f 20 d1             	mov    %cr2,%ecx
8010621d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106220:	e8 2b d6 ff ff       	call   80103850 <cpuid>
80106225:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106228:	8b 47 34             	mov    0x34(%edi),%eax
8010622b:	8b 77 30             	mov    0x30(%edi),%esi
8010622e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106231:	e8 3a d6 ff ff       	call   80103870 <myproc>
80106236:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106239:	e8 32 d6 ff ff       	call   80103870 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010623e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106241:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106244:	51                   	push   %ecx
80106245:	53                   	push   %ebx
80106246:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106247:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010624a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010624d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010624e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106251:	52                   	push   %edx
80106252:	ff 70 10             	pushl  0x10(%eax)
80106255:	68 0c 83 10 80       	push   $0x8010830c
8010625a:	e8 01 a4 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010625f:	83 c4 20             	add    $0x20,%esp
80106262:	e8 09 d6 ff ff       	call   80103870 <myproc>
80106267:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010626e:	e8 fd d5 ff ff       	call   80103870 <myproc>
80106273:	85 c0                	test   %eax,%eax
80106275:	74 1d                	je     80106294 <trap+0xc4>
80106277:	e8 f4 d5 ff ff       	call   80103870 <myproc>
8010627c:	8b 50 24             	mov    0x24(%eax),%edx
8010627f:	85 d2                	test   %edx,%edx
80106281:	74 11                	je     80106294 <trap+0xc4>
80106283:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106287:	83 e0 03             	and    $0x3,%eax
8010628a:	66 83 f8 03          	cmp    $0x3,%ax
8010628e:	0f 84 4c 01 00 00    	je     801063e0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106294:	e8 d7 d5 ff ff       	call   80103870 <myproc>
80106299:	85 c0                	test   %eax,%eax
8010629b:	74 0b                	je     801062a8 <trap+0xd8>
8010629d:	e8 ce d5 ff ff       	call   80103870 <myproc>
801062a2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062a6:	74 68                	je     80106310 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062a8:	e8 c3 d5 ff ff       	call   80103870 <myproc>
801062ad:	85 c0                	test   %eax,%eax
801062af:	74 19                	je     801062ca <trap+0xfa>
801062b1:	e8 ba d5 ff ff       	call   80103870 <myproc>
801062b6:	8b 40 24             	mov    0x24(%eax),%eax
801062b9:	85 c0                	test   %eax,%eax
801062bb:	74 0d                	je     801062ca <trap+0xfa>
801062bd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801062c1:	83 e0 03             	and    $0x3,%eax
801062c4:	66 83 f8 03          	cmp    $0x3,%ax
801062c8:	74 37                	je     80106301 <trap+0x131>
    exit();
}
801062ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062cd:	5b                   	pop    %ebx
801062ce:	5e                   	pop    %esi
801062cf:	5f                   	pop    %edi
801062d0:	5d                   	pop    %ebp
801062d1:	c3                   	ret    
801062d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801062d8:	e8 93 d5 ff ff       	call   80103870 <myproc>
801062dd:	8b 58 24             	mov    0x24(%eax),%ebx
801062e0:	85 db                	test   %ebx,%ebx
801062e2:	0f 85 e8 00 00 00    	jne    801063d0 <trap+0x200>
    myproc()->tf = tf;
801062e8:	e8 83 d5 ff ff       	call   80103870 <myproc>
801062ed:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801062f0:	e8 0b ed ff ff       	call   80105000 <syscall>
    if(myproc()->killed)
801062f5:	e8 76 d5 ff ff       	call   80103870 <myproc>
801062fa:	8b 48 24             	mov    0x24(%eax),%ecx
801062fd:	85 c9                	test   %ecx,%ecx
801062ff:	74 c9                	je     801062ca <trap+0xfa>
}
80106301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106304:	5b                   	pop    %ebx
80106305:	5e                   	pop    %esi
80106306:	5f                   	pop    %edi
80106307:	5d                   	pop    %ebp
      exit();
80106308:	e9 b3 d9 ff ff       	jmp    80103cc0 <exit>
8010630d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106310:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106314:	75 92                	jne    801062a8 <trap+0xd8>
    yield();
80106316:	e8 d5 da ff ff       	call   80103df0 <yield>
8010631b:	eb 8b                	jmp    801062a8 <trap+0xd8>
8010631d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106320:	e8 2b d5 ff ff       	call   80103850 <cpuid>
80106325:	85 c0                	test   %eax,%eax
80106327:	0f 84 c3 00 00 00    	je     801063f0 <trap+0x220>
    lapiceoi();
8010632d:	e8 4e c4 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106332:	e8 39 d5 ff ff       	call   80103870 <myproc>
80106337:	85 c0                	test   %eax,%eax
80106339:	0f 85 38 ff ff ff    	jne    80106277 <trap+0xa7>
8010633f:	e9 50 ff ff ff       	jmp    80106294 <trap+0xc4>
80106344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106348:	e8 f3 c2 ff ff       	call   80102640 <kbdintr>
    lapiceoi();
8010634d:	e8 2e c4 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106352:	e8 19 d5 ff ff       	call   80103870 <myproc>
80106357:	85 c0                	test   %eax,%eax
80106359:	0f 85 18 ff ff ff    	jne    80106277 <trap+0xa7>
8010635f:	e9 30 ff ff ff       	jmp    80106294 <trap+0xc4>
80106364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106368:	e8 53 02 00 00       	call   801065c0 <uartintr>
    lapiceoi();
8010636d:	e8 0e c4 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106372:	e8 f9 d4 ff ff       	call   80103870 <myproc>
80106377:	85 c0                	test   %eax,%eax
80106379:	0f 85 f8 fe ff ff    	jne    80106277 <trap+0xa7>
8010637f:	e9 10 ff ff ff       	jmp    80106294 <trap+0xc4>
80106384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106388:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010638c:	8b 77 38             	mov    0x38(%edi),%esi
8010638f:	e8 bc d4 ff ff       	call   80103850 <cpuid>
80106394:	56                   	push   %esi
80106395:	53                   	push   %ebx
80106396:	50                   	push   %eax
80106397:	68 b4 82 10 80       	push   $0x801082b4
8010639c:	e8 bf a2 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801063a1:	e8 da c3 ff ff       	call   80102780 <lapiceoi>
    break;
801063a6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063a9:	e8 c2 d4 ff ff       	call   80103870 <myproc>
801063ae:	85 c0                	test   %eax,%eax
801063b0:	0f 85 c1 fe ff ff    	jne    80106277 <trap+0xa7>
801063b6:	e9 d9 fe ff ff       	jmp    80106294 <trap+0xc4>
801063bb:	90                   	nop
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801063c0:	e8 eb bc ff ff       	call   801020b0 <ideintr>
801063c5:	e9 63 ff ff ff       	jmp    8010632d <trap+0x15d>
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801063d0:	e8 eb d8 ff ff       	call   80103cc0 <exit>
801063d5:	e9 0e ff ff ff       	jmp    801062e8 <trap+0x118>
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801063e0:	e8 db d8 ff ff       	call   80103cc0 <exit>
801063e5:	e9 aa fe ff ff       	jmp    80106294 <trap+0xc4>
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	68 80 d9 11 80       	push   $0x8011d980
801063f8:	e8 03 e7 ff ff       	call   80104b00 <acquire>
      wakeup(&ticks);
801063fd:	c7 04 24 c0 e1 11 80 	movl   $0x8011e1c0,(%esp)
      ticks++;
80106404:	83 05 c0 e1 11 80 01 	addl   $0x1,0x8011e1c0
      wakeup(&ticks);
8010640b:	e8 f0 db ff ff       	call   80104000 <wakeup>
      release(&tickslock);
80106410:	c7 04 24 80 d9 11 80 	movl   $0x8011d980,(%esp)
80106417:	e8 a4 e7 ff ff       	call   80104bc0 <release>
8010641c:	83 c4 10             	add    $0x10,%esp
8010641f:	e9 09 ff ff ff       	jmp    8010632d <trap+0x15d>
80106424:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106427:	e8 24 d4 ff ff       	call   80103850 <cpuid>
8010642c:	83 ec 0c             	sub    $0xc,%esp
8010642f:	56                   	push   %esi
80106430:	53                   	push   %ebx
80106431:	50                   	push   %eax
80106432:	ff 77 30             	pushl  0x30(%edi)
80106435:	68 d8 82 10 80       	push   $0x801082d8
8010643a:	e8 21 a2 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010643f:	83 c4 14             	add    $0x14,%esp
80106442:	68 ac 82 10 80       	push   $0x801082ac
80106447:	e8 44 9f ff ff       	call   80100390 <panic>
8010644c:	66 90                	xchg   %ax,%ax
8010644e:	66 90                	xchg   %ax,%ax

80106450 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106450:	a1 40 b6 10 80       	mov    0x8010b640,%eax
{
80106455:	55                   	push   %ebp
80106456:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106458:	85 c0                	test   %eax,%eax
8010645a:	74 1c                	je     80106478 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106461:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106462:	a8 01                	test   $0x1,%al
80106464:	74 12                	je     80106478 <uartgetc+0x28>
80106466:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010646c:	0f b6 c0             	movzbl %al,%eax
}
8010646f:	5d                   	pop    %ebp
80106470:	c3                   	ret    
80106471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010647d:	5d                   	pop    %ebp
8010647e:	c3                   	ret    
8010647f:	90                   	nop

80106480 <uartputc.part.0>:
uartputc(int c)
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	57                   	push   %edi
80106484:	56                   	push   %esi
80106485:	53                   	push   %ebx
80106486:	89 c7                	mov    %eax,%edi
80106488:	bb 80 00 00 00       	mov    $0x80,%ebx
8010648d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106492:	83 ec 0c             	sub    $0xc,%esp
80106495:	eb 1b                	jmp    801064b2 <uartputc.part.0+0x32>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	6a 0a                	push   $0xa
801064a5:	e8 f6 c2 ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064aa:	83 c4 10             	add    $0x10,%esp
801064ad:	83 eb 01             	sub    $0x1,%ebx
801064b0:	74 07                	je     801064b9 <uartputc.part.0+0x39>
801064b2:	89 f2                	mov    %esi,%edx
801064b4:	ec                   	in     (%dx),%al
801064b5:	a8 20                	test   $0x20,%al
801064b7:	74 e7                	je     801064a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064be:	89 f8                	mov    %edi,%eax
801064c0:	ee                   	out    %al,(%dx)
}
801064c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064c4:	5b                   	pop    %ebx
801064c5:	5e                   	pop    %esi
801064c6:	5f                   	pop    %edi
801064c7:	5d                   	pop    %ebp
801064c8:	c3                   	ret    
801064c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064d0 <uartinit>:
{
801064d0:	55                   	push   %ebp
801064d1:	31 c9                	xor    %ecx,%ecx
801064d3:	89 c8                	mov    %ecx,%eax
801064d5:	89 e5                	mov    %esp,%ebp
801064d7:	57                   	push   %edi
801064d8:	56                   	push   %esi
801064d9:	53                   	push   %ebx
801064da:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064df:	89 da                	mov    %ebx,%edx
801064e1:	83 ec 0c             	sub    $0xc,%esp
801064e4:	ee                   	out    %al,(%dx)
801064e5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801064ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064ef:	89 fa                	mov    %edi,%edx
801064f1:	ee                   	out    %al,(%dx)
801064f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064fc:	ee                   	out    %al,(%dx)
801064fd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106502:	89 c8                	mov    %ecx,%eax
80106504:	89 f2                	mov    %esi,%edx
80106506:	ee                   	out    %al,(%dx)
80106507:	b8 03 00 00 00       	mov    $0x3,%eax
8010650c:	89 fa                	mov    %edi,%edx
8010650e:	ee                   	out    %al,(%dx)
8010650f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106514:	89 c8                	mov    %ecx,%eax
80106516:	ee                   	out    %al,(%dx)
80106517:	b8 01 00 00 00       	mov    $0x1,%eax
8010651c:	89 f2                	mov    %esi,%edx
8010651e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010651f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106524:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106525:	3c ff                	cmp    $0xff,%al
80106527:	74 5a                	je     80106583 <uartinit+0xb3>
  uart = 1;
80106529:	c7 05 40 b6 10 80 01 	movl   $0x1,0x8010b640
80106530:	00 00 00 
80106533:	89 da                	mov    %ebx,%edx
80106535:	ec                   	in     (%dx),%al
80106536:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010653b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010653c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010653f:	bb d0 83 10 80       	mov    $0x801083d0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106544:	6a 00                	push   $0x0
80106546:	6a 04                	push   $0x4
80106548:	e8 b3 bd ff ff       	call   80102300 <ioapicenable>
8010654d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106550:	b8 78 00 00 00       	mov    $0x78,%eax
80106555:	eb 13                	jmp    8010656a <uartinit+0x9a>
80106557:	89 f6                	mov    %esi,%esi
80106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106560:	83 c3 01             	add    $0x1,%ebx
80106563:	0f be 03             	movsbl (%ebx),%eax
80106566:	84 c0                	test   %al,%al
80106568:	74 19                	je     80106583 <uartinit+0xb3>
  if(!uart)
8010656a:	8b 15 40 b6 10 80    	mov    0x8010b640,%edx
80106570:	85 d2                	test   %edx,%edx
80106572:	74 ec                	je     80106560 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106574:	83 c3 01             	add    $0x1,%ebx
80106577:	e8 04 ff ff ff       	call   80106480 <uartputc.part.0>
8010657c:	0f be 03             	movsbl (%ebx),%eax
8010657f:	84 c0                	test   %al,%al
80106581:	75 e7                	jne    8010656a <uartinit+0x9a>
}
80106583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106586:	5b                   	pop    %ebx
80106587:	5e                   	pop    %esi
80106588:	5f                   	pop    %edi
80106589:	5d                   	pop    %ebp
8010658a:	c3                   	ret    
8010658b:	90                   	nop
8010658c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106590 <uartputc>:
  if(!uart)
80106590:	8b 15 40 b6 10 80    	mov    0x8010b640,%edx
{
80106596:	55                   	push   %ebp
80106597:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106599:	85 d2                	test   %edx,%edx
{
8010659b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010659e:	74 10                	je     801065b0 <uartputc+0x20>
}
801065a0:	5d                   	pop    %ebp
801065a1:	e9 da fe ff ff       	jmp    80106480 <uartputc.part.0>
801065a6:	8d 76 00             	lea    0x0(%esi),%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    
801065b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065c0 <uartintr>:

void
uartintr(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065c6:	68 50 64 10 80       	push   $0x80106450
801065cb:	e8 40 a2 ff ff       	call   80100810 <consoleintr>
}
801065d0:	83 c4 10             	add    $0x10,%esp
801065d3:	c9                   	leave  
801065d4:	c3                   	ret    

801065d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $0
801065d7:	6a 00                	push   $0x0
  jmp alltraps
801065d9:	e9 11 fb ff ff       	jmp    801060ef <alltraps>

801065de <vector1>:
.globl vector1
vector1:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $1
801065e0:	6a 01                	push   $0x1
  jmp alltraps
801065e2:	e9 08 fb ff ff       	jmp    801060ef <alltraps>

801065e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $2
801065e9:	6a 02                	push   $0x2
  jmp alltraps
801065eb:	e9 ff fa ff ff       	jmp    801060ef <alltraps>

801065f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $3
801065f2:	6a 03                	push   $0x3
  jmp alltraps
801065f4:	e9 f6 fa ff ff       	jmp    801060ef <alltraps>

801065f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $4
801065fb:	6a 04                	push   $0x4
  jmp alltraps
801065fd:	e9 ed fa ff ff       	jmp    801060ef <alltraps>

80106602 <vector5>:
.globl vector5
vector5:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $5
80106604:	6a 05                	push   $0x5
  jmp alltraps
80106606:	e9 e4 fa ff ff       	jmp    801060ef <alltraps>

8010660b <vector6>:
.globl vector6
vector6:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $6
8010660d:	6a 06                	push   $0x6
  jmp alltraps
8010660f:	e9 db fa ff ff       	jmp    801060ef <alltraps>

80106614 <vector7>:
.globl vector7
vector7:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $7
80106616:	6a 07                	push   $0x7
  jmp alltraps
80106618:	e9 d2 fa ff ff       	jmp    801060ef <alltraps>

8010661d <vector8>:
.globl vector8
vector8:
  pushl $8
8010661d:	6a 08                	push   $0x8
  jmp alltraps
8010661f:	e9 cb fa ff ff       	jmp    801060ef <alltraps>

80106624 <vector9>:
.globl vector9
vector9:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $9
80106626:	6a 09                	push   $0x9
  jmp alltraps
80106628:	e9 c2 fa ff ff       	jmp    801060ef <alltraps>

8010662d <vector10>:
.globl vector10
vector10:
  pushl $10
8010662d:	6a 0a                	push   $0xa
  jmp alltraps
8010662f:	e9 bb fa ff ff       	jmp    801060ef <alltraps>

80106634 <vector11>:
.globl vector11
vector11:
  pushl $11
80106634:	6a 0b                	push   $0xb
  jmp alltraps
80106636:	e9 b4 fa ff ff       	jmp    801060ef <alltraps>

8010663b <vector12>:
.globl vector12
vector12:
  pushl $12
8010663b:	6a 0c                	push   $0xc
  jmp alltraps
8010663d:	e9 ad fa ff ff       	jmp    801060ef <alltraps>

80106642 <vector13>:
.globl vector13
vector13:
  pushl $13
80106642:	6a 0d                	push   $0xd
  jmp alltraps
80106644:	e9 a6 fa ff ff       	jmp    801060ef <alltraps>

80106649 <vector14>:
.globl vector14
vector14:
  pushl $14
80106649:	6a 0e                	push   $0xe
  jmp alltraps
8010664b:	e9 9f fa ff ff       	jmp    801060ef <alltraps>

80106650 <vector15>:
.globl vector15
vector15:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $15
80106652:	6a 0f                	push   $0xf
  jmp alltraps
80106654:	e9 96 fa ff ff       	jmp    801060ef <alltraps>

80106659 <vector16>:
.globl vector16
vector16:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $16
8010665b:	6a 10                	push   $0x10
  jmp alltraps
8010665d:	e9 8d fa ff ff       	jmp    801060ef <alltraps>

80106662 <vector17>:
.globl vector17
vector17:
  pushl $17
80106662:	6a 11                	push   $0x11
  jmp alltraps
80106664:	e9 86 fa ff ff       	jmp    801060ef <alltraps>

80106669 <vector18>:
.globl vector18
vector18:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $18
8010666b:	6a 12                	push   $0x12
  jmp alltraps
8010666d:	e9 7d fa ff ff       	jmp    801060ef <alltraps>

80106672 <vector19>:
.globl vector19
vector19:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $19
80106674:	6a 13                	push   $0x13
  jmp alltraps
80106676:	e9 74 fa ff ff       	jmp    801060ef <alltraps>

8010667b <vector20>:
.globl vector20
vector20:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $20
8010667d:	6a 14                	push   $0x14
  jmp alltraps
8010667f:	e9 6b fa ff ff       	jmp    801060ef <alltraps>

80106684 <vector21>:
.globl vector21
vector21:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $21
80106686:	6a 15                	push   $0x15
  jmp alltraps
80106688:	e9 62 fa ff ff       	jmp    801060ef <alltraps>

8010668d <vector22>:
.globl vector22
vector22:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $22
8010668f:	6a 16                	push   $0x16
  jmp alltraps
80106691:	e9 59 fa ff ff       	jmp    801060ef <alltraps>

80106696 <vector23>:
.globl vector23
vector23:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $23
80106698:	6a 17                	push   $0x17
  jmp alltraps
8010669a:	e9 50 fa ff ff       	jmp    801060ef <alltraps>

8010669f <vector24>:
.globl vector24
vector24:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $24
801066a1:	6a 18                	push   $0x18
  jmp alltraps
801066a3:	e9 47 fa ff ff       	jmp    801060ef <alltraps>

801066a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $25
801066aa:	6a 19                	push   $0x19
  jmp alltraps
801066ac:	e9 3e fa ff ff       	jmp    801060ef <alltraps>

801066b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $26
801066b3:	6a 1a                	push   $0x1a
  jmp alltraps
801066b5:	e9 35 fa ff ff       	jmp    801060ef <alltraps>

801066ba <vector27>:
.globl vector27
vector27:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $27
801066bc:	6a 1b                	push   $0x1b
  jmp alltraps
801066be:	e9 2c fa ff ff       	jmp    801060ef <alltraps>

801066c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $28
801066c5:	6a 1c                	push   $0x1c
  jmp alltraps
801066c7:	e9 23 fa ff ff       	jmp    801060ef <alltraps>

801066cc <vector29>:
.globl vector29
vector29:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $29
801066ce:	6a 1d                	push   $0x1d
  jmp alltraps
801066d0:	e9 1a fa ff ff       	jmp    801060ef <alltraps>

801066d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $30
801066d7:	6a 1e                	push   $0x1e
  jmp alltraps
801066d9:	e9 11 fa ff ff       	jmp    801060ef <alltraps>

801066de <vector31>:
.globl vector31
vector31:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $31
801066e0:	6a 1f                	push   $0x1f
  jmp alltraps
801066e2:	e9 08 fa ff ff       	jmp    801060ef <alltraps>

801066e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $32
801066e9:	6a 20                	push   $0x20
  jmp alltraps
801066eb:	e9 ff f9 ff ff       	jmp    801060ef <alltraps>

801066f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $33
801066f2:	6a 21                	push   $0x21
  jmp alltraps
801066f4:	e9 f6 f9 ff ff       	jmp    801060ef <alltraps>

801066f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $34
801066fb:	6a 22                	push   $0x22
  jmp alltraps
801066fd:	e9 ed f9 ff ff       	jmp    801060ef <alltraps>

80106702 <vector35>:
.globl vector35
vector35:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $35
80106704:	6a 23                	push   $0x23
  jmp alltraps
80106706:	e9 e4 f9 ff ff       	jmp    801060ef <alltraps>

8010670b <vector36>:
.globl vector36
vector36:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $36
8010670d:	6a 24                	push   $0x24
  jmp alltraps
8010670f:	e9 db f9 ff ff       	jmp    801060ef <alltraps>

80106714 <vector37>:
.globl vector37
vector37:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $37
80106716:	6a 25                	push   $0x25
  jmp alltraps
80106718:	e9 d2 f9 ff ff       	jmp    801060ef <alltraps>

8010671d <vector38>:
.globl vector38
vector38:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $38
8010671f:	6a 26                	push   $0x26
  jmp alltraps
80106721:	e9 c9 f9 ff ff       	jmp    801060ef <alltraps>

80106726 <vector39>:
.globl vector39
vector39:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $39
80106728:	6a 27                	push   $0x27
  jmp alltraps
8010672a:	e9 c0 f9 ff ff       	jmp    801060ef <alltraps>

8010672f <vector40>:
.globl vector40
vector40:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $40
80106731:	6a 28                	push   $0x28
  jmp alltraps
80106733:	e9 b7 f9 ff ff       	jmp    801060ef <alltraps>

80106738 <vector41>:
.globl vector41
vector41:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $41
8010673a:	6a 29                	push   $0x29
  jmp alltraps
8010673c:	e9 ae f9 ff ff       	jmp    801060ef <alltraps>

80106741 <vector42>:
.globl vector42
vector42:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $42
80106743:	6a 2a                	push   $0x2a
  jmp alltraps
80106745:	e9 a5 f9 ff ff       	jmp    801060ef <alltraps>

8010674a <vector43>:
.globl vector43
vector43:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $43
8010674c:	6a 2b                	push   $0x2b
  jmp alltraps
8010674e:	e9 9c f9 ff ff       	jmp    801060ef <alltraps>

80106753 <vector44>:
.globl vector44
vector44:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $44
80106755:	6a 2c                	push   $0x2c
  jmp alltraps
80106757:	e9 93 f9 ff ff       	jmp    801060ef <alltraps>

8010675c <vector45>:
.globl vector45
vector45:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $45
8010675e:	6a 2d                	push   $0x2d
  jmp alltraps
80106760:	e9 8a f9 ff ff       	jmp    801060ef <alltraps>

80106765 <vector46>:
.globl vector46
vector46:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $46
80106767:	6a 2e                	push   $0x2e
  jmp alltraps
80106769:	e9 81 f9 ff ff       	jmp    801060ef <alltraps>

8010676e <vector47>:
.globl vector47
vector47:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $47
80106770:	6a 2f                	push   $0x2f
  jmp alltraps
80106772:	e9 78 f9 ff ff       	jmp    801060ef <alltraps>

80106777 <vector48>:
.globl vector48
vector48:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $48
80106779:	6a 30                	push   $0x30
  jmp alltraps
8010677b:	e9 6f f9 ff ff       	jmp    801060ef <alltraps>

80106780 <vector49>:
.globl vector49
vector49:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $49
80106782:	6a 31                	push   $0x31
  jmp alltraps
80106784:	e9 66 f9 ff ff       	jmp    801060ef <alltraps>

80106789 <vector50>:
.globl vector50
vector50:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $50
8010678b:	6a 32                	push   $0x32
  jmp alltraps
8010678d:	e9 5d f9 ff ff       	jmp    801060ef <alltraps>

80106792 <vector51>:
.globl vector51
vector51:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $51
80106794:	6a 33                	push   $0x33
  jmp alltraps
80106796:	e9 54 f9 ff ff       	jmp    801060ef <alltraps>

8010679b <vector52>:
.globl vector52
vector52:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $52
8010679d:	6a 34                	push   $0x34
  jmp alltraps
8010679f:	e9 4b f9 ff ff       	jmp    801060ef <alltraps>

801067a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $53
801067a6:	6a 35                	push   $0x35
  jmp alltraps
801067a8:	e9 42 f9 ff ff       	jmp    801060ef <alltraps>

801067ad <vector54>:
.globl vector54
vector54:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $54
801067af:	6a 36                	push   $0x36
  jmp alltraps
801067b1:	e9 39 f9 ff ff       	jmp    801060ef <alltraps>

801067b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $55
801067b8:	6a 37                	push   $0x37
  jmp alltraps
801067ba:	e9 30 f9 ff ff       	jmp    801060ef <alltraps>

801067bf <vector56>:
.globl vector56
vector56:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $56
801067c1:	6a 38                	push   $0x38
  jmp alltraps
801067c3:	e9 27 f9 ff ff       	jmp    801060ef <alltraps>

801067c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $57
801067ca:	6a 39                	push   $0x39
  jmp alltraps
801067cc:	e9 1e f9 ff ff       	jmp    801060ef <alltraps>

801067d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $58
801067d3:	6a 3a                	push   $0x3a
  jmp alltraps
801067d5:	e9 15 f9 ff ff       	jmp    801060ef <alltraps>

801067da <vector59>:
.globl vector59
vector59:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $59
801067dc:	6a 3b                	push   $0x3b
  jmp alltraps
801067de:	e9 0c f9 ff ff       	jmp    801060ef <alltraps>

801067e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $60
801067e5:	6a 3c                	push   $0x3c
  jmp alltraps
801067e7:	e9 03 f9 ff ff       	jmp    801060ef <alltraps>

801067ec <vector61>:
.globl vector61
vector61:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $61
801067ee:	6a 3d                	push   $0x3d
  jmp alltraps
801067f0:	e9 fa f8 ff ff       	jmp    801060ef <alltraps>

801067f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $62
801067f7:	6a 3e                	push   $0x3e
  jmp alltraps
801067f9:	e9 f1 f8 ff ff       	jmp    801060ef <alltraps>

801067fe <vector63>:
.globl vector63
vector63:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $63
80106800:	6a 3f                	push   $0x3f
  jmp alltraps
80106802:	e9 e8 f8 ff ff       	jmp    801060ef <alltraps>

80106807 <vector64>:
.globl vector64
vector64:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $64
80106809:	6a 40                	push   $0x40
  jmp alltraps
8010680b:	e9 df f8 ff ff       	jmp    801060ef <alltraps>

80106810 <vector65>:
.globl vector65
vector65:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $65
80106812:	6a 41                	push   $0x41
  jmp alltraps
80106814:	e9 d6 f8 ff ff       	jmp    801060ef <alltraps>

80106819 <vector66>:
.globl vector66
vector66:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $66
8010681b:	6a 42                	push   $0x42
  jmp alltraps
8010681d:	e9 cd f8 ff ff       	jmp    801060ef <alltraps>

80106822 <vector67>:
.globl vector67
vector67:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $67
80106824:	6a 43                	push   $0x43
  jmp alltraps
80106826:	e9 c4 f8 ff ff       	jmp    801060ef <alltraps>

8010682b <vector68>:
.globl vector68
vector68:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $68
8010682d:	6a 44                	push   $0x44
  jmp alltraps
8010682f:	e9 bb f8 ff ff       	jmp    801060ef <alltraps>

80106834 <vector69>:
.globl vector69
vector69:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $69
80106836:	6a 45                	push   $0x45
  jmp alltraps
80106838:	e9 b2 f8 ff ff       	jmp    801060ef <alltraps>

8010683d <vector70>:
.globl vector70
vector70:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $70
8010683f:	6a 46                	push   $0x46
  jmp alltraps
80106841:	e9 a9 f8 ff ff       	jmp    801060ef <alltraps>

80106846 <vector71>:
.globl vector71
vector71:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $71
80106848:	6a 47                	push   $0x47
  jmp alltraps
8010684a:	e9 a0 f8 ff ff       	jmp    801060ef <alltraps>

8010684f <vector72>:
.globl vector72
vector72:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $72
80106851:	6a 48                	push   $0x48
  jmp alltraps
80106853:	e9 97 f8 ff ff       	jmp    801060ef <alltraps>

80106858 <vector73>:
.globl vector73
vector73:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $73
8010685a:	6a 49                	push   $0x49
  jmp alltraps
8010685c:	e9 8e f8 ff ff       	jmp    801060ef <alltraps>

80106861 <vector74>:
.globl vector74
vector74:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $74
80106863:	6a 4a                	push   $0x4a
  jmp alltraps
80106865:	e9 85 f8 ff ff       	jmp    801060ef <alltraps>

8010686a <vector75>:
.globl vector75
vector75:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $75
8010686c:	6a 4b                	push   $0x4b
  jmp alltraps
8010686e:	e9 7c f8 ff ff       	jmp    801060ef <alltraps>

80106873 <vector76>:
.globl vector76
vector76:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $76
80106875:	6a 4c                	push   $0x4c
  jmp alltraps
80106877:	e9 73 f8 ff ff       	jmp    801060ef <alltraps>

8010687c <vector77>:
.globl vector77
vector77:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $77
8010687e:	6a 4d                	push   $0x4d
  jmp alltraps
80106880:	e9 6a f8 ff ff       	jmp    801060ef <alltraps>

80106885 <vector78>:
.globl vector78
vector78:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $78
80106887:	6a 4e                	push   $0x4e
  jmp alltraps
80106889:	e9 61 f8 ff ff       	jmp    801060ef <alltraps>

8010688e <vector79>:
.globl vector79
vector79:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $79
80106890:	6a 4f                	push   $0x4f
  jmp alltraps
80106892:	e9 58 f8 ff ff       	jmp    801060ef <alltraps>

80106897 <vector80>:
.globl vector80
vector80:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $80
80106899:	6a 50                	push   $0x50
  jmp alltraps
8010689b:	e9 4f f8 ff ff       	jmp    801060ef <alltraps>

801068a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $81
801068a2:	6a 51                	push   $0x51
  jmp alltraps
801068a4:	e9 46 f8 ff ff       	jmp    801060ef <alltraps>

801068a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $82
801068ab:	6a 52                	push   $0x52
  jmp alltraps
801068ad:	e9 3d f8 ff ff       	jmp    801060ef <alltraps>

801068b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $83
801068b4:	6a 53                	push   $0x53
  jmp alltraps
801068b6:	e9 34 f8 ff ff       	jmp    801060ef <alltraps>

801068bb <vector84>:
.globl vector84
vector84:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $84
801068bd:	6a 54                	push   $0x54
  jmp alltraps
801068bf:	e9 2b f8 ff ff       	jmp    801060ef <alltraps>

801068c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $85
801068c6:	6a 55                	push   $0x55
  jmp alltraps
801068c8:	e9 22 f8 ff ff       	jmp    801060ef <alltraps>

801068cd <vector86>:
.globl vector86
vector86:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $86
801068cf:	6a 56                	push   $0x56
  jmp alltraps
801068d1:	e9 19 f8 ff ff       	jmp    801060ef <alltraps>

801068d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $87
801068d8:	6a 57                	push   $0x57
  jmp alltraps
801068da:	e9 10 f8 ff ff       	jmp    801060ef <alltraps>

801068df <vector88>:
.globl vector88
vector88:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $88
801068e1:	6a 58                	push   $0x58
  jmp alltraps
801068e3:	e9 07 f8 ff ff       	jmp    801060ef <alltraps>

801068e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $89
801068ea:	6a 59                	push   $0x59
  jmp alltraps
801068ec:	e9 fe f7 ff ff       	jmp    801060ef <alltraps>

801068f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $90
801068f3:	6a 5a                	push   $0x5a
  jmp alltraps
801068f5:	e9 f5 f7 ff ff       	jmp    801060ef <alltraps>

801068fa <vector91>:
.globl vector91
vector91:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $91
801068fc:	6a 5b                	push   $0x5b
  jmp alltraps
801068fe:	e9 ec f7 ff ff       	jmp    801060ef <alltraps>

80106903 <vector92>:
.globl vector92
vector92:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $92
80106905:	6a 5c                	push   $0x5c
  jmp alltraps
80106907:	e9 e3 f7 ff ff       	jmp    801060ef <alltraps>

8010690c <vector93>:
.globl vector93
vector93:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $93
8010690e:	6a 5d                	push   $0x5d
  jmp alltraps
80106910:	e9 da f7 ff ff       	jmp    801060ef <alltraps>

80106915 <vector94>:
.globl vector94
vector94:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $94
80106917:	6a 5e                	push   $0x5e
  jmp alltraps
80106919:	e9 d1 f7 ff ff       	jmp    801060ef <alltraps>

8010691e <vector95>:
.globl vector95
vector95:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $95
80106920:	6a 5f                	push   $0x5f
  jmp alltraps
80106922:	e9 c8 f7 ff ff       	jmp    801060ef <alltraps>

80106927 <vector96>:
.globl vector96
vector96:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $96
80106929:	6a 60                	push   $0x60
  jmp alltraps
8010692b:	e9 bf f7 ff ff       	jmp    801060ef <alltraps>

80106930 <vector97>:
.globl vector97
vector97:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $97
80106932:	6a 61                	push   $0x61
  jmp alltraps
80106934:	e9 b6 f7 ff ff       	jmp    801060ef <alltraps>

80106939 <vector98>:
.globl vector98
vector98:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $98
8010693b:	6a 62                	push   $0x62
  jmp alltraps
8010693d:	e9 ad f7 ff ff       	jmp    801060ef <alltraps>

80106942 <vector99>:
.globl vector99
vector99:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $99
80106944:	6a 63                	push   $0x63
  jmp alltraps
80106946:	e9 a4 f7 ff ff       	jmp    801060ef <alltraps>

8010694b <vector100>:
.globl vector100
vector100:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $100
8010694d:	6a 64                	push   $0x64
  jmp alltraps
8010694f:	e9 9b f7 ff ff       	jmp    801060ef <alltraps>

80106954 <vector101>:
.globl vector101
vector101:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $101
80106956:	6a 65                	push   $0x65
  jmp alltraps
80106958:	e9 92 f7 ff ff       	jmp    801060ef <alltraps>

8010695d <vector102>:
.globl vector102
vector102:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $102
8010695f:	6a 66                	push   $0x66
  jmp alltraps
80106961:	e9 89 f7 ff ff       	jmp    801060ef <alltraps>

80106966 <vector103>:
.globl vector103
vector103:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $103
80106968:	6a 67                	push   $0x67
  jmp alltraps
8010696a:	e9 80 f7 ff ff       	jmp    801060ef <alltraps>

8010696f <vector104>:
.globl vector104
vector104:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $104
80106971:	6a 68                	push   $0x68
  jmp alltraps
80106973:	e9 77 f7 ff ff       	jmp    801060ef <alltraps>

80106978 <vector105>:
.globl vector105
vector105:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $105
8010697a:	6a 69                	push   $0x69
  jmp alltraps
8010697c:	e9 6e f7 ff ff       	jmp    801060ef <alltraps>

80106981 <vector106>:
.globl vector106
vector106:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $106
80106983:	6a 6a                	push   $0x6a
  jmp alltraps
80106985:	e9 65 f7 ff ff       	jmp    801060ef <alltraps>

8010698a <vector107>:
.globl vector107
vector107:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $107
8010698c:	6a 6b                	push   $0x6b
  jmp alltraps
8010698e:	e9 5c f7 ff ff       	jmp    801060ef <alltraps>

80106993 <vector108>:
.globl vector108
vector108:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $108
80106995:	6a 6c                	push   $0x6c
  jmp alltraps
80106997:	e9 53 f7 ff ff       	jmp    801060ef <alltraps>

8010699c <vector109>:
.globl vector109
vector109:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $109
8010699e:	6a 6d                	push   $0x6d
  jmp alltraps
801069a0:	e9 4a f7 ff ff       	jmp    801060ef <alltraps>

801069a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $110
801069a7:	6a 6e                	push   $0x6e
  jmp alltraps
801069a9:	e9 41 f7 ff ff       	jmp    801060ef <alltraps>

801069ae <vector111>:
.globl vector111
vector111:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $111
801069b0:	6a 6f                	push   $0x6f
  jmp alltraps
801069b2:	e9 38 f7 ff ff       	jmp    801060ef <alltraps>

801069b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $112
801069b9:	6a 70                	push   $0x70
  jmp alltraps
801069bb:	e9 2f f7 ff ff       	jmp    801060ef <alltraps>

801069c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $113
801069c2:	6a 71                	push   $0x71
  jmp alltraps
801069c4:	e9 26 f7 ff ff       	jmp    801060ef <alltraps>

801069c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $114
801069cb:	6a 72                	push   $0x72
  jmp alltraps
801069cd:	e9 1d f7 ff ff       	jmp    801060ef <alltraps>

801069d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $115
801069d4:	6a 73                	push   $0x73
  jmp alltraps
801069d6:	e9 14 f7 ff ff       	jmp    801060ef <alltraps>

801069db <vector116>:
.globl vector116
vector116:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $116
801069dd:	6a 74                	push   $0x74
  jmp alltraps
801069df:	e9 0b f7 ff ff       	jmp    801060ef <alltraps>

801069e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $117
801069e6:	6a 75                	push   $0x75
  jmp alltraps
801069e8:	e9 02 f7 ff ff       	jmp    801060ef <alltraps>

801069ed <vector118>:
.globl vector118
vector118:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $118
801069ef:	6a 76                	push   $0x76
  jmp alltraps
801069f1:	e9 f9 f6 ff ff       	jmp    801060ef <alltraps>

801069f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $119
801069f8:	6a 77                	push   $0x77
  jmp alltraps
801069fa:	e9 f0 f6 ff ff       	jmp    801060ef <alltraps>

801069ff <vector120>:
.globl vector120
vector120:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $120
80106a01:	6a 78                	push   $0x78
  jmp alltraps
80106a03:	e9 e7 f6 ff ff       	jmp    801060ef <alltraps>

80106a08 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $121
80106a0a:	6a 79                	push   $0x79
  jmp alltraps
80106a0c:	e9 de f6 ff ff       	jmp    801060ef <alltraps>

80106a11 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $122
80106a13:	6a 7a                	push   $0x7a
  jmp alltraps
80106a15:	e9 d5 f6 ff ff       	jmp    801060ef <alltraps>

80106a1a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $123
80106a1c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a1e:	e9 cc f6 ff ff       	jmp    801060ef <alltraps>

80106a23 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $124
80106a25:	6a 7c                	push   $0x7c
  jmp alltraps
80106a27:	e9 c3 f6 ff ff       	jmp    801060ef <alltraps>

80106a2c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $125
80106a2e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a30:	e9 ba f6 ff ff       	jmp    801060ef <alltraps>

80106a35 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $126
80106a37:	6a 7e                	push   $0x7e
  jmp alltraps
80106a39:	e9 b1 f6 ff ff       	jmp    801060ef <alltraps>

80106a3e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $127
80106a40:	6a 7f                	push   $0x7f
  jmp alltraps
80106a42:	e9 a8 f6 ff ff       	jmp    801060ef <alltraps>

80106a47 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $128
80106a49:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a4e:	e9 9c f6 ff ff       	jmp    801060ef <alltraps>

80106a53 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $129
80106a55:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a5a:	e9 90 f6 ff ff       	jmp    801060ef <alltraps>

80106a5f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $130
80106a61:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a66:	e9 84 f6 ff ff       	jmp    801060ef <alltraps>

80106a6b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $131
80106a6d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a72:	e9 78 f6 ff ff       	jmp    801060ef <alltraps>

80106a77 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $132
80106a79:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a7e:	e9 6c f6 ff ff       	jmp    801060ef <alltraps>

80106a83 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $133
80106a85:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a8a:	e9 60 f6 ff ff       	jmp    801060ef <alltraps>

80106a8f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $134
80106a91:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a96:	e9 54 f6 ff ff       	jmp    801060ef <alltraps>

80106a9b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $135
80106a9d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106aa2:	e9 48 f6 ff ff       	jmp    801060ef <alltraps>

80106aa7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $136
80106aa9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106aae:	e9 3c f6 ff ff       	jmp    801060ef <alltraps>

80106ab3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $137
80106ab5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aba:	e9 30 f6 ff ff       	jmp    801060ef <alltraps>

80106abf <vector138>:
.globl vector138
vector138:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $138
80106ac1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ac6:	e9 24 f6 ff ff       	jmp    801060ef <alltraps>

80106acb <vector139>:
.globl vector139
vector139:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $139
80106acd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ad2:	e9 18 f6 ff ff       	jmp    801060ef <alltraps>

80106ad7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $140
80106ad9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ade:	e9 0c f6 ff ff       	jmp    801060ef <alltraps>

80106ae3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $141
80106ae5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106aea:	e9 00 f6 ff ff       	jmp    801060ef <alltraps>

80106aef <vector142>:
.globl vector142
vector142:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $142
80106af1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106af6:	e9 f4 f5 ff ff       	jmp    801060ef <alltraps>

80106afb <vector143>:
.globl vector143
vector143:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $143
80106afd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b02:	e9 e8 f5 ff ff       	jmp    801060ef <alltraps>

80106b07 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $144
80106b09:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b0e:	e9 dc f5 ff ff       	jmp    801060ef <alltraps>

80106b13 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $145
80106b15:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b1a:	e9 d0 f5 ff ff       	jmp    801060ef <alltraps>

80106b1f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $146
80106b21:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b26:	e9 c4 f5 ff ff       	jmp    801060ef <alltraps>

80106b2b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $147
80106b2d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b32:	e9 b8 f5 ff ff       	jmp    801060ef <alltraps>

80106b37 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $148
80106b39:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b3e:	e9 ac f5 ff ff       	jmp    801060ef <alltraps>

80106b43 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $149
80106b45:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b4a:	e9 a0 f5 ff ff       	jmp    801060ef <alltraps>

80106b4f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $150
80106b51:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b56:	e9 94 f5 ff ff       	jmp    801060ef <alltraps>

80106b5b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $151
80106b5d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b62:	e9 88 f5 ff ff       	jmp    801060ef <alltraps>

80106b67 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $152
80106b69:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b6e:	e9 7c f5 ff ff       	jmp    801060ef <alltraps>

80106b73 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $153
80106b75:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b7a:	e9 70 f5 ff ff       	jmp    801060ef <alltraps>

80106b7f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $154
80106b81:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b86:	e9 64 f5 ff ff       	jmp    801060ef <alltraps>

80106b8b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $155
80106b8d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b92:	e9 58 f5 ff ff       	jmp    801060ef <alltraps>

80106b97 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $156
80106b99:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b9e:	e9 4c f5 ff ff       	jmp    801060ef <alltraps>

80106ba3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $157
80106ba5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106baa:	e9 40 f5 ff ff       	jmp    801060ef <alltraps>

80106baf <vector158>:
.globl vector158
vector158:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $158
80106bb1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bb6:	e9 34 f5 ff ff       	jmp    801060ef <alltraps>

80106bbb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $159
80106bbd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bc2:	e9 28 f5 ff ff       	jmp    801060ef <alltraps>

80106bc7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $160
80106bc9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bce:	e9 1c f5 ff ff       	jmp    801060ef <alltraps>

80106bd3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $161
80106bd5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bda:	e9 10 f5 ff ff       	jmp    801060ef <alltraps>

80106bdf <vector162>:
.globl vector162
vector162:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $162
80106be1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106be6:	e9 04 f5 ff ff       	jmp    801060ef <alltraps>

80106beb <vector163>:
.globl vector163
vector163:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $163
80106bed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bf2:	e9 f8 f4 ff ff       	jmp    801060ef <alltraps>

80106bf7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $164
80106bf9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bfe:	e9 ec f4 ff ff       	jmp    801060ef <alltraps>

80106c03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $165
80106c05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c0a:	e9 e0 f4 ff ff       	jmp    801060ef <alltraps>

80106c0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $166
80106c11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c16:	e9 d4 f4 ff ff       	jmp    801060ef <alltraps>

80106c1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $167
80106c1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c22:	e9 c8 f4 ff ff       	jmp    801060ef <alltraps>

80106c27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $168
80106c29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c2e:	e9 bc f4 ff ff       	jmp    801060ef <alltraps>

80106c33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $169
80106c35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c3a:	e9 b0 f4 ff ff       	jmp    801060ef <alltraps>

80106c3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $170
80106c41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c46:	e9 a4 f4 ff ff       	jmp    801060ef <alltraps>

80106c4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $171
80106c4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c52:	e9 98 f4 ff ff       	jmp    801060ef <alltraps>

80106c57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $172
80106c59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c5e:	e9 8c f4 ff ff       	jmp    801060ef <alltraps>

80106c63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $173
80106c65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c6a:	e9 80 f4 ff ff       	jmp    801060ef <alltraps>

80106c6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $174
80106c71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c76:	e9 74 f4 ff ff       	jmp    801060ef <alltraps>

80106c7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $175
80106c7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c82:	e9 68 f4 ff ff       	jmp    801060ef <alltraps>

80106c87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $176
80106c89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c8e:	e9 5c f4 ff ff       	jmp    801060ef <alltraps>

80106c93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $177
80106c95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c9a:	e9 50 f4 ff ff       	jmp    801060ef <alltraps>

80106c9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $178
80106ca1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ca6:	e9 44 f4 ff ff       	jmp    801060ef <alltraps>

80106cab <vector179>:
.globl vector179
vector179:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $179
80106cad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cb2:	e9 38 f4 ff ff       	jmp    801060ef <alltraps>

80106cb7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $180
80106cb9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cbe:	e9 2c f4 ff ff       	jmp    801060ef <alltraps>

80106cc3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $181
80106cc5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cca:	e9 20 f4 ff ff       	jmp    801060ef <alltraps>

80106ccf <vector182>:
.globl vector182
vector182:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $182
80106cd1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cd6:	e9 14 f4 ff ff       	jmp    801060ef <alltraps>

80106cdb <vector183>:
.globl vector183
vector183:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $183
80106cdd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ce2:	e9 08 f4 ff ff       	jmp    801060ef <alltraps>

80106ce7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $184
80106ce9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cee:	e9 fc f3 ff ff       	jmp    801060ef <alltraps>

80106cf3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $185
80106cf5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cfa:	e9 f0 f3 ff ff       	jmp    801060ef <alltraps>

80106cff <vector186>:
.globl vector186
vector186:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $186
80106d01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d06:	e9 e4 f3 ff ff       	jmp    801060ef <alltraps>

80106d0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $187
80106d0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d12:	e9 d8 f3 ff ff       	jmp    801060ef <alltraps>

80106d17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $188
80106d19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d1e:	e9 cc f3 ff ff       	jmp    801060ef <alltraps>

80106d23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $189
80106d25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d2a:	e9 c0 f3 ff ff       	jmp    801060ef <alltraps>

80106d2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $190
80106d31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d36:	e9 b4 f3 ff ff       	jmp    801060ef <alltraps>

80106d3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $191
80106d3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d42:	e9 a8 f3 ff ff       	jmp    801060ef <alltraps>

80106d47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $192
80106d49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d4e:	e9 9c f3 ff ff       	jmp    801060ef <alltraps>

80106d53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $193
80106d55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d5a:	e9 90 f3 ff ff       	jmp    801060ef <alltraps>

80106d5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $194
80106d61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d66:	e9 84 f3 ff ff       	jmp    801060ef <alltraps>

80106d6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $195
80106d6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d72:	e9 78 f3 ff ff       	jmp    801060ef <alltraps>

80106d77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $196
80106d79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d7e:	e9 6c f3 ff ff       	jmp    801060ef <alltraps>

80106d83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $197
80106d85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d8a:	e9 60 f3 ff ff       	jmp    801060ef <alltraps>

80106d8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $198
80106d91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d96:	e9 54 f3 ff ff       	jmp    801060ef <alltraps>

80106d9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $199
80106d9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106da2:	e9 48 f3 ff ff       	jmp    801060ef <alltraps>

80106da7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $200
80106da9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dae:	e9 3c f3 ff ff       	jmp    801060ef <alltraps>

80106db3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $201
80106db5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dba:	e9 30 f3 ff ff       	jmp    801060ef <alltraps>

80106dbf <vector202>:
.globl vector202
vector202:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $202
80106dc1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dc6:	e9 24 f3 ff ff       	jmp    801060ef <alltraps>

80106dcb <vector203>:
.globl vector203
vector203:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $203
80106dcd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dd2:	e9 18 f3 ff ff       	jmp    801060ef <alltraps>

80106dd7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $204
80106dd9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dde:	e9 0c f3 ff ff       	jmp    801060ef <alltraps>

80106de3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $205
80106de5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dea:	e9 00 f3 ff ff       	jmp    801060ef <alltraps>

80106def <vector206>:
.globl vector206
vector206:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $206
80106df1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106df6:	e9 f4 f2 ff ff       	jmp    801060ef <alltraps>

80106dfb <vector207>:
.globl vector207
vector207:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $207
80106dfd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e02:	e9 e8 f2 ff ff       	jmp    801060ef <alltraps>

80106e07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $208
80106e09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e0e:	e9 dc f2 ff ff       	jmp    801060ef <alltraps>

80106e13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $209
80106e15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e1a:	e9 d0 f2 ff ff       	jmp    801060ef <alltraps>

80106e1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $210
80106e21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e26:	e9 c4 f2 ff ff       	jmp    801060ef <alltraps>

80106e2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $211
80106e2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e32:	e9 b8 f2 ff ff       	jmp    801060ef <alltraps>

80106e37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $212
80106e39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e3e:	e9 ac f2 ff ff       	jmp    801060ef <alltraps>

80106e43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $213
80106e45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e4a:	e9 a0 f2 ff ff       	jmp    801060ef <alltraps>

80106e4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $214
80106e51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e56:	e9 94 f2 ff ff       	jmp    801060ef <alltraps>

80106e5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $215
80106e5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e62:	e9 88 f2 ff ff       	jmp    801060ef <alltraps>

80106e67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $216
80106e69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e6e:	e9 7c f2 ff ff       	jmp    801060ef <alltraps>

80106e73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $217
80106e75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e7a:	e9 70 f2 ff ff       	jmp    801060ef <alltraps>

80106e7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $218
80106e81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e86:	e9 64 f2 ff ff       	jmp    801060ef <alltraps>

80106e8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $219
80106e8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e92:	e9 58 f2 ff ff       	jmp    801060ef <alltraps>

80106e97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $220
80106e99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e9e:	e9 4c f2 ff ff       	jmp    801060ef <alltraps>

80106ea3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $221
80106ea5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eaa:	e9 40 f2 ff ff       	jmp    801060ef <alltraps>

80106eaf <vector222>:
.globl vector222
vector222:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $222
80106eb1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eb6:	e9 34 f2 ff ff       	jmp    801060ef <alltraps>

80106ebb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $223
80106ebd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ec2:	e9 28 f2 ff ff       	jmp    801060ef <alltraps>

80106ec7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $224
80106ec9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ece:	e9 1c f2 ff ff       	jmp    801060ef <alltraps>

80106ed3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $225
80106ed5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eda:	e9 10 f2 ff ff       	jmp    801060ef <alltraps>

80106edf <vector226>:
.globl vector226
vector226:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $226
80106ee1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ee6:	e9 04 f2 ff ff       	jmp    801060ef <alltraps>

80106eeb <vector227>:
.globl vector227
vector227:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $227
80106eed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ef2:	e9 f8 f1 ff ff       	jmp    801060ef <alltraps>

80106ef7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $228
80106ef9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106efe:	e9 ec f1 ff ff       	jmp    801060ef <alltraps>

80106f03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $229
80106f05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f0a:	e9 e0 f1 ff ff       	jmp    801060ef <alltraps>

80106f0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $230
80106f11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f16:	e9 d4 f1 ff ff       	jmp    801060ef <alltraps>

80106f1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $231
80106f1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f22:	e9 c8 f1 ff ff       	jmp    801060ef <alltraps>

80106f27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $232
80106f29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f2e:	e9 bc f1 ff ff       	jmp    801060ef <alltraps>

80106f33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $233
80106f35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f3a:	e9 b0 f1 ff ff       	jmp    801060ef <alltraps>

80106f3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $234
80106f41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f46:	e9 a4 f1 ff ff       	jmp    801060ef <alltraps>

80106f4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $235
80106f4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f52:	e9 98 f1 ff ff       	jmp    801060ef <alltraps>

80106f57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $236
80106f59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f5e:	e9 8c f1 ff ff       	jmp    801060ef <alltraps>

80106f63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $237
80106f65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f6a:	e9 80 f1 ff ff       	jmp    801060ef <alltraps>

80106f6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $238
80106f71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f76:	e9 74 f1 ff ff       	jmp    801060ef <alltraps>

80106f7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $239
80106f7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f82:	e9 68 f1 ff ff       	jmp    801060ef <alltraps>

80106f87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $240
80106f89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f8e:	e9 5c f1 ff ff       	jmp    801060ef <alltraps>

80106f93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $241
80106f95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f9a:	e9 50 f1 ff ff       	jmp    801060ef <alltraps>

80106f9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $242
80106fa1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fa6:	e9 44 f1 ff ff       	jmp    801060ef <alltraps>

80106fab <vector243>:
.globl vector243
vector243:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $243
80106fad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fb2:	e9 38 f1 ff ff       	jmp    801060ef <alltraps>

80106fb7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $244
80106fb9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fbe:	e9 2c f1 ff ff       	jmp    801060ef <alltraps>

80106fc3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $245
80106fc5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fca:	e9 20 f1 ff ff       	jmp    801060ef <alltraps>

80106fcf <vector246>:
.globl vector246
vector246:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $246
80106fd1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fd6:	e9 14 f1 ff ff       	jmp    801060ef <alltraps>

80106fdb <vector247>:
.globl vector247
vector247:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $247
80106fdd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fe2:	e9 08 f1 ff ff       	jmp    801060ef <alltraps>

80106fe7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $248
80106fe9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fee:	e9 fc f0 ff ff       	jmp    801060ef <alltraps>

80106ff3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $249
80106ff5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ffa:	e9 f0 f0 ff ff       	jmp    801060ef <alltraps>

80106fff <vector250>:
.globl vector250
vector250:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $250
80107001:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107006:	e9 e4 f0 ff ff       	jmp    801060ef <alltraps>

8010700b <vector251>:
.globl vector251
vector251:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $251
8010700d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107012:	e9 d8 f0 ff ff       	jmp    801060ef <alltraps>

80107017 <vector252>:
.globl vector252
vector252:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $252
80107019:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010701e:	e9 cc f0 ff ff       	jmp    801060ef <alltraps>

80107023 <vector253>:
.globl vector253
vector253:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $253
80107025:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010702a:	e9 c0 f0 ff ff       	jmp    801060ef <alltraps>

8010702f <vector254>:
.globl vector254
vector254:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $254
80107031:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107036:	e9 b4 f0 ff ff       	jmp    801060ef <alltraps>

8010703b <vector255>:
.globl vector255
vector255:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $255
8010703d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107042:	e9 a8 f0 ff ff       	jmp    801060ef <alltraps>
80107047:	66 90                	xchg   %ax,%ax
80107049:	66 90                	xchg   %ax,%ax
8010704b:	66 90                	xchg   %ax,%ax
8010704d:	66 90                	xchg   %ax,%ax
8010704f:	90                   	nop

80107050 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107056:	89 d3                	mov    %edx,%ebx
{
80107058:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010705a:	c1 eb 16             	shr    $0x16,%ebx
8010705d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107060:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107063:	8b 06                	mov    (%esi),%eax
80107065:	a8 01                	test   $0x1,%al
80107067:	74 27                	je     80107090 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107069:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010706e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107074:	c1 ef 0a             	shr    $0xa,%edi
}
80107077:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010707a:	89 fa                	mov    %edi,%edx
8010707c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107082:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107085:	5b                   	pop    %ebx
80107086:	5e                   	pop    %esi
80107087:	5f                   	pop    %edi
80107088:	5d                   	pop    %ebp
80107089:	c3                   	ret    
8010708a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107090:	85 c9                	test   %ecx,%ecx
80107092:	74 2c                	je     801070c0 <walkpgdir+0x70>
80107094:	e8 57 b4 ff ff       	call   801024f0 <kalloc>
80107099:	85 c0                	test   %eax,%eax
8010709b:	89 c3                	mov    %eax,%ebx
8010709d:	74 21                	je     801070c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010709f:	83 ec 04             	sub    $0x4,%esp
801070a2:	68 00 10 00 00       	push   $0x1000
801070a7:	6a 00                	push   $0x0
801070a9:	50                   	push   %eax
801070aa:	e8 61 db ff ff       	call   80104c10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070b5:	83 c4 10             	add    $0x10,%esp
801070b8:	83 c8 07             	or     $0x7,%eax
801070bb:	89 06                	mov    %eax,(%esi)
801070bd:	eb b5                	jmp    80107074 <walkpgdir+0x24>
801070bf:	90                   	nop
}
801070c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070c3:	31 c0                	xor    %eax,%eax
}
801070c5:	5b                   	pop    %ebx
801070c6:	5e                   	pop    %esi
801070c7:	5f                   	pop    %edi
801070c8:	5d                   	pop    %ebp
801070c9:	c3                   	ret    
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801070d6:	89 d3                	mov    %edx,%ebx
801070d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801070de:	83 ec 1c             	sub    $0x1c,%esp
801070e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801070e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801070f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070f6:	29 df                	sub    %ebx,%edi
801070f8:	83 c8 01             	or     $0x1,%eax
801070fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070fe:	eb 15                	jmp    80107115 <mappages+0x45>
    if(*pte & PTE_P)
80107100:	f6 00 01             	testb  $0x1,(%eax)
80107103:	75 45                	jne    8010714a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107105:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107108:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010710b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010710d:	74 31                	je     80107140 <mappages+0x70>
      break;
    a += PGSIZE;
8010710f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107115:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107118:	b9 01 00 00 00       	mov    $0x1,%ecx
8010711d:	89 da                	mov    %ebx,%edx
8010711f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107122:	e8 29 ff ff ff       	call   80107050 <walkpgdir>
80107127:	85 c0                	test   %eax,%eax
80107129:	75 d5                	jne    80107100 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010712b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010712e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107133:	5b                   	pop    %ebx
80107134:	5e                   	pop    %esi
80107135:	5f                   	pop    %edi
80107136:	5d                   	pop    %ebp
80107137:	c3                   	ret    
80107138:	90                   	nop
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107143:	31 c0                	xor    %eax,%eax
}
80107145:	5b                   	pop    %ebx
80107146:	5e                   	pop    %esi
80107147:	5f                   	pop    %edi
80107148:	5d                   	pop    %ebp
80107149:	c3                   	ret    
      panic("remap");
8010714a:	83 ec 0c             	sub    $0xc,%esp
8010714d:	68 d8 83 10 80       	push   $0x801083d8
80107152:	e8 39 92 ff ff       	call   80100390 <panic>
80107157:	89 f6                	mov    %esi,%esi
80107159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107160 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107166:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010716c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010716e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107174:	83 ec 1c             	sub    $0x1c,%esp
80107177:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010717a:	39 d3                	cmp    %edx,%ebx
8010717c:	73 66                	jae    801071e4 <deallocuvm.part.0+0x84>
8010717e:	89 d6                	mov    %edx,%esi
80107180:	eb 3d                	jmp    801071bf <deallocuvm.part.0+0x5f>
80107182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107188:	8b 10                	mov    (%eax),%edx
8010718a:	f6 c2 01             	test   $0x1,%dl
8010718d:	74 26                	je     801071b5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010718f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107195:	74 58                	je     801071ef <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107197:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010719a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801071a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801071a3:	52                   	push   %edx
801071a4:	e8 97 b1 ff ff       	call   80102340 <kfree>
      *pte = 0;
801071a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ac:	83 c4 10             	add    $0x10,%esp
801071af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801071b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071bb:	39 f3                	cmp    %esi,%ebx
801071bd:	73 25                	jae    801071e4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071bf:	31 c9                	xor    %ecx,%ecx
801071c1:	89 da                	mov    %ebx,%edx
801071c3:	89 f8                	mov    %edi,%eax
801071c5:	e8 86 fe ff ff       	call   80107050 <walkpgdir>
    if(!pte)
801071ca:	85 c0                	test   %eax,%eax
801071cc:	75 ba                	jne    80107188 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071ce:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801071d4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801071da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071e0:	39 f3                	cmp    %esi,%ebx
801071e2:	72 db                	jb     801071bf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801071e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ea:	5b                   	pop    %ebx
801071eb:	5e                   	pop    %esi
801071ec:	5f                   	pop    %edi
801071ed:	5d                   	pop    %ebp
801071ee:	c3                   	ret    
        panic("kfree");
801071ef:	83 ec 0c             	sub    $0xc,%esp
801071f2:	68 e6 7b 10 80       	push   $0x80107be6
801071f7:	e8 94 91 ff ff       	call   80100390 <panic>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107200 <seginit>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107206:	e8 45 c6 ff ff       	call   80103850 <cpuid>
8010720b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107211:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107216:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010721a:	c7 80 98 88 11 80 ff 	movl   $0xffff,-0x7fee7768(%eax)
80107221:	ff 00 00 
80107224:	c7 80 9c 88 11 80 00 	movl   $0xcf9a00,-0x7fee7764(%eax)
8010722b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010722e:	c7 80 a0 88 11 80 ff 	movl   $0xffff,-0x7fee7760(%eax)
80107235:	ff 00 00 
80107238:	c7 80 a4 88 11 80 00 	movl   $0xcf9200,-0x7fee775c(%eax)
8010723f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107242:	c7 80 a8 88 11 80 ff 	movl   $0xffff,-0x7fee7758(%eax)
80107249:	ff 00 00 
8010724c:	c7 80 ac 88 11 80 00 	movl   $0xcffa00,-0x7fee7754(%eax)
80107253:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107256:	c7 80 b0 88 11 80 ff 	movl   $0xffff,-0x7fee7750(%eax)
8010725d:	ff 00 00 
80107260:	c7 80 b4 88 11 80 00 	movl   $0xcff200,-0x7fee774c(%eax)
80107267:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010726a:	05 90 88 11 80       	add    $0x80118890,%eax
  pd[1] = (uint)p;
8010726f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107273:	c1 e8 10             	shr    $0x10,%eax
80107276:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010727a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010727d:	0f 01 10             	lgdtl  (%eax)
}
80107280:	c9                   	leave  
80107281:	c3                   	ret    
80107282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107290:	a1 c4 e1 11 80       	mov    0x8011e1c4,%eax
{
80107295:	55                   	push   %ebp
80107296:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107298:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010729d:	0f 22 d8             	mov    %eax,%cr3
}
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret    
801072a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072b0 <switchuvm>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 1c             	sub    $0x1c,%esp
801072b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801072bc:	85 db                	test   %ebx,%ebx
801072be:	0f 84 cb 00 00 00    	je     8010738f <switchuvm+0xdf>
  if(p->kstack == 0)
801072c4:	8b 43 08             	mov    0x8(%ebx),%eax
801072c7:	85 c0                	test   %eax,%eax
801072c9:	0f 84 da 00 00 00    	je     801073a9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801072cf:	8b 43 04             	mov    0x4(%ebx),%eax
801072d2:	85 c0                	test   %eax,%eax
801072d4:	0f 84 c2 00 00 00    	je     8010739c <switchuvm+0xec>
  pushcli();
801072da:	e8 51 d7 ff ff       	call   80104a30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072df:	e8 ec c4 ff ff       	call   801037d0 <mycpu>
801072e4:	89 c6                	mov    %eax,%esi
801072e6:	e8 e5 c4 ff ff       	call   801037d0 <mycpu>
801072eb:	89 c7                	mov    %eax,%edi
801072ed:	e8 de c4 ff ff       	call   801037d0 <mycpu>
801072f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072f5:	83 c7 08             	add    $0x8,%edi
801072f8:	e8 d3 c4 ff ff       	call   801037d0 <mycpu>
801072fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107300:	83 c0 08             	add    $0x8,%eax
80107303:	ba 67 00 00 00       	mov    $0x67,%edx
80107308:	c1 e8 18             	shr    $0x18,%eax
8010730b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107312:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107319:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010731f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107324:	83 c1 08             	add    $0x8,%ecx
80107327:	c1 e9 10             	shr    $0x10,%ecx
8010732a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107330:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107335:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010733c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107341:	e8 8a c4 ff ff       	call   801037d0 <mycpu>
80107346:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010734d:	e8 7e c4 ff ff       	call   801037d0 <mycpu>
80107352:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107356:	8b 73 08             	mov    0x8(%ebx),%esi
80107359:	e8 72 c4 ff ff       	call   801037d0 <mycpu>
8010735e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107364:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107367:	e8 64 c4 ff ff       	call   801037d0 <mycpu>
8010736c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107370:	b8 28 00 00 00       	mov    $0x28,%eax
80107375:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107378:	8b 43 04             	mov    0x4(%ebx),%eax
8010737b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107380:	0f 22 d8             	mov    %eax,%cr3
}
80107383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107386:	5b                   	pop    %ebx
80107387:	5e                   	pop    %esi
80107388:	5f                   	pop    %edi
80107389:	5d                   	pop    %ebp
  popcli();
8010738a:	e9 e1 d6 ff ff       	jmp    80104a70 <popcli>
    panic("switchuvm: no process");
8010738f:	83 ec 0c             	sub    $0xc,%esp
80107392:	68 de 83 10 80       	push   $0x801083de
80107397:	e8 f4 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010739c:	83 ec 0c             	sub    $0xc,%esp
8010739f:	68 09 84 10 80       	push   $0x80108409
801073a4:	e8 e7 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073a9:	83 ec 0c             	sub    $0xc,%esp
801073ac:	68 f4 83 10 80       	push   $0x801083f4
801073b1:	e8 da 8f ff ff       	call   80100390 <panic>
801073b6:	8d 76 00             	lea    0x0(%esi),%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073c0 <inituvm>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 1c             	sub    $0x1c,%esp
801073c9:	8b 75 10             	mov    0x10(%ebp),%esi
801073cc:	8b 45 08             	mov    0x8(%ebp),%eax
801073cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801073d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801073d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073db:	77 49                	ja     80107426 <inituvm+0x66>
  mem = kalloc();
801073dd:	e8 0e b1 ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
801073e2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801073e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073e7:	68 00 10 00 00       	push   $0x1000
801073ec:	6a 00                	push   $0x0
801073ee:	50                   	push   %eax
801073ef:	e8 1c d8 ff ff       	call   80104c10 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073f4:	58                   	pop    %eax
801073f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107400:	5a                   	pop    %edx
80107401:	6a 06                	push   $0x6
80107403:	50                   	push   %eax
80107404:	31 d2                	xor    %edx,%edx
80107406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107409:	e8 c2 fc ff ff       	call   801070d0 <mappages>
  memmove(mem, init, sz);
8010740e:	89 75 10             	mov    %esi,0x10(%ebp)
80107411:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107414:	83 c4 10             	add    $0x10,%esp
80107417:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010741a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010741d:	5b                   	pop    %ebx
8010741e:	5e                   	pop    %esi
8010741f:	5f                   	pop    %edi
80107420:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107421:	e9 9a d8 ff ff       	jmp    80104cc0 <memmove>
    panic("inituvm: more than a page");
80107426:	83 ec 0c             	sub    $0xc,%esp
80107429:	68 1d 84 10 80       	push   $0x8010841d
8010742e:	e8 5d 8f ff ff       	call   80100390 <panic>
80107433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107440 <loaduvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107449:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107450:	0f 85 91 00 00 00    	jne    801074e7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107456:	8b 75 18             	mov    0x18(%ebp),%esi
80107459:	31 db                	xor    %ebx,%ebx
8010745b:	85 f6                	test   %esi,%esi
8010745d:	75 1a                	jne    80107479 <loaduvm+0x39>
8010745f:	eb 6f                	jmp    801074d0 <loaduvm+0x90>
80107461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107468:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010746e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107474:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107477:	76 57                	jbe    801074d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107479:	8b 55 0c             	mov    0xc(%ebp),%edx
8010747c:	8b 45 08             	mov    0x8(%ebp),%eax
8010747f:	31 c9                	xor    %ecx,%ecx
80107481:	01 da                	add    %ebx,%edx
80107483:	e8 c8 fb ff ff       	call   80107050 <walkpgdir>
80107488:	85 c0                	test   %eax,%eax
8010748a:	74 4e                	je     801074da <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010748c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010748e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107491:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107496:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010749b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074a1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074a4:	01 d9                	add    %ebx,%ecx
801074a6:	05 00 00 00 80       	add    $0x80000000,%eax
801074ab:	57                   	push   %edi
801074ac:	51                   	push   %ecx
801074ad:	50                   	push   %eax
801074ae:	ff 75 10             	pushl  0x10(%ebp)
801074b1:	e8 da a4 ff ff       	call   80101990 <readi>
801074b6:	83 c4 10             	add    $0x10,%esp
801074b9:	39 f8                	cmp    %edi,%eax
801074bb:	74 ab                	je     80107468 <loaduvm+0x28>
}
801074bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074d3:	31 c0                	xor    %eax,%eax
}
801074d5:	5b                   	pop    %ebx
801074d6:	5e                   	pop    %esi
801074d7:	5f                   	pop    %edi
801074d8:	5d                   	pop    %ebp
801074d9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074da:	83 ec 0c             	sub    $0xc,%esp
801074dd:	68 37 84 10 80       	push   $0x80108437
801074e2:	e8 a9 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801074e7:	83 ec 0c             	sub    $0xc,%esp
801074ea:	68 d8 84 10 80       	push   $0x801084d8
801074ef:	e8 9c 8e ff ff       	call   80100390 <panic>
801074f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107500 <allocuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107509:	8b 7d 10             	mov    0x10(%ebp),%edi
8010750c:	85 ff                	test   %edi,%edi
8010750e:	0f 88 8e 00 00 00    	js     801075a2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107514:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107517:	0f 82 93 00 00 00    	jb     801075b0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010751d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107520:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107526:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010752c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010752f:	0f 86 7e 00 00 00    	jbe    801075b3 <allocuvm+0xb3>
80107535:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107538:	8b 7d 08             	mov    0x8(%ebp),%edi
8010753b:	eb 42                	jmp    8010757f <allocuvm+0x7f>
8010753d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107540:	83 ec 04             	sub    $0x4,%esp
80107543:	68 00 10 00 00       	push   $0x1000
80107548:	6a 00                	push   $0x0
8010754a:	50                   	push   %eax
8010754b:	e8 c0 d6 ff ff       	call   80104c10 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107550:	58                   	pop    %eax
80107551:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107557:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010755c:	5a                   	pop    %edx
8010755d:	6a 06                	push   $0x6
8010755f:	50                   	push   %eax
80107560:	89 da                	mov    %ebx,%edx
80107562:	89 f8                	mov    %edi,%eax
80107564:	e8 67 fb ff ff       	call   801070d0 <mappages>
80107569:	83 c4 10             	add    $0x10,%esp
8010756c:	85 c0                	test   %eax,%eax
8010756e:	78 50                	js     801075c0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107570:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107576:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107579:	0f 86 81 00 00 00    	jbe    80107600 <allocuvm+0x100>
    mem = kalloc();
8010757f:	e8 6c af ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
80107584:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107586:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107588:	75 b6                	jne    80107540 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010758a:	83 ec 0c             	sub    $0xc,%esp
8010758d:	68 55 84 10 80       	push   $0x80108455
80107592:	e8 c9 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107597:	83 c4 10             	add    $0x10,%esp
8010759a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010759d:	39 45 10             	cmp    %eax,0x10(%ebp)
801075a0:	77 6e                	ja     80107610 <allocuvm+0x110>
}
801075a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801075a5:	31 ff                	xor    %edi,%edi
}
801075a7:	89 f8                	mov    %edi,%eax
801075a9:	5b                   	pop    %ebx
801075aa:	5e                   	pop    %esi
801075ab:	5f                   	pop    %edi
801075ac:	5d                   	pop    %ebp
801075ad:	c3                   	ret    
801075ae:	66 90                	xchg   %ax,%ax
    return oldsz;
801075b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801075b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b6:	89 f8                	mov    %edi,%eax
801075b8:	5b                   	pop    %ebx
801075b9:	5e                   	pop    %esi
801075ba:	5f                   	pop    %edi
801075bb:	5d                   	pop    %ebp
801075bc:	c3                   	ret    
801075bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075c0:	83 ec 0c             	sub    $0xc,%esp
801075c3:	68 6d 84 10 80       	push   $0x8010846d
801075c8:	e8 93 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801075cd:	83 c4 10             	add    $0x10,%esp
801075d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801075d3:	39 45 10             	cmp    %eax,0x10(%ebp)
801075d6:	76 0d                	jbe    801075e5 <allocuvm+0xe5>
801075d8:	89 c1                	mov    %eax,%ecx
801075da:	8b 55 10             	mov    0x10(%ebp),%edx
801075dd:	8b 45 08             	mov    0x8(%ebp),%eax
801075e0:	e8 7b fb ff ff       	call   80107160 <deallocuvm.part.0>
      kfree(mem);
801075e5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801075e8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801075ea:	56                   	push   %esi
801075eb:	e8 50 ad ff ff       	call   80102340 <kfree>
      return 0;
801075f0:	83 c4 10             	add    $0x10,%esp
}
801075f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f6:	89 f8                	mov    %edi,%eax
801075f8:	5b                   	pop    %ebx
801075f9:	5e                   	pop    %esi
801075fa:	5f                   	pop    %edi
801075fb:	5d                   	pop    %ebp
801075fc:	c3                   	ret    
801075fd:	8d 76 00             	lea    0x0(%esi),%esi
80107600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107603:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107606:	5b                   	pop    %ebx
80107607:	89 f8                	mov    %edi,%eax
80107609:	5e                   	pop    %esi
8010760a:	5f                   	pop    %edi
8010760b:	5d                   	pop    %ebp
8010760c:	c3                   	ret    
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
80107610:	89 c1                	mov    %eax,%ecx
80107612:	8b 55 10             	mov    0x10(%ebp),%edx
80107615:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107618:	31 ff                	xor    %edi,%edi
8010761a:	e8 41 fb ff ff       	call   80107160 <deallocuvm.part.0>
8010761f:	eb 92                	jmp    801075b3 <allocuvm+0xb3>
80107621:	eb 0d                	jmp    80107630 <deallocuvm>
80107623:	90                   	nop
80107624:	90                   	nop
80107625:	90                   	nop
80107626:	90                   	nop
80107627:	90                   	nop
80107628:	90                   	nop
80107629:	90                   	nop
8010762a:	90                   	nop
8010762b:	90                   	nop
8010762c:	90                   	nop
8010762d:	90                   	nop
8010762e:	90                   	nop
8010762f:	90                   	nop

80107630 <deallocuvm>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	8b 55 0c             	mov    0xc(%ebp),%edx
80107636:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107639:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010763c:	39 d1                	cmp    %edx,%ecx
8010763e:	73 10                	jae    80107650 <deallocuvm+0x20>
}
80107640:	5d                   	pop    %ebp
80107641:	e9 1a fb ff ff       	jmp    80107160 <deallocuvm.part.0>
80107646:	8d 76 00             	lea    0x0(%esi),%esi
80107649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107650:	89 d0                	mov    %edx,%eax
80107652:	5d                   	pop    %ebp
80107653:	c3                   	ret    
80107654:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010765a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107660 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 0c             	sub    $0xc,%esp
80107669:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010766c:	85 f6                	test   %esi,%esi
8010766e:	74 59                	je     801076c9 <freevm+0x69>
80107670:	31 c9                	xor    %ecx,%ecx
80107672:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107677:	89 f0                	mov    %esi,%eax
80107679:	e8 e2 fa ff ff       	call   80107160 <deallocuvm.part.0>
8010767e:	89 f3                	mov    %esi,%ebx
80107680:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107686:	eb 0f                	jmp    80107697 <freevm+0x37>
80107688:	90                   	nop
80107689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107690:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107693:	39 fb                	cmp    %edi,%ebx
80107695:	74 23                	je     801076ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107697:	8b 03                	mov    (%ebx),%eax
80107699:	a8 01                	test   $0x1,%al
8010769b:	74 f3                	je     80107690 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010769d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076a2:	83 ec 0c             	sub    $0xc,%esp
801076a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076ad:	50                   	push   %eax
801076ae:	e8 8d ac ff ff       	call   80102340 <kfree>
801076b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076b6:	39 fb                	cmp    %edi,%ebx
801076b8:	75 dd                	jne    80107697 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c0:	5b                   	pop    %ebx
801076c1:	5e                   	pop    %esi
801076c2:	5f                   	pop    %edi
801076c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076c4:	e9 77 ac ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
801076c9:	83 ec 0c             	sub    $0xc,%esp
801076cc:	68 89 84 10 80       	push   $0x80108489
801076d1:	e8 ba 8c ff ff       	call   80100390 <panic>
801076d6:	8d 76 00             	lea    0x0(%esi),%esi
801076d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076e0 <setupkvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	56                   	push   %esi
801076e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076e5:	e8 06 ae ff ff       	call   801024f0 <kalloc>
801076ea:	85 c0                	test   %eax,%eax
801076ec:	89 c6                	mov    %eax,%esi
801076ee:	74 42                	je     80107732 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801076f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076f3:	bb a0 b4 10 80       	mov    $0x8010b4a0,%ebx
  memset(pgdir, 0, PGSIZE);
801076f8:	68 00 10 00 00       	push   $0x1000
801076fd:	6a 00                	push   $0x0
801076ff:	50                   	push   %eax
80107700:	e8 0b d5 ff ff       	call   80104c10 <memset>
80107705:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107708:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010770b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010770e:	83 ec 08             	sub    $0x8,%esp
80107711:	8b 13                	mov    (%ebx),%edx
80107713:	ff 73 0c             	pushl  0xc(%ebx)
80107716:	50                   	push   %eax
80107717:	29 c1                	sub    %eax,%ecx
80107719:	89 f0                	mov    %esi,%eax
8010771b:	e8 b0 f9 ff ff       	call   801070d0 <mappages>
80107720:	83 c4 10             	add    $0x10,%esp
80107723:	85 c0                	test   %eax,%eax
80107725:	78 19                	js     80107740 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107727:	83 c3 10             	add    $0x10,%ebx
8010772a:	81 fb e0 b4 10 80    	cmp    $0x8010b4e0,%ebx
80107730:	75 d6                	jne    80107708 <setupkvm+0x28>
}
80107732:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107735:	89 f0                	mov    %esi,%eax
80107737:	5b                   	pop    %ebx
80107738:	5e                   	pop    %esi
80107739:	5d                   	pop    %ebp
8010773a:	c3                   	ret    
8010773b:	90                   	nop
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107740:	83 ec 0c             	sub    $0xc,%esp
80107743:	56                   	push   %esi
      return 0;
80107744:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107746:	e8 15 ff ff ff       	call   80107660 <freevm>
      return 0;
8010774b:	83 c4 10             	add    $0x10,%esp
}
8010774e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107751:	89 f0                	mov    %esi,%eax
80107753:	5b                   	pop    %ebx
80107754:	5e                   	pop    %esi
80107755:	5d                   	pop    %ebp
80107756:	c3                   	ret    
80107757:	89 f6                	mov    %esi,%esi
80107759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107760 <kvmalloc>:
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107766:	e8 75 ff ff ff       	call   801076e0 <setupkvm>
8010776b:	a3 c4 e1 11 80       	mov    %eax,0x8011e1c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107770:	05 00 00 00 80       	add    $0x80000000,%eax
80107775:	0f 22 d8             	mov    %eax,%cr3
}
80107778:	c9                   	leave  
80107779:	c3                   	ret    
8010777a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107780 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107780:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107781:	31 c9                	xor    %ecx,%ecx
{
80107783:	89 e5                	mov    %esp,%ebp
80107785:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107788:	8b 55 0c             	mov    0xc(%ebp),%edx
8010778b:	8b 45 08             	mov    0x8(%ebp),%eax
8010778e:	e8 bd f8 ff ff       	call   80107050 <walkpgdir>
  if(pte == 0)
80107793:	85 c0                	test   %eax,%eax
80107795:	74 05                	je     8010779c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107797:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010779a:	c9                   	leave  
8010779b:	c3                   	ret    
    panic("clearpteu");
8010779c:	83 ec 0c             	sub    $0xc,%esp
8010779f:	68 9a 84 10 80       	push   $0x8010849a
801077a4:	e8 e7 8b ff ff       	call   80100390 <panic>
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077b9:	e8 22 ff ff ff       	call   801076e0 <setupkvm>
801077be:	85 c0                	test   %eax,%eax
801077c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077c3:	0f 84 9f 00 00 00    	je     80107868 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077cc:	85 c9                	test   %ecx,%ecx
801077ce:	0f 84 94 00 00 00    	je     80107868 <copyuvm+0xb8>
801077d4:	31 ff                	xor    %edi,%edi
801077d6:	eb 4a                	jmp    80107822 <copyuvm+0x72>
801077d8:	90                   	nop
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801077e0:	83 ec 04             	sub    $0x4,%esp
801077e3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801077e9:	68 00 10 00 00       	push   $0x1000
801077ee:	53                   	push   %ebx
801077ef:	50                   	push   %eax
801077f0:	e8 cb d4 ff ff       	call   80104cc0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801077f5:	58                   	pop    %eax
801077f6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801077fc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107801:	5a                   	pop    %edx
80107802:	ff 75 e4             	pushl  -0x1c(%ebp)
80107805:	50                   	push   %eax
80107806:	89 fa                	mov    %edi,%edx
80107808:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010780b:	e8 c0 f8 ff ff       	call   801070d0 <mappages>
80107810:	83 c4 10             	add    $0x10,%esp
80107813:	85 c0                	test   %eax,%eax
80107815:	78 61                	js     80107878 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107817:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010781d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107820:	76 46                	jbe    80107868 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107822:	8b 45 08             	mov    0x8(%ebp),%eax
80107825:	31 c9                	xor    %ecx,%ecx
80107827:	89 fa                	mov    %edi,%edx
80107829:	e8 22 f8 ff ff       	call   80107050 <walkpgdir>
8010782e:	85 c0                	test   %eax,%eax
80107830:	74 61                	je     80107893 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107832:	8b 00                	mov    (%eax),%eax
80107834:	a8 01                	test   $0x1,%al
80107836:	74 4e                	je     80107886 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107838:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010783a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010783f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107845:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107848:	e8 a3 ac ff ff       	call   801024f0 <kalloc>
8010784d:	85 c0                	test   %eax,%eax
8010784f:	89 c6                	mov    %eax,%esi
80107851:	75 8d                	jne    801077e0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107853:	83 ec 0c             	sub    $0xc,%esp
80107856:	ff 75 e0             	pushl  -0x20(%ebp)
80107859:	e8 02 fe ff ff       	call   80107660 <freevm>
  return 0;
8010785e:	83 c4 10             	add    $0x10,%esp
80107861:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107868:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010786b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010786e:	5b                   	pop    %ebx
8010786f:	5e                   	pop    %esi
80107870:	5f                   	pop    %edi
80107871:	5d                   	pop    %ebp
80107872:	c3                   	ret    
80107873:	90                   	nop
80107874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107878:	83 ec 0c             	sub    $0xc,%esp
8010787b:	56                   	push   %esi
8010787c:	e8 bf aa ff ff       	call   80102340 <kfree>
      goto bad;
80107881:	83 c4 10             	add    $0x10,%esp
80107884:	eb cd                	jmp    80107853 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107886:	83 ec 0c             	sub    $0xc,%esp
80107889:	68 be 84 10 80       	push   $0x801084be
8010788e:	e8 fd 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107893:	83 ec 0c             	sub    $0xc,%esp
80107896:	68 a4 84 10 80       	push   $0x801084a4
8010789b:	e8 f0 8a ff ff       	call   80100390 <panic>

801078a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078a1:	31 c9                	xor    %ecx,%ecx
{
801078a3:	89 e5                	mov    %esp,%ebp
801078a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801078ab:	8b 45 08             	mov    0x8(%ebp),%eax
801078ae:	e8 9d f7 ff ff       	call   80107050 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078b5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078b6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078bd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078c0:	05 00 00 00 80       	add    $0x80000000,%eax
801078c5:	83 fa 05             	cmp    $0x5,%edx
801078c8:	ba 00 00 00 00       	mov    $0x0,%edx
801078cd:	0f 45 c2             	cmovne %edx,%eax
}
801078d0:	c3                   	ret    
801078d1:	eb 0d                	jmp    801078e0 <copyout>
801078d3:	90                   	nop
801078d4:	90                   	nop
801078d5:	90                   	nop
801078d6:	90                   	nop
801078d7:	90                   	nop
801078d8:	90                   	nop
801078d9:	90                   	nop
801078da:	90                   	nop
801078db:	90                   	nop
801078dc:	90                   	nop
801078dd:	90                   	nop
801078de:	90                   	nop
801078df:	90                   	nop

801078e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 1c             	sub    $0x1c,%esp
801078e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801078ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801078ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078f2:	85 db                	test   %ebx,%ebx
801078f4:	75 40                	jne    80107936 <copyout+0x56>
801078f6:	eb 70                	jmp    80107968 <copyout+0x88>
801078f8:	90                   	nop
801078f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107903:	89 f1                	mov    %esi,%ecx
80107905:	29 d1                	sub    %edx,%ecx
80107907:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010790d:	39 d9                	cmp    %ebx,%ecx
8010790f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107912:	29 f2                	sub    %esi,%edx
80107914:	83 ec 04             	sub    $0x4,%esp
80107917:	01 d0                	add    %edx,%eax
80107919:	51                   	push   %ecx
8010791a:	57                   	push   %edi
8010791b:	50                   	push   %eax
8010791c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010791f:	e8 9c d3 ff ff       	call   80104cc0 <memmove>
    len -= n;
    buf += n;
80107924:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107927:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010792a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107930:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107932:	29 cb                	sub    %ecx,%ebx
80107934:	74 32                	je     80107968 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107936:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107938:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010793b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010793e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107944:	56                   	push   %esi
80107945:	ff 75 08             	pushl  0x8(%ebp)
80107948:	e8 53 ff ff ff       	call   801078a0 <uva2ka>
    if(pa0 == 0)
8010794d:	83 c4 10             	add    $0x10,%esp
80107950:	85 c0                	test   %eax,%eax
80107952:	75 ac                	jne    80107900 <copyout+0x20>
  }
  return 0;
}
80107954:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010795c:	5b                   	pop    %ebx
8010795d:	5e                   	pop    %esi
8010795e:	5f                   	pop    %edi
8010795f:	5d                   	pop    %ebp
80107960:	c3                   	ret    
80107961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107968:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010796b:	31 c0                	xor    %eax,%eax
}
8010796d:	5b                   	pop    %ebx
8010796e:	5e                   	pop    %esi
8010796f:	5f                   	pop    %edi
80107970:	5d                   	pop    %ebp
80107971:	c3                   	ret    
