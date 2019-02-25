
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	be 01 00 00 00       	mov    $0x1,%esi
  16:	83 ec 18             	sub    $0x18,%esp
  19:	8b 01                	mov    (%ecx),%eax
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  21:	83 f8 01             	cmp    $0x1,%eax
{
  24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(argc <= 1){
  27:	7e 54                	jle    7d <main+0x7d>
  29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	pushl  (%ebx)
  37:	e8 66 03 00 00       	call   3a2 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	89 c7                	mov    %eax,%edi
  43:	78 24                	js     69 <main+0x69>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  45:	83 ec 0c             	sub    $0xc,%esp
  for(i = 1; i < argc; i++){
  48:	83 c6 01             	add    $0x1,%esi
  4b:	83 c3 04             	add    $0x4,%ebx
    cat(fd);
  4e:	50                   	push   %eax
  4f:	e8 3c 00 00 00       	call   90 <cat>
    close(fd);
  54:	89 3c 24             	mov    %edi,(%esp)
  57:	e8 2e 03 00 00       	call   38a <close>
  for(i = 1; i < argc; i++){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  62:	75 cc                	jne    30 <main+0x30>
  }
  exit();
  64:	e8 f9 02 00 00       	call   362 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  69:	50                   	push   %eax
  6a:	ff 33                	pushl  (%ebx)
  6c:	68 7b 08 00 00       	push   $0x87b
  71:	6a 01                	push   $0x1
  73:	e8 88 04 00 00       	call   500 <printf>
      exit();
  78:	e8 e5 02 00 00       	call   362 <exit>
    cat(0);
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	6a 00                	push   $0x0
  82:	e8 09 00 00 00       	call   90 <cat>
    exit();
  87:	e8 d6 02 00 00       	call   362 <exit>
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <cat>:
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	53                   	push   %ebx
  95:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  98:	eb 1d                	jmp    b7 <cat+0x27>
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  a0:	83 ec 04             	sub    $0x4,%esp
  a3:	53                   	push   %ebx
  a4:	68 a0 0b 00 00       	push   $0xba0
  a9:	6a 01                	push   $0x1
  ab:	e8 d2 02 00 00       	call   382 <write>
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	39 d8                	cmp    %ebx,%eax
  b5:	75 26                	jne    dd <cat+0x4d>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  b7:	83 ec 04             	sub    $0x4,%esp
  ba:	68 00 02 00 00       	push   $0x200
  bf:	68 a0 0b 00 00       	push   $0xba0
  c4:	56                   	push   %esi
  c5:	e8 b0 02 00 00       	call   37a <read>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	83 f8 00             	cmp    $0x0,%eax
  d0:	89 c3                	mov    %eax,%ebx
  d2:	7f cc                	jg     a0 <cat+0x10>
  if(n < 0){
  d4:	75 1b                	jne    f1 <cat+0x61>
}
  d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  d9:	5b                   	pop    %ebx
  da:	5e                   	pop    %esi
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
      printf(1, "cat: write error\n");
  dd:	83 ec 08             	sub    $0x8,%esp
  e0:	68 58 08 00 00       	push   $0x858
  e5:	6a 01                	push   $0x1
  e7:	e8 14 04 00 00       	call   500 <printf>
      exit();
  ec:	e8 71 02 00 00       	call   362 <exit>
    printf(1, "cat: read error\n");
  f1:	50                   	push   %eax
  f2:	50                   	push   %eax
  f3:	68 6a 08 00 00       	push   $0x86a
  f8:	6a 01                	push   $0x1
  fa:	e8 01 04 00 00       	call   500 <printf>
    exit();
  ff:	e8 5e 02 00 00       	call   362 <exit>
 104:	66 90                	xchg   %ax,%ax
 106:	66 90                	xchg   %ax,%ax
 108:	66 90                	xchg   %ax,%ax
 10a:	66 90                	xchg   %ax,%ax
 10c:	66 90                	xchg   %ax,%ax
 10e:	66 90                	xchg   %ax,%ax

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	89 c2                	mov    %eax,%edx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 120:	83 c1 01             	add    $0x1,%ecx
 123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 db                	test   %bl,%bl
 12c:	88 5a ff             	mov    %bl,-0x1(%edx)
 12f:	75 ef                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 131:	5b                   	pop    %ebx
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
 134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 13a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 55 08             	mov    0x8(%ebp),%edx
 147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 14a:	0f b6 02             	movzbl (%edx),%eax
 14d:	0f b6 19             	movzbl (%ecx),%ebx
 150:	84 c0                	test   %al,%al
 152:	75 1c                	jne    170 <strcmp+0x30>
 154:	eb 2a                	jmp    180 <strcmp+0x40>
 156:	8d 76 00             	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 160:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 163:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 166:	83 c1 01             	add    $0x1,%ecx
 169:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 16c:	84 c0                	test   %al,%al
 16e:	74 10                	je     180 <strcmp+0x40>
 170:	38 d8                	cmp    %bl,%al
 172:	74 ec                	je     160 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 174:	29 d8                	sub    %ebx,%eax
}
 176:	5b                   	pop    %ebx
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 180:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 182:	29 d8                	sub    %ebx,%eax
}
 184:	5b                   	pop    %ebx
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	89 f6                	mov    %esi,%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strlen>:

uint
strlen(const char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 39 00             	cmpb   $0x0,(%ecx)
 199:	74 15                	je     1b0 <strlen+0x20>
 19b:	31 d2                	xor    %edx,%edx
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1b0:	31 c0                	xor    %eax,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
 1b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld    
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	89 d0                	mov    %edx,%eax
 1d4:	5f                   	pop    %edi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	74 1d                	je     20e <strchr+0x2e>
    if(*s == c)
 1f1:	38 d3                	cmp    %dl,%bl
 1f3:	89 d9                	mov    %ebx,%ecx
 1f5:	75 0d                	jne    204 <strchr+0x24>
 1f7:	eb 17                	jmp    210 <strchr+0x30>
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	38 ca                	cmp    %cl,%dl
 202:	74 0c                	je     210 <strchr+0x30>
  for(; *s; s++)
 204:	83 c0 01             	add    $0x1,%eax
 207:	0f b6 10             	movzbl (%eax),%edx
 20a:	84 d2                	test   %dl,%dl
 20c:	75 f2                	jne    200 <strchr+0x20>
      return (char*)s;
  return 0;
 20e:	31 c0                	xor    %eax,%eax
}
 210:	5b                   	pop    %ebx
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
 213:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 226:	31 f6                	xor    %esi,%esi
 228:	89 f3                	mov    %esi,%ebx
{
 22a:	83 ec 1c             	sub    $0x1c,%esp
 22d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 230:	eb 2f                	jmp    261 <gets+0x41>
 232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 238:	8d 45 e7             	lea    -0x19(%ebp),%eax
 23b:	83 ec 04             	sub    $0x4,%esp
 23e:	6a 01                	push   $0x1
 240:	50                   	push   %eax
 241:	6a 00                	push   $0x0
 243:	e8 32 01 00 00       	call   37a <read>
    if(cc < 1)
 248:	83 c4 10             	add    $0x10,%esp
 24b:	85 c0                	test   %eax,%eax
 24d:	7e 1c                	jle    26b <gets+0x4b>
      break;
    buf[i++] = c;
 24f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 253:	83 c7 01             	add    $0x1,%edi
 256:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 259:	3c 0a                	cmp    $0xa,%al
 25b:	74 23                	je     280 <gets+0x60>
 25d:	3c 0d                	cmp    $0xd,%al
 25f:	74 1f                	je     280 <gets+0x60>
  for(i=0; i+1 < max; ){
 261:	83 c3 01             	add    $0x1,%ebx
 264:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 267:	89 fe                	mov    %edi,%esi
 269:	7c cd                	jl     238 <gets+0x18>
 26b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 270:	c6 03 00             	movb   $0x0,(%ebx)
}
 273:	8d 65 f4             	lea    -0xc(%ebp),%esp
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret    
 27b:	90                   	nop
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 280:	8b 75 08             	mov    0x8(%ebp),%esi
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	01 de                	add    %ebx,%esi
 288:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 28a:	c6 03 00             	movb   $0x0,(%ebx)
}
 28d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 290:	5b                   	pop    %ebx
 291:	5e                   	pop    %esi
 292:	5f                   	pop    %edi
 293:	5d                   	pop    %ebp
 294:	c3                   	ret    
 295:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a5:	83 ec 08             	sub    $0x8,%esp
 2a8:	6a 00                	push   $0x0
 2aa:	ff 75 08             	pushl  0x8(%ebp)
 2ad:	e8 f0 00 00 00       	call   3a2 <open>
  if(fd < 0)
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	85 c0                	test   %eax,%eax
 2b7:	78 27                	js     2e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2b9:	83 ec 08             	sub    $0x8,%esp
 2bc:	ff 75 0c             	pushl  0xc(%ebp)
 2bf:	89 c3                	mov    %eax,%ebx
 2c1:	50                   	push   %eax
 2c2:	e8 f3 00 00 00       	call   3ba <fstat>
  close(fd);
 2c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ca:	89 c6                	mov    %eax,%esi
  close(fd);
 2cc:	e8 b9 00 00 00       	call   38a <close>
  return r;
 2d1:	83 c4 10             	add    $0x10,%esp
}
 2d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2d7:	89 f0                	mov    %esi,%eax
 2d9:	5b                   	pop    %ebx
 2da:	5e                   	pop    %esi
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2e5:	eb ed                	jmp    2d4 <stat+0x34>
 2e7:	89 f6                	mov    %esi,%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f7:	0f be 11             	movsbl (%ecx),%edx
 2fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 2fd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2ff:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 304:	77 1f                	ja     325 <atoi+0x35>
 306:	8d 76 00             	lea    0x0(%esi),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 310:	8d 04 80             	lea    (%eax,%eax,4),%eax
 313:	83 c1 01             	add    $0x1,%ecx
 316:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 31a:	0f be 11             	movsbl (%ecx),%edx
 31d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 320:	80 fb 09             	cmp    $0x9,%bl
 323:	76 eb                	jbe    310 <atoi+0x20>
  return n;
}
 325:	5b                   	pop    %ebx
 326:	5d                   	pop    %ebp
 327:	c3                   	ret    
 328:	90                   	nop
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000330 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	56                   	push   %esi
 334:	53                   	push   %ebx
 335:	8b 5d 10             	mov    0x10(%ebp),%ebx
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	85 db                	test   %ebx,%ebx
 340:	7e 14                	jle    356 <memmove+0x26>
 342:	31 d2                	xor    %edx,%edx
 344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 348:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 34c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 34f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 352:	39 d3                	cmp    %edx,%ebx
 354:	75 f2                	jne    348 <memmove+0x18>
  return vdst;
}
 356:	5b                   	pop    %ebx
 357:	5e                   	pop    %esi
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    

0000035a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35a:	b8 01 00 00 00       	mov    $0x1,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <exit>:
SYSCALL(exit)
 362:	b8 02 00 00 00       	mov    $0x2,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <wait>:
SYSCALL(wait)
 36a:	b8 03 00 00 00       	mov    $0x3,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <pipe>:
SYSCALL(pipe)
 372:	b8 04 00 00 00       	mov    $0x4,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <read>:
SYSCALL(read)
 37a:	b8 05 00 00 00       	mov    $0x5,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <write>:
SYSCALL(write)
 382:	b8 10 00 00 00       	mov    $0x10,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <close>:
SYSCALL(close)
 38a:	b8 15 00 00 00       	mov    $0x15,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <kill>:
SYSCALL(kill)
 392:	b8 06 00 00 00       	mov    $0x6,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <exec>:
SYSCALL(exec)
 39a:	b8 07 00 00 00       	mov    $0x7,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <open>:
SYSCALL(open)
 3a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <mknod>:
SYSCALL(mknod)
 3aa:	b8 11 00 00 00       	mov    $0x11,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <unlink>:
SYSCALL(unlink)
 3b2:	b8 12 00 00 00       	mov    $0x12,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <fstat>:
SYSCALL(fstat)
 3ba:	b8 08 00 00 00       	mov    $0x8,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <link>:
SYSCALL(link)
 3c2:	b8 13 00 00 00       	mov    $0x13,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mkdir>:
SYSCALL(mkdir)
 3ca:	b8 14 00 00 00       	mov    $0x14,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <chdir>:
SYSCALL(chdir)
 3d2:	b8 09 00 00 00       	mov    $0x9,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <dup>:
SYSCALL(dup)
 3da:	b8 0a 00 00 00       	mov    $0xa,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <getpid>:
SYSCALL(getpid)
 3e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <sbrk>:
SYSCALL(sbrk)
 3ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <sleep>:
SYSCALL(sleep)
 3f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <uptime>:
SYSCALL(uptime)
 3fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <print_count>:
SYSCALL(print_count)
 402:	b8 16 00 00 00       	mov    $0x16,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <toggle>:
SYSCALL(toggle)
 40a:	b8 17 00 00 00       	mov    $0x17,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <add>:
SYSCALL(add)
 412:	b8 18 00 00 00       	mov    $0x18,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <ps>:
SYSCALL(ps)
 41a:	b8 19 00 00 00       	mov    $0x19,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <send>:
SYSCALL(send)
 422:	b8 1a 00 00 00       	mov    $0x1a,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <recv>:
SYSCALL(recv)
 42a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <sig_set>:
SYSCALL(sig_set)
 432:	b8 1c 00 00 00       	mov    $0x1c,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <sig_send>:
SYSCALL(sig_send)
 43a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <sig_pause>:
SYSCALL(sig_pause)
 442:	b8 1e 00 00 00       	mov    $0x1e,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <sig_ret>:
SYSCALL(sig_ret)
 44a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <send_multi>:
 452:	b8 20 00 00 00       	mov    $0x20,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    
 45a:	66 90                	xchg   %ax,%ax
 45c:	66 90                	xchg   %ax,%ax
 45e:	66 90                	xchg   %ax,%ax

00000460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 469:	85 d2                	test   %edx,%edx
{
 46b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 46e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 470:	79 76                	jns    4e8 <printint+0x88>
 472:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 476:	74 70                	je     4e8 <printint+0x88>
    x = -xx;
 478:	f7 d8                	neg    %eax
    neg = 1;
 47a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 481:	31 f6                	xor    %esi,%esi
 483:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 486:	eb 0a                	jmp    492 <printint+0x32>
 488:	90                   	nop
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 490:	89 fe                	mov    %edi,%esi
 492:	31 d2                	xor    %edx,%edx
 494:	8d 7e 01             	lea    0x1(%esi),%edi
 497:	f7 f1                	div    %ecx
 499:	0f b6 92 98 08 00 00 	movzbl 0x898(%edx),%edx
  }while((x /= base) != 0);
 4a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 4a5:	75 e9                	jne    490 <printint+0x30>
  if(neg)
 4a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4aa:	85 c0                	test   %eax,%eax
 4ac:	74 08                	je     4b6 <printint+0x56>
    buf[i++] = '-';
 4ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 4b3:	8d 7e 02             	lea    0x2(%esi),%edi
 4b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 4ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
 4c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 4c3:	83 ec 04             	sub    $0x4,%esp
 4c6:	83 ee 01             	sub    $0x1,%esi
 4c9:	6a 01                	push   $0x1
 4cb:	53                   	push   %ebx
 4cc:	57                   	push   %edi
 4cd:	88 45 d7             	mov    %al,-0x29(%ebp)
 4d0:	e8 ad fe ff ff       	call   382 <write>

  while(--i >= 0)
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	39 de                	cmp    %ebx,%esi
 4da:	75 e4                	jne    4c0 <printint+0x60>
    putc(fd, buf[i]);
}
 4dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5f                   	pop    %edi
 4e2:	5d                   	pop    %ebp
 4e3:	c3                   	ret    
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4ef:	eb 90                	jmp    481 <printint+0x21>
 4f1:	eb 0d                	jmp    500 <printf>
 4f3:	90                   	nop
 4f4:	90                   	nop
 4f5:	90                   	nop
 4f6:	90                   	nop
 4f7:	90                   	nop
 4f8:	90                   	nop
 4f9:	90                   	nop
 4fa:	90                   	nop
 4fb:	90                   	nop
 4fc:	90                   	nop
 4fd:	90                   	nop
 4fe:	90                   	nop
 4ff:	90                   	nop

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 509:	8b 75 0c             	mov    0xc(%ebp),%esi
 50c:	0f b6 1e             	movzbl (%esi),%ebx
 50f:	84 db                	test   %bl,%bl
 511:	0f 84 b3 00 00 00    	je     5ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 517:	8d 45 10             	lea    0x10(%ebp),%eax
 51a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 51d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 51f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 522:	eb 2f                	jmp    553 <printf+0x53>
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	0f 84 a7 00 00 00    	je     5d8 <printf+0xd8>
  write(fd, &c, 1);
 531:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 534:	83 ec 04             	sub    $0x4,%esp
 537:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 53a:	6a 01                	push   $0x1
 53c:	50                   	push   %eax
 53d:	ff 75 08             	pushl  0x8(%ebp)
 540:	e8 3d fe ff ff       	call   382 <write>
 545:	83 c4 10             	add    $0x10,%esp
 548:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 54b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 54f:	84 db                	test   %bl,%bl
 551:	74 77                	je     5ca <printf+0xca>
    if(state == 0){
 553:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 555:	0f be cb             	movsbl %bl,%ecx
 558:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 55b:	74 cb                	je     528 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55d:	83 ff 25             	cmp    $0x25,%edi
 560:	75 e6                	jne    548 <printf+0x48>
      if(c == 'd'){
 562:	83 f8 64             	cmp    $0x64,%eax
 565:	0f 84 05 01 00 00    	je     670 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 56b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 571:	83 f9 70             	cmp    $0x70,%ecx
 574:	74 72                	je     5e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 576:	83 f8 73             	cmp    $0x73,%eax
 579:	0f 84 99 00 00 00    	je     618 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57f:	83 f8 63             	cmp    $0x63,%eax
 582:	0f 84 08 01 00 00    	je     690 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 588:	83 f8 25             	cmp    $0x25,%eax
 58b:	0f 84 ef 00 00 00    	je     680 <printf+0x180>
  write(fd, &c, 1);
 591:	8d 45 e7             	lea    -0x19(%ebp),%eax
 594:	83 ec 04             	sub    $0x4,%esp
 597:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 59b:	6a 01                	push   $0x1
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 dc fd ff ff       	call   382 <write>
 5a6:	83 c4 0c             	add    $0xc,%esp
 5a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5af:	6a 01                	push   $0x1
 5b1:	50                   	push   %eax
 5b2:	ff 75 08             	pushl  0x8(%ebp)
 5b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 5ba:	e8 c3 fd ff ff       	call   382 <write>
  for(i = 0; fmt[i]; i++){
 5bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 5c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5c6:	84 db                	test   %bl,%bl
 5c8:	75 89                	jne    553 <printf+0x53>
    }
  }
}
 5ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cd:	5b                   	pop    %ebx
 5ce:	5e                   	pop    %esi
 5cf:	5f                   	pop    %edi
 5d0:	5d                   	pop    %ebp
 5d1:	c3                   	ret    
 5d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 5d8:	bf 25 00 00 00       	mov    $0x25,%edi
 5dd:	e9 66 ff ff ff       	jmp    548 <printf+0x48>
 5e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5e8:	83 ec 0c             	sub    $0xc,%esp
 5eb:	b9 10 00 00 00       	mov    $0x10,%ecx
 5f0:	6a 00                	push   $0x0
 5f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	8b 17                	mov    (%edi),%edx
 5fa:	e8 61 fe ff ff       	call   460 <printint>
        ap++;
 5ff:	89 f8                	mov    %edi,%eax
 601:	83 c4 10             	add    $0x10,%esp
      state = 0;
 604:	31 ff                	xor    %edi,%edi
        ap++;
 606:	83 c0 04             	add    $0x4,%eax
 609:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 60c:	e9 37 ff ff ff       	jmp    548 <printf+0x48>
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 61b:	8b 08                	mov    (%eax),%ecx
        ap++;
 61d:	83 c0 04             	add    $0x4,%eax
 620:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 623:	85 c9                	test   %ecx,%ecx
 625:	0f 84 8e 00 00 00    	je     6b9 <printf+0x1b9>
        while(*s != 0){
 62b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 62e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 630:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 632:	84 c0                	test   %al,%al
 634:	0f 84 0e ff ff ff    	je     548 <printf+0x48>
 63a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 63d:	89 de                	mov    %ebx,%esi
 63f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 642:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 645:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 648:	83 ec 04             	sub    $0x4,%esp
          s++;
 64b:	83 c6 01             	add    $0x1,%esi
 64e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 651:	6a 01                	push   $0x1
 653:	57                   	push   %edi
 654:	53                   	push   %ebx
 655:	e8 28 fd ff ff       	call   382 <write>
        while(*s != 0){
 65a:	0f b6 06             	movzbl (%esi),%eax
 65d:	83 c4 10             	add    $0x10,%esp
 660:	84 c0                	test   %al,%al
 662:	75 e4                	jne    648 <printf+0x148>
 664:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 667:	31 ff                	xor    %edi,%edi
 669:	e9 da fe ff ff       	jmp    548 <printf+0x48>
 66e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 0a 00 00 00       	mov    $0xa,%ecx
 678:	6a 01                	push   $0x1
 67a:	e9 73 ff ff ff       	jmp    5f2 <printf+0xf2>
 67f:	90                   	nop
  write(fd, &c, 1);
 680:	83 ec 04             	sub    $0x4,%esp
 683:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 686:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 689:	6a 01                	push   $0x1
 68b:	e9 21 ff ff ff       	jmp    5b1 <printf+0xb1>
        putc(fd, *ap);
 690:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 693:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 696:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 698:	6a 01                	push   $0x1
        ap++;
 69a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 69d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6a3:	50                   	push   %eax
 6a4:	ff 75 08             	pushl  0x8(%ebp)
 6a7:	e8 d6 fc ff ff       	call   382 <write>
        ap++;
 6ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6af:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6b2:	31 ff                	xor    %edi,%edi
 6b4:	e9 8f fe ff ff       	jmp    548 <printf+0x48>
          s = "(null)";
 6b9:	bb 90 08 00 00       	mov    $0x890,%ebx
        while(*s != 0){
 6be:	b8 28 00 00 00       	mov    $0x28,%eax
 6c3:	e9 72 ff ff ff       	jmp    63a <printf+0x13a>
 6c8:	66 90                	xchg   %ax,%ax
 6ca:	66 90                	xchg   %ax,%ax
 6cc:	66 90                	xchg   %ax,%ax
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 80 0b 00 00       	mov    0xb80,%eax
{
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	53                   	push   %ebx
 6db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	39 c8                	cmp    %ecx,%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	73 32                	jae    720 <free+0x50>
 6ee:	39 d1                	cmp    %edx,%ecx
 6f0:	72 04                	jb     6f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	39 d0                	cmp    %edx,%eax
 6f4:	72 32                	jb     728 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fc:	39 fa                	cmp    %edi,%edx
 6fe:	74 30                	je     730 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 700:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 703:	8b 50 04             	mov    0x4(%eax),%edx
 706:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 709:	39 f1                	cmp    %esi,%ecx
 70b:	74 3a                	je     747 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 70d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 70f:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 714:	5b                   	pop    %ebx
 715:	5e                   	pop    %esi
 716:	5f                   	pop    %edi
 717:	5d                   	pop    %ebp
 718:	c3                   	ret    
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	39 d0                	cmp    %edx,%eax
 722:	72 04                	jb     728 <free+0x58>
 724:	39 d1                	cmp    %edx,%ecx
 726:	72 ce                	jb     6f6 <free+0x26>
{
 728:	89 d0                	mov    %edx,%eax
 72a:	eb bc                	jmp    6e8 <free+0x18>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 730:	03 72 04             	add    0x4(%edx),%esi
 733:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	8b 10                	mov    (%eax),%edx
 738:	8b 12                	mov    (%edx),%edx
 73a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 743:	39 f1                	cmp    %esi,%ecx
 745:	75 c6                	jne    70d <free+0x3d>
    p->s.size += bp->s.size;
 747:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 74a:	a3 80 0b 00 00       	mov    %eax,0xb80
    p->s.size += bp->s.size;
 74f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 752:	8b 53 f8             	mov    -0x8(%ebx),%edx
 755:	89 10                	mov    %edx,(%eax)
}
 757:	5b                   	pop    %ebx
 758:	5e                   	pop    %esi
 759:	5f                   	pop    %edi
 75a:	5d                   	pop    %ebp
 75b:	c3                   	ret    
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000760 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 769:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 76c:	8b 15 80 0b 00 00    	mov    0xb80,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	8d 78 07             	lea    0x7(%eax),%edi
 775:	c1 ef 03             	shr    $0x3,%edi
 778:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 77b:	85 d2                	test   %edx,%edx
 77d:	0f 84 9d 00 00 00    	je     820 <malloc+0xc0>
 783:	8b 02                	mov    (%edx),%eax
 785:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 788:	39 cf                	cmp    %ecx,%edi
 78a:	76 6c                	jbe    7f8 <malloc+0x98>
 78c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 792:	bb 00 10 00 00       	mov    $0x1000,%ebx
 797:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 79a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7a1:	eb 0e                	jmp    7b1 <malloc+0x51>
 7a3:	90                   	nop
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7aa:	8b 48 04             	mov    0x4(%eax),%ecx
 7ad:	39 f9                	cmp    %edi,%ecx
 7af:	73 47                	jae    7f8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b1:	39 05 80 0b 00 00    	cmp    %eax,0xb80
 7b7:	89 c2                	mov    %eax,%edx
 7b9:	75 ed                	jne    7a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7bb:	83 ec 0c             	sub    $0xc,%esp
 7be:	56                   	push   %esi
 7bf:	e8 26 fc ff ff       	call   3ea <sbrk>
  if(p == (char*)-1)
 7c4:	83 c4 10             	add    $0x10,%esp
 7c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ca:	74 1c                	je     7e8 <malloc+0x88>
  hp->s.size = nu;
 7cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7cf:	83 ec 0c             	sub    $0xc,%esp
 7d2:	83 c0 08             	add    $0x8,%eax
 7d5:	50                   	push   %eax
 7d6:	e8 f5 fe ff ff       	call   6d0 <free>
  return freep;
 7db:	8b 15 80 0b 00 00    	mov    0xb80,%edx
      if((p = morecore(nunits)) == 0)
 7e1:	83 c4 10             	add    $0x10,%esp
 7e4:	85 d2                	test   %edx,%edx
 7e6:	75 c0                	jne    7a8 <malloc+0x48>
        return 0;
  }
}
 7e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7eb:	31 c0                	xor    %eax,%eax
}
 7ed:	5b                   	pop    %ebx
 7ee:	5e                   	pop    %esi
 7ef:	5f                   	pop    %edi
 7f0:	5d                   	pop    %ebp
 7f1:	c3                   	ret    
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7f8:	39 cf                	cmp    %ecx,%edi
 7fa:	74 54                	je     850 <malloc+0xf0>
        p->s.size -= nunits;
 7fc:	29 f9                	sub    %edi,%ecx
 7fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 801:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 804:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 807:	89 15 80 0b 00 00    	mov    %edx,0xb80
}
 80d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 810:	83 c0 08             	add    $0x8,%eax
}
 813:	5b                   	pop    %ebx
 814:	5e                   	pop    %esi
 815:	5f                   	pop    %edi
 816:	5d                   	pop    %ebp
 817:	c3                   	ret    
 818:	90                   	nop
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 820:	c7 05 80 0b 00 00 84 	movl   $0xb84,0xb80
 827:	0b 00 00 
 82a:	c7 05 84 0b 00 00 84 	movl   $0xb84,0xb84
 831:	0b 00 00 
    base.s.size = 0;
 834:	b8 84 0b 00 00       	mov    $0xb84,%eax
 839:	c7 05 88 0b 00 00 00 	movl   $0x0,0xb88
 840:	00 00 00 
 843:	e9 44 ff ff ff       	jmp    78c <malloc+0x2c>
 848:	90                   	nop
 849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 850:	8b 08                	mov    (%eax),%ecx
 852:	89 0a                	mov    %ecx,(%edx)
 854:	eb b1                	jmp    807 <malloc+0xa7>
