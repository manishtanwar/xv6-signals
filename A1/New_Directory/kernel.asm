
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
8010004c:	68 e0 79 10 80       	push   $0x801079e0
80100051:	68 60 c6 10 80       	push   $0x8010c660
80100056:	e8 75 49 00 00       	call   801049d0 <initlock>
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
80100092:	68 e7 79 10 80       	push   $0x801079e7
80100097:	50                   	push   %eax
80100098:	e8 03 48 00 00       	call   801048a0 <initsleeplock>
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
801000e4:	e8 27 4a 00 00       	call   80104b10 <acquire>
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
80100162:	e8 69 4a 00 00       	call   80104bd0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 47 00 00       	call   801048e0 <acquiresleep>
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
80100193:	68 ee 79 10 80       	push   $0x801079ee
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
801001ae:	e8 cd 47 00 00       	call   80104980 <holdingsleep>
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
801001cc:	68 ff 79 10 80       	push   $0x801079ff
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
801001ef:	e8 8c 47 00 00       	call   80104980 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 47 00 00       	call   80104940 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010020b:	e8 00 49 00 00       	call   80104b10 <acquire>
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
8010025c:	e9 6f 49 00 00       	jmp    80104bd0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 7a 10 80       	push   $0x80107a06
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
8010028c:	e8 7f 48 00 00       	call   80104b10 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 40 20 13 80    	mov    0x80132040,%edx
801002a7:	39 15 44 20 13 80    	cmp    %edx,0x80132044
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
801002c0:	68 40 20 13 80       	push   $0x80132040
801002c5:	e8 76 3b 00 00       	call   80103e40 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 20 13 80    	mov    0x80132040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 20 13 80    	cmp    0x80132044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 35 00 00       	call   80103870 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 a0 b5 10 80       	push   $0x8010b5a0
801002ef:	e8 dc 48 00 00       	call   80104bd0 <release>
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
80100313:	a3 40 20 13 80       	mov    %eax,0x80132040
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 c0 1f 13 80 	movsbl -0x7fece040(%eax),%eax
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
8010034d:	e8 7e 48 00 00       	call   80104bd0 <release>
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
80100372:	89 15 40 20 13 80    	mov    %edx,0x80132040
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
801003b2:	68 0d 7a 10 80       	push   $0x80107a0d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 c7 84 10 80 	movl   $0x801084c7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 46 00 00       	call   801049f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 7a 10 80       	push   $0x80107a21
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
8010043a:	e8 a1 61 00 00       	call   801065e0 <uartputc>
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
801004ec:	e8 ef 60 00 00       	call   801065e0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 e3 60 00 00       	call   801065e0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 d7 60 00 00       	call   801065e0 <uartputc>
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
80100524:	e8 a7 47 00 00       	call   80104cd0 <memmove>
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
80100541:	e8 da 46 00 00       	call   80104c20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 7a 10 80       	push   $0x80107a25
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
801005b1:	0f b6 92 50 7a 10 80 	movzbl -0x7fef85b0(%edx),%edx
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
8010061b:	e8 f0 44 00 00       	call   80104b10 <acquire>
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
80100647:	e8 84 45 00 00       	call   80104bd0 <release>
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
8010071f:	e8 ac 44 00 00       	call   80104bd0 <release>
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
801007d0:	ba 38 7a 10 80       	mov    $0x80107a38,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 a0 b5 10 80       	push   $0x8010b5a0
801007f0:	e8 1b 43 00 00       	call   80104b10 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 7a 10 80       	push   $0x80107a3f
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
80100823:	e8 e8 42 00 00       	call   80104b10 <acquire>
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
80100851:	a1 48 20 13 80       	mov    0x80132048,%eax
80100856:	3b 05 44 20 13 80    	cmp    0x80132044,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 48 20 13 80       	mov    %eax,0x80132048
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
80100888:	e8 43 43 00 00       	call   80104bd0 <release>
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
801008a9:	a1 48 20 13 80       	mov    0x80132048,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 40 20 13 80    	sub    0x80132040,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 48 20 13 80    	mov    %edx,0x80132048
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 c0 1f 13 80    	mov    %cl,-0x7fece040(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 40 20 13 80       	mov    0x80132040,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 48 20 13 80    	cmp    %eax,0x80132048
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 44 20 13 80       	mov    %eax,0x80132044
          wakeup(&input.r);
80100911:	68 40 20 13 80       	push   $0x80132040
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
80100938:	a1 48 20 13 80       	mov    0x80132048,%eax
8010093d:	39 05 44 20 13 80    	cmp    %eax,0x80132044
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 48 20 13 80       	mov    %eax,0x80132048
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 48 20 13 80       	mov    0x80132048,%eax
80100964:	3b 05 44 20 13 80    	cmp    0x80132044,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba c0 1f 13 80 0a 	cmpb   $0xa,-0x7fece040(%edx)
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
801009a0:	c6 80 c0 1f 13 80 0a 	movb   $0xa,-0x7fece040(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 48 20 13 80       	mov    0x80132048,%eax
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
801009c6:	68 48 7a 10 80       	push   $0x80107a48
801009cb:	68 a0 b5 10 80       	push   $0x8010b5a0
801009d0:	e8 fb 3f 00 00       	call   801049d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 0c 2a 13 80 00 	movl   $0x80100600,0x80132a0c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 08 2a 13 80 70 	movl   $0x80100270,0x80132a08
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
80100a94:	e8 97 6c 00 00       	call   80107730 <setupkvm>
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
80100af6:	e8 55 6a 00 00       	call   80107550 <allocuvm>
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
80100b28:	e8 63 69 00 00       	call   80107490 <loaduvm>
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
80100b72:	e8 39 6b 00 00       	call   801076b0 <freevm>
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
80100baa:	e8 a1 69 00 00       	call   80107550 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ea 6a 00 00       	call   801076b0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 68 20 00 00       	call   80102c40 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 61 7a 10 80       	push   $0x80107a61
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
80100c06:	e8 c5 6b 00 00       	call   801077d0 <clearpteu>
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
80100c39:	e8 02 42 00 00       	call   80104e40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 41 00 00       	call   80104e40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ce 6c 00 00       	call   80107930 <copyout>
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
80100cc7:	e8 64 6c 00 00       	call   80107930 <copyout>
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
80100d0a:	e8 f1 40 00 00       	call   80104e00 <safestrcpy>
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
80100d59:	e8 a2 65 00 00       	call   80107300 <switchuvm>
  freevm(oldpgdir);
80100d5e:	89 3c 24             	mov    %edi,(%esp)
80100d61:	e8 4a 69 00 00       	call   801076b0 <freevm>
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
80100d86:	68 6d 7a 10 80       	push   $0x80107a6d
80100d8b:	68 60 20 13 80       	push   $0x80132060
80100d90:	e8 3b 3c 00 00       	call   801049d0 <initlock>
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
80100da4:	bb 94 20 13 80       	mov    $0x80132094,%ebx
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dac:	68 60 20 13 80       	push   $0x80132060
80100db1:	e8 5a 3d 00 00       	call   80104b10 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb f4 29 13 80    	cmp    $0x801329f4,%ebx
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
80100ddc:	68 60 20 13 80       	push   $0x80132060
80100de1:	e8 ea 3d 00 00       	call   80104bd0 <release>
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
80100df5:	68 60 20 13 80       	push   $0x80132060
80100dfa:	e8 d1 3d 00 00       	call   80104bd0 <release>
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
80100e1a:	68 60 20 13 80       	push   $0x80132060
80100e1f:	e8 ec 3c 00 00       	call   80104b10 <acquire>
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
80100e37:	68 60 20 13 80       	push   $0x80132060
80100e3c:	e8 8f 3d 00 00       	call   80104bd0 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 74 7a 10 80       	push   $0x80107a74
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
80100e6c:	68 60 20 13 80       	push   $0x80132060
80100e71:	e8 9a 3c 00 00       	call   80104b10 <acquire>
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
80100e8e:	c7 45 08 60 20 13 80 	movl   $0x80132060,0x8(%ebp)
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
80100e9c:	e9 2f 3d 00 00       	jmp    80104bd0 <release>
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
80100ec0:	68 60 20 13 80       	push   $0x80132060
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ec8:	e8 03 3d 00 00       	call   80104bd0 <release>
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
80100f22:	68 7c 7a 10 80       	push   $0x80107a7c
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
80101002:	68 86 7a 10 80       	push   $0x80107a86
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
80101115:	68 8f 7a 10 80       	push   $0x80107a8f
8010111a:	e8 71 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 95 7a 10 80       	push   $0x80107a95
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
80101139:	8b 0d 60 2a 13 80    	mov    0x80132a60,%ecx
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
8010115c:	03 05 78 2a 13 80    	add    0x80132a78,%eax
80101162:	50                   	push   %eax
80101163:	ff 75 d8             	pushl  -0x28(%ebp)
80101166:	e8 65 ef ff ff       	call   801000d0 <bread>
8010116b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116e:	a1 60 2a 13 80       	mov    0x80132a60,%eax
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
801011c9:	39 05 60 2a 13 80    	cmp    %eax,0x80132a60
801011cf:	77 80                	ja     80101151 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011d1:	83 ec 0c             	sub    $0xc,%esp
801011d4:	68 9f 7a 10 80       	push   $0x80107a9f
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
80101215:	e8 06 3a 00 00       	call   80104c20 <memset>
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
8010124a:	bb b4 2a 13 80       	mov    $0x80132ab4,%ebx
{
8010124f:	83 ec 28             	sub    $0x28,%esp
80101252:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101255:	68 80 2a 13 80       	push   $0x80132a80
8010125a:	e8 b1 38 00 00       	call   80104b10 <acquire>
8010125f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101265:	eb 17                	jmp    8010127e <iget+0x3e>
80101267:	89 f6                	mov    %esi,%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101270:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101276:	81 fb d4 46 13 80    	cmp    $0x801346d4,%ebx
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
80101298:	81 fb d4 46 13 80    	cmp    $0x801346d4,%ebx
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
801012ba:	68 80 2a 13 80       	push   $0x80132a80
801012bf:	e8 0c 39 00 00       	call   80104bd0 <release>

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
801012e5:	68 80 2a 13 80       	push   $0x80132a80
      ip->ref++;
801012ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012ed:	e8 de 38 00 00       	call   80104bd0 <release>
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
80101302:	68 b5 7a 10 80       	push   $0x80107ab5
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
801013d7:	68 c5 7a 10 80       	push   $0x80107ac5
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
80101411:	e8 ba 38 00 00       	call   80104cd0 <memmove>
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
8010143c:	68 60 2a 13 80       	push   $0x80132a60
80101441:	50                   	push   %eax
80101442:	e8 a9 ff ff ff       	call   801013f0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101447:	58                   	pop    %eax
80101448:	5a                   	pop    %edx
80101449:	89 da                	mov    %ebx,%edx
8010144b:	c1 ea 0c             	shr    $0xc,%edx
8010144e:	03 15 78 2a 13 80    	add    0x80132a78,%edx
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
801014a4:	68 d8 7a 10 80       	push   $0x80107ad8
801014a9:	e8 e2 ee ff ff       	call   80100390 <panic>
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb c0 2a 13 80       	mov    $0x80132ac0,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 eb 7a 10 80       	push   $0x80107aeb
801014c1:	68 80 2a 13 80       	push   $0x80132a80
801014c6:	e8 05 35 00 00       	call   801049d0 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 f2 7a 10 80       	push   $0x80107af2
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 bc 33 00 00       	call   801048a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb e0 46 13 80    	cmp    $0x801346e0,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 60 2a 13 80       	push   $0x80132a60
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 f1 fe ff ff       	call   801013f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 78 2a 13 80    	pushl  0x80132a78
80101505:	ff 35 74 2a 13 80    	pushl  0x80132a74
8010150b:	ff 35 70 2a 13 80    	pushl  0x80132a70
80101511:	ff 35 6c 2a 13 80    	pushl  0x80132a6c
80101517:	ff 35 68 2a 13 80    	pushl  0x80132a68
8010151d:	ff 35 64 2a 13 80    	pushl  0x80132a64
80101523:	ff 35 60 2a 13 80    	pushl  0x80132a60
80101529:	68 58 7b 10 80       	push   $0x80107b58
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
80101549:	83 3d 68 2a 13 80 01 	cmpl   $0x1,0x80132a68
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
8010157f:	39 1d 68 2a 13 80    	cmp    %ebx,0x80132a68
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 74 2a 13 80    	add    0x80132a74,%eax
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
801015be:	e8 5d 36 00 00       	call   80104c20 <memset>
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
801015f3:	68 f8 7a 10 80       	push   $0x80107af8
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
80101614:	03 05 74 2a 13 80    	add    0x80132a74,%eax
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
80101661:	e8 6a 36 00 00       	call   80104cd0 <memmove>
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
8010168a:	68 80 2a 13 80       	push   $0x80132a80
8010168f:	e8 7c 34 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 80 2a 13 80 	movl   $0x80132a80,(%esp)
8010169f:	e8 2c 35 00 00       	call   80104bd0 <release>
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
801016d2:	e8 09 32 00 00       	call   801048e0 <acquiresleep>
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
801016f9:	03 05 74 2a 13 80    	add    0x80132a74,%eax
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
80101748:	e8 83 35 00 00       	call   80104cd0 <memmove>
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
8010176d:	68 10 7b 10 80       	push   $0x80107b10
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 0a 7b 10 80       	push   $0x80107b0a
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
801017a3:	e8 d8 31 00 00       	call   80104980 <holdingsleep>
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
801017bf:	e9 7c 31 00 00       	jmp    80104940 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 1f 7b 10 80       	push   $0x80107b1f
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
801017f0:	e8 eb 30 00 00       	call   801048e0 <acquiresleep>
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
8010180a:	e8 31 31 00 00       	call   80104940 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 80 2a 13 80 	movl   $0x80132a80,(%esp)
80101816:	e8 f5 32 00 00       	call   80104b10 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 80 2a 13 80 	movl   $0x80132a80,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 9b 33 00 00       	jmp    80104bd0 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 80 2a 13 80       	push   $0x80132a80
80101840:	e8 cb 32 00 00       	call   80104b10 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 80 2a 13 80 	movl   $0x80132a80,(%esp)
8010184f:	e8 7c 33 00 00       	call   80104bd0 <release>
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
80101a37:	e8 94 32 00 00       	call   80104cd0 <memmove>
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
80101a6a:	8b 04 c5 00 2a 13 80 	mov    -0x7fecd600(,%eax,8),%eax
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
80101b33:	e8 98 31 00 00       	call   80104cd0 <memmove>
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
80101b7a:	8b 04 c5 04 2a 13 80 	mov    -0x7fecd5fc(,%eax,8),%eax
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
80101bce:	e8 6d 31 00 00       	call   80104d40 <strncmp>
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
80101c2d:	e8 0e 31 00 00       	call   80104d40 <strncmp>
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
80101c72:	68 39 7b 10 80       	push   $0x80107b39
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 27 7b 10 80       	push   $0x80107b27
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
80101cb4:	68 80 2a 13 80       	push   $0x80132a80
80101cb9:	e8 52 2e 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 80 2a 13 80 	movl   $0x80132a80,(%esp)
80101cc9:	e8 02 2f 00 00       	call   80104bd0 <release>
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
80101d25:	e8 a6 2f 00 00       	call   80104cd0 <memmove>
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
80101db8:	e8 13 2f 00 00       	call   80104cd0 <memmove>
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
80101ead:	e8 ee 2e 00 00       	call   80104da0 <strncpy>
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
80101eeb:	68 48 7b 10 80       	push   $0x80107b48
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 aa 82 10 80       	push   $0x801082aa
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
8010200b:	68 b4 7b 10 80       	push   $0x80107bb4
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 ab 7b 10 80       	push   $0x80107bab
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 c6 7b 10 80       	push   $0x80107bc6
8010203b:	68 00 b6 10 80       	push   $0x8010b600
80102040:	e8 8b 29 00 00       	call   801049d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 a0 4d 13 80       	mov    0x80134da0,%eax
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
801020be:	e8 4d 2a 00 00       	call   80104b10 <acquire>

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
8010213f:	e8 8c 2a 00 00       	call   80104bd0 <release>

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
8010215e:	e8 1d 28 00 00       	call   80104980 <holdingsleep>
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
80102198:	e8 73 29 00 00       	call   80104b10 <acquire>

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
80102206:	e9 c5 29 00 00       	jmp    80104bd0 <release>
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
8010222a:	68 e0 7b 10 80       	push   $0x80107be0
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 ca 7b 10 80       	push   $0x80107bca
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 f5 7b 10 80       	push   $0x80107bf5
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
80102251:	c7 05 d4 46 13 80 00 	movl   $0xfec00000,0x801346d4
80102258:	00 c0 fe 
{
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	56                   	push   %esi
8010225e:	53                   	push   %ebx
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	a1 d4 46 13 80       	mov    0x801346d4,%eax
8010226e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102277:	8b 0d d4 46 13 80    	mov    0x801346d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227d:	0f b6 15 00 48 13 80 	movzbl 0x80134800,%edx
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
80102297:	68 14 7c 10 80       	push   $0x80107c14
8010229c:	e8 bf e3 ff ff       	call   80100660 <cprintf>
801022a1:	8b 0d d4 46 13 80    	mov    0x801346d4,%ecx
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
801022c2:	8b 0d d4 46 13 80    	mov    0x801346d4,%ecx

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
801022e0:	8b 0d d4 46 13 80    	mov    0x801346d4,%ecx
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
80102301:	8b 0d d4 46 13 80    	mov    0x801346d4,%ecx
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
80102315:	8b 0d d4 46 13 80    	mov    0x801346d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010231e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102321:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102324:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102326:	a1 d4 46 13 80       	mov    0x801346d4,%eax
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
80102352:	81 fb c8 89 16 80    	cmp    $0x801689c8,%ebx
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
80102372:	e8 a9 28 00 00       	call   80104c20 <memset>

  if(kmem.use_lock)
80102377:	8b 15 14 47 13 80    	mov    0x80134714,%edx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 d2                	test   %edx,%edx
80102382:	75 2c                	jne    801023b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102384:	a1 18 47 13 80       	mov    0x80134718,%eax
80102389:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010238b:	a1 14 47 13 80       	mov    0x80134714,%eax
  kmem.freelist = r;
80102390:	89 1d 18 47 13 80    	mov    %ebx,0x80134718
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
801023a0:	c7 45 08 e0 46 13 80 	movl   $0x801346e0,0x8(%ebp)
}
801023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023aa:	c9                   	leave  
    release(&kmem.lock);
801023ab:	e9 20 28 00 00       	jmp    80104bd0 <release>
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 e0 46 13 80       	push   $0x801346e0
801023b8:	e8 53 27 00 00       	call   80104b10 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 46 7c 10 80       	push   $0x80107c46
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
8010242b:	68 4c 7c 10 80       	push   $0x80107c4c
80102430:	68 e0 46 13 80       	push   $0x801346e0
80102435:	e8 96 25 00 00       	call   801049d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102440:	c7 05 14 47 13 80 00 	movl   $0x0,0x80134714
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
801024d4:	c7 05 14 47 13 80 01 	movl   $0x1,0x80134714
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
801024f0:	a1 14 47 13 80       	mov    0x80134714,%eax
801024f5:	85 c0                	test   %eax,%eax
801024f7:	75 1f                	jne    80102518 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f9:	a1 18 47 13 80       	mov    0x80134718,%eax
  if(r)
801024fe:	85 c0                	test   %eax,%eax
80102500:	74 0e                	je     80102510 <kalloc+0x20>
    kmem.freelist = r->next;
80102502:	8b 10                	mov    (%eax),%edx
80102504:	89 15 18 47 13 80    	mov    %edx,0x80134718
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
8010251e:	68 e0 46 13 80       	push   $0x801346e0
80102523:	e8 e8 25 00 00       	call   80104b10 <acquire>
  r = kmem.freelist;
80102528:	a1 18 47 13 80       	mov    0x80134718,%eax
  if(r)
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	8b 15 14 47 13 80    	mov    0x80134714,%edx
80102536:	85 c0                	test   %eax,%eax
80102538:	74 08                	je     80102542 <kalloc+0x52>
    kmem.freelist = r->next;
8010253a:	8b 08                	mov    (%eax),%ecx
8010253c:	89 0d 18 47 13 80    	mov    %ecx,0x80134718
  if(kmem.use_lock)
80102542:	85 d2                	test   %edx,%edx
80102544:	74 16                	je     8010255c <kalloc+0x6c>
    release(&kmem.lock);
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010254c:	68 e0 46 13 80       	push   $0x801346e0
80102551:	e8 7a 26 00 00       	call   80104bd0 <release>
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
801025a3:	0f b6 82 80 7d 10 80 	movzbl -0x7fef8280(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 80 7c 10 80 	movzbl -0x7fef8380(%edx),%eax
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
801025c3:	8b 04 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%eax
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
801025e8:	0f b6 82 80 7d 10 80 	movzbl -0x7fef8280(%edx),%eax
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
80102660:	a1 1c 47 13 80       	mov    0x8013471c,%eax
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
80102760:	8b 15 1c 47 13 80    	mov    0x8013471c,%edx
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
80102780:	a1 1c 47 13 80       	mov    0x8013471c,%eax
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
801027ee:	a1 1c 47 13 80       	mov    0x8013471c,%eax
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
80102967:	e8 04 23 00 00       	call   80104c70 <memcmp>
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
80102a30:	8b 0d 68 47 13 80    	mov    0x80134768,%ecx
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
80102a50:	a1 54 47 13 80       	mov    0x80134754,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 64 47 13 80    	pushl  0x80134764
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d 6c 47 13 80 	pushl  -0x7fecb894(,%ebx,4)
80102a74:	ff 35 64 47 13 80    	pushl  0x80134764
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
80102a94:	e8 37 22 00 00       	call   80104cd0 <memmove>
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
80102ab4:	39 1d 68 47 13 80    	cmp    %ebx,0x80134768
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
80102ad8:	ff 35 54 47 13 80    	pushl  0x80134754
80102ade:	ff 35 64 47 13 80    	pushl  0x80134764
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae9:	8b 1d 68 47 13 80    	mov    0x80134768,%ebx
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
80102b00:	8b 8a 6c 47 13 80    	mov    -0x7fecb894(%edx),%ecx
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
80102b3a:	68 80 7e 10 80       	push   $0x80107e80
80102b3f:	68 20 47 13 80       	push   $0x80134720
80102b44:	e8 87 1e 00 00       	call   801049d0 <initlock>
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
80102b5c:	89 1d 64 47 13 80    	mov    %ebx,0x80134764
  log.size = sb.nlog;
80102b62:	89 15 58 47 13 80    	mov    %edx,0x80134758
  log.start = sb.logstart;
80102b68:	a3 54 47 13 80       	mov    %eax,0x80134754
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
80102b7d:	89 1d 68 47 13 80    	mov    %ebx,0x80134768
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	c1 e3 02             	shl    $0x2,%ebx
80102b88:	31 d2                	xor    %edx,%edx
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a 68 47 13 80    	mov    %ecx,-0x7fecb898(%edx)
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
80102baf:	c7 05 68 47 13 80 00 	movl   $0x0,0x80134768
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
80102bd6:	68 20 47 13 80       	push   $0x80134720
80102bdb:	e8 30 1f 00 00       	call   80104b10 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 20 47 13 80       	push   $0x80134720
80102bf0:	68 20 47 13 80       	push   $0x80134720
80102bf5:	e8 46 12 00 00       	call   80103e40 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bfd:	a1 60 47 13 80       	mov    0x80134760,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 5c 47 13 80       	mov    0x8013475c,%eax
80102c0b:	8b 15 68 47 13 80    	mov    0x80134768,%edx
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
80102c22:	a3 5c 47 13 80       	mov    %eax,0x8013475c
      release(&log.lock);
80102c27:	68 20 47 13 80       	push   $0x80134720
80102c2c:	e8 9f 1f 00 00       	call   80104bd0 <release>
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
80102c49:	68 20 47 13 80       	push   $0x80134720
80102c4e:	e8 bd 1e 00 00       	call   80104b10 <acquire>
  log.outstanding -= 1;
80102c53:	a1 5c 47 13 80       	mov    0x8013475c,%eax
  if(log.committing)
80102c58:	8b 35 60 47 13 80    	mov    0x80134760,%esi
80102c5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c66:	89 1d 5c 47 13 80    	mov    %ebx,0x8013475c
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
80102c7d:	c7 05 60 47 13 80 01 	movl   $0x1,0x80134760
80102c84:	00 00 00 
  release(&log.lock);
80102c87:	68 20 47 13 80       	push   $0x80134720
80102c8c:	e8 3f 1f 00 00       	call   80104bd0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c91:	8b 0d 68 47 13 80    	mov    0x80134768,%ecx
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	85 c9                	test   %ecx,%ecx
80102c9c:	0f 8e 85 00 00 00    	jle    80102d27 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca2:	a1 54 47 13 80       	mov    0x80134754,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	01 d8                	add    %ebx,%eax
80102cac:	83 c0 01             	add    $0x1,%eax
80102caf:	50                   	push   %eax
80102cb0:	ff 35 64 47 13 80    	pushl  0x80134764
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	58                   	pop    %eax
80102cbe:	5a                   	pop    %edx
80102cbf:	ff 34 9d 6c 47 13 80 	pushl  -0x7fecb894(,%ebx,4)
80102cc6:	ff 35 64 47 13 80    	pushl  0x80134764
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
80102ce6:	e8 e5 1f 00 00       	call   80104cd0 <memmove>
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
80102d06:	3b 1d 68 47 13 80    	cmp    0x80134768,%ebx
80102d0c:	7c 94                	jl     80102ca2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d0e:	e8 bd fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d13:	e8 18 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d18:	c7 05 68 47 13 80 00 	movl   $0x0,0x80134768
80102d1f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d22:	e8 a9 fd ff ff       	call   80102ad0 <write_head>
    acquire(&log.lock);
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 20 47 13 80       	push   $0x80134720
80102d2f:	e8 dc 1d 00 00       	call   80104b10 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 20 47 13 80 	movl   $0x80134720,(%esp)
    log.committing = 0;
80102d3b:	c7 05 60 47 13 80 00 	movl   $0x0,0x80134760
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 b6 12 00 00       	call   80104000 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 20 47 13 80 	movl   $0x80134720,(%esp)
80102d51:	e8 7a 1e 00 00       	call   80104bd0 <release>
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
80102d6b:	68 20 47 13 80       	push   $0x80134720
80102d70:	e8 8b 12 00 00       	call   80104000 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 20 47 13 80 	movl   $0x80134720,(%esp)
80102d7c:	e8 4f 1e 00 00       	call   80104bd0 <release>
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
80102d8f:	68 84 7e 10 80       	push   $0x80107e84
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
80102da7:	8b 15 68 47 13 80    	mov    0x80134768,%edx
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 9d 00 00 00    	jg     80102e56 <log_write+0xb6>
80102db9:	a1 58 47 13 80       	mov    0x80134758,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 8d 00 00 00    	jge    80102e56 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 5c 47 13 80       	mov    0x8013475c,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 8d 00 00 00    	jle    80102e63 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 20 47 13 80       	push   $0x80134720
80102dde:	e8 2d 1d 00 00       	call   80104b10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 0d 68 47 13 80    	mov    0x80134768,%ecx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 f9 00             	cmp    $0x0,%ecx
80102def:	7e 57                	jle    80102e48 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 15 6c 47 13 80    	cmp    0x8013476c,%edx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 14 85 6c 47 13 80 	cmp    %edx,-0x7fecb894(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 c1                	cmp    %eax,%ecx
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 14 85 6c 47 13 80 	mov    %edx,-0x7fecb894(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c0 01             	add    $0x1,%eax
80102e1a:	a3 68 47 13 80       	mov    %eax,0x80134768
  b->flags |= B_DIRTY; // prevent eviction
80102e1f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e22:	c7 45 08 20 47 13 80 	movl   $0x80134720,0x8(%ebp)
}
80102e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2c:	c9                   	leave  
  release(&log.lock);
80102e2d:	e9 9e 1d 00 00       	jmp    80104bd0 <release>
80102e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e38:	89 14 85 6c 47 13 80 	mov    %edx,-0x7fecb894(,%eax,4)
80102e3f:	eb de                	jmp    80102e1f <log_write+0x7f>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8b 43 08             	mov    0x8(%ebx),%eax
80102e4b:	a3 6c 47 13 80       	mov    %eax,0x8013476c
  if (i == log.lh.n)
80102e50:	75 cd                	jne    80102e1f <log_write+0x7f>
80102e52:	31 c0                	xor    %eax,%eax
80102e54:	eb c1                	jmp    80102e17 <log_write+0x77>
    panic("too big a transaction");
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 93 7e 10 80       	push   $0x80107e93
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 a9 7e 10 80       	push   $0x80107ea9
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
80102e88:	68 c4 7e 10 80       	push   $0x80107ec4
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e92:	e8 59 33 00 00       	call   801061f0 <idtinit>
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
80102eb6:	e8 25 44 00 00       	call   801072e0 <switchkvm>
  seginit();
80102ebb:	e8 90 43 00 00       	call   80107250 <seginit>
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
80102ee7:	68 c8 89 16 80       	push   $0x801689c8
80102eec:	e8 2f f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 ba 48 00 00       	call   801077b0 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 60 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 4b 43 00 00       	call   80107250 <seginit>
  picinit();       // disable pic
80102f05:	e8 46 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 41 f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 07 36 00 00       	call   80106520 <uartinit>
  pinit();         // process table
80102f19:	e8 92 08 00 00       	call   801037b0 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 4d 32 00 00       	call   80106170 <tvinit>
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
80102f44:	e8 87 1d 00 00       	call   80104cd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f49:	69 05 a0 4d 13 80 b0 	imul   $0xb0,0x80134da0,%eax
80102f50:	00 00 00 
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	05 20 48 13 80       	add    $0x80134820,%eax
80102f5b:	3d 20 48 13 80       	cmp    $0x80134820,%eax
80102f60:	76 71                	jbe    80102fd3 <main+0x103>
80102f62:	bb 20 48 13 80       	mov    $0x80134820,%ebx
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
80102fba:	69 05 a0 4d 13 80 b0 	imul   $0xb0,0x80134da0,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fca:	05 20 48 13 80       	add    $0x80134820,%eax
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
8010301e:	68 d8 7e 10 80       	push   $0x80107ed8
80103023:	56                   	push   %esi
80103024:	e8 47 1c 00 00       	call   80104c70 <memcmp>
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
801030dc:	68 f5 7e 10 80       	push   $0x80107ef5
801030e1:	56                   	push   %esi
801030e2:	e8 89 1b 00 00       	call   80104c70 <memcmp>
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
80103147:	a3 1c 47 13 80       	mov    %eax,0x8013471c
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
80103170:	ff 24 95 1c 7f 10 80 	jmp    *-0x7fef80e4(,%edx,4)
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
801031b8:	8b 0d a0 4d 13 80    	mov    0x80134da0,%ecx
801031be:	83 f9 07             	cmp    $0x7,%ecx
801031c1:	7f 19                	jg     801031dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031cd:	83 c1 01             	add    $0x1,%ecx
801031d0:	89 0d a0 4d 13 80    	mov    %ecx,0x80134da0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d6:	88 97 20 48 13 80    	mov    %dl,-0x7fecb7e0(%edi)
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
801031ef:	88 15 00 48 13 80    	mov    %dl,0x80134800
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
80103223:	68 dd 7e 10 80       	push   $0x80107edd
80103228:	e8 63 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 fc 7e 10 80       	push   $0x80107efc
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
8010332b:	68 d0 80 10 80       	push   $0x801080d0
80103330:	50                   	push   %eax
80103331:	e8 9a 16 00 00       	call   801049d0 <initlock>
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
8010338f:	e8 7c 17 00 00       	call   80104b10 <acquire>
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
801033d4:	e9 f7 17 00 00       	jmp    80104bd0 <release>
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
80103404:	e8 c7 17 00 00       	call   80104bd0 <release>
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
8010342d:	e8 de 16 00 00       	call   80104b10 <acquire>
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
801034c4:	e8 07 17 00 00       	call   80104bd0 <release>
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
8010351b:	e8 b0 16 00 00       	call   80104bd0 <release>
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
80103540:	e8 cb 15 00 00       	call   80104b10 <acquire>
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
801035ae:	e8 1d 16 00 00       	call   80104bd0 <release>
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
8010360f:	e8 bc 15 00 00       	call   80104bd0 <release>
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
80103637:	bb f4 4d 13 80       	mov    $0x80134df4,%ebx
  acquire(&ptable.lock);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	68 c0 4d 13 80       	push   $0x80134dc0
80103644:	e8 c7 14 00 00       	call   80104b10 <acquire>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	eb 17                	jmp    80103665 <allocproc+0x35>
8010364e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++,i++)
80103650:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
80103656:	83 c6 01             	add    $0x1,%esi
80103659:	81 fb f4 80 16 80    	cmp    $0x801680f4,%ebx
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
80103681:	68 c0 4d 13 80       	push   $0x80134dc0
  p->pid = nextpid++;
80103686:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010368c:	e8 3f 15 00 00       	call   80104bd0 <release>

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
  // Initialize data for signal handling
  p->sig_handler_busy = 0;
  p->SigQueue.start = p->SigQueue.end = 0;
  p->SigQueue.lock.locked = 0;

  MsgQueue[i].start = MsgQueue[i].end = 0;
801036b2:	69 f6 40 08 00 00    	imul   $0x840,%esi,%esi
  sp -= sizeof *p->tf;
801036b8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036bb:	c7 40 14 5f 61 10 80 	movl   $0x8010615f,0x14(%eax)
  p->context = (struct context*)sp;
801036c2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036c5:	6a 14                	push   $0x14
801036c7:	6a 00                	push   $0x0
801036c9:	50                   	push   %eax
801036ca:	e8 51 15 00 00       	call   80104c20 <memset>
  p->context->eip = (uint)forkret;
801036cf:	8b 43 1c             	mov    0x1c(%ebx),%eax
  MsgQueue[i].lock.locked = 0;

  // ****

  return p;
801036d2:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036d5:	c7 40 10 60 37 10 80 	movl   $0x80103760,0x10(%eax)
  p->sig_handler_busy = 0;
801036dc:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801036e3:	00 00 00 
  p->SigQueue.start = p->SigQueue.end = 0;
801036e6:	c7 83 c8 0c 00 00 00 	movl   $0x0,0xcc8(%ebx)
801036ed:	00 00 00 
801036f0:	c7 83 c4 0c 00 00 00 	movl   $0x0,0xcc4(%ebx)
801036f7:	00 00 00 
  p->SigQueue.lock.locked = 0;
801036fa:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103701:	00 00 00 
  MsgQueue[i].start = MsgQueue[i].end = 0;
80103704:	c7 86 f8 17 11 80 00 	movl   $0x0,-0x7feee808(%esi)
8010370b:	00 00 00 
8010370e:	c7 86 f4 17 11 80 00 	movl   $0x0,-0x7feee80c(%esi)
80103715:	00 00 00 
  MsgQueue[i].lock.locked = 0;
80103718:	c7 86 c0 0f 11 80 00 	movl   $0x0,-0x7feef040(%esi)
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
80103735:	68 c0 4d 13 80       	push   $0x80134dc0
8010373a:	e8 91 14 00 00       	call   80104bd0 <release>
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
80103766:	68 c0 4d 13 80       	push   $0x80134dc0
8010376b:	e8 60 14 00 00       	call   80104bd0 <release>

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
801037b6:	68 30 7f 10 80       	push   $0x80107f30
801037bb:	68 c0 4d 13 80       	push   $0x80134dc0
801037c0:	e8 0b 12 00 00       	call   801049d0 <initlock>
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
801037e1:	8b 35 a0 4d 13 80    	mov    0x80134da0,%esi
801037e7:	85 f6                	test   %esi,%esi
801037e9:	7e 42                	jle    8010382d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037eb:	0f b6 15 20 48 13 80 	movzbl 0x80134820,%edx
801037f2:	39 d0                	cmp    %edx,%eax
801037f4:	74 30                	je     80103826 <mycpu+0x56>
801037f6:	b9 d0 48 13 80       	mov    $0x801348d0,%ecx
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
8010381a:	05 20 48 13 80       	add    $0x80134820,%eax
}
8010381f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5d                   	pop    %ebp
80103825:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103826:	b8 20 48 13 80       	mov    $0x80134820,%eax
      return &cpus[i];
8010382b:	eb f2                	jmp    8010381f <mycpu+0x4f>
  panic("unknown apicid\n");
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 37 7f 10 80       	push   $0x80107f37
80103835:	e8 56 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010383a:	83 ec 0c             	sub    $0xc,%esp
8010383d:	68 1c 80 10 80       	push   $0x8010801c
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
8010385b:	2d 20 48 13 80       	sub    $0x80134820,%eax
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
80103877:	e8 c4 11 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010387c:	e8 4f ff ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103881:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103887:	e8 f4 11 00 00       	call   80104a80 <popcli>
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
801038b3:	e8 78 3e 00 00       	call   80107730 <setupkvm>
801038b8:	85 c0                	test   %eax,%eax
801038ba:	89 43 04             	mov    %eax,0x4(%ebx)
801038bd:	0f 84 bd 00 00 00    	je     80103980 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038c3:	83 ec 04             	sub    $0x4,%esp
801038c6:	68 2c 00 00 00       	push   $0x2c
801038cb:	68 e0 b4 10 80       	push   $0x8010b4e0
801038d0:	50                   	push   %eax
801038d1:	e8 3a 3b 00 00       	call   80107410 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038df:	6a 4c                	push   $0x4c
801038e1:	6a 00                	push   $0x0
801038e3:	ff 73 18             	pushl  0x18(%ebx)
801038e6:	e8 35 13 00 00       	call   80104c20 <memset>
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
8010393f:	68 60 7f 10 80       	push   $0x80107f60
80103944:	50                   	push   %eax
80103945:	e8 b6 14 00 00       	call   80104e00 <safestrcpy>
  p->cwd = namei("/");
8010394a:	c7 04 24 69 7f 10 80 	movl   $0x80107f69,(%esp)
80103951:	e8 ba e5 ff ff       	call   80101f10 <namei>
80103956:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103959:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103960:	e8 ab 11 00 00       	call   80104b10 <acquire>
  p->state = RUNNABLE;
80103965:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010396c:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103973:	e8 58 12 00 00       	call   80104bd0 <release>
}
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397e:	c9                   	leave  
8010397f:	c3                   	ret    
    panic("userinit: out of memory?");
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	68 47 7f 10 80       	push   $0x80107f47
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
80103998:	e8 a3 10 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010399d:	e8 2e fe ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801039a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a8:	e8 d3 10 00 00       	call   80104a80 <popcli>
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
801039bc:	e8 3f 39 00 00       	call   80107300 <switchuvm>
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
801039da:	e8 71 3b 00 00       	call   80107550 <allocuvm>
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
801039fa:	e8 81 3c 00 00       	call   80107680 <deallocuvm>
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
80103a19:	e8 22 10 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103a1e:	e8 ad fd ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103a23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a29:	e8 52 10 00 00       	call   80104a80 <popcli>
  if((np = allocproc()) == 0){
80103a2e:	e8 fd fb ff ff       	call   80103630 <allocproc>
80103a33:	85 c0                	test   %eax,%eax
80103a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a38:	0f 84 f3 00 00 00    	je     80103b31 <fork+0x121>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a3e:	83 ec 08             	sub    $0x8,%esp
80103a41:	ff 33                	pushl  (%ebx)
80103a43:	ff 73 04             	pushl  0x4(%ebx)
80103a46:	e8 b5 3d 00 00       	call   80107800 <copyuvm>
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
80103af7:	e8 04 13 00 00       	call   80104e00 <safestrcpy>
  pid = np->pid;
80103afc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103aff:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80103b02:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103b09:	e8 02 10 00 00       	call   80104b10 <acquire>
  np->state = RUNNABLE;
80103b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b11:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80103b18:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103b1f:	e8 ac 10 00 00       	call   80104bd0 <release>
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
80103b84:	bb f4 4d 13 80       	mov    $0x80134df4,%ebx
    acquire(&ptable.lock);
80103b89:	68 c0 4d 13 80       	push   $0x80134dc0
80103b8e:	e8 7d 0f 00 00       	call   80104b10 <acquire>
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
80103bb0:	e8 4b 37 00 00       	call   80107300 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103bb5:	58                   	pop    %eax
80103bb6:	5a                   	pop    %edx
80103bb7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bba:	57                   	push   %edi
      p->state = RUNNING;
80103bbb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103bc2:	e8 94 12 00 00       	call   80104e5b <swtch>
      switchkvm();
80103bc7:	e8 14 37 00 00       	call   801072e0 <switchkvm>
      c->proc = 0;
80103bcc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103bd3:	00 00 00 
80103bd6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bd9:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
80103bdf:	81 fb f4 80 16 80    	cmp    $0x801680f4,%ebx
80103be5:	72 b9                	jb     80103ba0 <scheduler+0x40>
    release(&ptable.lock);
80103be7:	83 ec 0c             	sub    $0xc,%esp
80103bea:	68 c0 4d 13 80       	push   $0x80134dc0
80103bef:	e8 dc 0f 00 00       	call   80104bd0 <release>
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
80103c05:	e8 36 0e 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103c0a:	e8 c1 fb ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103c0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c15:	e8 66 0e 00 00       	call   80104a80 <popcli>
  if(!holding(&ptable.lock))
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 c0 4d 13 80       	push   $0x80134dc0
80103c22:	e8 b9 0e 00 00       	call   80104ae0 <holding>
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
80103c63:	e8 f3 11 00 00       	call   80104e5b <swtch>
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
80103c80:	68 6b 7f 10 80       	push   $0x80107f6b
80103c85:	e8 06 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c8a:	83 ec 0c             	sub    $0xc,%esp
80103c8d:	68 97 7f 10 80       	push   $0x80107f97
80103c92:	e8 f9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c97:	83 ec 0c             	sub    $0xc,%esp
80103c9a:	68 89 7f 10 80       	push   $0x80107f89
80103c9f:	e8 ec c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	68 7d 7f 10 80       	push   $0x80107f7d
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
80103cc9:	e8 72 0d 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103cce:	e8 fd fa ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103cd3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cd9:	e8 a2 0d 00 00       	call   80104a80 <popcli>
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
80103d2b:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103d32:	e8 d9 0d 00 00       	call   80104b10 <acquire>
  wakeup1(curproc->parent);
80103d37:	8b 56 14             	mov    0x14(%esi),%edx
80103d3a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d3d:	b8 f4 4d 13 80       	mov    $0x80134df4,%eax
80103d42:	eb 10                	jmp    80103d54 <exit+0x94>
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d48:	05 cc 0c 00 00       	add    $0xccc,%eax
80103d4d:	3d f4 80 16 80       	cmp    $0x801680f4,%eax
80103d52:	73 1e                	jae    80103d72 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103d54:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d58:	75 ee                	jne    80103d48 <exit+0x88>
80103d5a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d5d:	75 e9                	jne    80103d48 <exit+0x88>
      p->state = RUNNABLE;
80103d5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d66:	05 cc 0c 00 00       	add    $0xccc,%eax
80103d6b:	3d f4 80 16 80       	cmp    $0x801680f4,%eax
80103d70:	72 e2                	jb     80103d54 <exit+0x94>
      p->parent = initproc;
80103d72:	8b 0d 38 b6 10 80    	mov    0x8010b638,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d78:	ba f4 4d 13 80       	mov    $0x80134df4,%edx
80103d7d:	eb 0f                	jmp    80103d8e <exit+0xce>
80103d7f:	90                   	nop
80103d80:	81 c2 cc 0c 00 00    	add    $0xccc,%edx
80103d86:	81 fa f4 80 16 80    	cmp    $0x801680f4,%edx
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
80103d9c:	b8 f4 4d 13 80       	mov    $0x80134df4,%eax
80103da1:	eb 11                	jmp    80103db4 <exit+0xf4>
80103da3:	90                   	nop
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103da8:	05 cc 0c 00 00       	add    $0xccc,%eax
80103dad:	3d f4 80 16 80       	cmp    $0x801680f4,%eax
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
80103dd7:	68 b8 7f 10 80       	push   $0x80107fb8
80103ddc:	e8 af c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103de1:	83 ec 0c             	sub    $0xc,%esp
80103de4:	68 ab 7f 10 80       	push   $0x80107fab
80103de9:	e8 a2 c5 ff ff       	call   80100390 <panic>
80103dee:	66 90                	xchg   %ax,%ax

80103df0 <yield>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103df7:	68 c0 4d 13 80       	push   $0x80134dc0
80103dfc:	e8 0f 0d 00 00       	call   80104b10 <acquire>
  pushcli();
80103e01:	e8 3a 0c 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103e06:	e8 c5 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103e0b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e11:	e8 6a 0c 00 00       	call   80104a80 <popcli>
  myproc()->state = RUNNABLE;
80103e16:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e1d:	e8 de fd ff ff       	call   80103c00 <sched>
  release(&ptable.lock);
80103e22:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103e29:	e8 a2 0d 00 00       	call   80104bd0 <release>
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
80103e4f:	e8 ec 0b 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103e54:	e8 77 f9 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103e59:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e5f:	e8 1c 0c 00 00       	call   80104a80 <popcli>
  if(p == 0)
80103e64:	85 db                	test   %ebx,%ebx
80103e66:	0f 84 87 00 00 00    	je     80103ef3 <sleep+0xb3>
  if(lk == 0)
80103e6c:	85 f6                	test   %esi,%esi
80103e6e:	74 76                	je     80103ee6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e70:	81 fe c0 4d 13 80    	cmp    $0x80134dc0,%esi
80103e76:	74 50                	je     80103ec8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	68 c0 4d 13 80       	push   $0x80134dc0
80103e80:	e8 8b 0c 00 00       	call   80104b10 <acquire>
    release(lk);
80103e85:	89 34 24             	mov    %esi,(%esp)
80103e88:	e8 43 0d 00 00       	call   80104bd0 <release>
  p->chan = chan;
80103e8d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e90:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e97:	e8 64 fd ff ff       	call   80103c00 <sched>
  p->chan = 0;
80103e9c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ea3:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
80103eaa:	e8 21 0d 00 00       	call   80104bd0 <release>
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
80103ebc:	e9 4f 0c 00 00       	jmp    80104b10 <acquire>
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
80103ee9:	68 c4 7f 10 80       	push   $0x80107fc4
80103eee:	e8 9d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ef3:	83 ec 0c             	sub    $0xc,%esp
80103ef6:	68 24 81 10 80       	push   $0x80108124
80103efb:	e8 90 c4 ff ff       	call   80100390 <panic>

80103f00 <wait>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
  pushcli();
80103f05:	e8 36 0b 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103f0a:	e8 c1 f8 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80103f0f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f15:	e8 66 0b 00 00       	call   80104a80 <popcli>
  acquire(&ptable.lock);
80103f1a:	83 ec 0c             	sub    $0xc,%esp
80103f1d:	68 c0 4d 13 80       	push   $0x80134dc0
80103f22:	e8 e9 0b 00 00       	call   80104b10 <acquire>
80103f27:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f2a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f2c:	bb f4 4d 13 80       	mov    $0x80134df4,%ebx
80103f31:	eb 13                	jmp    80103f46 <wait+0x46>
80103f33:	90                   	nop
80103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f38:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
80103f3e:	81 fb f4 80 16 80    	cmp    $0x801680f4,%ebx
80103f44:	73 1e                	jae    80103f64 <wait+0x64>
      if(p->parent != curproc)
80103f46:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f49:	75 ed                	jne    80103f38 <wait+0x38>
      if(p->state == ZOMBIE){
80103f4b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f4f:	74 37                	je     80103f88 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f51:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
      havekids = 1;
80103f57:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	81 fb f4 80 16 80    	cmp    $0x801680f4,%ebx
80103f62:	72 e2                	jb     80103f46 <wait+0x46>
    if(!havekids || curproc->killed){
80103f64:	85 c0                	test   %eax,%eax
80103f66:	74 76                	je     80103fde <wait+0xde>
80103f68:	8b 46 24             	mov    0x24(%esi),%eax
80103f6b:	85 c0                	test   %eax,%eax
80103f6d:	75 6f                	jne    80103fde <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f6f:	83 ec 08             	sub    $0x8,%esp
80103f72:	68 c0 4d 13 80       	push   $0x80134dc0
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
80103fa1:	e8 0a 37 00 00       	call   801076b0 <freevm>
        release(&ptable.lock);
80103fa6:	c7 04 24 c0 4d 13 80 	movl   $0x80134dc0,(%esp)
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
80103fcd:	e8 fe 0b 00 00       	call   80104bd0 <release>
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
80103fe6:	68 c0 4d 13 80       	push   $0x80134dc0
80103feb:	e8 e0 0b 00 00       	call   80104bd0 <release>
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
8010400a:	68 c0 4d 13 80       	push   $0x80134dc0
8010400f:	e8 fc 0a 00 00       	call   80104b10 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104017:	b8 f4 4d 13 80       	mov    $0x80134df4,%eax
8010401c:	eb 0e                	jmp    8010402c <wakeup+0x2c>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	05 cc 0c 00 00       	add    $0xccc,%eax
80104025:	3d f4 80 16 80       	cmp    $0x801680f4,%eax
8010402a:	73 1e                	jae    8010404a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010402c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104030:	75 ee                	jne    80104020 <wakeup+0x20>
80104032:	3b 58 20             	cmp    0x20(%eax),%ebx
80104035:	75 e9                	jne    80104020 <wakeup+0x20>
      p->state = RUNNABLE;
80104037:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403e:	05 cc 0c 00 00       	add    $0xccc,%eax
80104043:	3d f4 80 16 80       	cmp    $0x801680f4,%eax
80104048:	72 e2                	jb     8010402c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010404a:	c7 45 08 c0 4d 13 80 	movl   $0x80134dc0,0x8(%ebp)
}
80104051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104054:	c9                   	leave  
  release(&ptable.lock);
80104055:	e9 76 0b 00 00       	jmp    80104bd0 <release>
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
80104066:	bf 04 4e 13 80       	mov    $0x80134e04,%edi
  for(i = 0 ; i < NPROC; i++){
8010406b:	31 db                	xor    %ebx,%ebx
int sig_send(int dest_pid, int sig_num, char *sig_arg){
8010406d:	83 ec 1c             	sub    $0x1c,%esp
80104070:	eb 18                	jmp    8010408a <sig_send.part.2+0x2a>
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0 ; i < NPROC; i++){
80104078:	83 c3 01             	add    $0x1,%ebx
8010407b:	81 c7 cc 0c 00 00    	add    $0xccc,%edi
80104081:	83 fb 40             	cmp    $0x40,%ebx
80104084:	0f 84 db 00 00 00    	je     80104165 <sig_send.part.2+0x105>
    if(ptable.proc[i].pid == pid)
8010408a:	39 07                	cmp    %eax,(%edi)
8010408c:	75 ea                	jne    80104078 <sig_send.part.2+0x18>
8010408e:	69 fb cc 0c 00 00    	imul   $0xccc,%ebx,%edi
  // b = (uint)ptable.proc[id].sig_htable[sig_num];

  // debug:
  // cprintf("sigh : %d\n",b);

  acquire(&SigQueue->lock);
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	89 d6                	mov    %edx,%esi
80104099:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010409c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010409f:	8d 87 84 4e 13 80    	lea    -0x7fecb17c(%edi),%eax
801040a5:	50                   	push   %eax
801040a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040a9:	e8 62 0a 00 00       	call   80104b10 <acquire>
  if(ptable.proc[id].sig_htable[sig_num] == 0){
801040ae:	69 c3 33 03 00 00    	imul   $0x333,%ebx,%eax
801040b4:	83 c4 10             	add    $0x10,%esp
801040b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801040ba:	8d 44 06 28          	lea    0x28(%esi,%eax,1),%eax
801040be:	8b 04 85 d0 4d 13 80 	mov    -0x7fecb230(,%eax,4),%eax
801040c5:	85 c0                	test   %eax,%eax
801040c7:	0f 84 ab 00 00 00    	je     80104178 <sig_send.part.2+0x118>
    release(&SigQueue->lock);
    return 0;
  }

  if((SigQueue->end + 1) % SIG_QUE_SIZE == SigQueue->start){
801040cd:	8b 8f bc 5a 13 80    	mov    -0x7feca544(%edi),%ecx
801040d3:	8d 87 c0 4d 13 80    	lea    -0x7fecb240(%edi),%eax
801040d9:	89 c6                	mov    %eax,%esi
801040db:	8d 41 01             	lea    0x1(%ecx),%eax
801040de:	99                   	cltd   
801040df:	c1 ea 18             	shr    $0x18,%edx
801040e2:	01 d0                	add    %edx,%eax
801040e4:	0f b6 c0             	movzbl %al,%eax
801040e7:	29 d0                	sub    %edx,%eax
801040e9:	3b 86 f8 0c 00 00    	cmp    0xcf8(%esi),%eax
801040ef:	74 66                	je     80104157 <sig_send.part.2+0xf7>
    release(&SigQueue->lock);
    return -1;
  }

  // copy the data in queue
  SigQueue->sig_num_list[SigQueue->end] = sig_num;
801040f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801040f4:	8b 75 dc             	mov    -0x24(%ebp),%esi
  int i;
  for(i = 0; i < MSGSIZE; i++)
801040f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  SigQueue->sig_num_list[SigQueue->end] = sig_num;
801040fa:	8d 94 11 3c 02 00 00 	lea    0x23c(%ecx,%edx,1),%edx
80104101:	8d 0c cf             	lea    (%edi,%ecx,8),%ecx
80104104:	89 34 95 c8 4d 13 80 	mov    %esi,-0x7fecb238(,%edx,4)
  for(i = 0; i < MSGSIZE; i++)
8010410b:	8b 75 d8             	mov    -0x28(%ebp),%esi
8010410e:	31 d2                	xor    %edx,%edx
    SigQueue->sig_arg[SigQueue->end][i] = sig_arg[i];
80104110:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80104114:	88 84 11 b8 4e 13 80 	mov    %al,-0x7fecb148(%ecx,%edx,1)
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
80104129:	69 db cc 0c 00 00    	imul   $0xccc,%ebx,%ebx
8010412f:	89 83 bc 5a 13 80    	mov    %eax,-0x7feca544(%ebx)
  wakeup(&SigQueue->start);
80104135:	8d 87 b8 5a 13 80    	lea    -0x7feca548(%edi),%eax
8010413b:	50                   	push   %eax
8010413c:	e8 bf fe ff ff       	call   80104000 <wakeup>

  release(&SigQueue->lock);
80104141:	5a                   	pop    %edx
80104142:	ff 75 e4             	pushl  -0x1c(%ebp)
80104145:	e8 86 0a 00 00       	call   80104bd0 <release>
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
8010415d:	e8 6e 0a 00 00       	call   80104bd0 <release>
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
8010417e:	e8 4d 0a 00 00       	call   80104bd0 <release>
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
8010419a:	68 c0 4d 13 80       	push   $0x80134dc0
8010419f:	e8 6c 09 00 00       	call   80104b10 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a7:	b8 f4 4d 13 80       	mov    $0x80134df4,%eax
801041ac:	eb 0e                	jmp    801041bc <kill+0x2c>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	05 cc 0c 00 00       	add    $0xccc,%eax
801041b5:	3d f4 80 16 80       	cmp    $0x801680f4,%eax
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
801041d8:	68 c0 4d 13 80       	push   $0x80134dc0
801041dd:	e8 ee 09 00 00       	call   80104bd0 <release>
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
801041f3:	68 c0 4d 13 80       	push   $0x80134dc0
801041f8:	e8 d3 09 00 00       	call   80104bd0 <release>
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
80104219:	bb f4 4d 13 80       	mov    $0x80134df4,%ebx
{
8010421e:	83 ec 3c             	sub    $0x3c,%esp
80104221:	eb 27                	jmp    8010424a <procdump+0x3a>
80104223:	90                   	nop
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 c7 84 10 80       	push   $0x801084c7
80104230:	e8 2b c4 ff ff       	call   80100660 <cprintf>
80104235:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104238:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
8010423e:	81 fb f4 80 16 80    	cmp    $0x801680f4,%ebx
80104244:	0f 83 86 00 00 00    	jae    801042d0 <procdump+0xc0>
    if(p->state == UNUSED)
8010424a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010424d:	85 c0                	test   %eax,%eax
8010424f:	74 e7                	je     80104238 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104251:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104254:	ba d5 7f 10 80       	mov    $0x80107fd5,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104259:	77 11                	ja     8010426c <procdump+0x5c>
8010425b:	8b 14 85 44 80 10 80 	mov    -0x7fef7fbc(,%eax,4),%edx
      state = "???";
80104262:	b8 d5 7f 10 80       	mov    $0x80107fd5,%eax
80104267:	85 d2                	test   %edx,%edx
80104269:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010426c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010426f:	50                   	push   %eax
80104270:	52                   	push   %edx
80104271:	ff 73 10             	pushl  0x10(%ebx)
80104274:	68 d9 7f 10 80       	push   $0x80107fd9
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
8010429b:	e8 50 07 00 00       	call   801049f0 <getcallerpcs>
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
801042b9:	68 21 7a 10 80       	push   $0x80107a21
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
801042e4:	bb 60 4e 13 80       	mov    $0x80134e60,%ebx
801042e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801042ec:	68 c0 4d 13 80       	push   $0x80134dc0
801042f1:	e8 1a 08 00 00       	call   80104b10 <acquire>
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	eb 13                	jmp    8010430e <ps_print_list+0x2e>
801042fb:	90                   	nop
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104300:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
  for(i = 0; i < NPROC; i++){
80104306:	81 fb 60 81 16 80    	cmp    $0x80168160,%ebx
8010430c:	74 29                	je     80104337 <ps_print_list+0x57>
    if(ptable.proc[i].state != UNUSED){
8010430e:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104311:	85 c0                	test   %eax,%eax
80104313:	74 eb                	je     80104300 <ps_print_list+0x20>
      cprintf("pid:%d name:%s\n", ptable.proc[i].pid, ptable.proc[i].name);
80104315:	83 ec 04             	sub    $0x4,%esp
80104318:	53                   	push   %ebx
80104319:	ff 73 a4             	pushl  -0x5c(%ebx)
8010431c:	81 c3 cc 0c 00 00    	add    $0xccc,%ebx
80104322:	68 e2 7f 10 80       	push   $0x80107fe2
80104327:	e8 34 c3 ff ff       	call   80100660 <cprintf>
8010432c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPROC; i++){
8010432f:	81 fb 60 81 16 80    	cmp    $0x80168160,%ebx
80104335:	75 d7                	jne    8010430e <ps_print_list+0x2e>
  release(&ptable.lock);
80104337:	83 ec 0c             	sub    $0xc,%esp
8010433a:	68 c0 4d 13 80       	push   $0x80134dc0
8010433f:	e8 8c 08 00 00       	call   80104bd0 <release>
}
80104344:	83 c4 10             	add    $0x10,%esp
80104347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010434a:	c9                   	leave  
8010434b:	c3                   	ret    
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104350 <get_process_id>:
get_process_id(int pid){
80104350:	55                   	push   %ebp
80104351:	ba 04 4e 13 80       	mov    $0x80134e04,%edx
  for(i = 0 ; i < NPROC; i++){
80104356:	31 c0                	xor    %eax,%eax
get_process_id(int pid){
80104358:	89 e5                	mov    %esp,%ebp
8010435a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010435d:	eb 0f                	jmp    8010436e <get_process_id+0x1e>
8010435f:	90                   	nop
  for(i = 0 ; i < NPROC; i++){
80104360:	83 c0 01             	add    $0x1,%eax
80104363:	81 c2 cc 0c 00 00    	add    $0xccc,%edx
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
80104381:	b8 04 4e 13 80       	mov    $0x80134e04,%eax
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
801043a3:	05 cc 0c 00 00       	add    $0xccc,%eax
801043a8:	83 fb 40             	cmp    $0x40,%ebx
801043ab:	0f 84 a3 00 00 00    	je     80104454 <send_msg+0xd4>
    if(ptable.proc[i].pid == pid)
801043b1:	3b 10                	cmp    (%eax),%edx
801043b3:	75 eb                	jne    801043a0 <send_msg+0x20>
801043b5:	69 c3 40 08 00 00    	imul   $0x840,%ebx,%eax
  acquire(&MsgQueue[id].lock);
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	8d b8 c0 0f 11 80    	lea    -0x7feef040(%eax),%edi
801043c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043c7:	57                   	push   %edi
801043c8:	e8 43 07 00 00       	call   80104b10 <acquire>
  if((MsgQueue[id].end + 1) % BUFFER_SIZE == MsgQueue[id].start){
801043cd:	8b 87 38 08 00 00    	mov    0x838(%edi),%eax
801043d3:	83 c4 10             	add    $0x10,%esp
801043d6:	8d 48 01             	lea    0x1(%eax),%ecx
801043d9:	89 ca                	mov    %ecx,%edx
801043db:	c1 fa 1f             	sar    $0x1f,%edx
801043de:	c1 ea 18             	shr    $0x18,%edx
801043e1:	01 d1                	add    %edx,%ecx
801043e3:	0f b6 c9             	movzbl %cl,%ecx
801043e6:	29 d1                	sub    %edx,%ecx
801043e8:	3b 8f 34 08 00 00    	cmp    0x834(%edi),%ecx
801043ee:	74 58                	je     80104448 <send_msg+0xc8>
801043f0:	69 d3 08 01 00 00    	imul   $0x108,%ebx,%edx
  for(i = 0; i < MSGSIZE; i++){
801043f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801043f9:	01 c2                	add    %eax,%edx
801043fb:	31 c0                	xor    %eax,%eax
801043fd:	c1 e2 03             	shl    $0x3,%edx
    MsgQueue[id].data[MsgQueue[id].end][i] = msg[i];
80104400:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104404:	88 8c 02 f4 0f 11 80 	mov    %cl,-0x7feef00c(%edx,%eax,1)
  for(i = 0; i < MSGSIZE; i++){
8010440b:	83 c0 01             	add    $0x1,%eax
8010440e:	83 f8 08             	cmp    $0x8,%eax
80104411:	75 ed                	jne    80104400 <send_msg+0x80>
  wakeup(&MsgQueue[id].channel);
80104413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  MsgQueue[id].end %= BUFFER_SIZE;
8010441c:	69 db 40 08 00 00    	imul   $0x840,%ebx,%ebx
  wakeup(&MsgQueue[id].channel);
80104422:	05 fc 17 11 80       	add    $0x801117fc,%eax
80104427:	50                   	push   %eax
  MsgQueue[id].end %= BUFFER_SIZE;
80104428:	89 8b f8 17 11 80    	mov    %ecx,-0x7feee808(%ebx)
  wakeup(&MsgQueue[id].channel);
8010442e:	e8 cd fb ff ff       	call   80104000 <wakeup>
  release(&MsgQueue[id].lock);
80104433:	89 3c 24             	mov    %edi,(%esp)
80104436:	e8 95 07 00 00       	call   80104bd0 <release>
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
8010444c:	e8 7f 07 00 00       	call   80104bd0 <release>
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
8010447b:	e8 c0 05 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80104480:	e8 4b f3 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104485:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448b:	e8 f0 05 00 00       	call   80104a80 <popcli>
80104490:	ba 04 4e 13 80       	mov    $0x80134e04,%edx
  int rec_id = myproc()->pid;
80104495:	8b 4b 10             	mov    0x10(%ebx),%ecx
80104498:	eb 18                	jmp    801044b2 <recv_msg+0x42>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0 ; i < NPROC; i++){
801044a0:	83 c6 01             	add    $0x1,%esi
801044a3:	81 c2 cc 0c 00 00    	add    $0xccc,%edx
801044a9:	83 fe 40             	cmp    $0x40,%esi
801044ac:	0f 84 c6 00 00 00    	je     80104578 <recv_msg+0x108>
    if(ptable.proc[i].pid == pid)
801044b2:	3b 0a                	cmp    (%edx),%ecx
801044b4:	75 ea                	jne    801044a0 <recv_msg+0x30>
801044b6:	69 fe 40 08 00 00    	imul   $0x840,%esi,%edi
  acquire(&MsgQueue[id].lock);
801044bc:	83 ec 0c             	sub    $0xc,%esp
801044bf:	8d 9f c0 0f 11 80    	lea    -0x7feef040(%edi),%ebx
801044c5:	53                   	push   %ebx
801044c6:	e8 45 06 00 00       	call   80104b10 <acquire>
    if(MsgQueue[id].end == MsgQueue[id].start){
801044cb:	8b 8b 34 08 00 00    	mov    0x834(%ebx),%ecx
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	3b 8b 38 08 00 00    	cmp    0x838(%ebx),%ecx
      sleep(&MsgQueue[id].channel, &MsgQueue[id].lock);
801044da:	8d 87 fc 17 11 80    	lea    -0x7feee804(%edi),%eax
    if(MsgQueue[id].end == MsgQueue[id].start){
801044e0:	89 df                	mov    %ebx,%edi
      sleep(&MsgQueue[id].channel, &MsgQueue[id].lock);
801044e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(MsgQueue[id].end == MsgQueue[id].start){
801044e5:	75 26                	jne    8010450d <recv_msg+0x9d>
801044e7:	89 f6                	mov    %esi,%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      sleep(&MsgQueue[id].channel, &MsgQueue[id].lock);
801044f0:	83 ec 08             	sub    $0x8,%esp
801044f3:	53                   	push   %ebx
801044f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801044f7:	e8 44 f9 ff ff       	call   80103e40 <sleep>
    if(MsgQueue[id].end == MsgQueue[id].start){
801044fc:	8b 8f 34 08 00 00    	mov    0x834(%edi),%ecx
80104502:	83 c4 10             	add    $0x10,%esp
80104505:	39 8f 38 08 00 00    	cmp    %ecx,0x838(%edi)
8010450b:	74 e3                	je     801044f0 <recv_msg+0x80>
        msg[i] = MsgQueue[id].data[MsgQueue[id].start][i];
8010450d:	69 c6 40 08 00 00    	imul   $0x840,%esi,%eax
      for(i = 0; i < MSGSIZE; i++){
80104513:	31 d2                	xor    %edx,%edx
80104515:	8d b8 c0 0f 11 80    	lea    -0x7feef040(%eax),%edi
8010451b:	eb 09                	jmp    80104526 <recv_msg+0xb6>
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
80104520:	8b 8f 34 08 00 00    	mov    0x834(%edi),%ecx
        msg[i] = MsgQueue[id].data[MsgQueue[id].start][i];
80104526:	8d 8c c8 c0 0f 11 80 	lea    -0x7feef040(%eax,%ecx,8),%ecx
8010452d:	8b 75 08             	mov    0x8(%ebp),%esi
80104530:	0f b6 4c 11 34       	movzbl 0x34(%ecx,%edx,1),%ecx
80104535:	88 0c 16             	mov    %cl,(%esi,%edx,1)
      for(i = 0; i < MSGSIZE; i++){
80104538:	83 c2 01             	add    $0x1,%edx
8010453b:	83 fa 08             	cmp    $0x8,%edx
8010453e:	75 e0                	jne    80104520 <recv_msg+0xb0>
      MsgQueue[id].start++;
80104540:	8b b8 f4 17 11 80    	mov    -0x7feee80c(%eax),%edi
      release(&MsgQueue[id].lock);
80104546:	83 ec 0c             	sub    $0xc,%esp
80104549:	53                   	push   %ebx
      MsgQueue[id].start++;
8010454a:	8d 57 01             	lea    0x1(%edi),%edx
      MsgQueue[id].start %= BUFFER_SIZE;
8010454d:	89 d1                	mov    %edx,%ecx
8010454f:	c1 f9 1f             	sar    $0x1f,%ecx
80104552:	c1 e9 18             	shr    $0x18,%ecx
80104555:	01 ca                	add    %ecx,%edx
80104557:	0f b6 d2             	movzbl %dl,%edx
8010455a:	29 ca                	sub    %ecx,%edx
8010455c:	89 90 f4 17 11 80    	mov    %edx,-0x7feee80c(%eax)
      release(&MsgQueue[id].lock);
80104562:	e8 69 06 00 00       	call   80104bd0 <release>
  return 0;
80104567:	83 c4 10             	add    $0x10,%esp
}
8010456a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010456d:	31 c0                	xor    %eax,%eax
}
8010456f:	5b                   	pop    %ebx
80104570:	5e                   	pop    %esi
80104571:	5f                   	pop    %edi
80104572:	5d                   	pop    %ebp
80104573:	c3                   	ret    
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
8010459d:	e8 9e 04 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801045a2:	e8 29 f2 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801045a7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045ad:	e8 ce 04 00 00       	call   80104a80 <popcli>
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

int sig_pause(volatile int *flag_addr, int flag_expected){
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
  pushcli();
801045f5:	e8 46 04 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801045fa:	e8 d1 f1 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801045ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104605:	e8 76 04 00 00       	call   80104a80 <popcli>
8010460a:	ba 04 4e 13 80       	mov    $0x80134e04,%edx
  for(i = 0 ; i < NPROC; i++){
8010460f:	31 c0                	xor    %eax,%eax
  int pid = myproc()->pid;
80104611:	8b 4b 10             	mov    0x10(%ebx),%ecx
80104614:	eb 18                	jmp    8010462e <sig_pause+0x3e>
80104616:	8d 76 00             	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i = 0 ; i < NPROC; i++){
80104620:	83 c0 01             	add    $0x1,%eax
80104623:	81 c2 cc 0c 00 00    	add    $0xccc,%edx
80104629:	83 f8 40             	cmp    $0x40,%eax
8010462c:	74 62                	je     80104690 <sig_pause+0xa0>
    if(ptable.proc[i].pid == pid)
8010462e:	3b 0a                	cmp    (%edx),%ecx
80104630:	75 ee                	jne    80104620 <sig_pause+0x30>
80104632:	69 d8 cc 0c 00 00    	imul   $0xccc,%eax,%ebx
  int id = get_process_id(pid);
  if(id == -1) return -1;
  
  acquire(&ptable.proc[id].SigQueue.lock);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d b3 84 4e 13 80    	lea    -0x7fecb17c(%ebx),%esi
80104641:	56                   	push   %esi
80104642:	e8 c9 04 00 00       	call   80104b10 <acquire>
  // debug:
  cprintf("s");
80104647:	c7 04 24 e0 7f 10 80 	movl   $0x80107fe0,(%esp)
8010464e:	e8 0d c0 ff ff       	call   80100660 <cprintf>
  
  if(*flag_addr != flag_expected && ptable.proc[id].SigQueue.end == ptable.proc[id].SigQueue.start){
80104653:	8b 45 08             	mov    0x8(%ebp),%eax
80104656:	83 c4 10             	add    $0x10,%esp
80104659:	8b 00                	mov    (%eax),%eax
8010465b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010465e:	74 0e                	je     8010466e <sig_pause+0x7e>
80104660:	8b 83 b8 5a 13 80    	mov    -0x7feca548(%ebx),%eax
80104666:	39 83 bc 5a 13 80    	cmp    %eax,-0x7feca544(%ebx)
8010466c:	74 32                	je     801046a0 <sig_pause+0xb0>
    sleep(&ptable.proc[id].SigQueue.start, &ptable.proc[id].SigQueue.lock);
    // debug:
    // cprintf("Pause : Sleep done\n");
  }
  // debug:
  cprintf("e");
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	68 c8 7b 10 80       	push   $0x80107bc8
80104676:	e8 e5 bf ff ff       	call   80100660 <cprintf>
  release(&ptable.proc[id].SigQueue.lock);
8010467b:	89 34 24             	mov    %esi,(%esp)
8010467e:	e8 4d 05 00 00       	call   80104bd0 <release>
  return 0;
80104683:	83 c4 10             	add    $0x10,%esp
}
80104686:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
80104689:	31 c0                	xor    %eax,%eax
}
8010468b:	5b                   	pop    %ebx
8010468c:	5e                   	pop    %esi
8010468d:	5d                   	pop    %ebp
8010468e:	c3                   	ret    
8010468f:	90                   	nop
80104690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(id == -1) return -1;
80104693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104698:	5b                   	pop    %ebx
80104699:	5e                   	pop    %esi
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(&ptable.proc[id].SigQueue.start, &ptable.proc[id].SigQueue.lock);
801046a0:	8d 83 b8 5a 13 80    	lea    -0x7feca548(%ebx),%eax
801046a6:	83 ec 08             	sub    $0x8,%esp
801046a9:	56                   	push   %esi
801046aa:	50                   	push   %eax
801046ab:	e8 90 f7 ff ff       	call   80103e40 <sleep>
801046b0:	83 c4 10             	add    $0x10,%esp
801046b3:	eb b9                	jmp    8010466e <sig_pause+0x7e>
801046b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <sig_ret>:

int sig_ret(void){
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801046c7:	e8 74 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801046cc:	e8 ff f0 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
801046d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046d7:	e8 a4 03 00 00       	call   80104a80 <popcli>
  uint ustack_esp = curproc->tf->esp;
  
  uint sig_ret_code_size = ((uint)&execute_sigret_syscall_end - (uint)&execute_sigret_syscall_start);
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
  // copy back the trapframe to kernel stack
  memmove((void *)curproc->tf, (void *)ustack_esp, sizeof(struct trapframe));
801046dc:	83 ec 04             	sub    $0x4,%esp
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
801046df:	b8 a0 48 10 80       	mov    $0x801048a0,%eax
  uint ustack_esp = curproc->tf->esp;
801046e4:	8b 53 18             	mov    0x18(%ebx),%edx
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
801046e7:	2d 8c 48 10 80       	sub    $0x8010488c,%eax
  memmove((void *)curproc->tf, (void *)ustack_esp, sizeof(struct trapframe));
801046ec:	6a 4c                	push   $0x4c
  ustack_esp += sizeof(uint) + MSGSIZE + sig_ret_code_size;
801046ee:	03 42 44             	add    0x44(%edx),%eax
  memmove((void *)curproc->tf, (void *)ustack_esp, sizeof(struct trapframe));
801046f1:	50                   	push   %eax
801046f2:	52                   	push   %edx
801046f3:	e8 d8 05 00 00       	call   80104cd0 <memmove>
  return 0;
}
801046f8:	31 c0                	xor    %eax,%eax
801046fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046fd:	c9                   	leave  
801046fe:	c3                   	ret    
801046ff:	90                   	nop

80104700 <execute_signal_handler>:

void execute_signal_handler(void){
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80104709:	e8 32 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010470e:	e8 bd f0 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104713:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104719:	e8 62 03 00 00       	call   80104a80 <popcli>
  pushcli();
8010471e:	e8 1d 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80104723:	e8 a8 f0 ff ff       	call   801037d0 <mycpu>
  p = c->proc;
80104728:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010472e:	e8 4d 03 00 00       	call   80104a80 <popcli>
  struct proc *curproc = myproc();
  struct sig_queue *SigQueue = &curproc->SigQueue;

  if(myproc() == 0 || (curproc->tf->cs & 3) != DPL_USER)
80104733:	85 f6                	test   %esi,%esi
80104735:	74 10                	je     80104747 <execute_signal_handler+0x47>
80104737:	8b 43 18             	mov    0x18(%ebx),%eax
8010473a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010473e:	83 e0 03             	and    $0x3,%eax
80104741:	66 83 f8 03          	cmp    $0x3,%ax
80104745:	74 09                	je     80104750 <execute_signal_handler+0x50>
  curproc->tf->esp = ustack_esp;
  // cprintf("esp : %d, uesp : %d\n", curproc->tf->esp, ustack_esp);

  release(&SigQueue->lock);
  return;
}
80104747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5f                   	pop    %edi
8010474d:	5d                   	pop    %ebp
8010474e:	c3                   	ret    
8010474f:	90                   	nop
  acquire(&SigQueue->lock);
80104750:	8d bb 90 00 00 00    	lea    0x90(%ebx),%edi
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	57                   	push   %edi
8010475a:	e8 b1 03 00 00       	call   80104b10 <acquire>
  if(SigQueue->start == SigQueue->end){
8010475f:	8b 83 c4 0c 00 00    	mov    0xcc4(%ebx),%eax
80104765:	83 c4 10             	add    $0x10,%esp
80104768:	3b 83 c8 0c 00 00    	cmp    0xcc8(%ebx),%eax
8010476e:	0f 84 c4 00 00 00    	je     80104838 <execute_signal_handler+0x138>
  int sig_num = SigQueue->sig_num_list[SigQueue->start];
80104774:	8b b4 83 c4 08 00 00 	mov    0x8c4(%ebx,%eax,4),%esi
  char* msg = SigQueue->sig_arg[SigQueue->start];
8010477b:	8d 54 c7 34          	lea    0x34(%edi,%eax,8),%edx
  SigQueue->start++;
8010477f:	83 c0 01             	add    $0x1,%eax
  SigQueue->start %= SIG_QUE_SIZE;
80104782:	89 c1                	mov    %eax,%ecx
  memmove((void *)ustack_esp, (void *)curproc->tf, sizeof(struct trapframe));
80104784:	83 ec 04             	sub    $0x4,%esp
  SigQueue->start %= SIG_QUE_SIZE;
80104787:	c1 f9 1f             	sar    $0x1f,%ecx
  char* msg = SigQueue->sig_arg[SigQueue->start];
8010478a:	89 55 d0             	mov    %edx,-0x30(%ebp)
  SigQueue->start %= SIG_QUE_SIZE;
8010478d:	c1 e9 18             	shr    $0x18,%ecx
80104790:	01 c8                	add    %ecx,%eax
80104792:	0f b6 c0             	movzbl %al,%eax
80104795:	29 c8                	sub    %ecx,%eax
80104797:	89 83 c4 0c 00 00    	mov    %eax,0xcc4(%ebx)
  uint ustack_esp = curproc->tf->esp;
8010479d:	8b 43 18             	mov    0x18(%ebx),%eax
  ustack_esp -= sizeof(struct trapframe);
801047a0:	8b 50 44             	mov    0x44(%eax),%edx
  memmove((void *)ustack_esp, (void *)curproc->tf, sizeof(struct trapframe));
801047a3:	6a 4c                	push   $0x4c
801047a5:	50                   	push   %eax
  ustack_esp -= sizeof(struct trapframe);
801047a6:	8d 4a b4             	lea    -0x4c(%edx),%ecx
  memmove((void *)ustack_esp, (void *)curproc->tf, sizeof(struct trapframe));
801047a9:	51                   	push   %ecx
801047aa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
801047ad:	e8 1e 05 00 00       	call   80104cd0 <memmove>
  curproc->tf->eip = (uint)curproc->sig_htable[sig_num];
801047b2:	8b 43 18             	mov    0x18(%ebx),%eax
801047b5:	8b 74 b3 7c          	mov    0x7c(%ebx,%esi,4),%esi
  memmove((void *)ustack_esp, sig_ret_code_addr, sig_ret_code_size);
801047b9:	83 c4 0c             	add    $0xc,%esp
  ustack_esp -= sig_ret_code_size;
801047bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  curproc->tf->eip = (uint)curproc->sig_htable[sig_num];
801047bf:	89 70 38             	mov    %esi,0x38(%eax)
  uint sig_ret_code_size = ((uint)&execute_sigret_syscall_end - (uint)&execute_sigret_syscall_start);
801047c2:	b8 94 48 10 80       	mov    $0x80104894,%eax
801047c7:	2d 8c 48 10 80       	sub    $0x8010488c,%eax
  ustack_esp -= sig_ret_code_size;
801047cc:	29 c1                	sub    %eax,%ecx
  memmove((void *)ustack_esp, sig_ret_code_addr, sig_ret_code_size);
801047ce:	50                   	push   %eax
801047cf:	68 8c 48 10 80       	push   $0x8010488c
801047d4:	51                   	push   %ecx
  ustack_esp -= sig_ret_code_size;
801047d5:	89 ce                	mov    %ecx,%esi
  uint handler_ret_addr = ustack_esp;
801047d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  memmove((void *)ustack_esp, sig_ret_code_addr, sig_ret_code_size);
801047da:	e8 f1 04 00 00       	call   80104cd0 <memmove>
  memmove((void *)ustack_esp, (void *)msg, MSGSIZE); 
801047df:	8b 55 d0             	mov    -0x30(%ebp),%edx
  ustack_esp -= MSGSIZE;
801047e2:	8d 46 f8             	lea    -0x8(%esi),%eax
  memmove((void *)ustack_esp, (void *)msg, MSGSIZE); 
801047e5:	83 c4 0c             	add    $0xc,%esp
801047e8:	6a 08                	push   $0x8
  uint para1 = ustack_esp;
801047ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memmove((void *)ustack_esp, (void *)msg, MSGSIZE); 
801047ed:	52                   	push   %edx
801047ee:	50                   	push   %eax
801047ef:	e8 dc 04 00 00       	call   80104cd0 <memmove>
  memmove((void *)ustack_esp, (void *)&para1, sizeof(uint));
801047f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801047f7:	83 c4 0c             	add    $0xc,%esp
801047fa:	6a 04                	push   $0x4
801047fc:	50                   	push   %eax
  ustack_esp -= sizeof(uint);
801047fd:	8d 46 f4             	lea    -0xc(%esi),%eax
  ustack_esp -= sizeof(uint);
80104800:	83 ee 10             	sub    $0x10,%esi
  memmove((void *)ustack_esp, (void *)&para1, sizeof(uint));
80104803:	50                   	push   %eax
80104804:	e8 c7 04 00 00       	call   80104cd0 <memmove>
  memmove((void *)ustack_esp, (void *)&handler_ret_addr, sizeof(uint));
80104809:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010480c:	83 c4 0c             	add    $0xc,%esp
8010480f:	6a 04                	push   $0x4
80104811:	50                   	push   %eax
80104812:	56                   	push   %esi
80104813:	e8 b8 04 00 00       	call   80104cd0 <memmove>
  curproc->tf->esp = ustack_esp;
80104818:	8b 43 18             	mov    0x18(%ebx),%eax
8010481b:	89 70 44             	mov    %esi,0x44(%eax)
  release(&SigQueue->lock);
8010481e:	89 3c 24             	mov    %edi,(%esp)
80104821:	e8 aa 03 00 00       	call   80104bd0 <release>
  return;
80104826:	83 c4 10             	add    $0x10,%esp
}
80104829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010482c:	5b                   	pop    %ebx
8010482d:	5e                   	pop    %esi
8010482e:	5f                   	pop    %edi
8010482f:	5d                   	pop    %ebp
80104830:	c3                   	ret    
80104831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&SigQueue->lock);
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	57                   	push   %edi
8010483c:	e8 8f 03 00 00       	call   80104bd0 <release>
    return;
80104841:	83 c4 10             	add    $0x10,%esp
80104844:	e9 fe fe ff ff       	jmp    80104747 <execute_signal_handler+0x47>
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104850 <send_multi>:

// ********** multicasting ***************

int send_multi(int sender_pid, int rec_pids[], char *msg, int rec_length){
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	83 ec 0c             	sub    $0xc,%esp
80104859:	8b 45 14             	mov    0x14(%ebp),%eax
8010485c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;
  // debug:
  // cprintf("rec_length %d\n",rec_length);
  for(i = 0; i < rec_length; i++){
8010485f:	85 c0                	test   %eax,%eax
80104861:	7e 1f                	jle    80104882 <send_multi+0x32>
80104863:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104866:	8d 3c 83             	lea    (%ebx,%eax,4),%edi
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104870:	8b 03                	mov    (%ebx),%eax
80104872:	31 d2                	xor    %edx,%edx
80104874:	89 f1                	mov    %esi,%ecx
80104876:	83 c3 04             	add    $0x4,%ebx
80104879:	e8 e2 f7 ff ff       	call   80104060 <sig_send.part.2>
8010487e:	39 df                	cmp    %ebx,%edi
80104880:	75 ee                	jne    80104870 <send_multi+0x20>
    sig_send(rec_pids[i], 0, msg);
  }
  return 0;
80104882:	83 c4 0c             	add    $0xc,%esp
80104885:	31 c0                	xor    %eax,%eax
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5f                   	pop    %edi
8010488a:	5d                   	pop    %ebp
8010488b:	c3                   	ret    

8010488c <execute_sigret_syscall_start>:

.globl execute_sigret_syscall_start;
.globl execute_sigret_syscall_end;

execute_sigret_syscall_start:
	movl $SYS_sig_ret, %eax;
8010488c:	b8 20 00 00 00       	mov    $0x20,%eax
	int $T_SYSCALL;
80104891:	cd 40                	int    $0x40
	ret
80104893:	c3                   	ret    

80104894 <execute_sigret_syscall_end>:
80104894:	66 90                	xchg   %ax,%ax
80104896:	66 90                	xchg   %ax,%ax
80104898:	66 90                	xchg   %ax,%ax
8010489a:	66 90                	xchg   %ax,%ax
8010489c:	66 90                	xchg   %ax,%ax
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048aa:	68 5c 80 10 80       	push   $0x8010805c
801048af:	8d 43 04             	lea    0x4(%ebx),%eax
801048b2:	50                   	push   %eax
801048b3:	e8 18 01 00 00       	call   801049d0 <initlock>
  lk->name = name;
801048b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801048c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801048c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801048cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801048ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d1:	c9                   	leave  
801048d2:	c3                   	ret    
801048d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	8d 73 04             	lea    0x4(%ebx),%esi
801048ee:	56                   	push   %esi
801048ef:	e8 1c 02 00 00       	call   80104b10 <acquire>
  while (lk->locked) {
801048f4:	8b 13                	mov    (%ebx),%edx
801048f6:	83 c4 10             	add    $0x10,%esp
801048f9:	85 d2                	test   %edx,%edx
801048fb:	74 16                	je     80104913 <acquiresleep+0x33>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104900:	83 ec 08             	sub    $0x8,%esp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	e8 36 f5 ff ff       	call   80103e40 <sleep>
  while (lk->locked) {
8010490a:	8b 03                	mov    (%ebx),%eax
8010490c:	83 c4 10             	add    $0x10,%esp
8010490f:	85 c0                	test   %eax,%eax
80104911:	75 ed                	jne    80104900 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104913:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104919:	e8 52 ef ff ff       	call   80103870 <myproc>
8010491e:	8b 40 10             	mov    0x10(%eax),%eax
80104921:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104924:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104927:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010492a:	5b                   	pop    %ebx
8010492b:	5e                   	pop    %esi
8010492c:	5d                   	pop    %ebp
  release(&lk->lk);
8010492d:	e9 9e 02 00 00       	jmp    80104bd0 <release>
80104932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	8d 73 04             	lea    0x4(%ebx),%esi
8010494e:	56                   	push   %esi
8010494f:	e8 bc 01 00 00       	call   80104b10 <acquire>
  lk->locked = 0;
80104954:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010495a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104961:	89 1c 24             	mov    %ebx,(%esp)
80104964:	e8 97 f6 ff ff       	call   80104000 <wakeup>
  release(&lk->lk);
80104969:	89 75 08             	mov    %esi,0x8(%ebp)
8010496c:	83 c4 10             	add    $0x10,%esp
}
8010496f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104972:	5b                   	pop    %ebx
80104973:	5e                   	pop    %esi
80104974:	5d                   	pop    %ebp
  release(&lk->lk);
80104975:	e9 56 02 00 00       	jmp    80104bd0 <release>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	53                   	push   %ebx
80104986:	31 ff                	xor    %edi,%edi
80104988:	83 ec 18             	sub    $0x18,%esp
8010498b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010498e:	8d 73 04             	lea    0x4(%ebx),%esi
80104991:	56                   	push   %esi
80104992:	e8 79 01 00 00       	call   80104b10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104997:	8b 03                	mov    (%ebx),%eax
80104999:	83 c4 10             	add    $0x10,%esp
8010499c:	85 c0                	test   %eax,%eax
8010499e:	74 13                	je     801049b3 <holdingsleep+0x33>
801049a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801049a3:	e8 c8 ee ff ff       	call   80103870 <myproc>
801049a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801049ab:	0f 94 c0             	sete   %al
801049ae:	0f b6 c0             	movzbl %al,%eax
801049b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801049b3:	83 ec 0c             	sub    $0xc,%esp
801049b6:	56                   	push   %esi
801049b7:	e8 14 02 00 00       	call   80104bd0 <release>
  return r;
}
801049bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049bf:	89 f8                	mov    %edi,%eax
801049c1:	5b                   	pop    %ebx
801049c2:	5e                   	pop    %esi
801049c3:	5f                   	pop    %edi
801049c4:	5d                   	pop    %ebp
801049c5:	c3                   	ret    
801049c6:	66 90                	xchg   %ax,%ax
801049c8:	66 90                	xchg   %ax,%ax
801049ca:	66 90                	xchg   %ax,%ax
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801049d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801049d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801049df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801049e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    
801049eb:	90                   	nop
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801049f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049f1:	31 d2                	xor    %edx,%edx
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801049f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801049f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801049fc:	83 e8 08             	sub    $0x8,%eax
801049ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a00:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a06:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a0c:	77 1a                	ja     80104a28 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a0e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a11:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a14:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a17:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a19:	83 fa 0a             	cmp    $0xa,%edx
80104a1c:	75 e2                	jne    80104a00 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a1e:	5b                   	pop    %ebx
80104a1f:	5d                   	pop    %ebp
80104a20:	c3                   	ret    
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a28:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a2b:	83 c1 28             	add    $0x28,%ecx
80104a2e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a39:	39 c1                	cmp    %eax,%ecx
80104a3b:	75 f3                	jne    80104a30 <getcallerpcs+0x40>
}
80104a3d:	5b                   	pop    %ebx
80104a3e:	5d                   	pop    %ebp
80104a3f:	c3                   	ret    

80104a40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	9c                   	pushf  
80104a48:	5b                   	pop    %ebx
  asm volatile("cli");
80104a49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a4a:	e8 81 ed ff ff       	call   801037d0 <mycpu>
80104a4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a55:	85 c0                	test   %eax,%eax
80104a57:	75 11                	jne    80104a6a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a59:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a5f:	e8 6c ed ff ff       	call   801037d0 <mycpu>
80104a64:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a6a:	e8 61 ed ff ff       	call   801037d0 <mycpu>
80104a6f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a76:	83 c4 04             	add    $0x4,%esp
80104a79:	5b                   	pop    %ebx
80104a7a:	5d                   	pop    %ebp
80104a7b:	c3                   	ret    
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a80 <popcli>:

void
popcli(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a86:	9c                   	pushf  
80104a87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a88:	f6 c4 02             	test   $0x2,%ah
80104a8b:	75 35                	jne    80104ac2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a8d:	e8 3e ed ff ff       	call   801037d0 <mycpu>
80104a92:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a99:	78 34                	js     80104acf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a9b:	e8 30 ed ff ff       	call   801037d0 <mycpu>
80104aa0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104aa6:	85 d2                	test   %edx,%edx
80104aa8:	74 06                	je     80104ab0 <popcli+0x30>
    sti();
}
80104aaa:	c9                   	leave  
80104aab:	c3                   	ret    
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ab0:	e8 1b ed ff ff       	call   801037d0 <mycpu>
80104ab5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104abb:	85 c0                	test   %eax,%eax
80104abd:	74 eb                	je     80104aaa <popcli+0x2a>
  asm volatile("sti");
80104abf:	fb                   	sti    
}
80104ac0:	c9                   	leave  
80104ac1:	c3                   	ret    
    panic("popcli - interruptible");
80104ac2:	83 ec 0c             	sub    $0xc,%esp
80104ac5:	68 67 80 10 80       	push   $0x80108067
80104aca:	e8 c1 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	68 7e 80 10 80       	push   $0x8010807e
80104ad7:	e8 b4 b8 ff ff       	call   80100390 <panic>
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <holding>:
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	53                   	push   %ebx
80104ae5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ae8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104aea:	e8 51 ff ff ff       	call   80104a40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104aef:	8b 06                	mov    (%esi),%eax
80104af1:	85 c0                	test   %eax,%eax
80104af3:	74 10                	je     80104b05 <holding+0x25>
80104af5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104af8:	e8 d3 ec ff ff       	call   801037d0 <mycpu>
80104afd:	39 c3                	cmp    %eax,%ebx
80104aff:	0f 94 c3             	sete   %bl
80104b02:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104b05:	e8 76 ff ff ff       	call   80104a80 <popcli>
}
80104b0a:	89 d8                	mov    %ebx,%eax
80104b0c:	5b                   	pop    %ebx
80104b0d:	5e                   	pop    %esi
80104b0e:	5d                   	pop    %ebp
80104b0f:	c3                   	ret    

80104b10 <acquire>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b15:	e8 26 ff ff ff       	call   80104a40 <pushcli>
  if(holding(lk))
80104b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b1d:	83 ec 0c             	sub    $0xc,%esp
80104b20:	53                   	push   %ebx
80104b21:	e8 ba ff ff ff       	call   80104ae0 <holding>
80104b26:	83 c4 10             	add    $0x10,%esp
80104b29:	85 c0                	test   %eax,%eax
80104b2b:	0f 85 83 00 00 00    	jne    80104bb4 <acquire+0xa4>
80104b31:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b33:	ba 01 00 00 00       	mov    $0x1,%edx
80104b38:	eb 09                	jmp    80104b43 <acquire+0x33>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b43:	89 d0                	mov    %edx,%eax
80104b45:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	75 f4                	jne    80104b40 <acquire+0x30>
  __sync_synchronize();
80104b4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b54:	e8 77 ec ff ff       	call   801037d0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b59:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104b5c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b5f:	89 e8                	mov    %ebp,%eax
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b68:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104b6e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104b74:	77 1a                	ja     80104b90 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b76:	8b 48 04             	mov    0x4(%eax),%ecx
80104b79:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104b7c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b81:	83 fe 0a             	cmp    $0xa,%esi
80104b84:	75 e2                	jne    80104b68 <acquire+0x58>
}
80104b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104b93:	83 c2 28             	add    $0x28,%edx
80104b96:	8d 76 00             	lea    0x0(%esi),%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ba6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ba9:	39 d0                	cmp    %edx,%eax
80104bab:	75 f3                	jne    80104ba0 <acquire+0x90>
}
80104bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb0:	5b                   	pop    %ebx
80104bb1:	5e                   	pop    %esi
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
    panic("acquire");
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	68 85 80 10 80       	push   $0x80108085
80104bbc:	e8 cf b7 ff ff       	call   80100390 <panic>
80104bc1:	eb 0d                	jmp    80104bd0 <release>
80104bc3:	90                   	nop
80104bc4:	90                   	nop
80104bc5:	90                   	nop
80104bc6:	90                   	nop
80104bc7:	90                   	nop
80104bc8:	90                   	nop
80104bc9:	90                   	nop
80104bca:	90                   	nop
80104bcb:	90                   	nop
80104bcc:	90                   	nop
80104bcd:	90                   	nop
80104bce:	90                   	nop
80104bcf:	90                   	nop

80104bd0 <release>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 10             	sub    $0x10,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104bda:	53                   	push   %ebx
80104bdb:	e8 00 ff ff ff       	call   80104ae0 <holding>
80104be0:	83 c4 10             	add    $0x10,%esp
80104be3:	85 c0                	test   %eax,%eax
80104be5:	74 22                	je     80104c09 <release+0x39>
  lk->pcs[0] = 0;
80104be7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bf5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bfa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c03:	c9                   	leave  
  popcli();
80104c04:	e9 77 fe ff ff       	jmp    80104a80 <popcli>
    panic("release");
80104c09:	83 ec 0c             	sub    $0xc,%esp
80104c0c:	68 8d 80 10 80       	push   $0x8010808d
80104c11:	e8 7a b7 ff ff       	call   80100390 <panic>
80104c16:	66 90                	xchg   %ax,%ax
80104c18:	66 90                	xchg   %ax,%ax
80104c1a:	66 90                	xchg   %ax,%ax
80104c1c:	66 90                	xchg   %ax,%ax
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	53                   	push   %ebx
80104c25:	8b 55 08             	mov    0x8(%ebp),%edx
80104c28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c2b:	f6 c2 03             	test   $0x3,%dl
80104c2e:	75 05                	jne    80104c35 <memset+0x15>
80104c30:	f6 c1 03             	test   $0x3,%cl
80104c33:	74 13                	je     80104c48 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104c35:	89 d7                	mov    %edx,%edi
80104c37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3a:	fc                   	cld    
80104c3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c3d:	5b                   	pop    %ebx
80104c3e:	89 d0                	mov    %edx,%eax
80104c40:	5f                   	pop    %edi
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    
80104c43:	90                   	nop
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104c48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c4c:	c1 e9 02             	shr    $0x2,%ecx
80104c4f:	89 f8                	mov    %edi,%eax
80104c51:	89 fb                	mov    %edi,%ebx
80104c53:	c1 e0 18             	shl    $0x18,%eax
80104c56:	c1 e3 10             	shl    $0x10,%ebx
80104c59:	09 d8                	or     %ebx,%eax
80104c5b:	09 f8                	or     %edi,%eax
80104c5d:	c1 e7 08             	shl    $0x8,%edi
80104c60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c62:	89 d7                	mov    %edx,%edi
80104c64:	fc                   	cld    
80104c65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104c67:	5b                   	pop    %ebx
80104c68:	89 d0                	mov    %edx,%eax
80104c6a:	5f                   	pop    %edi
80104c6b:	5d                   	pop    %ebp
80104c6c:	c3                   	ret    
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c79:	8b 75 08             	mov    0x8(%ebp),%esi
80104c7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c7f:	85 db                	test   %ebx,%ebx
80104c81:	74 29                	je     80104cac <memcmp+0x3c>
    if(*s1 != *s2)
80104c83:	0f b6 16             	movzbl (%esi),%edx
80104c86:	0f b6 0f             	movzbl (%edi),%ecx
80104c89:	38 d1                	cmp    %dl,%cl
80104c8b:	75 2b                	jne    80104cb8 <memcmp+0x48>
80104c8d:	b8 01 00 00 00       	mov    $0x1,%eax
80104c92:	eb 14                	jmp    80104ca8 <memcmp+0x38>
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104c9c:	83 c0 01             	add    $0x1,%eax
80104c9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ca4:	38 ca                	cmp    %cl,%dl
80104ca6:	75 10                	jne    80104cb8 <memcmp+0x48>
  while(n-- > 0){
80104ca8:	39 d8                	cmp    %ebx,%eax
80104caa:	75 ec                	jne    80104c98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104cac:	5b                   	pop    %ebx
  return 0;
80104cad:	31 c0                	xor    %eax,%eax
}
80104caf:	5e                   	pop    %esi
80104cb0:	5f                   	pop    %edi
80104cb1:	5d                   	pop    %ebp
80104cb2:	c3                   	ret    
80104cb3:	90                   	nop
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104cb8:	0f b6 c2             	movzbl %dl,%eax
}
80104cbb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104cbc:	29 c8                	sub    %ecx,%eax
}
80104cbe:	5e                   	pop    %esi
80104cbf:	5f                   	pop    %edi
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret    
80104cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
80104cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104cdb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cde:	39 c3                	cmp    %eax,%ebx
80104ce0:	73 26                	jae    80104d08 <memmove+0x38>
80104ce2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ce5:	39 c8                	cmp    %ecx,%eax
80104ce7:	73 1f                	jae    80104d08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ce9:	85 f6                	test   %esi,%esi
80104ceb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104cee:	74 0f                	je     80104cff <memmove+0x2f>
      *--d = *--s;
80104cf0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104cf4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104cf7:	83 ea 01             	sub    $0x1,%edx
80104cfa:	83 fa ff             	cmp    $0xffffffff,%edx
80104cfd:	75 f1                	jne    80104cf0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cff:	5b                   	pop    %ebx
80104d00:	5e                   	pop    %esi
80104d01:	5d                   	pop    %ebp
80104d02:	c3                   	ret    
80104d03:	90                   	nop
80104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104d08:	31 d2                	xor    %edx,%edx
80104d0a:	85 f6                	test   %esi,%esi
80104d0c:	74 f1                	je     80104cff <memmove+0x2f>
80104d0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d1a:	39 d6                	cmp    %edx,%esi
80104d1c:	75 f2                	jne    80104d10 <memmove+0x40>
}
80104d1e:	5b                   	pop    %ebx
80104d1f:	5e                   	pop    %esi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    
80104d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104d34:	eb 9a                	jmp    80104cd0 <memmove>
80104d36:	8d 76 00             	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
80104d45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104d48:	53                   	push   %ebx
80104d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d4f:	85 ff                	test   %edi,%edi
80104d51:	74 2f                	je     80104d82 <strncmp+0x42>
80104d53:	0f b6 01             	movzbl (%ecx),%eax
80104d56:	0f b6 1e             	movzbl (%esi),%ebx
80104d59:	84 c0                	test   %al,%al
80104d5b:	74 37                	je     80104d94 <strncmp+0x54>
80104d5d:	38 c3                	cmp    %al,%bl
80104d5f:	75 33                	jne    80104d94 <strncmp+0x54>
80104d61:	01 f7                	add    %esi,%edi
80104d63:	eb 13                	jmp    80104d78 <strncmp+0x38>
80104d65:	8d 76 00             	lea    0x0(%esi),%esi
80104d68:	0f b6 01             	movzbl (%ecx),%eax
80104d6b:	84 c0                	test   %al,%al
80104d6d:	74 21                	je     80104d90 <strncmp+0x50>
80104d6f:	0f b6 1a             	movzbl (%edx),%ebx
80104d72:	89 d6                	mov    %edx,%esi
80104d74:	38 d8                	cmp    %bl,%al
80104d76:	75 1c                	jne    80104d94 <strncmp+0x54>
    n--, p++, q++;
80104d78:	8d 56 01             	lea    0x1(%esi),%edx
80104d7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d7e:	39 fa                	cmp    %edi,%edx
80104d80:	75 e6                	jne    80104d68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104d82:	5b                   	pop    %ebx
    return 0;
80104d83:	31 c0                	xor    %eax,%eax
}
80104d85:	5e                   	pop    %esi
80104d86:	5f                   	pop    %edi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104d94:	29 d8                	sub    %ebx,%eax
}
80104d96:	5b                   	pop    %ebx
80104d97:	5e                   	pop    %esi
80104d98:	5f                   	pop    %edi
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    
80104d9b:	90                   	nop
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	8b 45 08             	mov    0x8(%ebp),%eax
80104da8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104dae:	89 c2                	mov    %eax,%edx
80104db0:	eb 19                	jmp    80104dcb <strncpy+0x2b>
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db8:	83 c3 01             	add    $0x1,%ebx
80104dbb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104dbf:	83 c2 01             	add    $0x1,%edx
80104dc2:	84 c9                	test   %cl,%cl
80104dc4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104dc7:	74 09                	je     80104dd2 <strncpy+0x32>
80104dc9:	89 f1                	mov    %esi,%ecx
80104dcb:	85 c9                	test   %ecx,%ecx
80104dcd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104dd0:	7f e6                	jg     80104db8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104dd2:	31 c9                	xor    %ecx,%ecx
80104dd4:	85 f6                	test   %esi,%esi
80104dd6:	7e 17                	jle    80104def <strncpy+0x4f>
80104dd8:	90                   	nop
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104de0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104de4:	89 f3                	mov    %esi,%ebx
80104de6:	83 c1 01             	add    $0x1,%ecx
80104de9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104deb:	85 db                	test   %ebx,%ebx
80104ded:	7f f1                	jg     80104de0 <strncpy+0x40>
  return os;
}
80104def:	5b                   	pop    %ebx
80104df0:	5e                   	pop    %esi
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    
80104df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e08:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104e0e:	85 c9                	test   %ecx,%ecx
80104e10:	7e 26                	jle    80104e38 <safestrcpy+0x38>
80104e12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e16:	89 c1                	mov    %eax,%ecx
80104e18:	eb 17                	jmp    80104e31 <safestrcpy+0x31>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e20:	83 c2 01             	add    $0x1,%edx
80104e23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e27:	83 c1 01             	add    $0x1,%ecx
80104e2a:	84 db                	test   %bl,%bl
80104e2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e2f:	74 04                	je     80104e35 <safestrcpy+0x35>
80104e31:	39 f2                	cmp    %esi,%edx
80104e33:	75 eb                	jne    80104e20 <safestrcpy+0x20>
    ;
  *s = 0;
80104e35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e38:	5b                   	pop    %ebx
80104e39:	5e                   	pop    %esi
80104e3a:	5d                   	pop    %ebp
80104e3b:	c3                   	ret    
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <strlen>:

int
strlen(const char *s)
{
80104e40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e41:	31 c0                	xor    %eax,%eax
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e48:	80 3a 00             	cmpb   $0x0,(%edx)
80104e4b:	74 0c                	je     80104e59 <strlen+0x19>
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
80104e50:	83 c0 01             	add    $0x1,%eax
80104e53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e57:	75 f7                	jne    80104e50 <strlen+0x10>
    ;
  return n;
}
80104e59:	5d                   	pop    %ebp
80104e5a:	c3                   	ret    

80104e5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e63:	55                   	push   %ebp
  pushl %ebx
80104e64:	53                   	push   %ebx
  pushl %esi
80104e65:	56                   	push   %esi
  pushl %edi
80104e66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e6b:	5f                   	pop    %edi
  popl %esi
80104e6c:	5e                   	pop    %esi
  popl %ebx
80104e6d:	5b                   	pop    %ebx
  popl %ebp
80104e6e:	5d                   	pop    %ebp
  ret
80104e6f:	c3                   	ret    

80104e70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	53                   	push   %ebx
80104e74:	83 ec 04             	sub    $0x4,%esp
80104e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e7a:	e8 f1 e9 ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e7f:	8b 00                	mov    (%eax),%eax
80104e81:	39 d8                	cmp    %ebx,%eax
80104e83:	76 1b                	jbe    80104ea0 <fetchint+0x30>
80104e85:	8d 53 04             	lea    0x4(%ebx),%edx
80104e88:	39 d0                	cmp    %edx,%eax
80104e8a:	72 14                	jb     80104ea0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8f:	8b 13                	mov    (%ebx),%edx
80104e91:	89 10                	mov    %edx,(%eax)
  return 0;
80104e93:	31 c0                	xor    %eax,%eax
}
80104e95:	83 c4 04             	add    $0x4,%esp
80104e98:	5b                   	pop    %ebx
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    
80104e9b:	90                   	nop
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea5:	eb ee                	jmp    80104e95 <fetchint+0x25>
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	53                   	push   %ebx
80104eb4:	83 ec 04             	sub    $0x4,%esp
80104eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eba:	e8 b1 e9 ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz)
80104ebf:	39 18                	cmp    %ebx,(%eax)
80104ec1:	76 29                	jbe    80104eec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ec6:	89 da                	mov    %ebx,%edx
80104ec8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104eca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104ecc:	39 c3                	cmp    %eax,%ebx
80104ece:	73 1c                	jae    80104eec <fetchstr+0x3c>
    if(*s == 0)
80104ed0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ed3:	75 10                	jne    80104ee5 <fetchstr+0x35>
80104ed5:	eb 39                	jmp    80104f10 <fetchstr+0x60>
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ee0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ee3:	74 1b                	je     80104f00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ee5:	83 c2 01             	add    $0x1,%edx
80104ee8:	39 d0                	cmp    %edx,%eax
80104eea:	77 f4                	ja     80104ee0 <fetchstr+0x30>
    return -1;
80104eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ef1:	83 c4 04             	add    $0x4,%esp
80104ef4:	5b                   	pop    %ebx
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f00:	83 c4 04             	add    $0x4,%esp
80104f03:	89 d0                	mov    %edx,%eax
80104f05:	29 d8                	sub    %ebx,%eax
80104f07:	5b                   	pop    %ebx
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f12:	eb dd                	jmp    80104ef1 <fetchstr+0x41>
80104f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f25:	e8 46 e9 ff ff       	call   80103870 <myproc>
80104f2a:	8b 40 18             	mov    0x18(%eax),%eax
80104f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f30:	8b 40 44             	mov    0x44(%eax),%eax
80104f33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f36:	e8 35 e9 ff ff       	call   80103870 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f40:	39 c6                	cmp    %eax,%esi
80104f42:	73 1c                	jae    80104f60 <argint+0x40>
80104f44:	8d 53 08             	lea    0x8(%ebx),%edx
80104f47:	39 d0                	cmp    %edx,%eax
80104f49:	72 15                	jb     80104f60 <argint+0x40>
  *ip = *(int*)(addr);
80104f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f51:	89 10                	mov    %edx,(%eax)
  return 0;
80104f53:	31 c0                	xor    %eax,%eax
}
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret    
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f65:	eb ee                	jmp    80104f55 <argint+0x35>
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
80104f75:	83 ec 10             	sub    $0x10,%esp
80104f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f7b:	e8 f0 e8 ff ff       	call   80103870 <myproc>
80104f80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f85:	83 ec 08             	sub    $0x8,%esp
80104f88:	50                   	push   %eax
80104f89:	ff 75 08             	pushl  0x8(%ebp)
80104f8c:	e8 8f ff ff ff       	call   80104f20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	85 c0                	test   %eax,%eax
80104f96:	78 28                	js     80104fc0 <argptr+0x50>
80104f98:	85 db                	test   %ebx,%ebx
80104f9a:	78 24                	js     80104fc0 <argptr+0x50>
80104f9c:	8b 16                	mov    (%esi),%edx
80104f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa1:	39 c2                	cmp    %eax,%edx
80104fa3:	76 1b                	jbe    80104fc0 <argptr+0x50>
80104fa5:	01 c3                	add    %eax,%ebx
80104fa7:	39 da                	cmp    %ebx,%edx
80104fa9:	72 15                	jb     80104fc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104fab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fae:	89 02                	mov    %eax,(%edx)
  return 0;
80104fb0:	31 c0                	xor    %eax,%eax
}
80104fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb5:	5b                   	pop    %ebx
80104fb6:	5e                   	pop    %esi
80104fb7:	5d                   	pop    %ebp
80104fb8:	c3                   	ret    
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb eb                	jmp    80104fb2 <argptr+0x42>
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fd9:	50                   	push   %eax
80104fda:	ff 75 08             	pushl  0x8(%ebp)
80104fdd:	e8 3e ff ff ff       	call   80104f20 <argint>
80104fe2:	83 c4 10             	add    $0x10,%esp
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 17                	js     80105000 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104fe9:	83 ec 08             	sub    $0x8,%esp
80104fec:	ff 75 0c             	pushl  0xc(%ebp)
80104fef:	ff 75 f4             	pushl  -0xc(%ebp)
80104ff2:	e8 b9 fe ff ff       	call   80104eb0 <fetchstr>
80104ff7:	83 c4 10             	add    $0x10,%esp
}
80104ffa:	c9                   	leave  
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <syscall>:
"sys_toggle", "sys_add", "sys_ps", "sys_send", "sys_recv", "sys_send_multi",
"sys_sig_set", "sys_sig_send", "sys_sig_pause", "sys_sig_ret"};

void
syscall(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	53                   	push   %ebx
80105014:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105017:	e8 54 e8 ff ff       	call   80103870 <myproc>
8010501c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010501e:	8b 40 18             	mov    0x18(%eax),%eax
80105021:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105024:	8d 50 ff             	lea    -0x1(%eax),%edx
80105027:	83 fa 1f             	cmp    $0x1f,%edx
8010502a:	77 2c                	ja     80105058 <syscall+0x48>
8010502c:	8b 0c 85 00 82 10 80 	mov    -0x7fef7e00(,%eax,4),%ecx
80105033:	85 c9                	test   %ecx,%ecx
80105035:	74 21                	je     80105058 <syscall+0x48>
    
    if(toggle_flag)
80105037:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
8010503c:	85 c0                	test   %eax,%eax
8010503e:	74 08                	je     80105048 <syscall+0x38>
      system_call_count[num-1]++;
80105040:	83 04 95 00 81 16 80 	addl   $0x1,-0x7fe97f00(,%edx,4)
80105047:	01 

    curproc->tf->eax = syscalls[num]();
80105048:	ff d1                	call   *%ecx
8010504a:	8b 53 18             	mov    0x18(%ebx),%edx
8010504d:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
80105050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105053:	c9                   	leave  
80105054:	c3                   	ret    
80105055:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105058:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105059:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010505c:	50                   	push   %eax
8010505d:	ff 73 10             	pushl  0x10(%ebx)
80105060:	68 95 80 10 80       	push   $0x80108095
80105065:	e8 f6 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010506a:	8b 43 18             	mov    0x18(%ebx),%eax
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80105077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    
8010507c:	66 90                	xchg   %ax,%ax
8010507e:	66 90                	xchg   %ax,%ax

80105080 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105086:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105089:	83 ec 44             	sub    $0x44,%esp
8010508c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010508f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105092:	56                   	push   %esi
80105093:	50                   	push   %eax
{
80105094:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105097:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010509a:	e8 91 ce ff ff       	call   80101f30 <nameiparent>
8010509f:	83 c4 10             	add    $0x10,%esp
801050a2:	85 c0                	test   %eax,%eax
801050a4:	0f 84 46 01 00 00    	je     801051f0 <create+0x170>
    return 0;
  ilock(dp);
801050aa:	83 ec 0c             	sub    $0xc,%esp
801050ad:	89 c3                	mov    %eax,%ebx
801050af:	50                   	push   %eax
801050b0:	e8 fb c5 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801050b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801050b8:	83 c4 0c             	add    $0xc,%esp
801050bb:	50                   	push   %eax
801050bc:	56                   	push   %esi
801050bd:	53                   	push   %ebx
801050be:	e8 1d cb ff ff       	call   80101be0 <dirlookup>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	89 c7                	mov    %eax,%edi
801050ca:	74 34                	je     80105100 <create+0x80>
    iunlockput(dp);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	53                   	push   %ebx
801050d0:	e8 6b c8 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
801050d5:	89 3c 24             	mov    %edi,(%esp)
801050d8:	e8 d3 c5 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801050e5:	0f 85 95 00 00 00    	jne    80105180 <create+0x100>
801050eb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801050f0:	0f 85 8a 00 00 00    	jne    80105180 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050f9:	89 f8                	mov    %edi,%eax
801050fb:	5b                   	pop    %ebx
801050fc:	5e                   	pop    %esi
801050fd:	5f                   	pop    %edi
801050fe:	5d                   	pop    %ebp
801050ff:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105100:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105104:	83 ec 08             	sub    $0x8,%esp
80105107:	50                   	push   %eax
80105108:	ff 33                	pushl  (%ebx)
8010510a:	e8 31 c4 ff ff       	call   80101540 <ialloc>
8010510f:	83 c4 10             	add    $0x10,%esp
80105112:	85 c0                	test   %eax,%eax
80105114:	89 c7                	mov    %eax,%edi
80105116:	0f 84 e8 00 00 00    	je     80105204 <create+0x184>
  ilock(ip);
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	50                   	push   %eax
80105120:	e8 8b c5 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105125:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105129:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010512d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105131:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105135:	b8 01 00 00 00       	mov    $0x1,%eax
8010513a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010513e:	89 3c 24             	mov    %edi,(%esp)
80105141:	e8 ba c4 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010514e:	74 50                	je     801051a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105150:	83 ec 04             	sub    $0x4,%esp
80105153:	ff 77 04             	pushl  0x4(%edi)
80105156:	56                   	push   %esi
80105157:	53                   	push   %ebx
80105158:	e8 f3 cc ff ff       	call   80101e50 <dirlink>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	0f 88 8f 00 00 00    	js     801051f7 <create+0x177>
  iunlockput(dp);
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	53                   	push   %ebx
8010516c:	e8 cf c7 ff ff       	call   80101940 <iunlockput>
  return ip;
80105171:	83 c4 10             	add    $0x10,%esp
}
80105174:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105177:	89 f8                	mov    %edi,%eax
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5f                   	pop    %edi
8010517c:	5d                   	pop    %ebp
8010517d:	c3                   	ret    
8010517e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	57                   	push   %edi
    return 0;
80105184:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105186:	e8 b5 c7 ff ff       	call   80101940 <iunlockput>
    return 0;
8010518b:	83 c4 10             	add    $0x10,%esp
}
8010518e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105191:	89 f8                	mov    %edi,%eax
80105193:	5b                   	pop    %ebx
80105194:	5e                   	pop    %esi
80105195:	5f                   	pop    %edi
80105196:	5d                   	pop    %ebp
80105197:	c3                   	ret    
80105198:	90                   	nop
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801051a0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801051a5:	83 ec 0c             	sub    $0xc,%esp
801051a8:	53                   	push   %ebx
801051a9:	e8 52 c4 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801051ae:	83 c4 0c             	add    $0xc,%esp
801051b1:	ff 77 04             	pushl  0x4(%edi)
801051b4:	68 a0 82 10 80       	push   $0x801082a0
801051b9:	57                   	push   %edi
801051ba:	e8 91 cc ff ff       	call   80101e50 <dirlink>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	85 c0                	test   %eax,%eax
801051c4:	78 1c                	js     801051e2 <create+0x162>
801051c6:	83 ec 04             	sub    $0x4,%esp
801051c9:	ff 73 04             	pushl  0x4(%ebx)
801051cc:	68 9f 82 10 80       	push   $0x8010829f
801051d1:	57                   	push   %edi
801051d2:	e8 79 cc ff ff       	call   80101e50 <dirlink>
801051d7:	83 c4 10             	add    $0x10,%esp
801051da:	85 c0                	test   %eax,%eax
801051dc:	0f 89 6e ff ff ff    	jns    80105150 <create+0xd0>
      panic("create dots");
801051e2:	83 ec 0c             	sub    $0xc,%esp
801051e5:	68 93 82 10 80       	push   $0x80108293
801051ea:	e8 a1 b1 ff ff       	call   80100390 <panic>
801051ef:	90                   	nop
    return 0;
801051f0:	31 ff                	xor    %edi,%edi
801051f2:	e9 ff fe ff ff       	jmp    801050f6 <create+0x76>
    panic("create: dirlink");
801051f7:	83 ec 0c             	sub    $0xc,%esp
801051fa:	68 a2 82 10 80       	push   $0x801082a2
801051ff:	e8 8c b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	68 84 82 10 80       	push   $0x80108284
8010520c:	e8 7f b1 ff ff       	call   80100390 <panic>
80105211:	eb 0d                	jmp    80105220 <argfd.constprop.0>
80105213:	90                   	nop
80105214:	90                   	nop
80105215:	90                   	nop
80105216:	90                   	nop
80105217:	90                   	nop
80105218:	90                   	nop
80105219:	90                   	nop
8010521a:	90                   	nop
8010521b:	90                   	nop
8010521c:	90                   	nop
8010521d:	90                   	nop
8010521e:	90                   	nop
8010521f:	90                   	nop

80105220 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
80105225:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105227:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010522a:	89 d6                	mov    %edx,%esi
8010522c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010522f:	50                   	push   %eax
80105230:	6a 00                	push   $0x0
80105232:	e8 e9 fc ff ff       	call   80104f20 <argint>
80105237:	83 c4 10             	add    $0x10,%esp
8010523a:	85 c0                	test   %eax,%eax
8010523c:	78 2a                	js     80105268 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010523e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105242:	77 24                	ja     80105268 <argfd.constprop.0+0x48>
80105244:	e8 27 e6 ff ff       	call   80103870 <myproc>
80105249:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010524c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105250:	85 c0                	test   %eax,%eax
80105252:	74 14                	je     80105268 <argfd.constprop.0+0x48>
  if(pfd)
80105254:	85 db                	test   %ebx,%ebx
80105256:	74 02                	je     8010525a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105258:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010525a:	89 06                	mov    %eax,(%esi)
  return 0;
8010525c:	31 c0                	xor    %eax,%eax
}
8010525e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105261:	5b                   	pop    %ebx
80105262:	5e                   	pop    %esi
80105263:	5d                   	pop    %ebp
80105264:	c3                   	ret    
80105265:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526d:	eb ef                	jmp    8010525e <argfd.constprop.0+0x3e>
8010526f:	90                   	nop

80105270 <sys_dup>:
{
80105270:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105271:	31 c0                	xor    %eax,%eax
{
80105273:	89 e5                	mov    %esp,%ebp
80105275:	56                   	push   %esi
80105276:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105277:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010527a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010527d:	e8 9e ff ff ff       	call   80105220 <argfd.constprop.0>
80105282:	85 c0                	test   %eax,%eax
80105284:	78 42                	js     801052c8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105286:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105289:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010528b:	e8 e0 e5 ff ff       	call   80103870 <myproc>
80105290:	eb 0e                	jmp    801052a0 <sys_dup+0x30>
80105292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105298:	83 c3 01             	add    $0x1,%ebx
8010529b:	83 fb 10             	cmp    $0x10,%ebx
8010529e:	74 28                	je     801052c8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801052a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052a4:	85 d2                	test   %edx,%edx
801052a6:	75 f0                	jne    80105298 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801052a8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	ff 75 f4             	pushl  -0xc(%ebp)
801052b2:	e8 59 bb ff ff       	call   80100e10 <filedup>
  return fd;
801052b7:	83 c4 10             	add    $0x10,%esp
}
801052ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052bd:	89 d8                	mov    %ebx,%eax
801052bf:	5b                   	pop    %ebx
801052c0:	5e                   	pop    %esi
801052c1:	5d                   	pop    %ebp
801052c2:	c3                   	ret    
801052c3:	90                   	nop
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801052cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801052d0:	89 d8                	mov    %ebx,%eax
801052d2:	5b                   	pop    %ebx
801052d3:	5e                   	pop    %esi
801052d4:	5d                   	pop    %ebp
801052d5:	c3                   	ret    
801052d6:	8d 76 00             	lea    0x0(%esi),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_read>:
{
801052e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052e1:	31 c0                	xor    %eax,%eax
{
801052e3:	89 e5                	mov    %esp,%ebp
801052e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052eb:	e8 30 ff ff ff       	call   80105220 <argfd.constprop.0>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 4c                	js     80105340 <sys_read+0x60>
801052f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052f7:	83 ec 08             	sub    $0x8,%esp
801052fa:	50                   	push   %eax
801052fb:	6a 02                	push   $0x2
801052fd:	e8 1e fc ff ff       	call   80104f20 <argint>
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	85 c0                	test   %eax,%eax
80105307:	78 37                	js     80105340 <sys_read+0x60>
80105309:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530c:	83 ec 04             	sub    $0x4,%esp
8010530f:	ff 75 f0             	pushl  -0x10(%ebp)
80105312:	50                   	push   %eax
80105313:	6a 01                	push   $0x1
80105315:	e8 56 fc ff ff       	call   80104f70 <argptr>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	78 1f                	js     80105340 <sys_read+0x60>
  return fileread(f, p, n);
80105321:	83 ec 04             	sub    $0x4,%esp
80105324:	ff 75 f0             	pushl  -0x10(%ebp)
80105327:	ff 75 f4             	pushl  -0xc(%ebp)
8010532a:	ff 75 ec             	pushl  -0x14(%ebp)
8010532d:	e8 4e bc ff ff       	call   80100f80 <fileread>
80105332:	83 c4 10             	add    $0x10,%esp
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105345:	c9                   	leave  
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_write>:
{
80105350:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105351:	31 c0                	xor    %eax,%eax
{
80105353:	89 e5                	mov    %esp,%ebp
80105355:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105358:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010535b:	e8 c0 fe ff ff       	call   80105220 <argfd.constprop.0>
80105360:	85 c0                	test   %eax,%eax
80105362:	78 4c                	js     801053b0 <sys_write+0x60>
80105364:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105367:	83 ec 08             	sub    $0x8,%esp
8010536a:	50                   	push   %eax
8010536b:	6a 02                	push   $0x2
8010536d:	e8 ae fb ff ff       	call   80104f20 <argint>
80105372:	83 c4 10             	add    $0x10,%esp
80105375:	85 c0                	test   %eax,%eax
80105377:	78 37                	js     801053b0 <sys_write+0x60>
80105379:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010537c:	83 ec 04             	sub    $0x4,%esp
8010537f:	ff 75 f0             	pushl  -0x10(%ebp)
80105382:	50                   	push   %eax
80105383:	6a 01                	push   $0x1
80105385:	e8 e6 fb ff ff       	call   80104f70 <argptr>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	85 c0                	test   %eax,%eax
8010538f:	78 1f                	js     801053b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105391:	83 ec 04             	sub    $0x4,%esp
80105394:	ff 75 f0             	pushl  -0x10(%ebp)
80105397:	ff 75 f4             	pushl  -0xc(%ebp)
8010539a:	ff 75 ec             	pushl  -0x14(%ebp)
8010539d:	e8 6e bc ff ff       	call   80101010 <filewrite>
801053a2:	83 c4 10             	add    $0x10,%esp
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_close>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801053c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801053c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053cc:	e8 4f fe ff ff       	call   80105220 <argfd.constprop.0>
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 2b                	js     80105400 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801053d5:	e8 96 e4 ff ff       	call   80103870 <myproc>
801053da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801053dd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053e0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053e7:	00 
  fileclose(f);
801053e8:	ff 75 f4             	pushl  -0xc(%ebp)
801053eb:	e8 70 ba ff ff       	call   80100e60 <fileclose>
  return 0;
801053f0:	83 c4 10             	add    $0x10,%esp
801053f3:	31 c0                	xor    %eax,%eax
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_fstat>:
{
80105410:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105411:	31 c0                	xor    %eax,%eax
{
80105413:	89 e5                	mov    %esp,%ebp
80105415:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105418:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010541b:	e8 00 fe ff ff       	call   80105220 <argfd.constprop.0>
80105420:	85 c0                	test   %eax,%eax
80105422:	78 2c                	js     80105450 <sys_fstat+0x40>
80105424:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105427:	83 ec 04             	sub    $0x4,%esp
8010542a:	6a 14                	push   $0x14
8010542c:	50                   	push   %eax
8010542d:	6a 01                	push   $0x1
8010542f:	e8 3c fb ff ff       	call   80104f70 <argptr>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	78 15                	js     80105450 <sys_fstat+0x40>
  return filestat(f, st);
8010543b:	83 ec 08             	sub    $0x8,%esp
8010543e:	ff 75 f4             	pushl  -0xc(%ebp)
80105441:	ff 75 f0             	pushl  -0x10(%ebp)
80105444:	e8 e7 ba ff ff       	call   80100f30 <filestat>
80105449:	83 c4 10             	add    $0x10,%esp
}
8010544c:	c9                   	leave  
8010544d:	c3                   	ret    
8010544e:	66 90                	xchg   %ax,%ax
    return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <sys_link>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105466:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105469:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010546c:	50                   	push   %eax
8010546d:	6a 00                	push   $0x0
8010546f:	e8 5c fb ff ff       	call   80104fd0 <argstr>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
80105479:	0f 88 fb 00 00 00    	js     8010557a <sys_link+0x11a>
8010547f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105482:	83 ec 08             	sub    $0x8,%esp
80105485:	50                   	push   %eax
80105486:	6a 01                	push   $0x1
80105488:	e8 43 fb ff ff       	call   80104fd0 <argstr>
8010548d:	83 c4 10             	add    $0x10,%esp
80105490:	85 c0                	test   %eax,%eax
80105492:	0f 88 e2 00 00 00    	js     8010557a <sys_link+0x11a>
  begin_op();
80105498:	e8 33 d7 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	ff 75 d4             	pushl  -0x2c(%ebp)
801054a3:	e8 68 ca ff ff       	call   80101f10 <namei>
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	85 c0                	test   %eax,%eax
801054ad:	89 c3                	mov    %eax,%ebx
801054af:	0f 84 ea 00 00 00    	je     8010559f <sys_link+0x13f>
  ilock(ip);
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	50                   	push   %eax
801054b9:	e8 f2 c1 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c6:	0f 84 bb 00 00 00    	je     80105587 <sys_link+0x127>
  ip->nlink++;
801054cc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801054d1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801054d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054d7:	53                   	push   %ebx
801054d8:	e8 23 c1 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
801054dd:	89 1c 24             	mov    %ebx,(%esp)
801054e0:	e8 ab c2 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054e5:	58                   	pop    %eax
801054e6:	5a                   	pop    %edx
801054e7:	57                   	push   %edi
801054e8:	ff 75 d0             	pushl  -0x30(%ebp)
801054eb:	e8 40 ca ff ff       	call   80101f30 <nameiparent>
801054f0:	83 c4 10             	add    $0x10,%esp
801054f3:	85 c0                	test   %eax,%eax
801054f5:	89 c6                	mov    %eax,%esi
801054f7:	74 5b                	je     80105554 <sys_link+0xf4>
  ilock(dp);
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	50                   	push   %eax
801054fd:	e8 ae c1 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	8b 03                	mov    (%ebx),%eax
80105507:	39 06                	cmp    %eax,(%esi)
80105509:	75 3d                	jne    80105548 <sys_link+0xe8>
8010550b:	83 ec 04             	sub    $0x4,%esp
8010550e:	ff 73 04             	pushl  0x4(%ebx)
80105511:	57                   	push   %edi
80105512:	56                   	push   %esi
80105513:	e8 38 c9 ff ff       	call   80101e50 <dirlink>
80105518:	83 c4 10             	add    $0x10,%esp
8010551b:	85 c0                	test   %eax,%eax
8010551d:	78 29                	js     80105548 <sys_link+0xe8>
  iunlockput(dp);
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	56                   	push   %esi
80105523:	e8 18 c4 ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105528:	89 1c 24             	mov    %ebx,(%esp)
8010552b:	e8 b0 c2 ff ff       	call   801017e0 <iput>
  end_op();
80105530:	e8 0b d7 ff ff       	call   80102c40 <end_op>
  return 0;
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	31 c0                	xor    %eax,%eax
}
8010553a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010553d:	5b                   	pop    %ebx
8010553e:	5e                   	pop    %esi
8010553f:	5f                   	pop    %edi
80105540:	5d                   	pop    %ebp
80105541:	c3                   	ret    
80105542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	56                   	push   %esi
8010554c:	e8 ef c3 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105551:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	53                   	push   %ebx
80105558:	e8 53 c1 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
8010555d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105562:	89 1c 24             	mov    %ebx,(%esp)
80105565:	e8 96 c0 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010556a:	89 1c 24             	mov    %ebx,(%esp)
8010556d:	e8 ce c3 ff ff       	call   80101940 <iunlockput>
  end_op();
80105572:	e8 c9 d6 ff ff       	call   80102c40 <end_op>
  return -1;
80105577:	83 c4 10             	add    $0x10,%esp
}
8010557a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010557d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105582:	5b                   	pop    %ebx
80105583:	5e                   	pop    %esi
80105584:	5f                   	pop    %edi
80105585:	5d                   	pop    %ebp
80105586:	c3                   	ret    
    iunlockput(ip);
80105587:	83 ec 0c             	sub    $0xc,%esp
8010558a:	53                   	push   %ebx
8010558b:	e8 b0 c3 ff ff       	call   80101940 <iunlockput>
    end_op();
80105590:	e8 ab d6 ff ff       	call   80102c40 <end_op>
    return -1;
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559d:	eb 9b                	jmp    8010553a <sys_link+0xda>
    end_op();
8010559f:	e8 9c d6 ff ff       	call   80102c40 <end_op>
    return -1;
801055a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a9:	eb 8f                	jmp    8010553a <sys_link+0xda>
801055ab:	90                   	nop
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_unlink>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
801055b5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801055b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801055b9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801055bc:	50                   	push   %eax
801055bd:	6a 00                	push   $0x0
801055bf:	e8 0c fa ff ff       	call   80104fd0 <argstr>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	85 c0                	test   %eax,%eax
801055c9:	0f 88 77 01 00 00    	js     80105746 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801055cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801055d2:	e8 f9 d5 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055d7:	83 ec 08             	sub    $0x8,%esp
801055da:	53                   	push   %ebx
801055db:	ff 75 c0             	pushl  -0x40(%ebp)
801055de:	e8 4d c9 ff ff       	call   80101f30 <nameiparent>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	89 c6                	mov    %eax,%esi
801055ea:	0f 84 60 01 00 00    	je     80105750 <sys_unlink+0x1a0>
  ilock(dp);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	50                   	push   %eax
801055f4:	e8 b7 c0 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055f9:	58                   	pop    %eax
801055fa:	5a                   	pop    %edx
801055fb:	68 a0 82 10 80       	push   $0x801082a0
80105600:	53                   	push   %ebx
80105601:	e8 ba c5 ff ff       	call   80101bc0 <namecmp>
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	0f 84 03 01 00 00    	je     80105714 <sys_unlink+0x164>
80105611:	83 ec 08             	sub    $0x8,%esp
80105614:	68 9f 82 10 80       	push   $0x8010829f
80105619:	53                   	push   %ebx
8010561a:	e8 a1 c5 ff ff       	call   80101bc0 <namecmp>
8010561f:	83 c4 10             	add    $0x10,%esp
80105622:	85 c0                	test   %eax,%eax
80105624:	0f 84 ea 00 00 00    	je     80105714 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010562a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010562d:	83 ec 04             	sub    $0x4,%esp
80105630:	50                   	push   %eax
80105631:	53                   	push   %ebx
80105632:	56                   	push   %esi
80105633:	e8 a8 c5 ff ff       	call   80101be0 <dirlookup>
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	85 c0                	test   %eax,%eax
8010563d:	89 c3                	mov    %eax,%ebx
8010563f:	0f 84 cf 00 00 00    	je     80105714 <sys_unlink+0x164>
  ilock(ip);
80105645:	83 ec 0c             	sub    $0xc,%esp
80105648:	50                   	push   %eax
80105649:	e8 62 c0 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105656:	0f 8e 10 01 00 00    	jle    8010576c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010565c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105661:	74 6d                	je     801056d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105663:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105666:	83 ec 04             	sub    $0x4,%esp
80105669:	6a 10                	push   $0x10
8010566b:	6a 00                	push   $0x0
8010566d:	50                   	push   %eax
8010566e:	e8 ad f5 ff ff       	call   80104c20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105673:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105676:	6a 10                	push   $0x10
80105678:	ff 75 c4             	pushl  -0x3c(%ebp)
8010567b:	50                   	push   %eax
8010567c:	56                   	push   %esi
8010567d:	e8 0e c4 ff ff       	call   80101a90 <writei>
80105682:	83 c4 20             	add    $0x20,%esp
80105685:	83 f8 10             	cmp    $0x10,%eax
80105688:	0f 85 eb 00 00 00    	jne    80105779 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010568e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105693:	0f 84 97 00 00 00    	je     80105730 <sys_unlink+0x180>
  iunlockput(dp);
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	56                   	push   %esi
8010569d:	e8 9e c2 ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
801056a2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056a7:	89 1c 24             	mov    %ebx,(%esp)
801056aa:	e8 51 bf ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801056af:	89 1c 24             	mov    %ebx,(%esp)
801056b2:	e8 89 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
801056b7:	e8 84 d5 ff ff       	call   80102c40 <end_op>
  return 0;
801056bc:	83 c4 10             	add    $0x10,%esp
801056bf:	31 c0                	xor    %eax,%eax
}
801056c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c4:	5b                   	pop    %ebx
801056c5:	5e                   	pop    %esi
801056c6:	5f                   	pop    %edi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret    
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056d4:	76 8d                	jbe    80105663 <sys_unlink+0xb3>
801056d6:	bf 20 00 00 00       	mov    $0x20,%edi
801056db:	eb 0f                	jmp    801056ec <sys_unlink+0x13c>
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
801056e0:	83 c7 10             	add    $0x10,%edi
801056e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801056e6:	0f 83 77 ff ff ff    	jae    80105663 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056ef:	6a 10                	push   $0x10
801056f1:	57                   	push   %edi
801056f2:	50                   	push   %eax
801056f3:	53                   	push   %ebx
801056f4:	e8 97 c2 ff ff       	call   80101990 <readi>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	83 f8 10             	cmp    $0x10,%eax
801056ff:	75 5e                	jne    8010575f <sys_unlink+0x1af>
    if(de.inum != 0)
80105701:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105706:	74 d8                	je     801056e0 <sys_unlink+0x130>
    iunlockput(ip);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	53                   	push   %ebx
8010570c:	e8 2f c2 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105711:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105714:	83 ec 0c             	sub    $0xc,%esp
80105717:	56                   	push   %esi
80105718:	e8 23 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
8010571d:	e8 1e d5 ff ff       	call   80102c40 <end_op>
  return -1;
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572a:	eb 95                	jmp    801056c1 <sys_unlink+0x111>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105730:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	56                   	push   %esi
80105739:	e8 c2 be ff ff       	call   80101600 <iupdate>
8010573e:	83 c4 10             	add    $0x10,%esp
80105741:	e9 53 ff ff ff       	jmp    80105699 <sys_unlink+0xe9>
    return -1;
80105746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574b:	e9 71 ff ff ff       	jmp    801056c1 <sys_unlink+0x111>
    end_op();
80105750:	e8 eb d4 ff ff       	call   80102c40 <end_op>
    return -1;
80105755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575a:	e9 62 ff ff ff       	jmp    801056c1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	68 c4 82 10 80       	push   $0x801082c4
80105767:	e8 24 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010576c:	83 ec 0c             	sub    $0xc,%esp
8010576f:	68 b2 82 10 80       	push   $0x801082b2
80105774:	e8 17 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	68 d6 82 10 80       	push   $0x801082d6
80105781:	e8 0a ac ff ff       	call   80100390 <panic>
80105786:	8d 76 00             	lea    0x0(%esi),%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_open>:

int
sys_open(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
80105795:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105796:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105799:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010579c:	50                   	push   %eax
8010579d:	6a 00                	push   $0x0
8010579f:	e8 2c f8 ff ff       	call   80104fd0 <argstr>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	0f 88 1d 01 00 00    	js     801058cc <sys_open+0x13c>
801057af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057b2:	83 ec 08             	sub    $0x8,%esp
801057b5:	50                   	push   %eax
801057b6:	6a 01                	push   $0x1
801057b8:	e8 63 f7 ff ff       	call   80104f20 <argint>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	85 c0                	test   %eax,%eax
801057c2:	0f 88 04 01 00 00    	js     801058cc <sys_open+0x13c>
    return -1;

  begin_op();
801057c8:	e8 03 d4 ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
801057cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057d1:	0f 85 a9 00 00 00    	jne    80105880 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057d7:	83 ec 0c             	sub    $0xc,%esp
801057da:	ff 75 e0             	pushl  -0x20(%ebp)
801057dd:	e8 2e c7 ff ff       	call   80101f10 <namei>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	89 c6                	mov    %eax,%esi
801057e9:	0f 84 b2 00 00 00    	je     801058a1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801057ef:	83 ec 0c             	sub    $0xc,%esp
801057f2:	50                   	push   %eax
801057f3:	e8 b8 be ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105800:	0f 84 aa 00 00 00    	je     801058b0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105806:	e8 95 b5 ff ff       	call   80100da0 <filealloc>
8010580b:	85 c0                	test   %eax,%eax
8010580d:	89 c7                	mov    %eax,%edi
8010580f:	0f 84 a6 00 00 00    	je     801058bb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105815:	e8 56 e0 ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010581a:	31 db                	xor    %ebx,%ebx
8010581c:	eb 0e                	jmp    8010582c <sys_open+0x9c>
8010581e:	66 90                	xchg   %ax,%ax
80105820:	83 c3 01             	add    $0x1,%ebx
80105823:	83 fb 10             	cmp    $0x10,%ebx
80105826:	0f 84 ac 00 00 00    	je     801058d8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010582c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105830:	85 d2                	test   %edx,%edx
80105832:	75 ec                	jne    80105820 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105834:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105837:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010583b:	56                   	push   %esi
8010583c:	e8 4f bf ff ff       	call   80101790 <iunlock>
  end_op();
80105841:	e8 fa d3 ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105846:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010584c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010584f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105852:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105855:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010585c:	89 d0                	mov    %edx,%eax
8010585e:	f7 d0                	not    %eax
80105860:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105863:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105866:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105869:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010586d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105870:	89 d8                	mov    %ebx,%eax
80105872:	5b                   	pop    %ebx
80105873:	5e                   	pop    %esi
80105874:	5f                   	pop    %edi
80105875:	5d                   	pop    %ebp
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105886:	31 c9                	xor    %ecx,%ecx
80105888:	6a 00                	push   $0x0
8010588a:	ba 02 00 00 00       	mov    $0x2,%edx
8010588f:	e8 ec f7 ff ff       	call   80105080 <create>
    if(ip == 0){
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105899:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010589b:	0f 85 65 ff ff ff    	jne    80105806 <sys_open+0x76>
      end_op();
801058a1:	e8 9a d3 ff ff       	call   80102c40 <end_op>
      return -1;
801058a6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058ab:	eb c0                	jmp    8010586d <sys_open+0xdd>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801058b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058b3:	85 c9                	test   %ecx,%ecx
801058b5:	0f 84 4b ff ff ff    	je     80105806 <sys_open+0x76>
    iunlockput(ip);
801058bb:	83 ec 0c             	sub    $0xc,%esp
801058be:	56                   	push   %esi
801058bf:	e8 7c c0 ff ff       	call   80101940 <iunlockput>
    end_op();
801058c4:	e8 77 d3 ff ff       	call   80102c40 <end_op>
    return -1;
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058d1:	eb 9a                	jmp    8010586d <sys_open+0xdd>
801058d3:	90                   	nop
801058d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	57                   	push   %edi
801058dc:	e8 7f b5 ff ff       	call   80100e60 <fileclose>
801058e1:	83 c4 10             	add    $0x10,%esp
801058e4:	eb d5                	jmp    801058bb <sys_open+0x12b>
801058e6:	8d 76 00             	lea    0x0(%esi),%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058f6:	e8 d5 d2 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fe:	83 ec 08             	sub    $0x8,%esp
80105901:	50                   	push   %eax
80105902:	6a 00                	push   $0x0
80105904:	e8 c7 f6 ff ff       	call   80104fd0 <argstr>
80105909:	83 c4 10             	add    $0x10,%esp
8010590c:	85 c0                	test   %eax,%eax
8010590e:	78 30                	js     80105940 <sys_mkdir+0x50>
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105916:	31 c9                	xor    %ecx,%ecx
80105918:	6a 00                	push   $0x0
8010591a:	ba 01 00 00 00       	mov    $0x1,%edx
8010591f:	e8 5c f7 ff ff       	call   80105080 <create>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	74 15                	je     80105940 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010592b:	83 ec 0c             	sub    $0xc,%esp
8010592e:	50                   	push   %eax
8010592f:	e8 0c c0 ff ff       	call   80101940 <iunlockput>
  end_op();
80105934:	e8 07 d3 ff ff       	call   80102c40 <end_op>
  return 0;
80105939:	83 c4 10             	add    $0x10,%esp
8010593c:	31 c0                	xor    %eax,%eax
}
8010593e:	c9                   	leave  
8010593f:	c3                   	ret    
    end_op();
80105940:	e8 fb d2 ff ff       	call   80102c40 <end_op>
    return -1;
80105945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010594a:	c9                   	leave  
8010594b:	c3                   	ret    
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_mknod>:

int
sys_mknod(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105956:	e8 75 d2 ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010595b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010595e:	83 ec 08             	sub    $0x8,%esp
80105961:	50                   	push   %eax
80105962:	6a 00                	push   $0x0
80105964:	e8 67 f6 ff ff       	call   80104fd0 <argstr>
80105969:	83 c4 10             	add    $0x10,%esp
8010596c:	85 c0                	test   %eax,%eax
8010596e:	78 60                	js     801059d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105970:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105973:	83 ec 08             	sub    $0x8,%esp
80105976:	50                   	push   %eax
80105977:	6a 01                	push   $0x1
80105979:	e8 a2 f5 ff ff       	call   80104f20 <argint>
  if((argstr(0, &path)) < 0 ||
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	85 c0                	test   %eax,%eax
80105983:	78 4b                	js     801059d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105985:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105988:	83 ec 08             	sub    $0x8,%esp
8010598b:	50                   	push   %eax
8010598c:	6a 02                	push   $0x2
8010598e:	e8 8d f5 ff ff       	call   80104f20 <argint>
     argint(1, &major) < 0 ||
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 c0                	test   %eax,%eax
80105998:	78 36                	js     801059d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010599a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010599e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801059a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801059a5:	ba 03 00 00 00       	mov    $0x3,%edx
801059aa:	50                   	push   %eax
801059ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059ae:	e8 cd f6 ff ff       	call   80105080 <create>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	85 c0                	test   %eax,%eax
801059b8:	74 16                	je     801059d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059ba:	83 ec 0c             	sub    $0xc,%esp
801059bd:	50                   	push   %eax
801059be:	e8 7d bf ff ff       	call   80101940 <iunlockput>
  end_op();
801059c3:	e8 78 d2 ff ff       	call   80102c40 <end_op>
  return 0;
801059c8:	83 c4 10             	add    $0x10,%esp
801059cb:	31 c0                	xor    %eax,%eax
}
801059cd:	c9                   	leave  
801059ce:	c3                   	ret    
801059cf:	90                   	nop
    end_op();
801059d0:	e8 6b d2 ff ff       	call   80102c40 <end_op>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059da:	c9                   	leave  
801059db:	c3                   	ret    
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_chdir>:

int
sys_chdir(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	56                   	push   %esi
801059e4:	53                   	push   %ebx
801059e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059e8:	e8 83 de ff ff       	call   80103870 <myproc>
801059ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059ef:	e8 dc d1 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f7:	83 ec 08             	sub    $0x8,%esp
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 ce f5 ff ff       	call   80104fd0 <argstr>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 77                	js     80105a80 <sys_chdir+0xa0>
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a0f:	e8 fc c4 ff ff       	call   80101f10 <namei>
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	85 c0                	test   %eax,%eax
80105a19:	89 c3                	mov    %eax,%ebx
80105a1b:	74 63                	je     80105a80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
80105a20:	50                   	push   %eax
80105a21:	e8 8a bc ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a2e:	75 30                	jne    80105a60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	53                   	push   %ebx
80105a34:	e8 57 bd ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105a39:	58                   	pop    %eax
80105a3a:	ff 76 68             	pushl  0x68(%esi)
80105a3d:	e8 9e bd ff ff       	call   801017e0 <iput>
  end_op();
80105a42:	e8 f9 d1 ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
80105a47:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	31 c0                	xor    %eax,%eax
}
80105a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a52:	5b                   	pop    %ebx
80105a53:	5e                   	pop    %esi
80105a54:	5d                   	pop    %ebp
80105a55:	c3                   	ret    
80105a56:	8d 76 00             	lea    0x0(%esi),%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	53                   	push   %ebx
80105a64:	e8 d7 be ff ff       	call   80101940 <iunlockput>
    end_op();
80105a69:	e8 d2 d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a76:	eb d7                	jmp    80105a4f <sys_chdir+0x6f>
80105a78:	90                   	nop
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a80:	e8 bb d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8a:	eb c3                	jmp    80105a4f <sys_chdir+0x6f>
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_exec>:

int
sys_exec(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
80105a95:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a96:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105aa2:	50                   	push   %eax
80105aa3:	6a 00                	push   $0x0
80105aa5:	e8 26 f5 ff ff       	call   80104fd0 <argstr>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	0f 88 87 00 00 00    	js     80105b3c <sys_exec+0xac>
80105ab5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105abb:	83 ec 08             	sub    $0x8,%esp
80105abe:	50                   	push   %eax
80105abf:	6a 01                	push   $0x1
80105ac1:	e8 5a f4 ff ff       	call   80104f20 <argint>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	78 6f                	js     80105b3c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105acd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ad3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ad6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ad8:	68 80 00 00 00       	push   $0x80
80105add:	6a 00                	push   $0x0
80105adf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ae5:	50                   	push   %eax
80105ae6:	e8 35 f1 ff ff       	call   80104c20 <memset>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	eb 2c                	jmp    80105b1c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105af0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105af6:	85 c0                	test   %eax,%eax
80105af8:	74 56                	je     80105b50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105afa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b00:	83 ec 08             	sub    $0x8,%esp
80105b03:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b06:	52                   	push   %edx
80105b07:	50                   	push   %eax
80105b08:	e8 a3 f3 ff ff       	call   80104eb0 <fetchstr>
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	85 c0                	test   %eax,%eax
80105b12:	78 28                	js     80105b3c <sys_exec+0xac>
  for(i=0;; i++){
80105b14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b17:	83 fb 20             	cmp    $0x20,%ebx
80105b1a:	74 20                	je     80105b3c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b22:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b29:	83 ec 08             	sub    $0x8,%esp
80105b2c:	57                   	push   %edi
80105b2d:	01 f0                	add    %esi,%eax
80105b2f:	50                   	push   %eax
80105b30:	e8 3b f3 ff ff       	call   80104e70 <fetchint>
80105b35:	83 c4 10             	add    $0x10,%esp
80105b38:	85 c0                	test   %eax,%eax
80105b3a:	79 b4                	jns    80105af0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b44:	5b                   	pop    %ebx
80105b45:	5e                   	pop    %esi
80105b46:	5f                   	pop    %edi
80105b47:	5d                   	pop    %ebp
80105b48:	c3                   	ret    
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b50:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b56:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105b59:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b60:	00 00 00 00 
  return exec(path, argv);
80105b64:	50                   	push   %eax
80105b65:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b6b:	e8 a0 ae ff ff       	call   80100a10 <exec>
80105b70:	83 c4 10             	add    $0x10,%esp
}
80105b73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b76:	5b                   	pop    %ebx
80105b77:	5e                   	pop    %esi
80105b78:	5f                   	pop    %edi
80105b79:	5d                   	pop    %ebp
80105b7a:	c3                   	ret    
80105b7b:	90                   	nop
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_pipe>:

int
sys_pipe(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b86:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b89:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b8c:	6a 08                	push   $0x8
80105b8e:	50                   	push   %eax
80105b8f:	6a 00                	push   $0x0
80105b91:	e8 da f3 ff ff       	call   80104f70 <argptr>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	0f 88 ae 00 00 00    	js     80105c4f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ba1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ba4:	83 ec 08             	sub    $0x8,%esp
80105ba7:	50                   	push   %eax
80105ba8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bab:	50                   	push   %eax
80105bac:	e8 bf d6 ff ff       	call   80103270 <pipealloc>
80105bb1:	83 c4 10             	add    $0x10,%esp
80105bb4:	85 c0                	test   %eax,%eax
80105bb6:	0f 88 93 00 00 00    	js     80105c4f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bbc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105bbf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105bc1:	e8 aa dc ff ff       	call   80103870 <myproc>
80105bc6:	eb 10                	jmp    80105bd8 <sys_pipe+0x58>
80105bc8:	90                   	nop
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105bd0:	83 c3 01             	add    $0x1,%ebx
80105bd3:	83 fb 10             	cmp    $0x10,%ebx
80105bd6:	74 60                	je     80105c38 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105bd8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bdc:	85 f6                	test   %esi,%esi
80105bde:	75 f0                	jne    80105bd0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105be0:	8d 73 08             	lea    0x8(%ebx),%esi
80105be3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105be7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bea:	e8 81 dc ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bef:	31 d2                	xor    %edx,%edx
80105bf1:	eb 0d                	jmp    80105c00 <sys_pipe+0x80>
80105bf3:	90                   	nop
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bf8:	83 c2 01             	add    $0x1,%edx
80105bfb:	83 fa 10             	cmp    $0x10,%edx
80105bfe:	74 28                	je     80105c28 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105c00:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c04:	85 c9                	test   %ecx,%ecx
80105c06:	75 f0                	jne    80105bf8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105c08:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c0f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c14:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c17:	31 c0                	xor    %eax,%eax
}
80105c19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c1c:	5b                   	pop    %ebx
80105c1d:	5e                   	pop    %esi
80105c1e:	5f                   	pop    %edi
80105c1f:	5d                   	pop    %ebp
80105c20:	c3                   	ret    
80105c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105c28:	e8 43 dc ff ff       	call   80103870 <myproc>
80105c2d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c34:	00 
80105c35:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105c38:	83 ec 0c             	sub    $0xc,%esp
80105c3b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c3e:	e8 1d b2 ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80105c43:	58                   	pop    %eax
80105c44:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c47:	e8 14 b2 ff ff       	call   80100e60 <fileclose>
    return -1;
80105c4c:	83 c4 10             	add    $0x10,%esp
80105c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c54:	eb c3                	jmp    80105c19 <sys_pipe+0x99>
80105c56:	66 90                	xchg   %ax,%ax
80105c58:	66 90                	xchg   %ax,%ax
80105c5a:	66 90                	xchg   %ax,%ax
80105c5c:	66 90                	xchg   %ax,%ax
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105c63:	5d                   	pop    %ebp
  return fork();
80105c64:	e9 a7 dd ff ff       	jmp    80103a10 <fork>
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_exit>:

int
sys_exit(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c76:	e8 45 e0 ff ff       	call   80103cc0 <exit>
  return 0;  // not reached
}
80105c7b:	31 c0                	xor    %eax,%eax
80105c7d:	c9                   	leave  
80105c7e:	c3                   	ret    
80105c7f:	90                   	nop

80105c80 <sys_wait>:

int
sys_wait(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c83:	5d                   	pop    %ebp
  return wait();
80105c84:	e9 77 e2 ff ff       	jmp    80103f00 <wait>
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_kill>:

int
sys_kill(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c99:	50                   	push   %eax
80105c9a:	6a 00                	push   $0x0
80105c9c:	e8 7f f2 ff ff       	call   80104f20 <argint>
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	85 c0                	test   %eax,%eax
80105ca6:	78 18                	js     80105cc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ca8:	83 ec 0c             	sub    $0xc,%esp
80105cab:	ff 75 f4             	pushl  -0xc(%ebp)
80105cae:	e8 dd e4 ff ff       	call   80104190 <kill>
80105cb3:	83 c4 10             	add    $0x10,%esp
}
80105cb6:	c9                   	leave  
80105cb7:	c3                   	ret    
80105cb8:	90                   	nop
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_getpid>:

int
sys_getpid(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105cd6:	e8 95 db ff ff       	call   80103870 <myproc>
80105cdb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cde:	c9                   	leave  
80105cdf:	c3                   	ret    

80105ce0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ce7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cea:	50                   	push   %eax
80105ceb:	6a 00                	push   $0x0
80105ced:	e8 2e f2 ff ff       	call   80104f20 <argint>
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	78 27                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cf9:	e8 72 db ff ff       	call   80103870 <myproc>
  if(growproc(n) < 0)
80105cfe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d01:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d03:	ff 75 f4             	pushl  -0xc(%ebp)
80105d06:	e8 85 dc ff ff       	call   80103990 <growproc>
80105d0b:	83 c4 10             	add    $0x10,%esp
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	78 0e                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d12:	89 d8                	mov    %ebx,%eax
80105d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d17:	c9                   	leave  
80105d18:	c3                   	ret    
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d25:	eb eb                	jmp    80105d12 <sys_sbrk+0x32>
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_sleep>:

int
sys_sleep(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d3a:	50                   	push   %eax
80105d3b:	6a 00                	push   $0x0
80105d3d:	e8 de f1 ff ff       	call   80104f20 <argint>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	0f 88 8a 00 00 00    	js     80105dd7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 80 81 16 80       	push   $0x80168180
80105d55:	e8 b6 ed ff ff       	call   80104b10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d5d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105d60:	8b 1d c0 89 16 80    	mov    0x801689c0,%ebx
  while(ticks - ticks0 < n){
80105d66:	85 d2                	test   %edx,%edx
80105d68:	75 27                	jne    80105d91 <sys_sleep+0x61>
80105d6a:	eb 54                	jmp    80105dc0 <sys_sleep+0x90>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	68 80 81 16 80       	push   $0x80168180
80105d78:	68 c0 89 16 80       	push   $0x801689c0
80105d7d:	e8 be e0 ff ff       	call   80103e40 <sleep>
  while(ticks - ticks0 < n){
80105d82:	a1 c0 89 16 80       	mov    0x801689c0,%eax
80105d87:	83 c4 10             	add    $0x10,%esp
80105d8a:	29 d8                	sub    %ebx,%eax
80105d8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d8f:	73 2f                	jae    80105dc0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d91:	e8 da da ff ff       	call   80103870 <myproc>
80105d96:	8b 40 24             	mov    0x24(%eax),%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	74 d3                	je     80105d70 <sys_sleep+0x40>
      release(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 80 81 16 80       	push   $0x80168180
80105da5:	e8 26 ee ff ff       	call   80104bd0 <release>
      return -1;
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	68 80 81 16 80       	push   $0x80168180
80105dc8:	e8 03 ee ff ff       	call   80104bd0 <release>
  return 0;
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	31 c0                	xor    %eax,%eax
}
80105dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
    return -1;
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddc:	eb f4                	jmp    80105dd2 <sys_sleep+0xa2>
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	53                   	push   %ebx
80105de4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105de7:	68 80 81 16 80       	push   $0x80168180
80105dec:	e8 1f ed ff ff       	call   80104b10 <acquire>
  xticks = ticks;
80105df1:	8b 1d c0 89 16 80    	mov    0x801689c0,%ebx
  release(&tickslock);
80105df7:	c7 04 24 80 81 16 80 	movl   $0x80168180,(%esp)
80105dfe:	e8 cd ed ff ff       	call   80104bd0 <release>
  return xticks;
}
80105e03:	89 d8                	mov    %ebx,%eax
80105e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e08:	c9                   	leave  
80105e09:	c3                   	ret    
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e10 <sys_print_count>:

extern int system_call_count[NoSysCalls];
extern char *system_call_names[NoSysCalls];

int
sys_print_count(void){
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
80105e14:	31 db                	xor    %ebx,%ebx
80105e16:	83 ec 04             	sub    $0x4,%esp
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int i;
  for(i = 0 ; i < NoPrintSysCalls; i++){
    if(system_call_count[i] > 0)
80105e20:	8b 83 00 81 16 80    	mov    -0x7fe97f00(%ebx),%eax
80105e26:	85 c0                	test   %eax,%eax
80105e28:	7e 17                	jle    80105e41 <sys_print_count+0x31>
    cprintf("%s %d\n", system_call_names[i], system_call_count[i]);
80105e2a:	83 ec 04             	sub    $0x4,%esp
80105e2d:	50                   	push   %eax
80105e2e:	ff b3 20 b0 10 80    	pushl  -0x7fef4fe0(%ebx)
80105e34:	68 e5 82 10 80       	push   $0x801082e5
80105e39:	e8 22 a8 ff ff       	call   80100660 <cprintf>
80105e3e:	83 c4 10             	add    $0x10,%esp
80105e41:	83 c3 04             	add    $0x4,%ebx
  for(i = 0 ; i < NoPrintSysCalls; i++){
80105e44:	83 fb 70             	cmp    $0x70,%ebx
80105e47:	75 d7                	jne    80105e20 <sys_print_count+0x10>
  }
  return 1;
}
80105e49:	b8 01 00 00 00       	mov    $0x1,%eax
80105e4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e51:	c9                   	leave  
80105e52:	c3                   	ret    
80105e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e60 <sys_toggle>:

int 
sys_toggle(void)
{
  if(toggle_flag == 0){
80105e60:	8b 15 3c b6 10 80    	mov    0x8010b63c,%edx
{
80105e66:	55                   	push   %ebp
80105e67:	89 e5                	mov    %esp,%ebp
  if(toggle_flag == 0){
80105e69:	85 d2                	test   %edx,%edx
80105e6b:	75 1b                	jne    80105e88 <sys_toggle+0x28>
80105e6d:	b8 00 81 16 80       	mov    $0x80168100,%eax
80105e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int i;
    for(i = 0; i < NoSysCalls; i++)
      system_call_count[i] = 0;
80105e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105e7e:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < NoSysCalls; i++)
80105e81:	3d 80 81 16 80       	cmp    $0x80168180,%eax
80105e86:	75 f0                	jne    80105e78 <sys_toggle+0x18>
  }
  toggle_flag ^= 1;
80105e88:	83 f2 01             	xor    $0x1,%edx
  return 1;
}
80105e8b:	b8 01 00 00 00       	mov    $0x1,%eax
  toggle_flag ^= 1;
80105e90:	89 15 3c b6 10 80    	mov    %edx,0x8010b63c
}
80105e96:	5d                   	pop    %ebp
80105e97:	c3                   	ret    
80105e98:	90                   	nop
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ea0 <sys_add>:

int
sys_add(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 20             	sub    $0x20,%esp
  int a,b;
  
  // return error if can't fetch the arguments
  if(argint(0, &a) < 0 || argint(1, &b) < 0)
80105ea6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ea9:	50                   	push   %eax
80105eaa:	6a 00                	push   $0x0
80105eac:	e8 6f f0 ff ff       	call   80104f20 <argint>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 20                	js     80105ed8 <sys_add+0x38>
80105eb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ebb:	83 ec 08             	sub    $0x8,%esp
80105ebe:	50                   	push   %eax
80105ebf:	6a 01                	push   $0x1
80105ec1:	e8 5a f0 ff ff       	call   80104f20 <argint>
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	78 0b                	js     80105ed8 <sys_add+0x38>
    return -1;

  return (a+b);
80105ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed0:	03 45 f0             	add    -0x10(%ebp),%eax
}
80105ed3:	c9                   	leave  
80105ed4:	c3                   	ret    
80105ed5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105edd:	c9                   	leave  
80105ede:	c3                   	ret    
80105edf:	90                   	nop

80105ee0 <sys_ps>:

int 
sys_ps(void){
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  ps_print_list();
80105ee6:	e8 f5 e3 ff ff       	call   801042e0 <ps_print_list>
  return 1;
}
80105eeb:	b8 01 00 00 00       	mov    $0x1,%eax
80105ef0:	c9                   	leave  
80105ef1:	c3                   	ret    
80105ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f00 <sys_send>:

// IPC unicast:

int 
sys_send(void){
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 20             	sub    $0x20,%esp
  int sender_pid, rec_pid;
  char* msg;
  // fetch the arguments
  if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSGSIZE) < 0)
80105f06:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f09:	50                   	push   %eax
80105f0a:	6a 00                	push   $0x0
80105f0c:	e8 0f f0 ff ff       	call   80104f20 <argint>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	78 48                	js     80105f60 <sys_send+0x60>
80105f18:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f1b:	83 ec 08             	sub    $0x8,%esp
80105f1e:	50                   	push   %eax
80105f1f:	6a 01                	push   $0x1
80105f21:	e8 fa ef ff ff       	call   80104f20 <argint>
80105f26:	83 c4 10             	add    $0x10,%esp
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	78 33                	js     80105f60 <sys_send+0x60>
80105f2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f30:	83 ec 04             	sub    $0x4,%esp
80105f33:	6a 08                	push   $0x8
80105f35:	50                   	push   %eax
80105f36:	6a 02                	push   $0x2
80105f38:	e8 33 f0 ff ff       	call   80104f70 <argptr>
80105f3d:	83 c4 10             	add    $0x10,%esp
80105f40:	85 c0                	test   %eax,%eax
80105f42:	78 1c                	js     80105f60 <sys_send+0x60>
    return -1;
  return send_msg(sender_pid, rec_pid, msg);
80105f44:	83 ec 04             	sub    $0x4,%esp
80105f47:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4a:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4d:	ff 75 ec             	pushl  -0x14(%ebp)
80105f50:	e8 2b e4 ff ff       	call   80104380 <send_msg>
80105f55:	83 c4 10             	add    $0x10,%esp
}
80105f58:	c9                   	leave  
80105f59:	c3                   	ret    
80105f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f65:	c9                   	leave  
80105f66:	c3                   	ret    
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <sys_recv>:

int 
sys_recv(void){
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 1c             	sub    $0x1c,%esp
  char* msg;
  // fetch the arguments
  if(argptr(0, &msg, MSGSIZE) < 0)
80105f76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f79:	6a 08                	push   $0x8
80105f7b:	50                   	push   %eax
80105f7c:	6a 00                	push   $0x0
80105f7e:	e8 ed ef ff ff       	call   80104f70 <argptr>
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	85 c0                	test   %eax,%eax
80105f88:	78 16                	js     80105fa0 <sys_recv+0x30>
    return -1;
  return recv_msg(msg);
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	ff 75 f4             	pushl  -0xc(%ebp)
80105f90:	e8 db e4 ff ff       	call   80104470 <recv_msg>
80105f95:	83 c4 10             	add    $0x10,%esp
}
80105f98:	c9                   	leave  
80105f99:	c3                   	ret    
80105f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa5:	c9                   	leave  
80105fa6:	c3                   	ret    
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fb0 <sys_sig_set>:

// Signals:

int
sys_sig_set(void){
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 20             	sub    $0x20,%esp
  int sig_num;
  char* handler_char;
  sighandler_t handler;
  // fetch the arguments
  if(argint(0, &sig_num) < 0 || argptr(1, &handler_char, 4) < 0)
80105fb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb9:	50                   	push   %eax
80105fba:	6a 00                	push   $0x0
80105fbc:	e8 5f ef ff ff       	call   80104f20 <argint>
80105fc1:	83 c4 10             	add    $0x10,%esp
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	78 30                	js     80105ff8 <sys_sig_set+0x48>
80105fc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fcb:	83 ec 04             	sub    $0x4,%esp
80105fce:	6a 04                	push   $0x4
80105fd0:	50                   	push   %eax
80105fd1:	6a 01                	push   $0x1
80105fd3:	e8 98 ef ff ff       	call   80104f70 <argptr>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	85 c0                	test   %eax,%eax
80105fdd:	78 19                	js     80105ff8 <sys_sig_set+0x48>
    return -1;
  handler = (sighandler_t) handler_char;
  return sig_set(sig_num, handler);
80105fdf:	83 ec 08             	sub    $0x8,%esp
80105fe2:	ff 75 f4             	pushl  -0xc(%ebp)
80105fe5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fe8:	e8 a3 e5 ff ff       	call   80104590 <sig_set>
80105fed:	83 c4 10             	add    $0x10,%esp
}
80105ff0:	c9                   	leave  
80105ff1:	c3                   	ret    
80105ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ffd:	c9                   	leave  
80105ffe:	c3                   	ret    
80105fff:	90                   	nop

80106000 <sys_sig_send>:

int
sys_sig_send(void){
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 20             	sub    $0x20,%esp
  int sig_num, dest_pid;
  char *sig_arg;
  // fetch the arguments
  if(argint(0, &dest_pid), argint(1, &sig_num) < 0 || argptr(2, &sig_arg, MSGSIZE) < 0)
80106006:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106009:	50                   	push   %eax
8010600a:	6a 00                	push   $0x0
8010600c:	e8 0f ef ff ff       	call   80104f20 <argint>
80106011:	58                   	pop    %eax
80106012:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106015:	5a                   	pop    %edx
80106016:	50                   	push   %eax
80106017:	6a 01                	push   $0x1
80106019:	e8 02 ef ff ff       	call   80104f20 <argint>
8010601e:	83 c4 10             	add    $0x10,%esp
80106021:	85 c0                	test   %eax,%eax
80106023:	78 33                	js     80106058 <sys_sig_send+0x58>
80106025:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106028:	83 ec 04             	sub    $0x4,%esp
8010602b:	6a 08                	push   $0x8
8010602d:	50                   	push   %eax
8010602e:	6a 02                	push   $0x2
80106030:	e8 3b ef ff ff       	call   80104f70 <argptr>
80106035:	83 c4 10             	add    $0x10,%esp
80106038:	85 c0                	test   %eax,%eax
8010603a:	78 1c                	js     80106058 <sys_sig_send+0x58>
    return -1;
  return sig_send(dest_pid, sig_num, sig_arg);
8010603c:	83 ec 04             	sub    $0x4,%esp
8010603f:	ff 75 f4             	pushl  -0xc(%ebp)
80106042:	ff 75 ec             	pushl  -0x14(%ebp)
80106045:	ff 75 f0             	pushl  -0x10(%ebp)
80106048:	e8 83 e5 ff ff       	call   801045d0 <sig_send>
8010604d:	83 c4 10             	add    $0x10,%esp
}
80106050:	c9                   	leave  
80106051:	c3                   	ret    
80106052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010605d:	c9                   	leave  
8010605e:	c3                   	ret    
8010605f:	90                   	nop

80106060 <sys_sig_pause>:

int
sys_sig_pause(void){
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 1c             	sub    $0x1c,%esp
  int *flag_addr, flag_expected;
  if(argptr(0, (char **)&flag_addr, 4) < 0 || argint(1, &flag_expected) < 0)
80106066:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106069:	6a 04                	push   $0x4
8010606b:	50                   	push   %eax
8010606c:	6a 00                	push   $0x0
8010606e:	e8 fd ee ff ff       	call   80104f70 <argptr>
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	85 c0                	test   %eax,%eax
80106078:	78 2e                	js     801060a8 <sys_sig_pause+0x48>
8010607a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010607d:	83 ec 08             	sub    $0x8,%esp
80106080:	50                   	push   %eax
80106081:	6a 01                	push   $0x1
80106083:	e8 98 ee ff ff       	call   80104f20 <argint>
80106088:	83 c4 10             	add    $0x10,%esp
8010608b:	85 c0                	test   %eax,%eax
8010608d:	78 19                	js     801060a8 <sys_sig_pause+0x48>
    return -1;
  // debug:
  // cprintf("%p, %d\n",flag_addr, flag_expected);
  return sig_pause(flag_addr, flag_expected);
8010608f:	83 ec 08             	sub    $0x8,%esp
80106092:	ff 75 f4             	pushl  -0xc(%ebp)
80106095:	ff 75 f0             	pushl  -0x10(%ebp)
80106098:	e8 53 e5 ff ff       	call   801045f0 <sig_pause>
8010609d:	83 c4 10             	add    $0x10,%esp
}
801060a0:	c9                   	leave  
801060a1:	c3                   	ret    
801060a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801060a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ad:	c9                   	leave  
801060ae:	c3                   	ret    
801060af:	90                   	nop

801060b0 <sys_sig_ret>:

int
sys_sig_ret(void){
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
  return sig_ret();
}
801060b3:	5d                   	pop    %ebp
  return sig_ret();
801060b4:	e9 07 e6 ff ff       	jmp    801046c0 <sig_ret>
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_send_multi>:

// IPC multicast:
int
sys_send_multi(void){
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 20             	sub    $0x20,%esp
  char *rec_pids_char;
  int sender_pid, *rec_pids, rec_length;
  char* msg;

  // fetch the arguments
  if(argint(3, &rec_length) < 0)
801060c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060c9:	50                   	push   %eax
801060ca:	6a 03                	push   $0x3
801060cc:	e8 4f ee ff ff       	call   80104f20 <argint>
801060d1:	83 c4 10             	add    $0x10,%esp
801060d4:	85 c0                	test   %eax,%eax
801060d6:	78 68                	js     80106140 <sys_send_multi+0x80>
    return -1;
  if(argint(0, &sender_pid) < 0 || argptr(1, &rec_pids_char, 4*rec_length) < 0
801060d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060db:	83 ec 08             	sub    $0x8,%esp
801060de:	50                   	push   %eax
801060df:	6a 00                	push   $0x0
801060e1:	e8 3a ee ff ff       	call   80104f20 <argint>
801060e6:	83 c4 10             	add    $0x10,%esp
801060e9:	85 c0                	test   %eax,%eax
801060eb:	78 53                	js     80106140 <sys_send_multi+0x80>
801060ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f0:	83 ec 04             	sub    $0x4,%esp
801060f3:	c1 e0 02             	shl    $0x2,%eax
801060f6:	50                   	push   %eax
801060f7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060fa:	50                   	push   %eax
801060fb:	6a 01                	push   $0x1
801060fd:	e8 6e ee ff ff       	call   80104f70 <argptr>
80106102:	83 c4 10             	add    $0x10,%esp
80106105:	85 c0                	test   %eax,%eax
80106107:	78 37                	js     80106140 <sys_send_multi+0x80>
   || argptr(2, &msg, MSGSIZE) < 0)
80106109:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010610c:	83 ec 04             	sub    $0x4,%esp
8010610f:	6a 08                	push   $0x8
80106111:	50                   	push   %eax
80106112:	6a 02                	push   $0x2
80106114:	e8 57 ee ff ff       	call   80104f70 <argptr>
80106119:	83 c4 10             	add    $0x10,%esp
8010611c:	85 c0                	test   %eax,%eax
8010611e:	78 20                	js     80106140 <sys_send_multi+0x80>
    return -1;

  rec_pids = (int *)rec_pids_char;
  return send_multi(sender_pid, rec_pids, msg, rec_length);
80106120:	ff 75 f0             	pushl  -0x10(%ebp)
80106123:	ff 75 f4             	pushl  -0xc(%ebp)
80106126:	ff 75 e8             	pushl  -0x18(%ebp)
80106129:	ff 75 ec             	pushl  -0x14(%ebp)
8010612c:	e8 1f e7 ff ff       	call   80104850 <send_multi>
80106131:	83 c4 10             	add    $0x10,%esp
80106134:	c9                   	leave  
80106135:	c3                   	ret    
80106136:	8d 76 00             	lea    0x0(%esi),%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106145:	c9                   	leave  
80106146:	c3                   	ret    

80106147 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106147:	1e                   	push   %ds
  pushl %es
80106148:	06                   	push   %es
  pushl %fs
80106149:	0f a0                	push   %fs
  pushl %gs
8010614b:	0f a8                	push   %gs
  pushal
8010614d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010614e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106152:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106154:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106156:	54                   	push   %esp
  call trap
80106157:	e8 c4 00 00 00       	call   80106220 <trap>
  addl $4, %esp
8010615c:	83 c4 04             	add    $0x4,%esp

8010615f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  # ****added**************
  call execute_signal_handler
8010615f:	e8 9c e5 ff ff       	call   80104700 <execute_signal_handler>
  # ****
  popal
80106164:	61                   	popa   
  popl %gs
80106165:	0f a9                	pop    %gs
  popl %fs
80106167:	0f a1                	pop    %fs
  popl %es
80106169:	07                   	pop    %es
  popl %ds
8010616a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010616b:	83 c4 08             	add    $0x8,%esp
  iret
8010616e:	cf                   	iret   
8010616f:	90                   	nop

80106170 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106170:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106171:	31 c0                	xor    %eax,%eax
{
80106173:	89 e5                	mov    %esp,%ebp
80106175:	83 ec 08             	sub    $0x8,%esp
80106178:	90                   	nop
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106180:	8b 14 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%edx
80106187:	c7 04 c5 c2 81 16 80 	movl   $0x8e000008,-0x7fe97e3e(,%eax,8)
8010618e:	08 00 00 8e 
80106192:	66 89 14 c5 c0 81 16 	mov    %dx,-0x7fe97e40(,%eax,8)
80106199:	80 
8010619a:	c1 ea 10             	shr    $0x10,%edx
8010619d:	66 89 14 c5 c6 81 16 	mov    %dx,-0x7fe97e3a(,%eax,8)
801061a4:	80 
  for(i = 0; i < 256; i++)
801061a5:	83 c0 01             	add    $0x1,%eax
801061a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061ad:	75 d1                	jne    80106180 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061af:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax

  initlock(&tickslock, "time");
801061b4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061b7:	c7 05 c2 83 16 80 08 	movl   $0xef000008,0x801683c2
801061be:	00 00 ef 
  initlock(&tickslock, "time");
801061c1:	68 30 81 10 80       	push   $0x80108130
801061c6:	68 80 81 16 80       	push   $0x80168180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061cb:	66 a3 c0 83 16 80    	mov    %ax,0x801683c0
801061d1:	c1 e8 10             	shr    $0x10,%eax
801061d4:	66 a3 c6 83 16 80    	mov    %ax,0x801683c6
  initlock(&tickslock, "time");
801061da:	e8 f1 e7 ff ff       	call   801049d0 <initlock>
}
801061df:	83 c4 10             	add    $0x10,%esp
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801061f0 <idtinit>:

void
idtinit(void)
{
801061f0:	55                   	push   %ebp
  pd[0] = size-1;
801061f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061f6:	89 e5                	mov    %esp,%ebp
801061f8:	83 ec 10             	sub    $0x10,%esp
801061fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061ff:	b8 c0 81 16 80       	mov    $0x801681c0,%eax
80106204:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106208:	c1 e8 10             	shr    $0x10,%eax
8010620b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010620f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106212:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106220 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	57                   	push   %edi
80106224:	56                   	push   %esi
80106225:	53                   	push   %ebx
80106226:	83 ec 1c             	sub    $0x1c,%esp
80106229:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010622c:	8b 47 30             	mov    0x30(%edi),%eax
8010622f:	83 f8 40             	cmp    $0x40,%eax
80106232:	0f 84 f0 00 00 00    	je     80106328 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106238:	83 e8 20             	sub    $0x20,%eax
8010623b:	83 f8 1f             	cmp    $0x1f,%eax
8010623e:	77 10                	ja     80106250 <trap+0x30>
80106240:	ff 24 85 90 83 10 80 	jmp    *-0x7fef7c70(,%eax,4)
80106247:	89 f6                	mov    %esi,%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106250:	e8 1b d6 ff ff       	call   80103870 <myproc>
80106255:	85 c0                	test   %eax,%eax
80106257:	8b 5f 38             	mov    0x38(%edi),%ebx
8010625a:	0f 84 14 02 00 00    	je     80106474 <trap+0x254>
80106260:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106264:	0f 84 0a 02 00 00    	je     80106474 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010626a:	0f 20 d1             	mov    %cr2,%ecx
8010626d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106270:	e8 db d5 ff ff       	call   80103850 <cpuid>
80106275:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106278:	8b 47 34             	mov    0x34(%edi),%eax
8010627b:	8b 77 30             	mov    0x30(%edi),%esi
8010627e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106281:	e8 ea d5 ff ff       	call   80103870 <myproc>
80106286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106289:	e8 e2 d5 ff ff       	call   80103870 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106291:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106294:	51                   	push   %ecx
80106295:	53                   	push   %ebx
80106296:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106297:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010629d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010629e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062a1:	52                   	push   %edx
801062a2:	ff 70 10             	pushl  0x10(%eax)
801062a5:	68 4c 83 10 80       	push   $0x8010834c
801062aa:	e8 b1 a3 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062af:	83 c4 20             	add    $0x20,%esp
801062b2:	e8 b9 d5 ff ff       	call   80103870 <myproc>
801062b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062be:	e8 ad d5 ff ff       	call   80103870 <myproc>
801062c3:	85 c0                	test   %eax,%eax
801062c5:	74 1d                	je     801062e4 <trap+0xc4>
801062c7:	e8 a4 d5 ff ff       	call   80103870 <myproc>
801062cc:	8b 50 24             	mov    0x24(%eax),%edx
801062cf:	85 d2                	test   %edx,%edx
801062d1:	74 11                	je     801062e4 <trap+0xc4>
801062d3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801062d7:	83 e0 03             	and    $0x3,%eax
801062da:	66 83 f8 03          	cmp    $0x3,%ax
801062de:	0f 84 4c 01 00 00    	je     80106430 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062e4:	e8 87 d5 ff ff       	call   80103870 <myproc>
801062e9:	85 c0                	test   %eax,%eax
801062eb:	74 0b                	je     801062f8 <trap+0xd8>
801062ed:	e8 7e d5 ff ff       	call   80103870 <myproc>
801062f2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062f6:	74 68                	je     80106360 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062f8:	e8 73 d5 ff ff       	call   80103870 <myproc>
801062fd:	85 c0                	test   %eax,%eax
801062ff:	74 19                	je     8010631a <trap+0xfa>
80106301:	e8 6a d5 ff ff       	call   80103870 <myproc>
80106306:	8b 40 24             	mov    0x24(%eax),%eax
80106309:	85 c0                	test   %eax,%eax
8010630b:	74 0d                	je     8010631a <trap+0xfa>
8010630d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106311:	83 e0 03             	and    $0x3,%eax
80106314:	66 83 f8 03          	cmp    $0x3,%ax
80106318:	74 37                	je     80106351 <trap+0x131>
    exit();
}
8010631a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010631d:	5b                   	pop    %ebx
8010631e:	5e                   	pop    %esi
8010631f:	5f                   	pop    %edi
80106320:	5d                   	pop    %ebp
80106321:	c3                   	ret    
80106322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106328:	e8 43 d5 ff ff       	call   80103870 <myproc>
8010632d:	8b 58 24             	mov    0x24(%eax),%ebx
80106330:	85 db                	test   %ebx,%ebx
80106332:	0f 85 e8 00 00 00    	jne    80106420 <trap+0x200>
    myproc()->tf = tf;
80106338:	e8 33 d5 ff ff       	call   80103870 <myproc>
8010633d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106340:	e8 cb ec ff ff       	call   80105010 <syscall>
    if(myproc()->killed)
80106345:	e8 26 d5 ff ff       	call   80103870 <myproc>
8010634a:	8b 48 24             	mov    0x24(%eax),%ecx
8010634d:	85 c9                	test   %ecx,%ecx
8010634f:	74 c9                	je     8010631a <trap+0xfa>
}
80106351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106354:	5b                   	pop    %ebx
80106355:	5e                   	pop    %esi
80106356:	5f                   	pop    %edi
80106357:	5d                   	pop    %ebp
      exit();
80106358:	e9 63 d9 ff ff       	jmp    80103cc0 <exit>
8010635d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106360:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106364:	75 92                	jne    801062f8 <trap+0xd8>
    yield();
80106366:	e8 85 da ff ff       	call   80103df0 <yield>
8010636b:	eb 8b                	jmp    801062f8 <trap+0xd8>
8010636d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106370:	e8 db d4 ff ff       	call   80103850 <cpuid>
80106375:	85 c0                	test   %eax,%eax
80106377:	0f 84 c3 00 00 00    	je     80106440 <trap+0x220>
    lapiceoi();
8010637d:	e8 fe c3 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106382:	e8 e9 d4 ff ff       	call   80103870 <myproc>
80106387:	85 c0                	test   %eax,%eax
80106389:	0f 85 38 ff ff ff    	jne    801062c7 <trap+0xa7>
8010638f:	e9 50 ff ff ff       	jmp    801062e4 <trap+0xc4>
80106394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106398:	e8 a3 c2 ff ff       	call   80102640 <kbdintr>
    lapiceoi();
8010639d:	e8 de c3 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063a2:	e8 c9 d4 ff ff       	call   80103870 <myproc>
801063a7:	85 c0                	test   %eax,%eax
801063a9:	0f 85 18 ff ff ff    	jne    801062c7 <trap+0xa7>
801063af:	e9 30 ff ff ff       	jmp    801062e4 <trap+0xc4>
801063b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801063b8:	e8 53 02 00 00       	call   80106610 <uartintr>
    lapiceoi();
801063bd:	e8 be c3 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063c2:	e8 a9 d4 ff ff       	call   80103870 <myproc>
801063c7:	85 c0                	test   %eax,%eax
801063c9:	0f 85 f8 fe ff ff    	jne    801062c7 <trap+0xa7>
801063cf:	e9 10 ff ff ff       	jmp    801062e4 <trap+0xc4>
801063d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063d8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801063dc:	8b 77 38             	mov    0x38(%edi),%esi
801063df:	e8 6c d4 ff ff       	call   80103850 <cpuid>
801063e4:	56                   	push   %esi
801063e5:	53                   	push   %ebx
801063e6:	50                   	push   %eax
801063e7:	68 f4 82 10 80       	push   $0x801082f4
801063ec:	e8 6f a2 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801063f1:	e8 8a c3 ff ff       	call   80102780 <lapiceoi>
    break;
801063f6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063f9:	e8 72 d4 ff ff       	call   80103870 <myproc>
801063fe:	85 c0                	test   %eax,%eax
80106400:	0f 85 c1 fe ff ff    	jne    801062c7 <trap+0xa7>
80106406:	e9 d9 fe ff ff       	jmp    801062e4 <trap+0xc4>
8010640b:	90                   	nop
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106410:	e8 9b bc ff ff       	call   801020b0 <ideintr>
80106415:	e9 63 ff ff ff       	jmp    8010637d <trap+0x15d>
8010641a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106420:	e8 9b d8 ff ff       	call   80103cc0 <exit>
80106425:	e9 0e ff ff ff       	jmp    80106338 <trap+0x118>
8010642a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106430:	e8 8b d8 ff ff       	call   80103cc0 <exit>
80106435:	e9 aa fe ff ff       	jmp    801062e4 <trap+0xc4>
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	68 80 81 16 80       	push   $0x80168180
80106448:	e8 c3 e6 ff ff       	call   80104b10 <acquire>
      wakeup(&ticks);
8010644d:	c7 04 24 c0 89 16 80 	movl   $0x801689c0,(%esp)
      ticks++;
80106454:	83 05 c0 89 16 80 01 	addl   $0x1,0x801689c0
      wakeup(&ticks);
8010645b:	e8 a0 db ff ff       	call   80104000 <wakeup>
      release(&tickslock);
80106460:	c7 04 24 80 81 16 80 	movl   $0x80168180,(%esp)
80106467:	e8 64 e7 ff ff       	call   80104bd0 <release>
8010646c:	83 c4 10             	add    $0x10,%esp
8010646f:	e9 09 ff ff ff       	jmp    8010637d <trap+0x15d>
80106474:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106477:	e8 d4 d3 ff ff       	call   80103850 <cpuid>
8010647c:	83 ec 0c             	sub    $0xc,%esp
8010647f:	56                   	push   %esi
80106480:	53                   	push   %ebx
80106481:	50                   	push   %eax
80106482:	ff 77 30             	pushl  0x30(%edi)
80106485:	68 18 83 10 80       	push   $0x80108318
8010648a:	e8 d1 a1 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010648f:	83 c4 14             	add    $0x14,%esp
80106492:	68 ec 82 10 80       	push   $0x801082ec
80106497:	e8 f4 9e ff ff       	call   80100390 <panic>
8010649c:	66 90                	xchg   %ax,%ax
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064a0:	a1 40 b6 10 80       	mov    0x8010b640,%eax
{
801064a5:	55                   	push   %ebp
801064a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801064a8:	85 c0                	test   %eax,%eax
801064aa:	74 1c                	je     801064c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064b2:	a8 01                	test   $0x1,%al
801064b4:	74 12                	je     801064c8 <uartgetc+0x28>
801064b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064bb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064bc:	0f b6 c0             	movzbl %al,%eax
}
801064bf:	5d                   	pop    %ebp
801064c0:	c3                   	ret    
801064c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064cd:	5d                   	pop    %ebp
801064ce:	c3                   	ret    
801064cf:	90                   	nop

801064d0 <uartputc.part.0>:
uartputc(int c)
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	57                   	push   %edi
801064d4:	56                   	push   %esi
801064d5:	53                   	push   %ebx
801064d6:	89 c7                	mov    %eax,%edi
801064d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801064dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801064e2:	83 ec 0c             	sub    $0xc,%esp
801064e5:	eb 1b                	jmp    80106502 <uartputc.part.0+0x32>
801064e7:	89 f6                	mov    %esi,%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	6a 0a                	push   $0xa
801064f5:	e8 a6 c2 ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	83 eb 01             	sub    $0x1,%ebx
80106500:	74 07                	je     80106509 <uartputc.part.0+0x39>
80106502:	89 f2                	mov    %esi,%edx
80106504:	ec                   	in     (%dx),%al
80106505:	a8 20                	test   $0x20,%al
80106507:	74 e7                	je     801064f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106509:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650e:	89 f8                	mov    %edi,%eax
80106510:	ee                   	out    %al,(%dx)
}
80106511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106514:	5b                   	pop    %ebx
80106515:	5e                   	pop    %esi
80106516:	5f                   	pop    %edi
80106517:	5d                   	pop    %ebp
80106518:	c3                   	ret    
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106520 <uartinit>:
{
80106520:	55                   	push   %ebp
80106521:	31 c9                	xor    %ecx,%ecx
80106523:	89 c8                	mov    %ecx,%eax
80106525:	89 e5                	mov    %esp,%ebp
80106527:	57                   	push   %edi
80106528:	56                   	push   %esi
80106529:	53                   	push   %ebx
8010652a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010652f:	89 da                	mov    %ebx,%edx
80106531:	83 ec 0c             	sub    $0xc,%esp
80106534:	ee                   	out    %al,(%dx)
80106535:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010653a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010653f:	89 fa                	mov    %edi,%edx
80106541:	ee                   	out    %al,(%dx)
80106542:	b8 0c 00 00 00       	mov    $0xc,%eax
80106547:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654c:	ee                   	out    %al,(%dx)
8010654d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106552:	89 c8                	mov    %ecx,%eax
80106554:	89 f2                	mov    %esi,%edx
80106556:	ee                   	out    %al,(%dx)
80106557:	b8 03 00 00 00       	mov    $0x3,%eax
8010655c:	89 fa                	mov    %edi,%edx
8010655e:	ee                   	out    %al,(%dx)
8010655f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106564:	89 c8                	mov    %ecx,%eax
80106566:	ee                   	out    %al,(%dx)
80106567:	b8 01 00 00 00       	mov    $0x1,%eax
8010656c:	89 f2                	mov    %esi,%edx
8010656e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010656f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106574:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106575:	3c ff                	cmp    $0xff,%al
80106577:	74 5a                	je     801065d3 <uartinit+0xb3>
  uart = 1;
80106579:	c7 05 40 b6 10 80 01 	movl   $0x1,0x8010b640
80106580:	00 00 00 
80106583:	89 da                	mov    %ebx,%edx
80106585:	ec                   	in     (%dx),%al
80106586:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010658c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010658f:	bb 10 84 10 80       	mov    $0x80108410,%ebx
  ioapicenable(IRQ_COM1, 0);
80106594:	6a 00                	push   $0x0
80106596:	6a 04                	push   $0x4
80106598:	e8 63 bd ff ff       	call   80102300 <ioapicenable>
8010659d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065a0:	b8 78 00 00 00       	mov    $0x78,%eax
801065a5:	eb 13                	jmp    801065ba <uartinit+0x9a>
801065a7:	89 f6                	mov    %esi,%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801065b0:	83 c3 01             	add    $0x1,%ebx
801065b3:	0f be 03             	movsbl (%ebx),%eax
801065b6:	84 c0                	test   %al,%al
801065b8:	74 19                	je     801065d3 <uartinit+0xb3>
  if(!uart)
801065ba:	8b 15 40 b6 10 80    	mov    0x8010b640,%edx
801065c0:	85 d2                	test   %edx,%edx
801065c2:	74 ec                	je     801065b0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801065c4:	83 c3 01             	add    $0x1,%ebx
801065c7:	e8 04 ff ff ff       	call   801064d0 <uartputc.part.0>
801065cc:	0f be 03             	movsbl (%ebx),%eax
801065cf:	84 c0                	test   %al,%al
801065d1:	75 e7                	jne    801065ba <uartinit+0x9a>
}
801065d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d6:	5b                   	pop    %ebx
801065d7:	5e                   	pop    %esi
801065d8:	5f                   	pop    %edi
801065d9:	5d                   	pop    %ebp
801065da:	c3                   	ret    
801065db:	90                   	nop
801065dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065e0 <uartputc>:
  if(!uart)
801065e0:	8b 15 40 b6 10 80    	mov    0x8010b640,%edx
{
801065e6:	55                   	push   %ebp
801065e7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801065e9:	85 d2                	test   %edx,%edx
{
801065eb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065ee:	74 10                	je     80106600 <uartputc+0x20>
}
801065f0:	5d                   	pop    %ebp
801065f1:	e9 da fe ff ff       	jmp    801064d0 <uartputc.part.0>
801065f6:	8d 76 00             	lea    0x0(%esi),%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106600:	5d                   	pop    %ebp
80106601:	c3                   	ret    
80106602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <uartintr>:

void
uartintr(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106616:	68 a0 64 10 80       	push   $0x801064a0
8010661b:	e8 f0 a1 ff ff       	call   80100810 <consoleintr>
}
80106620:	83 c4 10             	add    $0x10,%esp
80106623:	c9                   	leave  
80106624:	c3                   	ret    

80106625 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $0
80106627:	6a 00                	push   $0x0
  jmp alltraps
80106629:	e9 19 fb ff ff       	jmp    80106147 <alltraps>

8010662e <vector1>:
.globl vector1
vector1:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $1
80106630:	6a 01                	push   $0x1
  jmp alltraps
80106632:	e9 10 fb ff ff       	jmp    80106147 <alltraps>

80106637 <vector2>:
.globl vector2
vector2:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $2
80106639:	6a 02                	push   $0x2
  jmp alltraps
8010663b:	e9 07 fb ff ff       	jmp    80106147 <alltraps>

80106640 <vector3>:
.globl vector3
vector3:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $3
80106642:	6a 03                	push   $0x3
  jmp alltraps
80106644:	e9 fe fa ff ff       	jmp    80106147 <alltraps>

80106649 <vector4>:
.globl vector4
vector4:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $4
8010664b:	6a 04                	push   $0x4
  jmp alltraps
8010664d:	e9 f5 fa ff ff       	jmp    80106147 <alltraps>

80106652 <vector5>:
.globl vector5
vector5:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $5
80106654:	6a 05                	push   $0x5
  jmp alltraps
80106656:	e9 ec fa ff ff       	jmp    80106147 <alltraps>

8010665b <vector6>:
.globl vector6
vector6:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $6
8010665d:	6a 06                	push   $0x6
  jmp alltraps
8010665f:	e9 e3 fa ff ff       	jmp    80106147 <alltraps>

80106664 <vector7>:
.globl vector7
vector7:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $7
80106666:	6a 07                	push   $0x7
  jmp alltraps
80106668:	e9 da fa ff ff       	jmp    80106147 <alltraps>

8010666d <vector8>:
.globl vector8
vector8:
  pushl $8
8010666d:	6a 08                	push   $0x8
  jmp alltraps
8010666f:	e9 d3 fa ff ff       	jmp    80106147 <alltraps>

80106674 <vector9>:
.globl vector9
vector9:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $9
80106676:	6a 09                	push   $0x9
  jmp alltraps
80106678:	e9 ca fa ff ff       	jmp    80106147 <alltraps>

8010667d <vector10>:
.globl vector10
vector10:
  pushl $10
8010667d:	6a 0a                	push   $0xa
  jmp alltraps
8010667f:	e9 c3 fa ff ff       	jmp    80106147 <alltraps>

80106684 <vector11>:
.globl vector11
vector11:
  pushl $11
80106684:	6a 0b                	push   $0xb
  jmp alltraps
80106686:	e9 bc fa ff ff       	jmp    80106147 <alltraps>

8010668b <vector12>:
.globl vector12
vector12:
  pushl $12
8010668b:	6a 0c                	push   $0xc
  jmp alltraps
8010668d:	e9 b5 fa ff ff       	jmp    80106147 <alltraps>

80106692 <vector13>:
.globl vector13
vector13:
  pushl $13
80106692:	6a 0d                	push   $0xd
  jmp alltraps
80106694:	e9 ae fa ff ff       	jmp    80106147 <alltraps>

80106699 <vector14>:
.globl vector14
vector14:
  pushl $14
80106699:	6a 0e                	push   $0xe
  jmp alltraps
8010669b:	e9 a7 fa ff ff       	jmp    80106147 <alltraps>

801066a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $15
801066a2:	6a 0f                	push   $0xf
  jmp alltraps
801066a4:	e9 9e fa ff ff       	jmp    80106147 <alltraps>

801066a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $16
801066ab:	6a 10                	push   $0x10
  jmp alltraps
801066ad:	e9 95 fa ff ff       	jmp    80106147 <alltraps>

801066b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066b2:	6a 11                	push   $0x11
  jmp alltraps
801066b4:	e9 8e fa ff ff       	jmp    80106147 <alltraps>

801066b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $18
801066bb:	6a 12                	push   $0x12
  jmp alltraps
801066bd:	e9 85 fa ff ff       	jmp    80106147 <alltraps>

801066c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $19
801066c4:	6a 13                	push   $0x13
  jmp alltraps
801066c6:	e9 7c fa ff ff       	jmp    80106147 <alltraps>

801066cb <vector20>:
.globl vector20
vector20:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $20
801066cd:	6a 14                	push   $0x14
  jmp alltraps
801066cf:	e9 73 fa ff ff       	jmp    80106147 <alltraps>

801066d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $21
801066d6:	6a 15                	push   $0x15
  jmp alltraps
801066d8:	e9 6a fa ff ff       	jmp    80106147 <alltraps>

801066dd <vector22>:
.globl vector22
vector22:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $22
801066df:	6a 16                	push   $0x16
  jmp alltraps
801066e1:	e9 61 fa ff ff       	jmp    80106147 <alltraps>

801066e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $23
801066e8:	6a 17                	push   $0x17
  jmp alltraps
801066ea:	e9 58 fa ff ff       	jmp    80106147 <alltraps>

801066ef <vector24>:
.globl vector24
vector24:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $24
801066f1:	6a 18                	push   $0x18
  jmp alltraps
801066f3:	e9 4f fa ff ff       	jmp    80106147 <alltraps>

801066f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $25
801066fa:	6a 19                	push   $0x19
  jmp alltraps
801066fc:	e9 46 fa ff ff       	jmp    80106147 <alltraps>

80106701 <vector26>:
.globl vector26
vector26:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $26
80106703:	6a 1a                	push   $0x1a
  jmp alltraps
80106705:	e9 3d fa ff ff       	jmp    80106147 <alltraps>

8010670a <vector27>:
.globl vector27
vector27:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $27
8010670c:	6a 1b                	push   $0x1b
  jmp alltraps
8010670e:	e9 34 fa ff ff       	jmp    80106147 <alltraps>

80106713 <vector28>:
.globl vector28
vector28:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $28
80106715:	6a 1c                	push   $0x1c
  jmp alltraps
80106717:	e9 2b fa ff ff       	jmp    80106147 <alltraps>

8010671c <vector29>:
.globl vector29
vector29:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $29
8010671e:	6a 1d                	push   $0x1d
  jmp alltraps
80106720:	e9 22 fa ff ff       	jmp    80106147 <alltraps>

80106725 <vector30>:
.globl vector30
vector30:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $30
80106727:	6a 1e                	push   $0x1e
  jmp alltraps
80106729:	e9 19 fa ff ff       	jmp    80106147 <alltraps>

8010672e <vector31>:
.globl vector31
vector31:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $31
80106730:	6a 1f                	push   $0x1f
  jmp alltraps
80106732:	e9 10 fa ff ff       	jmp    80106147 <alltraps>

80106737 <vector32>:
.globl vector32
vector32:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $32
80106739:	6a 20                	push   $0x20
  jmp alltraps
8010673b:	e9 07 fa ff ff       	jmp    80106147 <alltraps>

80106740 <vector33>:
.globl vector33
vector33:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $33
80106742:	6a 21                	push   $0x21
  jmp alltraps
80106744:	e9 fe f9 ff ff       	jmp    80106147 <alltraps>

80106749 <vector34>:
.globl vector34
vector34:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $34
8010674b:	6a 22                	push   $0x22
  jmp alltraps
8010674d:	e9 f5 f9 ff ff       	jmp    80106147 <alltraps>

80106752 <vector35>:
.globl vector35
vector35:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $35
80106754:	6a 23                	push   $0x23
  jmp alltraps
80106756:	e9 ec f9 ff ff       	jmp    80106147 <alltraps>

8010675b <vector36>:
.globl vector36
vector36:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $36
8010675d:	6a 24                	push   $0x24
  jmp alltraps
8010675f:	e9 e3 f9 ff ff       	jmp    80106147 <alltraps>

80106764 <vector37>:
.globl vector37
vector37:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $37
80106766:	6a 25                	push   $0x25
  jmp alltraps
80106768:	e9 da f9 ff ff       	jmp    80106147 <alltraps>

8010676d <vector38>:
.globl vector38
vector38:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $38
8010676f:	6a 26                	push   $0x26
  jmp alltraps
80106771:	e9 d1 f9 ff ff       	jmp    80106147 <alltraps>

80106776 <vector39>:
.globl vector39
vector39:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $39
80106778:	6a 27                	push   $0x27
  jmp alltraps
8010677a:	e9 c8 f9 ff ff       	jmp    80106147 <alltraps>

8010677f <vector40>:
.globl vector40
vector40:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $40
80106781:	6a 28                	push   $0x28
  jmp alltraps
80106783:	e9 bf f9 ff ff       	jmp    80106147 <alltraps>

80106788 <vector41>:
.globl vector41
vector41:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $41
8010678a:	6a 29                	push   $0x29
  jmp alltraps
8010678c:	e9 b6 f9 ff ff       	jmp    80106147 <alltraps>

80106791 <vector42>:
.globl vector42
vector42:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $42
80106793:	6a 2a                	push   $0x2a
  jmp alltraps
80106795:	e9 ad f9 ff ff       	jmp    80106147 <alltraps>

8010679a <vector43>:
.globl vector43
vector43:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $43
8010679c:	6a 2b                	push   $0x2b
  jmp alltraps
8010679e:	e9 a4 f9 ff ff       	jmp    80106147 <alltraps>

801067a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $44
801067a5:	6a 2c                	push   $0x2c
  jmp alltraps
801067a7:	e9 9b f9 ff ff       	jmp    80106147 <alltraps>

801067ac <vector45>:
.globl vector45
vector45:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $45
801067ae:	6a 2d                	push   $0x2d
  jmp alltraps
801067b0:	e9 92 f9 ff ff       	jmp    80106147 <alltraps>

801067b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $46
801067b7:	6a 2e                	push   $0x2e
  jmp alltraps
801067b9:	e9 89 f9 ff ff       	jmp    80106147 <alltraps>

801067be <vector47>:
.globl vector47
vector47:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $47
801067c0:	6a 2f                	push   $0x2f
  jmp alltraps
801067c2:	e9 80 f9 ff ff       	jmp    80106147 <alltraps>

801067c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $48
801067c9:	6a 30                	push   $0x30
  jmp alltraps
801067cb:	e9 77 f9 ff ff       	jmp    80106147 <alltraps>

801067d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $49
801067d2:	6a 31                	push   $0x31
  jmp alltraps
801067d4:	e9 6e f9 ff ff       	jmp    80106147 <alltraps>

801067d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $50
801067db:	6a 32                	push   $0x32
  jmp alltraps
801067dd:	e9 65 f9 ff ff       	jmp    80106147 <alltraps>

801067e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $51
801067e4:	6a 33                	push   $0x33
  jmp alltraps
801067e6:	e9 5c f9 ff ff       	jmp    80106147 <alltraps>

801067eb <vector52>:
.globl vector52
vector52:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $52
801067ed:	6a 34                	push   $0x34
  jmp alltraps
801067ef:	e9 53 f9 ff ff       	jmp    80106147 <alltraps>

801067f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $53
801067f6:	6a 35                	push   $0x35
  jmp alltraps
801067f8:	e9 4a f9 ff ff       	jmp    80106147 <alltraps>

801067fd <vector54>:
.globl vector54
vector54:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $54
801067ff:	6a 36                	push   $0x36
  jmp alltraps
80106801:	e9 41 f9 ff ff       	jmp    80106147 <alltraps>

80106806 <vector55>:
.globl vector55
vector55:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $55
80106808:	6a 37                	push   $0x37
  jmp alltraps
8010680a:	e9 38 f9 ff ff       	jmp    80106147 <alltraps>

8010680f <vector56>:
.globl vector56
vector56:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $56
80106811:	6a 38                	push   $0x38
  jmp alltraps
80106813:	e9 2f f9 ff ff       	jmp    80106147 <alltraps>

80106818 <vector57>:
.globl vector57
vector57:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $57
8010681a:	6a 39                	push   $0x39
  jmp alltraps
8010681c:	e9 26 f9 ff ff       	jmp    80106147 <alltraps>

80106821 <vector58>:
.globl vector58
vector58:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $58
80106823:	6a 3a                	push   $0x3a
  jmp alltraps
80106825:	e9 1d f9 ff ff       	jmp    80106147 <alltraps>

8010682a <vector59>:
.globl vector59
vector59:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $59
8010682c:	6a 3b                	push   $0x3b
  jmp alltraps
8010682e:	e9 14 f9 ff ff       	jmp    80106147 <alltraps>

80106833 <vector60>:
.globl vector60
vector60:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $60
80106835:	6a 3c                	push   $0x3c
  jmp alltraps
80106837:	e9 0b f9 ff ff       	jmp    80106147 <alltraps>

8010683c <vector61>:
.globl vector61
vector61:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $61
8010683e:	6a 3d                	push   $0x3d
  jmp alltraps
80106840:	e9 02 f9 ff ff       	jmp    80106147 <alltraps>

80106845 <vector62>:
.globl vector62
vector62:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $62
80106847:	6a 3e                	push   $0x3e
  jmp alltraps
80106849:	e9 f9 f8 ff ff       	jmp    80106147 <alltraps>

8010684e <vector63>:
.globl vector63
vector63:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $63
80106850:	6a 3f                	push   $0x3f
  jmp alltraps
80106852:	e9 f0 f8 ff ff       	jmp    80106147 <alltraps>

80106857 <vector64>:
.globl vector64
vector64:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $64
80106859:	6a 40                	push   $0x40
  jmp alltraps
8010685b:	e9 e7 f8 ff ff       	jmp    80106147 <alltraps>

80106860 <vector65>:
.globl vector65
vector65:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $65
80106862:	6a 41                	push   $0x41
  jmp alltraps
80106864:	e9 de f8 ff ff       	jmp    80106147 <alltraps>

80106869 <vector66>:
.globl vector66
vector66:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $66
8010686b:	6a 42                	push   $0x42
  jmp alltraps
8010686d:	e9 d5 f8 ff ff       	jmp    80106147 <alltraps>

80106872 <vector67>:
.globl vector67
vector67:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $67
80106874:	6a 43                	push   $0x43
  jmp alltraps
80106876:	e9 cc f8 ff ff       	jmp    80106147 <alltraps>

8010687b <vector68>:
.globl vector68
vector68:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $68
8010687d:	6a 44                	push   $0x44
  jmp alltraps
8010687f:	e9 c3 f8 ff ff       	jmp    80106147 <alltraps>

80106884 <vector69>:
.globl vector69
vector69:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $69
80106886:	6a 45                	push   $0x45
  jmp alltraps
80106888:	e9 ba f8 ff ff       	jmp    80106147 <alltraps>

8010688d <vector70>:
.globl vector70
vector70:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $70
8010688f:	6a 46                	push   $0x46
  jmp alltraps
80106891:	e9 b1 f8 ff ff       	jmp    80106147 <alltraps>

80106896 <vector71>:
.globl vector71
vector71:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $71
80106898:	6a 47                	push   $0x47
  jmp alltraps
8010689a:	e9 a8 f8 ff ff       	jmp    80106147 <alltraps>

8010689f <vector72>:
.globl vector72
vector72:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $72
801068a1:	6a 48                	push   $0x48
  jmp alltraps
801068a3:	e9 9f f8 ff ff       	jmp    80106147 <alltraps>

801068a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $73
801068aa:	6a 49                	push   $0x49
  jmp alltraps
801068ac:	e9 96 f8 ff ff       	jmp    80106147 <alltraps>

801068b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $74
801068b3:	6a 4a                	push   $0x4a
  jmp alltraps
801068b5:	e9 8d f8 ff ff       	jmp    80106147 <alltraps>

801068ba <vector75>:
.globl vector75
vector75:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $75
801068bc:	6a 4b                	push   $0x4b
  jmp alltraps
801068be:	e9 84 f8 ff ff       	jmp    80106147 <alltraps>

801068c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $76
801068c5:	6a 4c                	push   $0x4c
  jmp alltraps
801068c7:	e9 7b f8 ff ff       	jmp    80106147 <alltraps>

801068cc <vector77>:
.globl vector77
vector77:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $77
801068ce:	6a 4d                	push   $0x4d
  jmp alltraps
801068d0:	e9 72 f8 ff ff       	jmp    80106147 <alltraps>

801068d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $78
801068d7:	6a 4e                	push   $0x4e
  jmp alltraps
801068d9:	e9 69 f8 ff ff       	jmp    80106147 <alltraps>

801068de <vector79>:
.globl vector79
vector79:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $79
801068e0:	6a 4f                	push   $0x4f
  jmp alltraps
801068e2:	e9 60 f8 ff ff       	jmp    80106147 <alltraps>

801068e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $80
801068e9:	6a 50                	push   $0x50
  jmp alltraps
801068eb:	e9 57 f8 ff ff       	jmp    80106147 <alltraps>

801068f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $81
801068f2:	6a 51                	push   $0x51
  jmp alltraps
801068f4:	e9 4e f8 ff ff       	jmp    80106147 <alltraps>

801068f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $82
801068fb:	6a 52                	push   $0x52
  jmp alltraps
801068fd:	e9 45 f8 ff ff       	jmp    80106147 <alltraps>

80106902 <vector83>:
.globl vector83
vector83:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $83
80106904:	6a 53                	push   $0x53
  jmp alltraps
80106906:	e9 3c f8 ff ff       	jmp    80106147 <alltraps>

8010690b <vector84>:
.globl vector84
vector84:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $84
8010690d:	6a 54                	push   $0x54
  jmp alltraps
8010690f:	e9 33 f8 ff ff       	jmp    80106147 <alltraps>

80106914 <vector85>:
.globl vector85
vector85:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $85
80106916:	6a 55                	push   $0x55
  jmp alltraps
80106918:	e9 2a f8 ff ff       	jmp    80106147 <alltraps>

8010691d <vector86>:
.globl vector86
vector86:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $86
8010691f:	6a 56                	push   $0x56
  jmp alltraps
80106921:	e9 21 f8 ff ff       	jmp    80106147 <alltraps>

80106926 <vector87>:
.globl vector87
vector87:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $87
80106928:	6a 57                	push   $0x57
  jmp alltraps
8010692a:	e9 18 f8 ff ff       	jmp    80106147 <alltraps>

8010692f <vector88>:
.globl vector88
vector88:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $88
80106931:	6a 58                	push   $0x58
  jmp alltraps
80106933:	e9 0f f8 ff ff       	jmp    80106147 <alltraps>

80106938 <vector89>:
.globl vector89
vector89:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $89
8010693a:	6a 59                	push   $0x59
  jmp alltraps
8010693c:	e9 06 f8 ff ff       	jmp    80106147 <alltraps>

80106941 <vector90>:
.globl vector90
vector90:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $90
80106943:	6a 5a                	push   $0x5a
  jmp alltraps
80106945:	e9 fd f7 ff ff       	jmp    80106147 <alltraps>

8010694a <vector91>:
.globl vector91
vector91:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $91
8010694c:	6a 5b                	push   $0x5b
  jmp alltraps
8010694e:	e9 f4 f7 ff ff       	jmp    80106147 <alltraps>

80106953 <vector92>:
.globl vector92
vector92:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $92
80106955:	6a 5c                	push   $0x5c
  jmp alltraps
80106957:	e9 eb f7 ff ff       	jmp    80106147 <alltraps>

8010695c <vector93>:
.globl vector93
vector93:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $93
8010695e:	6a 5d                	push   $0x5d
  jmp alltraps
80106960:	e9 e2 f7 ff ff       	jmp    80106147 <alltraps>

80106965 <vector94>:
.globl vector94
vector94:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $94
80106967:	6a 5e                	push   $0x5e
  jmp alltraps
80106969:	e9 d9 f7 ff ff       	jmp    80106147 <alltraps>

8010696e <vector95>:
.globl vector95
vector95:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $95
80106970:	6a 5f                	push   $0x5f
  jmp alltraps
80106972:	e9 d0 f7 ff ff       	jmp    80106147 <alltraps>

80106977 <vector96>:
.globl vector96
vector96:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $96
80106979:	6a 60                	push   $0x60
  jmp alltraps
8010697b:	e9 c7 f7 ff ff       	jmp    80106147 <alltraps>

80106980 <vector97>:
.globl vector97
vector97:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $97
80106982:	6a 61                	push   $0x61
  jmp alltraps
80106984:	e9 be f7 ff ff       	jmp    80106147 <alltraps>

80106989 <vector98>:
.globl vector98
vector98:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $98
8010698b:	6a 62                	push   $0x62
  jmp alltraps
8010698d:	e9 b5 f7 ff ff       	jmp    80106147 <alltraps>

80106992 <vector99>:
.globl vector99
vector99:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $99
80106994:	6a 63                	push   $0x63
  jmp alltraps
80106996:	e9 ac f7 ff ff       	jmp    80106147 <alltraps>

8010699b <vector100>:
.globl vector100
vector100:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $100
8010699d:	6a 64                	push   $0x64
  jmp alltraps
8010699f:	e9 a3 f7 ff ff       	jmp    80106147 <alltraps>

801069a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $101
801069a6:	6a 65                	push   $0x65
  jmp alltraps
801069a8:	e9 9a f7 ff ff       	jmp    80106147 <alltraps>

801069ad <vector102>:
.globl vector102
vector102:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $102
801069af:	6a 66                	push   $0x66
  jmp alltraps
801069b1:	e9 91 f7 ff ff       	jmp    80106147 <alltraps>

801069b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $103
801069b8:	6a 67                	push   $0x67
  jmp alltraps
801069ba:	e9 88 f7 ff ff       	jmp    80106147 <alltraps>

801069bf <vector104>:
.globl vector104
vector104:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $104
801069c1:	6a 68                	push   $0x68
  jmp alltraps
801069c3:	e9 7f f7 ff ff       	jmp    80106147 <alltraps>

801069c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $105
801069ca:	6a 69                	push   $0x69
  jmp alltraps
801069cc:	e9 76 f7 ff ff       	jmp    80106147 <alltraps>

801069d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $106
801069d3:	6a 6a                	push   $0x6a
  jmp alltraps
801069d5:	e9 6d f7 ff ff       	jmp    80106147 <alltraps>

801069da <vector107>:
.globl vector107
vector107:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $107
801069dc:	6a 6b                	push   $0x6b
  jmp alltraps
801069de:	e9 64 f7 ff ff       	jmp    80106147 <alltraps>

801069e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $108
801069e5:	6a 6c                	push   $0x6c
  jmp alltraps
801069e7:	e9 5b f7 ff ff       	jmp    80106147 <alltraps>

801069ec <vector109>:
.globl vector109
vector109:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $109
801069ee:	6a 6d                	push   $0x6d
  jmp alltraps
801069f0:	e9 52 f7 ff ff       	jmp    80106147 <alltraps>

801069f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $110
801069f7:	6a 6e                	push   $0x6e
  jmp alltraps
801069f9:	e9 49 f7 ff ff       	jmp    80106147 <alltraps>

801069fe <vector111>:
.globl vector111
vector111:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $111
80106a00:	6a 6f                	push   $0x6f
  jmp alltraps
80106a02:	e9 40 f7 ff ff       	jmp    80106147 <alltraps>

80106a07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $112
80106a09:	6a 70                	push   $0x70
  jmp alltraps
80106a0b:	e9 37 f7 ff ff       	jmp    80106147 <alltraps>

80106a10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $113
80106a12:	6a 71                	push   $0x71
  jmp alltraps
80106a14:	e9 2e f7 ff ff       	jmp    80106147 <alltraps>

80106a19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a19:	6a 00                	push   $0x0
  pushl $114
80106a1b:	6a 72                	push   $0x72
  jmp alltraps
80106a1d:	e9 25 f7 ff ff       	jmp    80106147 <alltraps>

80106a22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $115
80106a24:	6a 73                	push   $0x73
  jmp alltraps
80106a26:	e9 1c f7 ff ff       	jmp    80106147 <alltraps>

80106a2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $116
80106a2d:	6a 74                	push   $0x74
  jmp alltraps
80106a2f:	e9 13 f7 ff ff       	jmp    80106147 <alltraps>

80106a34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $117
80106a36:	6a 75                	push   $0x75
  jmp alltraps
80106a38:	e9 0a f7 ff ff       	jmp    80106147 <alltraps>

80106a3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $118
80106a3f:	6a 76                	push   $0x76
  jmp alltraps
80106a41:	e9 01 f7 ff ff       	jmp    80106147 <alltraps>

80106a46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $119
80106a48:	6a 77                	push   $0x77
  jmp alltraps
80106a4a:	e9 f8 f6 ff ff       	jmp    80106147 <alltraps>

80106a4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $120
80106a51:	6a 78                	push   $0x78
  jmp alltraps
80106a53:	e9 ef f6 ff ff       	jmp    80106147 <alltraps>

80106a58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $121
80106a5a:	6a 79                	push   $0x79
  jmp alltraps
80106a5c:	e9 e6 f6 ff ff       	jmp    80106147 <alltraps>

80106a61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $122
80106a63:	6a 7a                	push   $0x7a
  jmp alltraps
80106a65:	e9 dd f6 ff ff       	jmp    80106147 <alltraps>

80106a6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $123
80106a6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a6e:	e9 d4 f6 ff ff       	jmp    80106147 <alltraps>

80106a73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $124
80106a75:	6a 7c                	push   $0x7c
  jmp alltraps
80106a77:	e9 cb f6 ff ff       	jmp    80106147 <alltraps>

80106a7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $125
80106a7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a80:	e9 c2 f6 ff ff       	jmp    80106147 <alltraps>

80106a85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $126
80106a87:	6a 7e                	push   $0x7e
  jmp alltraps
80106a89:	e9 b9 f6 ff ff       	jmp    80106147 <alltraps>

80106a8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $127
80106a90:	6a 7f                	push   $0x7f
  jmp alltraps
80106a92:	e9 b0 f6 ff ff       	jmp    80106147 <alltraps>

80106a97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $128
80106a99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a9e:	e9 a4 f6 ff ff       	jmp    80106147 <alltraps>

80106aa3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $129
80106aa5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aaa:	e9 98 f6 ff ff       	jmp    80106147 <alltraps>

80106aaf <vector130>:
.globl vector130
vector130:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $130
80106ab1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ab6:	e9 8c f6 ff ff       	jmp    80106147 <alltraps>

80106abb <vector131>:
.globl vector131
vector131:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $131
80106abd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ac2:	e9 80 f6 ff ff       	jmp    80106147 <alltraps>

80106ac7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $132
80106ac9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ace:	e9 74 f6 ff ff       	jmp    80106147 <alltraps>

80106ad3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $133
80106ad5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ada:	e9 68 f6 ff ff       	jmp    80106147 <alltraps>

80106adf <vector134>:
.globl vector134
vector134:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $134
80106ae1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ae6:	e9 5c f6 ff ff       	jmp    80106147 <alltraps>

80106aeb <vector135>:
.globl vector135
vector135:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $135
80106aed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106af2:	e9 50 f6 ff ff       	jmp    80106147 <alltraps>

80106af7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $136
80106af9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106afe:	e9 44 f6 ff ff       	jmp    80106147 <alltraps>

80106b03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $137
80106b05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b0a:	e9 38 f6 ff ff       	jmp    80106147 <alltraps>

80106b0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $138
80106b11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b16:	e9 2c f6 ff ff       	jmp    80106147 <alltraps>

80106b1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $139
80106b1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b22:	e9 20 f6 ff ff       	jmp    80106147 <alltraps>

80106b27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $140
80106b29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b2e:	e9 14 f6 ff ff       	jmp    80106147 <alltraps>

80106b33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $141
80106b35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b3a:	e9 08 f6 ff ff       	jmp    80106147 <alltraps>

80106b3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $142
80106b41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b46:	e9 fc f5 ff ff       	jmp    80106147 <alltraps>

80106b4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $143
80106b4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b52:	e9 f0 f5 ff ff       	jmp    80106147 <alltraps>

80106b57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $144
80106b59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b5e:	e9 e4 f5 ff ff       	jmp    80106147 <alltraps>

80106b63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $145
80106b65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b6a:	e9 d8 f5 ff ff       	jmp    80106147 <alltraps>

80106b6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $146
80106b71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b76:	e9 cc f5 ff ff       	jmp    80106147 <alltraps>

80106b7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $147
80106b7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b82:	e9 c0 f5 ff ff       	jmp    80106147 <alltraps>

80106b87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $148
80106b89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b8e:	e9 b4 f5 ff ff       	jmp    80106147 <alltraps>

80106b93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $149
80106b95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b9a:	e9 a8 f5 ff ff       	jmp    80106147 <alltraps>

80106b9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $150
80106ba1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ba6:	e9 9c f5 ff ff       	jmp    80106147 <alltraps>

80106bab <vector151>:
.globl vector151
vector151:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $151
80106bad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bb2:	e9 90 f5 ff ff       	jmp    80106147 <alltraps>

80106bb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $152
80106bb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bbe:	e9 84 f5 ff ff       	jmp    80106147 <alltraps>

80106bc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $153
80106bc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bca:	e9 78 f5 ff ff       	jmp    80106147 <alltraps>

80106bcf <vector154>:
.globl vector154
vector154:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $154
80106bd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bd6:	e9 6c f5 ff ff       	jmp    80106147 <alltraps>

80106bdb <vector155>:
.globl vector155
vector155:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $155
80106bdd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106be2:	e9 60 f5 ff ff       	jmp    80106147 <alltraps>

80106be7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $156
80106be9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bee:	e9 54 f5 ff ff       	jmp    80106147 <alltraps>

80106bf3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $157
80106bf5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bfa:	e9 48 f5 ff ff       	jmp    80106147 <alltraps>

80106bff <vector158>:
.globl vector158
vector158:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $158
80106c01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c06:	e9 3c f5 ff ff       	jmp    80106147 <alltraps>

80106c0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $159
80106c0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c12:	e9 30 f5 ff ff       	jmp    80106147 <alltraps>

80106c17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $160
80106c19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c1e:	e9 24 f5 ff ff       	jmp    80106147 <alltraps>

80106c23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $161
80106c25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c2a:	e9 18 f5 ff ff       	jmp    80106147 <alltraps>

80106c2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $162
80106c31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c36:	e9 0c f5 ff ff       	jmp    80106147 <alltraps>

80106c3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $163
80106c3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c42:	e9 00 f5 ff ff       	jmp    80106147 <alltraps>

80106c47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $164
80106c49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c4e:	e9 f4 f4 ff ff       	jmp    80106147 <alltraps>

80106c53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $165
80106c55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c5a:	e9 e8 f4 ff ff       	jmp    80106147 <alltraps>

80106c5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $166
80106c61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c66:	e9 dc f4 ff ff       	jmp    80106147 <alltraps>

80106c6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $167
80106c6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c72:	e9 d0 f4 ff ff       	jmp    80106147 <alltraps>

80106c77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $168
80106c79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c7e:	e9 c4 f4 ff ff       	jmp    80106147 <alltraps>

80106c83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $169
80106c85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c8a:	e9 b8 f4 ff ff       	jmp    80106147 <alltraps>

80106c8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $170
80106c91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c96:	e9 ac f4 ff ff       	jmp    80106147 <alltraps>

80106c9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $171
80106c9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ca2:	e9 a0 f4 ff ff       	jmp    80106147 <alltraps>

80106ca7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $172
80106ca9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cae:	e9 94 f4 ff ff       	jmp    80106147 <alltraps>

80106cb3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $173
80106cb5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cba:	e9 88 f4 ff ff       	jmp    80106147 <alltraps>

80106cbf <vector174>:
.globl vector174
vector174:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $174
80106cc1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106cc6:	e9 7c f4 ff ff       	jmp    80106147 <alltraps>

80106ccb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $175
80106ccd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cd2:	e9 70 f4 ff ff       	jmp    80106147 <alltraps>

80106cd7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $176
80106cd9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cde:	e9 64 f4 ff ff       	jmp    80106147 <alltraps>

80106ce3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $177
80106ce5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cea:	e9 58 f4 ff ff       	jmp    80106147 <alltraps>

80106cef <vector178>:
.globl vector178
vector178:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $178
80106cf1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cf6:	e9 4c f4 ff ff       	jmp    80106147 <alltraps>

80106cfb <vector179>:
.globl vector179
vector179:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $179
80106cfd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d02:	e9 40 f4 ff ff       	jmp    80106147 <alltraps>

80106d07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $180
80106d09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d0e:	e9 34 f4 ff ff       	jmp    80106147 <alltraps>

80106d13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $181
80106d15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d1a:	e9 28 f4 ff ff       	jmp    80106147 <alltraps>

80106d1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $182
80106d21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d26:	e9 1c f4 ff ff       	jmp    80106147 <alltraps>

80106d2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $183
80106d2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d32:	e9 10 f4 ff ff       	jmp    80106147 <alltraps>

80106d37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $184
80106d39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d3e:	e9 04 f4 ff ff       	jmp    80106147 <alltraps>

80106d43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $185
80106d45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d4a:	e9 f8 f3 ff ff       	jmp    80106147 <alltraps>

80106d4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $186
80106d51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d56:	e9 ec f3 ff ff       	jmp    80106147 <alltraps>

80106d5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $187
80106d5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d62:	e9 e0 f3 ff ff       	jmp    80106147 <alltraps>

80106d67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $188
80106d69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d6e:	e9 d4 f3 ff ff       	jmp    80106147 <alltraps>

80106d73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $189
80106d75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d7a:	e9 c8 f3 ff ff       	jmp    80106147 <alltraps>

80106d7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $190
80106d81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d86:	e9 bc f3 ff ff       	jmp    80106147 <alltraps>

80106d8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $191
80106d8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d92:	e9 b0 f3 ff ff       	jmp    80106147 <alltraps>

80106d97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $192
80106d99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d9e:	e9 a4 f3 ff ff       	jmp    80106147 <alltraps>

80106da3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $193
80106da5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106daa:	e9 98 f3 ff ff       	jmp    80106147 <alltraps>

80106daf <vector194>:
.globl vector194
vector194:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $194
80106db1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106db6:	e9 8c f3 ff ff       	jmp    80106147 <alltraps>

80106dbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $195
80106dbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106dc2:	e9 80 f3 ff ff       	jmp    80106147 <alltraps>

80106dc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $196
80106dc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dce:	e9 74 f3 ff ff       	jmp    80106147 <alltraps>

80106dd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $197
80106dd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dda:	e9 68 f3 ff ff       	jmp    80106147 <alltraps>

80106ddf <vector198>:
.globl vector198
vector198:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $198
80106de1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106de6:	e9 5c f3 ff ff       	jmp    80106147 <alltraps>

80106deb <vector199>:
.globl vector199
vector199:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $199
80106ded:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106df2:	e9 50 f3 ff ff       	jmp    80106147 <alltraps>

80106df7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $200
80106df9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dfe:	e9 44 f3 ff ff       	jmp    80106147 <alltraps>

80106e03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $201
80106e05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e0a:	e9 38 f3 ff ff       	jmp    80106147 <alltraps>

80106e0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $202
80106e11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e16:	e9 2c f3 ff ff       	jmp    80106147 <alltraps>

80106e1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $203
80106e1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e22:	e9 20 f3 ff ff       	jmp    80106147 <alltraps>

80106e27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $204
80106e29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e2e:	e9 14 f3 ff ff       	jmp    80106147 <alltraps>

80106e33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $205
80106e35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e3a:	e9 08 f3 ff ff       	jmp    80106147 <alltraps>

80106e3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $206
80106e41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e46:	e9 fc f2 ff ff       	jmp    80106147 <alltraps>

80106e4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $207
80106e4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e52:	e9 f0 f2 ff ff       	jmp    80106147 <alltraps>

80106e57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $208
80106e59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e5e:	e9 e4 f2 ff ff       	jmp    80106147 <alltraps>

80106e63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $209
80106e65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e6a:	e9 d8 f2 ff ff       	jmp    80106147 <alltraps>

80106e6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $210
80106e71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e76:	e9 cc f2 ff ff       	jmp    80106147 <alltraps>

80106e7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $211
80106e7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e82:	e9 c0 f2 ff ff       	jmp    80106147 <alltraps>

80106e87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $212
80106e89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e8e:	e9 b4 f2 ff ff       	jmp    80106147 <alltraps>

80106e93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $213
80106e95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e9a:	e9 a8 f2 ff ff       	jmp    80106147 <alltraps>

80106e9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $214
80106ea1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ea6:	e9 9c f2 ff ff       	jmp    80106147 <alltraps>

80106eab <vector215>:
.globl vector215
vector215:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $215
80106ead:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106eb2:	e9 90 f2 ff ff       	jmp    80106147 <alltraps>

80106eb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $216
80106eb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ebe:	e9 84 f2 ff ff       	jmp    80106147 <alltraps>

80106ec3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $217
80106ec5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eca:	e9 78 f2 ff ff       	jmp    80106147 <alltraps>

80106ecf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $218
80106ed1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ed6:	e9 6c f2 ff ff       	jmp    80106147 <alltraps>

80106edb <vector219>:
.globl vector219
vector219:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $219
80106edd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ee2:	e9 60 f2 ff ff       	jmp    80106147 <alltraps>

80106ee7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $220
80106ee9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106eee:	e9 54 f2 ff ff       	jmp    80106147 <alltraps>

80106ef3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $221
80106ef5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106efa:	e9 48 f2 ff ff       	jmp    80106147 <alltraps>

80106eff <vector222>:
.globl vector222
vector222:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $222
80106f01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f06:	e9 3c f2 ff ff       	jmp    80106147 <alltraps>

80106f0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $223
80106f0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f12:	e9 30 f2 ff ff       	jmp    80106147 <alltraps>

80106f17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $224
80106f19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f1e:	e9 24 f2 ff ff       	jmp    80106147 <alltraps>

80106f23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $225
80106f25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f2a:	e9 18 f2 ff ff       	jmp    80106147 <alltraps>

80106f2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $226
80106f31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f36:	e9 0c f2 ff ff       	jmp    80106147 <alltraps>

80106f3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $227
80106f3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f42:	e9 00 f2 ff ff       	jmp    80106147 <alltraps>

80106f47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $228
80106f49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f4e:	e9 f4 f1 ff ff       	jmp    80106147 <alltraps>

80106f53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $229
80106f55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f5a:	e9 e8 f1 ff ff       	jmp    80106147 <alltraps>

80106f5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $230
80106f61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f66:	e9 dc f1 ff ff       	jmp    80106147 <alltraps>

80106f6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $231
80106f6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f72:	e9 d0 f1 ff ff       	jmp    80106147 <alltraps>

80106f77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $232
80106f79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f7e:	e9 c4 f1 ff ff       	jmp    80106147 <alltraps>

80106f83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $233
80106f85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f8a:	e9 b8 f1 ff ff       	jmp    80106147 <alltraps>

80106f8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $234
80106f91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f96:	e9 ac f1 ff ff       	jmp    80106147 <alltraps>

80106f9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $235
80106f9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fa2:	e9 a0 f1 ff ff       	jmp    80106147 <alltraps>

80106fa7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $236
80106fa9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fae:	e9 94 f1 ff ff       	jmp    80106147 <alltraps>

80106fb3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $237
80106fb5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fba:	e9 88 f1 ff ff       	jmp    80106147 <alltraps>

80106fbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $238
80106fc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fc6:	e9 7c f1 ff ff       	jmp    80106147 <alltraps>

80106fcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $239
80106fcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fd2:	e9 70 f1 ff ff       	jmp    80106147 <alltraps>

80106fd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $240
80106fd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fde:	e9 64 f1 ff ff       	jmp    80106147 <alltraps>

80106fe3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $241
80106fe5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fea:	e9 58 f1 ff ff       	jmp    80106147 <alltraps>

80106fef <vector242>:
.globl vector242
vector242:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $242
80106ff1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ff6:	e9 4c f1 ff ff       	jmp    80106147 <alltraps>

80106ffb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $243
80106ffd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107002:	e9 40 f1 ff ff       	jmp    80106147 <alltraps>

80107007 <vector244>:
.globl vector244
vector244:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $244
80107009:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010700e:	e9 34 f1 ff ff       	jmp    80106147 <alltraps>

80107013 <vector245>:
.globl vector245
vector245:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $245
80107015:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010701a:	e9 28 f1 ff ff       	jmp    80106147 <alltraps>

8010701f <vector246>:
.globl vector246
vector246:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $246
80107021:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107026:	e9 1c f1 ff ff       	jmp    80106147 <alltraps>

8010702b <vector247>:
.globl vector247
vector247:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $247
8010702d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107032:	e9 10 f1 ff ff       	jmp    80106147 <alltraps>

80107037 <vector248>:
.globl vector248
vector248:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $248
80107039:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010703e:	e9 04 f1 ff ff       	jmp    80106147 <alltraps>

80107043 <vector249>:
.globl vector249
vector249:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $249
80107045:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010704a:	e9 f8 f0 ff ff       	jmp    80106147 <alltraps>

8010704f <vector250>:
.globl vector250
vector250:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $250
80107051:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107056:	e9 ec f0 ff ff       	jmp    80106147 <alltraps>

8010705b <vector251>:
.globl vector251
vector251:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $251
8010705d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107062:	e9 e0 f0 ff ff       	jmp    80106147 <alltraps>

80107067 <vector252>:
.globl vector252
vector252:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $252
80107069:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010706e:	e9 d4 f0 ff ff       	jmp    80106147 <alltraps>

80107073 <vector253>:
.globl vector253
vector253:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $253
80107075:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010707a:	e9 c8 f0 ff ff       	jmp    80106147 <alltraps>

8010707f <vector254>:
.globl vector254
vector254:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $254
80107081:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107086:	e9 bc f0 ff ff       	jmp    80106147 <alltraps>

8010708b <vector255>:
.globl vector255
vector255:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $255
8010708d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107092:	e9 b0 f0 ff ff       	jmp    80106147 <alltraps>
80107097:	66 90                	xchg   %ax,%ax
80107099:	66 90                	xchg   %ax,%ax
8010709b:	66 90                	xchg   %ax,%ax
8010709d:	66 90                	xchg   %ax,%ax
8010709f:	90                   	nop

801070a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801070a6:	89 d3                	mov    %edx,%ebx
{
801070a8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801070aa:	c1 eb 16             	shr    $0x16,%ebx
801070ad:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801070b0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801070b3:	8b 06                	mov    (%esi),%eax
801070b5:	a8 01                	test   $0x1,%al
801070b7:	74 27                	je     801070e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070be:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801070c4:	c1 ef 0a             	shr    $0xa,%edi
}
801070c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801070ca:	89 fa                	mov    %edi,%edx
801070cc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070d2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070e0:	85 c9                	test   %ecx,%ecx
801070e2:	74 2c                	je     80107110 <walkpgdir+0x70>
801070e4:	e8 07 b4 ff ff       	call   801024f0 <kalloc>
801070e9:	85 c0                	test   %eax,%eax
801070eb:	89 c3                	mov    %eax,%ebx
801070ed:	74 21                	je     80107110 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070ef:	83 ec 04             	sub    $0x4,%esp
801070f2:	68 00 10 00 00       	push   $0x1000
801070f7:	6a 00                	push   $0x0
801070f9:	50                   	push   %eax
801070fa:	e8 21 db ff ff       	call   80104c20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107105:	83 c4 10             	add    $0x10,%esp
80107108:	83 c8 07             	or     $0x7,%eax
8010710b:	89 06                	mov    %eax,(%esi)
8010710d:	eb b5                	jmp    801070c4 <walkpgdir+0x24>
8010710f:	90                   	nop
}
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107120 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107126:	89 d3                	mov    %edx,%ebx
80107128:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010712e:	83 ec 1c             	sub    $0x1c,%esp
80107131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107134:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107138:	8b 7d 08             	mov    0x8(%ebp),%edi
8010713b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107140:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107143:	8b 45 0c             	mov    0xc(%ebp),%eax
80107146:	29 df                	sub    %ebx,%edi
80107148:	83 c8 01             	or     $0x1,%eax
8010714b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010714e:	eb 15                	jmp    80107165 <mappages+0x45>
    if(*pte & PTE_P)
80107150:	f6 00 01             	testb  $0x1,(%eax)
80107153:	75 45                	jne    8010719a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107155:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107158:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010715b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010715d:	74 31                	je     80107190 <mappages+0x70>
      break;
    a += PGSIZE;
8010715f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107168:	b9 01 00 00 00       	mov    $0x1,%ecx
8010716d:	89 da                	mov    %ebx,%edx
8010716f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107172:	e8 29 ff ff ff       	call   801070a0 <walkpgdir>
80107177:	85 c0                	test   %eax,%eax
80107179:	75 d5                	jne    80107150 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010717b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010717e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107183:	5b                   	pop    %ebx
80107184:	5e                   	pop    %esi
80107185:	5f                   	pop    %edi
80107186:	5d                   	pop    %ebp
80107187:	c3                   	ret    
80107188:	90                   	nop
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
      panic("remap");
8010719a:	83 ec 0c             	sub    $0xc,%esp
8010719d:	68 18 84 10 80       	push   $0x80108418
801071a2:	e8 e9 91 ff ff       	call   80100390 <panic>
801071a7:	89 f6                	mov    %esi,%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801071b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071bc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801071be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071c4:	83 ec 1c             	sub    $0x1c,%esp
801071c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071ca:	39 d3                	cmp    %edx,%ebx
801071cc:	73 66                	jae    80107234 <deallocuvm.part.0+0x84>
801071ce:	89 d6                	mov    %edx,%esi
801071d0:	eb 3d                	jmp    8010720f <deallocuvm.part.0+0x5f>
801071d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071d8:	8b 10                	mov    (%eax),%edx
801071da:	f6 c2 01             	test   $0x1,%dl
801071dd:	74 26                	je     80107205 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801071e5:	74 58                	je     8010723f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071e7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071ea:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801071f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801071f3:	52                   	push   %edx
801071f4:	e8 47 b1 ff ff       	call   80102340 <kfree>
      *pte = 0;
801071f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071fc:	83 c4 10             	add    $0x10,%esp
801071ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107205:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010720b:	39 f3                	cmp    %esi,%ebx
8010720d:	73 25                	jae    80107234 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010720f:	31 c9                	xor    %ecx,%ecx
80107211:	89 da                	mov    %ebx,%edx
80107213:	89 f8                	mov    %edi,%eax
80107215:	e8 86 fe ff ff       	call   801070a0 <walkpgdir>
    if(!pte)
8010721a:	85 c0                	test   %eax,%eax
8010721c:	75 ba                	jne    801071d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010721e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107224:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010722a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107230:	39 f3                	cmp    %esi,%ebx
80107232:	72 db                	jb     8010720f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107234:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107237:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723a:	5b                   	pop    %ebx
8010723b:	5e                   	pop    %esi
8010723c:	5f                   	pop    %edi
8010723d:	5d                   	pop    %ebp
8010723e:	c3                   	ret    
        panic("kfree");
8010723f:	83 ec 0c             	sub    $0xc,%esp
80107242:	68 46 7c 10 80       	push   $0x80107c46
80107247:	e8 44 91 ff ff       	call   80100390 <panic>
8010724c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107250 <seginit>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107256:	e8 f5 c5 ff ff       	call   80103850 <cpuid>
8010725b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107261:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107266:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010726a:	c7 80 98 48 13 80 ff 	movl   $0xffff,-0x7fecb768(%eax)
80107271:	ff 00 00 
80107274:	c7 80 9c 48 13 80 00 	movl   $0xcf9a00,-0x7fecb764(%eax)
8010727b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010727e:	c7 80 a0 48 13 80 ff 	movl   $0xffff,-0x7fecb760(%eax)
80107285:	ff 00 00 
80107288:	c7 80 a4 48 13 80 00 	movl   $0xcf9200,-0x7fecb75c(%eax)
8010728f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107292:	c7 80 a8 48 13 80 ff 	movl   $0xffff,-0x7fecb758(%eax)
80107299:	ff 00 00 
8010729c:	c7 80 ac 48 13 80 00 	movl   $0xcffa00,-0x7fecb754(%eax)
801072a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072a6:	c7 80 b0 48 13 80 ff 	movl   $0xffff,-0x7fecb750(%eax)
801072ad:	ff 00 00 
801072b0:	c7 80 b4 48 13 80 00 	movl   $0xcff200,-0x7fecb74c(%eax)
801072b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ba:	05 90 48 13 80       	add    $0x80134890,%eax
  pd[1] = (uint)p;
801072bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072c3:	c1 e8 10             	shr    $0x10,%eax
801072c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072cd:	0f 01 10             	lgdtl  (%eax)
}
801072d0:	c9                   	leave  
801072d1:	c3                   	ret    
801072d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e0:	a1 c4 89 16 80       	mov    0x801689c4,%eax
{
801072e5:	55                   	push   %ebp
801072e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ed:	0f 22 d8             	mov    %eax,%cr3
}
801072f0:	5d                   	pop    %ebp
801072f1:	c3                   	ret    
801072f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107300 <switchuvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
80107309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010730c:	85 db                	test   %ebx,%ebx
8010730e:	0f 84 cb 00 00 00    	je     801073df <switchuvm+0xdf>
  if(p->kstack == 0)
80107314:	8b 43 08             	mov    0x8(%ebx),%eax
80107317:	85 c0                	test   %eax,%eax
80107319:	0f 84 da 00 00 00    	je     801073f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010731f:	8b 43 04             	mov    0x4(%ebx),%eax
80107322:	85 c0                	test   %eax,%eax
80107324:	0f 84 c2 00 00 00    	je     801073ec <switchuvm+0xec>
  pushcli();
8010732a:	e8 11 d7 ff ff       	call   80104a40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010732f:	e8 9c c4 ff ff       	call   801037d0 <mycpu>
80107334:	89 c6                	mov    %eax,%esi
80107336:	e8 95 c4 ff ff       	call   801037d0 <mycpu>
8010733b:	89 c7                	mov    %eax,%edi
8010733d:	e8 8e c4 ff ff       	call   801037d0 <mycpu>
80107342:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107345:	83 c7 08             	add    $0x8,%edi
80107348:	e8 83 c4 ff ff       	call   801037d0 <mycpu>
8010734d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107350:	83 c0 08             	add    $0x8,%eax
80107353:	ba 67 00 00 00       	mov    $0x67,%edx
80107358:	c1 e8 18             	shr    $0x18,%eax
8010735b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107362:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107369:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010736f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107374:	83 c1 08             	add    $0x8,%ecx
80107377:	c1 e9 10             	shr    $0x10,%ecx
8010737a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107380:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107385:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010738c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107391:	e8 3a c4 ff ff       	call   801037d0 <mycpu>
80107396:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010739d:	e8 2e c4 ff ff       	call   801037d0 <mycpu>
801073a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073a6:	8b 73 08             	mov    0x8(%ebx),%esi
801073a9:	e8 22 c4 ff ff       	call   801037d0 <mycpu>
801073ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073b7:	e8 14 c4 ff ff       	call   801037d0 <mycpu>
801073bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073c0:	b8 28 00 00 00       	mov    $0x28,%eax
801073c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
801073cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073d0:	0f 22 d8             	mov    %eax,%cr3
}
801073d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d6:	5b                   	pop    %ebx
801073d7:	5e                   	pop    %esi
801073d8:	5f                   	pop    %edi
801073d9:	5d                   	pop    %ebp
  popcli();
801073da:	e9 a1 d6 ff ff       	jmp    80104a80 <popcli>
    panic("switchuvm: no process");
801073df:	83 ec 0c             	sub    $0xc,%esp
801073e2:	68 1e 84 10 80       	push   $0x8010841e
801073e7:	e8 a4 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 49 84 10 80       	push   $0x80108449
801073f4:	e8 97 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 34 84 10 80       	push   $0x80108434
80107401:	e8 8a 8f ff ff       	call   80100390 <panic>
80107406:	8d 76 00             	lea    0x0(%esi),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <inituvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 75 10             	mov    0x10(%ebp),%esi
8010741c:	8b 45 08             	mov    0x8(%ebp),%eax
8010741f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107422:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010742b:	77 49                	ja     80107476 <inituvm+0x66>
  mem = kalloc();
8010742d:	e8 be b0 ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107432:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107435:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107437:	68 00 10 00 00       	push   $0x1000
8010743c:	6a 00                	push   $0x0
8010743e:	50                   	push   %eax
8010743f:	e8 dc d7 ff ff       	call   80104c20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107444:	58                   	pop    %eax
80107445:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010744b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107450:	5a                   	pop    %edx
80107451:	6a 06                	push   $0x6
80107453:	50                   	push   %eax
80107454:	31 d2                	xor    %edx,%edx
80107456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107459:	e8 c2 fc ff ff       	call   80107120 <mappages>
  memmove(mem, init, sz);
8010745e:	89 75 10             	mov    %esi,0x10(%ebp)
80107461:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107464:	83 c4 10             	add    $0x10,%esp
80107467:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010746a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010746d:	5b                   	pop    %ebx
8010746e:	5e                   	pop    %esi
8010746f:	5f                   	pop    %edi
80107470:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107471:	e9 5a d8 ff ff       	jmp    80104cd0 <memmove>
    panic("inituvm: more than a page");
80107476:	83 ec 0c             	sub    $0xc,%esp
80107479:	68 5d 84 10 80       	push   $0x8010845d
8010747e:	e8 0d 8f ff ff       	call   80100390 <panic>
80107483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107490 <loaduvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107499:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801074a0:	0f 85 91 00 00 00    	jne    80107537 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801074a6:	8b 75 18             	mov    0x18(%ebp),%esi
801074a9:	31 db                	xor    %ebx,%ebx
801074ab:	85 f6                	test   %esi,%esi
801074ad:	75 1a                	jne    801074c9 <loaduvm+0x39>
801074af:	eb 6f                	jmp    80107520 <loaduvm+0x90>
801074b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801074c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801074c7:	76 57                	jbe    80107520 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801074cc:	8b 45 08             	mov    0x8(%ebp),%eax
801074cf:	31 c9                	xor    %ecx,%ecx
801074d1:	01 da                	add    %ebx,%edx
801074d3:	e8 c8 fb ff ff       	call   801070a0 <walkpgdir>
801074d8:	85 c0                	test   %eax,%eax
801074da:	74 4e                	je     8010752a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801074dc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074de:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801074e1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074f1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074f4:	01 d9                	add    %ebx,%ecx
801074f6:	05 00 00 00 80       	add    $0x80000000,%eax
801074fb:	57                   	push   %edi
801074fc:	51                   	push   %ecx
801074fd:	50                   	push   %eax
801074fe:	ff 75 10             	pushl  0x10(%ebp)
80107501:	e8 8a a4 ff ff       	call   80101990 <readi>
80107506:	83 c4 10             	add    $0x10,%esp
80107509:	39 f8                	cmp    %edi,%eax
8010750b:	74 ab                	je     801074b8 <loaduvm+0x28>
}
8010750d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret    
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
      panic("loaduvm: address should exist");
8010752a:	83 ec 0c             	sub    $0xc,%esp
8010752d:	68 77 84 10 80       	push   $0x80108477
80107532:	e8 59 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107537:	83 ec 0c             	sub    $0xc,%esp
8010753a:	68 18 85 10 80       	push   $0x80108518
8010753f:	e8 4c 8e ff ff       	call   80100390 <panic>
80107544:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010754a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107550 <allocuvm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107559:	8b 7d 10             	mov    0x10(%ebp),%edi
8010755c:	85 ff                	test   %edi,%edi
8010755e:	0f 88 8e 00 00 00    	js     801075f2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107564:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107567:	0f 82 93 00 00 00    	jb     80107600 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010756d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107570:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107576:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010757c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010757f:	0f 86 7e 00 00 00    	jbe    80107603 <allocuvm+0xb3>
80107585:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107588:	8b 7d 08             	mov    0x8(%ebp),%edi
8010758b:	eb 42                	jmp    801075cf <allocuvm+0x7f>
8010758d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107590:	83 ec 04             	sub    $0x4,%esp
80107593:	68 00 10 00 00       	push   $0x1000
80107598:	6a 00                	push   $0x0
8010759a:	50                   	push   %eax
8010759b:	e8 80 d6 ff ff       	call   80104c20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075a0:	58                   	pop    %eax
801075a1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075a7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075ac:	5a                   	pop    %edx
801075ad:	6a 06                	push   $0x6
801075af:	50                   	push   %eax
801075b0:	89 da                	mov    %ebx,%edx
801075b2:	89 f8                	mov    %edi,%eax
801075b4:	e8 67 fb ff ff       	call   80107120 <mappages>
801075b9:	83 c4 10             	add    $0x10,%esp
801075bc:	85 c0                	test   %eax,%eax
801075be:	78 50                	js     80107610 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801075c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075c6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801075c9:	0f 86 81 00 00 00    	jbe    80107650 <allocuvm+0x100>
    mem = kalloc();
801075cf:	e8 1c af ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
801075d4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801075d6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801075d8:	75 b6                	jne    80107590 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075da:	83 ec 0c             	sub    $0xc,%esp
801075dd:	68 95 84 10 80       	push   $0x80108495
801075e2:	e8 79 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801075e7:	83 c4 10             	add    $0x10,%esp
801075ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801075ed:	39 45 10             	cmp    %eax,0x10(%ebp)
801075f0:	77 6e                	ja     80107660 <allocuvm+0x110>
}
801075f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801075f5:	31 ff                	xor    %edi,%edi
}
801075f7:	89 f8                	mov    %edi,%eax
801075f9:	5b                   	pop    %ebx
801075fa:	5e                   	pop    %esi
801075fb:	5f                   	pop    %edi
801075fc:	5d                   	pop    %ebp
801075fd:	c3                   	ret    
801075fe:	66 90                	xchg   %ax,%ax
    return oldsz;
80107600:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107603:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107606:	89 f8                	mov    %edi,%eax
80107608:	5b                   	pop    %ebx
80107609:	5e                   	pop    %esi
8010760a:	5f                   	pop    %edi
8010760b:	5d                   	pop    %ebp
8010760c:	c3                   	ret    
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	68 ad 84 10 80       	push   $0x801084ad
80107618:	e8 43 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010761d:	83 c4 10             	add    $0x10,%esp
80107620:	8b 45 0c             	mov    0xc(%ebp),%eax
80107623:	39 45 10             	cmp    %eax,0x10(%ebp)
80107626:	76 0d                	jbe    80107635 <allocuvm+0xe5>
80107628:	89 c1                	mov    %eax,%ecx
8010762a:	8b 55 10             	mov    0x10(%ebp),%edx
8010762d:	8b 45 08             	mov    0x8(%ebp),%eax
80107630:	e8 7b fb ff ff       	call   801071b0 <deallocuvm.part.0>
      kfree(mem);
80107635:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107638:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010763a:	56                   	push   %esi
8010763b:	e8 00 ad ff ff       	call   80102340 <kfree>
      return 0;
80107640:	83 c4 10             	add    $0x10,%esp
}
80107643:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107646:	89 f8                	mov    %edi,%eax
80107648:	5b                   	pop    %ebx
80107649:	5e                   	pop    %esi
8010764a:	5f                   	pop    %edi
8010764b:	5d                   	pop    %ebp
8010764c:	c3                   	ret    
8010764d:	8d 76 00             	lea    0x0(%esi),%esi
80107650:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107653:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107656:	5b                   	pop    %ebx
80107657:	89 f8                	mov    %edi,%eax
80107659:	5e                   	pop    %esi
8010765a:	5f                   	pop    %edi
8010765b:	5d                   	pop    %ebp
8010765c:	c3                   	ret    
8010765d:	8d 76 00             	lea    0x0(%esi),%esi
80107660:	89 c1                	mov    %eax,%ecx
80107662:	8b 55 10             	mov    0x10(%ebp),%edx
80107665:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107668:	31 ff                	xor    %edi,%edi
8010766a:	e8 41 fb ff ff       	call   801071b0 <deallocuvm.part.0>
8010766f:	eb 92                	jmp    80107603 <allocuvm+0xb3>
80107671:	eb 0d                	jmp    80107680 <deallocuvm>
80107673:	90                   	nop
80107674:	90                   	nop
80107675:	90                   	nop
80107676:	90                   	nop
80107677:	90                   	nop
80107678:	90                   	nop
80107679:	90                   	nop
8010767a:	90                   	nop
8010767b:	90                   	nop
8010767c:	90                   	nop
8010767d:	90                   	nop
8010767e:	90                   	nop
8010767f:	90                   	nop

80107680 <deallocuvm>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	8b 55 0c             	mov    0xc(%ebp),%edx
80107686:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107689:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010768c:	39 d1                	cmp    %edx,%ecx
8010768e:	73 10                	jae    801076a0 <deallocuvm+0x20>
}
80107690:	5d                   	pop    %ebp
80107691:	e9 1a fb ff ff       	jmp    801071b0 <deallocuvm.part.0>
80107696:	8d 76 00             	lea    0x0(%esi),%esi
80107699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801076a0:	89 d0                	mov    %edx,%eax
801076a2:	5d                   	pop    %ebp
801076a3:	c3                   	ret    
801076a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801076b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 0c             	sub    $0xc,%esp
801076b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076bc:	85 f6                	test   %esi,%esi
801076be:	74 59                	je     80107719 <freevm+0x69>
801076c0:	31 c9                	xor    %ecx,%ecx
801076c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076c7:	89 f0                	mov    %esi,%eax
801076c9:	e8 e2 fa ff ff       	call   801071b0 <deallocuvm.part.0>
801076ce:	89 f3                	mov    %esi,%ebx
801076d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076d6:	eb 0f                	jmp    801076e7 <freevm+0x37>
801076d8:	90                   	nop
801076d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076e0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076e3:	39 fb                	cmp    %edi,%ebx
801076e5:	74 23                	je     8010770a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076e7:	8b 03                	mov    (%ebx),%eax
801076e9:	a8 01                	test   $0x1,%al
801076eb:	74 f3                	je     801076e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076f2:	83 ec 0c             	sub    $0xc,%esp
801076f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076fd:	50                   	push   %eax
801076fe:	e8 3d ac ff ff       	call   80102340 <kfree>
80107703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107706:	39 fb                	cmp    %edi,%ebx
80107708:	75 dd                	jne    801076e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010770a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010770d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107710:	5b                   	pop    %ebx
80107711:	5e                   	pop    %esi
80107712:	5f                   	pop    %edi
80107713:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107714:	e9 27 ac ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 c9 84 10 80       	push   $0x801084c9
80107721:	e8 6a 8c ff ff       	call   80100390 <panic>
80107726:	8d 76 00             	lea    0x0(%esi),%esi
80107729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107730 <setupkvm>:
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	56                   	push   %esi
80107734:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107735:	e8 b6 ad ff ff       	call   801024f0 <kalloc>
8010773a:	85 c0                	test   %eax,%eax
8010773c:	89 c6                	mov    %eax,%esi
8010773e:	74 42                	je     80107782 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107740:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107743:	bb a0 b4 10 80       	mov    $0x8010b4a0,%ebx
  memset(pgdir, 0, PGSIZE);
80107748:	68 00 10 00 00       	push   $0x1000
8010774d:	6a 00                	push   $0x0
8010774f:	50                   	push   %eax
80107750:	e8 cb d4 ff ff       	call   80104c20 <memset>
80107755:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107758:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010775b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010775e:	83 ec 08             	sub    $0x8,%esp
80107761:	8b 13                	mov    (%ebx),%edx
80107763:	ff 73 0c             	pushl  0xc(%ebx)
80107766:	50                   	push   %eax
80107767:	29 c1                	sub    %eax,%ecx
80107769:	89 f0                	mov    %esi,%eax
8010776b:	e8 b0 f9 ff ff       	call   80107120 <mappages>
80107770:	83 c4 10             	add    $0x10,%esp
80107773:	85 c0                	test   %eax,%eax
80107775:	78 19                	js     80107790 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107777:	83 c3 10             	add    $0x10,%ebx
8010777a:	81 fb e0 b4 10 80    	cmp    $0x8010b4e0,%ebx
80107780:	75 d6                	jne    80107758 <setupkvm+0x28>
}
80107782:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107785:	89 f0                	mov    %esi,%eax
80107787:	5b                   	pop    %ebx
80107788:	5e                   	pop    %esi
80107789:	5d                   	pop    %ebp
8010778a:	c3                   	ret    
8010778b:	90                   	nop
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	56                   	push   %esi
      return 0;
80107794:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107796:	e8 15 ff ff ff       	call   801076b0 <freevm>
      return 0;
8010779b:	83 c4 10             	add    $0x10,%esp
}
8010779e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a1:	89 f0                	mov    %esi,%eax
801077a3:	5b                   	pop    %ebx
801077a4:	5e                   	pop    %esi
801077a5:	5d                   	pop    %ebp
801077a6:	c3                   	ret    
801077a7:	89 f6                	mov    %esi,%esi
801077a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077b0 <kvmalloc>:
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077b6:	e8 75 ff ff ff       	call   80107730 <setupkvm>
801077bb:	a3 c4 89 16 80       	mov    %eax,0x801689c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c0:	05 00 00 00 80       	add    $0x80000000,%eax
801077c5:	0f 22 d8             	mov    %eax,%cr3
}
801077c8:	c9                   	leave  
801077c9:	c3                   	ret    
801077ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077d1:	31 c9                	xor    %ecx,%ecx
{
801077d3:	89 e5                	mov    %esp,%ebp
801077d5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077db:	8b 45 08             	mov    0x8(%ebp),%eax
801077de:	e8 bd f8 ff ff       	call   801070a0 <walkpgdir>
  if(pte == 0)
801077e3:	85 c0                	test   %eax,%eax
801077e5:	74 05                	je     801077ec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077e7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077ea:	c9                   	leave  
801077eb:	c3                   	ret    
    panic("clearpteu");
801077ec:	83 ec 0c             	sub    $0xc,%esp
801077ef:	68 da 84 10 80       	push   $0x801084da
801077f4:	e8 97 8b ff ff       	call   80100390 <panic>
801077f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107800 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107809:	e8 22 ff ff ff       	call   80107730 <setupkvm>
8010780e:	85 c0                	test   %eax,%eax
80107810:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107813:	0f 84 9f 00 00 00    	je     801078b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010781c:	85 c9                	test   %ecx,%ecx
8010781e:	0f 84 94 00 00 00    	je     801078b8 <copyuvm+0xb8>
80107824:	31 ff                	xor    %edi,%edi
80107826:	eb 4a                	jmp    80107872 <copyuvm+0x72>
80107828:	90                   	nop
80107829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107830:	83 ec 04             	sub    $0x4,%esp
80107833:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107839:	68 00 10 00 00       	push   $0x1000
8010783e:	53                   	push   %ebx
8010783f:	50                   	push   %eax
80107840:	e8 8b d4 ff ff       	call   80104cd0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107845:	58                   	pop    %eax
80107846:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010784c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107851:	5a                   	pop    %edx
80107852:	ff 75 e4             	pushl  -0x1c(%ebp)
80107855:	50                   	push   %eax
80107856:	89 fa                	mov    %edi,%edx
80107858:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010785b:	e8 c0 f8 ff ff       	call   80107120 <mappages>
80107860:	83 c4 10             	add    $0x10,%esp
80107863:	85 c0                	test   %eax,%eax
80107865:	78 61                	js     801078c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107867:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010786d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107870:	76 46                	jbe    801078b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107872:	8b 45 08             	mov    0x8(%ebp),%eax
80107875:	31 c9                	xor    %ecx,%ecx
80107877:	89 fa                	mov    %edi,%edx
80107879:	e8 22 f8 ff ff       	call   801070a0 <walkpgdir>
8010787e:	85 c0                	test   %eax,%eax
80107880:	74 61                	je     801078e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107882:	8b 00                	mov    (%eax),%eax
80107884:	a8 01                	test   $0x1,%al
80107886:	74 4e                	je     801078d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107888:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010788a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010788f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107895:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107898:	e8 53 ac ff ff       	call   801024f0 <kalloc>
8010789d:	85 c0                	test   %eax,%eax
8010789f:	89 c6                	mov    %eax,%esi
801078a1:	75 8d                	jne    80107830 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801078a3:	83 ec 0c             	sub    $0xc,%esp
801078a6:	ff 75 e0             	pushl  -0x20(%ebp)
801078a9:	e8 02 fe ff ff       	call   801076b0 <freevm>
  return 0;
801078ae:	83 c4 10             	add    $0x10,%esp
801078b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801078b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078be:	5b                   	pop    %ebx
801078bf:	5e                   	pop    %esi
801078c0:	5f                   	pop    %edi
801078c1:	5d                   	pop    %ebp
801078c2:	c3                   	ret    
801078c3:	90                   	nop
801078c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801078c8:	83 ec 0c             	sub    $0xc,%esp
801078cb:	56                   	push   %esi
801078cc:	e8 6f aa ff ff       	call   80102340 <kfree>
      goto bad;
801078d1:	83 c4 10             	add    $0x10,%esp
801078d4:	eb cd                	jmp    801078a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801078d6:	83 ec 0c             	sub    $0xc,%esp
801078d9:	68 fe 84 10 80       	push   $0x801084fe
801078de:	e8 ad 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078e3:	83 ec 0c             	sub    $0xc,%esp
801078e6:	68 e4 84 10 80       	push   $0x801084e4
801078eb:	e8 a0 8a ff ff       	call   80100390 <panic>

801078f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078f1:	31 c9                	xor    %ecx,%ecx
{
801078f3:	89 e5                	mov    %esp,%ebp
801078f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801078fb:	8b 45 08             	mov    0x8(%ebp),%eax
801078fe:	e8 9d f7 ff ff       	call   801070a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107903:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107905:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107906:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107908:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010790d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107910:	05 00 00 00 80       	add    $0x80000000,%eax
80107915:	83 fa 05             	cmp    $0x5,%edx
80107918:	ba 00 00 00 00       	mov    $0x0,%edx
8010791d:	0f 45 c2             	cmovne %edx,%eax
}
80107920:	c3                   	ret    
80107921:	eb 0d                	jmp    80107930 <copyout>
80107923:	90                   	nop
80107924:	90                   	nop
80107925:	90                   	nop
80107926:	90                   	nop
80107927:	90                   	nop
80107928:	90                   	nop
80107929:	90                   	nop
8010792a:	90                   	nop
8010792b:	90                   	nop
8010792c:	90                   	nop
8010792d:	90                   	nop
8010792e:	90                   	nop
8010792f:	90                   	nop

80107930 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 1c             	sub    $0x1c,%esp
80107939:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010793c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010793f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107942:	85 db                	test   %ebx,%ebx
80107944:	75 40                	jne    80107986 <copyout+0x56>
80107946:	eb 70                	jmp    801079b8 <copyout+0x88>
80107948:	90                   	nop
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107950:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107953:	89 f1                	mov    %esi,%ecx
80107955:	29 d1                	sub    %edx,%ecx
80107957:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010795d:	39 d9                	cmp    %ebx,%ecx
8010795f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107962:	29 f2                	sub    %esi,%edx
80107964:	83 ec 04             	sub    $0x4,%esp
80107967:	01 d0                	add    %edx,%eax
80107969:	51                   	push   %ecx
8010796a:	57                   	push   %edi
8010796b:	50                   	push   %eax
8010796c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010796f:	e8 5c d3 ff ff       	call   80104cd0 <memmove>
    len -= n;
    buf += n;
80107974:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107977:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010797a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107980:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107982:	29 cb                	sub    %ecx,%ebx
80107984:	74 32                	je     801079b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107986:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107988:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010798b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010798e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107994:	56                   	push   %esi
80107995:	ff 75 08             	pushl  0x8(%ebp)
80107998:	e8 53 ff ff ff       	call   801078f0 <uva2ka>
    if(pa0 == 0)
8010799d:	83 c4 10             	add    $0x10,%esp
801079a0:	85 c0                	test   %eax,%eax
801079a2:	75 ac                	jne    80107950 <copyout+0x20>
  }
  return 0;
}
801079a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079ac:	5b                   	pop    %ebx
801079ad:	5e                   	pop    %esi
801079ae:	5f                   	pop    %edi
801079af:	5d                   	pop    %ebp
801079b0:	c3                   	ret    
801079b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079bb:	31 c0                	xor    %eax,%eax
}
801079bd:	5b                   	pop    %ebx
801079be:	5e                   	pop    %esi
801079bf:	5f                   	pop    %edi
801079c0:	5d                   	pop    %ebp
801079c1:	c3                   	ret    
