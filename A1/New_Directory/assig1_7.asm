
_assig1_7:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
	printf(1,"%s\n","IPC Test case");
   f:	83 ec 04             	sub    $0x4,%esp
  12:	68 f8 07 00 00       	push   $0x7f8
  17:	68 06 08 00 00       	push   $0x806
  1c:	6a 01                	push   $0x1
  1e:	e8 7d 04 00 00       	call   4a0 <printf>
	
	int cid = fork();
  23:	e8 d2 02 00 00       	call   2fa <fork>
	if(cid==0){
  28:	83 c4 10             	add    $0x10,%esp
  2b:	85 c0                	test   %eax,%eax
  2d:	75 35                	jne    64 <main+0x64>
		// This is child
		char *msg = (char *)malloc(MSGSIZE);
  2f:	83 ec 0c             	sub    $0xc,%esp
  32:	6a 08                	push   $0x8
  34:	e8 c7 06 00 00       	call   700 <malloc>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	89 c3                	mov    %eax,%ebx
  3e:	66 90                	xchg   %ax,%ax
		int stat=-1;
		while(stat==-1){
			stat = recv(msg);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	53                   	push   %ebx
  44:	e8 81 03 00 00       	call   3ca <recv>
		while(stat==-1){
  49:	83 c4 10             	add    $0x10,%esp
  4c:	83 f8 ff             	cmp    $0xffffffff,%eax
  4f:	74 ef                	je     40 <main+0x40>
		}
		printf(1,"2 CHILD: msg recv is: %s \n", msg );
  51:	50                   	push   %eax
  52:	53                   	push   %ebx
  53:	68 0a 08 00 00       	push   $0x80a
  58:	6a 01                	push   $0x1
  5a:	e8 41 04 00 00       	call   4a0 <printf>

		exit();
  5f:	e8 9e 02 00 00       	call   302 <exit>
	}else{
		// This is parent
		char *msg_child = (char *)malloc(MSGSIZE);
  64:	83 ec 0c             	sub    $0xc,%esp
  67:	89 c3                	mov    %eax,%ebx
  69:	6a 08                	push   $0x8
  6b:	e8 90 06 00 00       	call   700 <malloc>
		msg_child = "P";
		send(getpid(),cid,msg_child);	
  70:	e8 0d 03 00 00       	call   382 <getpid>
  75:	83 c4 0c             	add    $0xc,%esp
  78:	68 25 08 00 00       	push   $0x825
  7d:	53                   	push   %ebx
  7e:	50                   	push   %eax
  7f:	e8 3e 03 00 00       	call   3c2 <send>
		printf(1,"1 PARENT: msg sent is: %s \n", msg_child );
  84:	83 c4 0c             	add    $0xc,%esp
  87:	68 25 08 00 00       	push   $0x825
  8c:	68 27 08 00 00       	push   $0x827
  91:	6a 01                	push   $0x1
  93:	e8 08 04 00 00       	call   4a0 <printf>
		
		free(msg_child);
  98:	c7 04 24 25 08 00 00 	movl   $0x825,(%esp)
  9f:	e8 cc 05 00 00       	call   670 <free>
	}
	wait();
  a4:	e8 61 02 00 00       	call   30a <wait>
	exit();
  a9:	e8 54 02 00 00       	call   302 <exit>
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ba:	89 c2                	mov    %eax,%edx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c0:	83 c1 01             	add    $0x1,%ecx
  c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  c7:	83 c2 01             	add    $0x1,%edx
  ca:	84 db                	test   %bl,%bl
  cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  cf:	75 ef                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  d1:	5b                   	pop    %ebx
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	0f b6 19             	movzbl (%ecx),%ebx
  f0:	84 c0                	test   %al,%al
  f2:	75 1c                	jne    110 <strcmp+0x30>
  f4:	eb 2a                	jmp    120 <strcmp+0x40>
  f6:	8d 76 00             	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 100:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 103:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 106:	83 c1 01             	add    $0x1,%ecx
 109:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 10c:	84 c0                	test   %al,%al
 10e:	74 10                	je     120 <strcmp+0x40>
 110:	38 d8                	cmp    %bl,%al
 112:	74 ec                	je     100 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 114:	29 d8                	sub    %ebx,%eax
}
 116:	5b                   	pop    %ebx
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 120:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 122:	29 d8                	sub    %ebx,%eax
}
 124:	5b                   	pop    %ebx
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strlen>:

uint
strlen(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 39 00             	cmpb   $0x0,(%ecx)
 139:	74 15                	je     150 <strlen+0x20>
 13b:	31 d2                	xor    %edx,%edx
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c2 01             	add    $0x1,%edx
 143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 147:	89 d0                	mov    %edx,%eax
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
 14d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 150:	31 c0                	xor    %eax,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    
 154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 15a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	89 d0                	mov    %edx,%eax
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	74 1d                	je     1ae <strchr+0x2e>
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	89 d9                	mov    %ebx,%ecx
 195:	75 0d                	jne    1a4 <strchr+0x24>
 197:	eb 17                	jmp    1b0 <strchr+0x30>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0c                	je     1b0 <strchr+0x30>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ae:	31 c0                	xor    %eax,%eax
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	31 f6                	xor    %esi,%esi
 1c8:	89 f3                	mov    %esi,%ebx
{
 1ca:	83 ec 1c             	sub    $0x1c,%esp
 1cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1d0:	eb 2f                	jmp    201 <gets+0x41>
 1d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1db:	83 ec 04             	sub    $0x4,%esp
 1de:	6a 01                	push   $0x1
 1e0:	50                   	push   %eax
 1e1:	6a 00                	push   $0x0
 1e3:	e8 32 01 00 00       	call   31a <read>
    if(cc < 1)
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	85 c0                	test   %eax,%eax
 1ed:	7e 1c                	jle    20b <gets+0x4b>
      break;
    buf[i++] = c;
 1ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f3:	83 c7 01             	add    $0x1,%edi
 1f6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1f9:	3c 0a                	cmp    $0xa,%al
 1fb:	74 23                	je     220 <gets+0x60>
 1fd:	3c 0d                	cmp    $0xd,%al
 1ff:	74 1f                	je     220 <gets+0x60>
  for(i=0; i+1 < max; ){
 201:	83 c3 01             	add    $0x1,%ebx
 204:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 207:	89 fe                	mov    %edi,%esi
 209:	7c cd                	jl     1d8 <gets+0x18>
 20b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 210:	c6 03 00             	movb   $0x0,(%ebx)
}
 213:	8d 65 f4             	lea    -0xc(%ebp),%esp
 216:	5b                   	pop    %ebx
 217:	5e                   	pop    %esi
 218:	5f                   	pop    %edi
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    
 21b:	90                   	nop
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	8b 75 08             	mov    0x8(%ebp),%esi
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	01 de                	add    %ebx,%esi
 228:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 22a:	c6 03 00             	movb   $0x0,(%ebx)
}
 22d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 230:	5b                   	pop    %ebx
 231:	5e                   	pop    %esi
 232:	5f                   	pop    %edi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    
 235:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 245:	83 ec 08             	sub    $0x8,%esp
 248:	6a 00                	push   $0x0
 24a:	ff 75 08             	pushl  0x8(%ebp)
 24d:	e8 f0 00 00 00       	call   342 <open>
  if(fd < 0)
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	78 27                	js     280 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	ff 75 0c             	pushl  0xc(%ebp)
 25f:	89 c3                	mov    %eax,%ebx
 261:	50                   	push   %eax
 262:	e8 f3 00 00 00       	call   35a <fstat>
  close(fd);
 267:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 26a:	89 c6                	mov    %eax,%esi
  close(fd);
 26c:	e8 b9 00 00 00       	call   32a <close>
  return r;
 271:	83 c4 10             	add    $0x10,%esp
}
 274:	8d 65 f8             	lea    -0x8(%ebp),%esp
 277:	89 f0                	mov    %esi,%eax
 279:	5b                   	pop    %ebx
 27a:	5e                   	pop    %esi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 280:	be ff ff ff ff       	mov    $0xffffffff,%esi
 285:	eb ed                	jmp    274 <stat+0x34>
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <atoi>:

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 11             	movsbl (%ecx),%edx
 29a:	8d 42 d0             	lea    -0x30(%edx),%eax
 29d:	3c 09                	cmp    $0x9,%al
  n = 0;
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2a4:	77 1f                	ja     2c5 <atoi+0x35>
 2a6:	8d 76 00             	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2b3:	83 c1 01             	add    $0x1,%ecx
 2b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2ba:	0f be 11             	movsbl (%ecx),%edx
 2bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2c0:	80 fb 09             	cmp    $0x9,%bl
 2c3:	76 eb                	jbe    2b0 <atoi+0x20>
  return n;
}
 2c5:	5b                   	pop    %ebx
 2c6:	5d                   	pop    %ebp
 2c7:	c3                   	ret    
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 db                	test   %ebx,%ebx
 2e0:	7e 14                	jle    2f6 <memmove+0x26>
 2e2:	31 d2                	xor    %edx,%edx
 2e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2f2:	39 d3                	cmp    %edx,%ebx
 2f4:	75 f2                	jne    2e8 <memmove+0x18>
  return vdst;
}
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    

000002fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <exit>:
SYSCALL(exit)
 302:	b8 02 00 00 00       	mov    $0x2,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <wait>:
SYSCALL(wait)
 30a:	b8 03 00 00 00       	mov    $0x3,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <pipe>:
SYSCALL(pipe)
 312:	b8 04 00 00 00       	mov    $0x4,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <read>:
SYSCALL(read)
 31a:	b8 05 00 00 00       	mov    $0x5,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <write>:
SYSCALL(write)
 322:	b8 10 00 00 00       	mov    $0x10,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <close>:
SYSCALL(close)
 32a:	b8 15 00 00 00       	mov    $0x15,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <kill>:
SYSCALL(kill)
 332:	b8 06 00 00 00       	mov    $0x6,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exec>:
SYSCALL(exec)
 33a:	b8 07 00 00 00       	mov    $0x7,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <open>:
SYSCALL(open)
 342:	b8 0f 00 00 00       	mov    $0xf,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mknod>:
SYSCALL(mknod)
 34a:	b8 11 00 00 00       	mov    $0x11,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <unlink>:
SYSCALL(unlink)
 352:	b8 12 00 00 00       	mov    $0x12,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <fstat>:
SYSCALL(fstat)
 35a:	b8 08 00 00 00       	mov    $0x8,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <link>:
SYSCALL(link)
 362:	b8 13 00 00 00       	mov    $0x13,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <mkdir>:
SYSCALL(mkdir)
 36a:	b8 14 00 00 00       	mov    $0x14,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <chdir>:
SYSCALL(chdir)
 372:	b8 09 00 00 00       	mov    $0x9,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <dup>:
SYSCALL(dup)
 37a:	b8 0a 00 00 00       	mov    $0xa,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getpid>:
SYSCALL(getpid)
 382:	b8 0b 00 00 00       	mov    $0xb,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sbrk>:
SYSCALL(sbrk)
 38a:	b8 0c 00 00 00       	mov    $0xc,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sleep>:
SYSCALL(sleep)
 392:	b8 0d 00 00 00       	mov    $0xd,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <uptime>:
SYSCALL(uptime)
 39a:	b8 0e 00 00 00       	mov    $0xe,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <print_count>:
SYSCALL(print_count)
 3a2:	b8 16 00 00 00       	mov    $0x16,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <toggle>:
SYSCALL(toggle)
 3aa:	b8 17 00 00 00       	mov    $0x17,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <add>:
SYSCALL(add)
 3b2:	b8 18 00 00 00       	mov    $0x18,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <ps>:
SYSCALL(ps)
 3ba:	b8 19 00 00 00       	mov    $0x19,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <send>:
SYSCALL(send)
 3c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <recv>:
SYSCALL(recv)
 3ca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <sig_set>:
SYSCALL(sig_set)
 3d2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sig_send>:
SYSCALL(sig_send)
 3da:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sig_pause>:
SYSCALL(sig_pause)
 3e2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <sig_ret>:
SYSCALL(sig_ret)
 3ea:	b8 20 00 00 00       	mov    $0x20,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <send_multi>:
 3f2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    
 3fa:	66 90                	xchg   %ax,%ax
 3fc:	66 90                	xchg   %ax,%ax
 3fe:	66 90                	xchg   %ax,%ax

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 409:	85 d2                	test   %edx,%edx
{
 40b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 40e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 410:	79 76                	jns    488 <printint+0x88>
 412:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 416:	74 70                	je     488 <printint+0x88>
    x = -xx;
 418:	f7 d8                	neg    %eax
    neg = 1;
 41a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 421:	31 f6                	xor    %esi,%esi
 423:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 426:	eb 0a                	jmp    432 <printint+0x32>
 428:	90                   	nop
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 430:	89 fe                	mov    %edi,%esi
 432:	31 d2                	xor    %edx,%edx
 434:	8d 7e 01             	lea    0x1(%esi),%edi
 437:	f7 f1                	div    %ecx
 439:	0f b6 92 4c 08 00 00 	movzbl 0x84c(%edx),%edx
  }while((x /= base) != 0);
 440:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 442:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 445:	75 e9                	jne    430 <printint+0x30>
  if(neg)
 447:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 44a:	85 c0                	test   %eax,%eax
 44c:	74 08                	je     456 <printint+0x56>
    buf[i++] = '-';
 44e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 453:	8d 7e 02             	lea    0x2(%esi),%edi
 456:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 45a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 463:	83 ec 04             	sub    $0x4,%esp
 466:	83 ee 01             	sub    $0x1,%esi
 469:	6a 01                	push   $0x1
 46b:	53                   	push   %ebx
 46c:	57                   	push   %edi
 46d:	88 45 d7             	mov    %al,-0x29(%ebp)
 470:	e8 ad fe ff ff       	call   322 <write>

  while(--i >= 0)
 475:	83 c4 10             	add    $0x10,%esp
 478:	39 de                	cmp    %ebx,%esi
 47a:	75 e4                	jne    460 <printint+0x60>
    putc(fd, buf[i]);
}
 47c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47f:	5b                   	pop    %ebx
 480:	5e                   	pop    %esi
 481:	5f                   	pop    %edi
 482:	5d                   	pop    %ebp
 483:	c3                   	ret    
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 488:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 48f:	eb 90                	jmp    421 <printint+0x21>
 491:	eb 0d                	jmp    4a0 <printf>
 493:	90                   	nop
 494:	90                   	nop
 495:	90                   	nop
 496:	90                   	nop
 497:	90                   	nop
 498:	90                   	nop
 499:	90                   	nop
 49a:	90                   	nop
 49b:	90                   	nop
 49c:	90                   	nop
 49d:	90                   	nop
 49e:	90                   	nop
 49f:	90                   	nop

000004a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 4ac:	0f b6 1e             	movzbl (%esi),%ebx
 4af:	84 db                	test   %bl,%bl
 4b1:	0f 84 b3 00 00 00    	je     56a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 4b7:	8d 45 10             	lea    0x10(%ebp),%eax
 4ba:	83 c6 01             	add    $0x1,%esi
  state = 0;
 4bd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 4bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c2:	eb 2f                	jmp    4f3 <printf+0x53>
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	0f 84 a7 00 00 00    	je     578 <printf+0xd8>
  write(fd, &c, 1);
 4d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d4:	83 ec 04             	sub    $0x4,%esp
 4d7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4da:	6a 01                	push   $0x1
 4dc:	50                   	push   %eax
 4dd:	ff 75 08             	pushl  0x8(%ebp)
 4e0:	e8 3d fe ff ff       	call   322 <write>
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4eb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4ef:	84 db                	test   %bl,%bl
 4f1:	74 77                	je     56a <printf+0xca>
    if(state == 0){
 4f3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4f5:	0f be cb             	movsbl %bl,%ecx
 4f8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4fb:	74 cb                	je     4c8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fd:	83 ff 25             	cmp    $0x25,%edi
 500:	75 e6                	jne    4e8 <printf+0x48>
      if(c == 'd'){
 502:	83 f8 64             	cmp    $0x64,%eax
 505:	0f 84 05 01 00 00    	je     610 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 50b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 511:	83 f9 70             	cmp    $0x70,%ecx
 514:	74 72                	je     588 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 516:	83 f8 73             	cmp    $0x73,%eax
 519:	0f 84 99 00 00 00    	je     5b8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51f:	83 f8 63             	cmp    $0x63,%eax
 522:	0f 84 08 01 00 00    	je     630 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	0f 84 ef 00 00 00    	je     620 <printf+0x180>
  write(fd, &c, 1);
 531:	8d 45 e7             	lea    -0x19(%ebp),%eax
 534:	83 ec 04             	sub    $0x4,%esp
 537:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 53b:	6a 01                	push   $0x1
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 dc fd ff ff       	call   322 <write>
 546:	83 c4 0c             	add    $0xc,%esp
 549:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 54c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 54f:	6a 01                	push   $0x1
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 558:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 55a:	e8 c3 fd ff ff       	call   322 <write>
  for(i = 0; fmt[i]; i++){
 55f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 563:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 566:	84 db                	test   %bl,%bl
 568:	75 89                	jne    4f3 <printf+0x53>
    }
  }
}
 56a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56d:	5b                   	pop    %ebx
 56e:	5e                   	pop    %esi
 56f:	5f                   	pop    %edi
 570:	5d                   	pop    %ebp
 571:	c3                   	ret    
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 578:	bf 25 00 00 00       	mov    $0x25,%edi
 57d:	e9 66 ff ff ff       	jmp    4e8 <printf+0x48>
 582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 588:	83 ec 0c             	sub    $0xc,%esp
 58b:	b9 10 00 00 00       	mov    $0x10,%ecx
 590:	6a 00                	push   $0x0
 592:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	8b 17                	mov    (%edi),%edx
 59a:	e8 61 fe ff ff       	call   400 <printint>
        ap++;
 59f:	89 f8                	mov    %edi,%eax
 5a1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a4:	31 ff                	xor    %edi,%edi
        ap++;
 5a6:	83 c0 04             	add    $0x4,%eax
 5a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5ac:	e9 37 ff ff ff       	jmp    4e8 <printf+0x48>
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5bb:	8b 08                	mov    (%eax),%ecx
        ap++;
 5bd:	83 c0 04             	add    $0x4,%eax
 5c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 5c3:	85 c9                	test   %ecx,%ecx
 5c5:	0f 84 8e 00 00 00    	je     659 <printf+0x1b9>
        while(*s != 0){
 5cb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 5ce:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 5d0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 5d2:	84 c0                	test   %al,%al
 5d4:	0f 84 0e ff ff ff    	je     4e8 <printf+0x48>
 5da:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5dd:	89 de                	mov    %ebx,%esi
 5df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5e8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5eb:	83 c6 01             	add    $0x1,%esi
 5ee:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5f1:	6a 01                	push   $0x1
 5f3:	57                   	push   %edi
 5f4:	53                   	push   %ebx
 5f5:	e8 28 fd ff ff       	call   322 <write>
        while(*s != 0){
 5fa:	0f b6 06             	movzbl (%esi),%eax
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	84 c0                	test   %al,%al
 602:	75 e4                	jne    5e8 <printf+0x148>
 604:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 607:	31 ff                	xor    %edi,%edi
 609:	e9 da fe ff ff       	jmp    4e8 <printf+0x48>
 60e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	6a 01                	push   $0x1
 61a:	e9 73 ff ff ff       	jmp    592 <printf+0xf2>
 61f:	90                   	nop
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 626:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 629:	6a 01                	push   $0x1
 62b:	e9 21 ff ff ff       	jmp    551 <printf+0xb1>
        putc(fd, *ap);
 630:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 633:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 636:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 638:	6a 01                	push   $0x1
        ap++;
 63a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 63d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 643:	50                   	push   %eax
 644:	ff 75 08             	pushl  0x8(%ebp)
 647:	e8 d6 fc ff ff       	call   322 <write>
        ap++;
 64c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 64f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 652:	31 ff                	xor    %edi,%edi
 654:	e9 8f fe ff ff       	jmp    4e8 <printf+0x48>
          s = "(null)";
 659:	bb 43 08 00 00       	mov    $0x843,%ebx
        while(*s != 0){
 65e:	b8 28 00 00 00       	mov    $0x28,%eax
 663:	e9 72 ff ff ff       	jmp    5da <printf+0x13a>
 668:	66 90                	xchg   %ax,%ax
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 f4 0a 00 00       	mov    0xaf4,%eax
{
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 67e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	39 c8                	cmp    %ecx,%eax
 68a:	8b 10                	mov    (%eax),%edx
 68c:	73 32                	jae    6c0 <free+0x50>
 68e:	39 d1                	cmp    %edx,%ecx
 690:	72 04                	jb     696 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	39 d0                	cmp    %edx,%eax
 694:	72 32                	jb     6c8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 696:	8b 73 fc             	mov    -0x4(%ebx),%esi
 699:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69c:	39 fa                	cmp    %edi,%edx
 69e:	74 30                	je     6d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a3:	8b 50 04             	mov    0x4(%eax),%edx
 6a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a9:	39 f1                	cmp    %esi,%ecx
 6ab:	74 3a                	je     6e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ad:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6af:	a3 f4 0a 00 00       	mov    %eax,0xaf4
}
 6b4:	5b                   	pop    %ebx
 6b5:	5e                   	pop    %esi
 6b6:	5f                   	pop    %edi
 6b7:	5d                   	pop    %ebp
 6b8:	c3                   	ret    
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	39 d0                	cmp    %edx,%eax
 6c2:	72 04                	jb     6c8 <free+0x58>
 6c4:	39 d1                	cmp    %edx,%ecx
 6c6:	72 ce                	jb     696 <free+0x26>
{
 6c8:	89 d0                	mov    %edx,%eax
 6ca:	eb bc                	jmp    688 <free+0x18>
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6d0:	03 72 04             	add    0x4(%edx),%esi
 6d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d6:	8b 10                	mov    (%eax),%edx
 6d8:	8b 12                	mov    (%edx),%edx
 6da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6e3:	39 f1                	cmp    %esi,%ecx
 6e5:	75 c6                	jne    6ad <free+0x3d>
    p->s.size += bp->s.size;
 6e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ea:	a3 f4 0a 00 00       	mov    %eax,0xaf4
    p->s.size += bp->s.size;
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6f5:	89 10                	mov    %edx,(%eax)
}
 6f7:	5b                   	pop    %ebx
 6f8:	5e                   	pop    %esi
 6f9:	5f                   	pop    %edi
 6fa:	5d                   	pop    %ebp
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 70c:	8b 15 f4 0a 00 00    	mov    0xaf4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	8d 78 07             	lea    0x7(%eax),%edi
 715:	c1 ef 03             	shr    $0x3,%edi
 718:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 71b:	85 d2                	test   %edx,%edx
 71d:	0f 84 9d 00 00 00    	je     7c0 <malloc+0xc0>
 723:	8b 02                	mov    (%edx),%eax
 725:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 728:	39 cf                	cmp    %ecx,%edi
 72a:	76 6c                	jbe    798 <malloc+0x98>
 72c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 732:	bb 00 10 00 00       	mov    $0x1000,%ebx
 737:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 73a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 741:	eb 0e                	jmp    751 <malloc+0x51>
 743:	90                   	nop
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 748:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 74a:	8b 48 04             	mov    0x4(%eax),%ecx
 74d:	39 f9                	cmp    %edi,%ecx
 74f:	73 47                	jae    798 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 751:	39 05 f4 0a 00 00    	cmp    %eax,0xaf4
 757:	89 c2                	mov    %eax,%edx
 759:	75 ed                	jne    748 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 75b:	83 ec 0c             	sub    $0xc,%esp
 75e:	56                   	push   %esi
 75f:	e8 26 fc ff ff       	call   38a <sbrk>
  if(p == (char*)-1)
 764:	83 c4 10             	add    $0x10,%esp
 767:	83 f8 ff             	cmp    $0xffffffff,%eax
 76a:	74 1c                	je     788 <malloc+0x88>
  hp->s.size = nu;
 76c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	83 c0 08             	add    $0x8,%eax
 775:	50                   	push   %eax
 776:	e8 f5 fe ff ff       	call   670 <free>
  return freep;
 77b:	8b 15 f4 0a 00 00    	mov    0xaf4,%edx
      if((p = morecore(nunits)) == 0)
 781:	83 c4 10             	add    $0x10,%esp
 784:	85 d2                	test   %edx,%edx
 786:	75 c0                	jne    748 <malloc+0x48>
        return 0;
  }
}
 788:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 78b:	31 c0                	xor    %eax,%eax
}
 78d:	5b                   	pop    %ebx
 78e:	5e                   	pop    %esi
 78f:	5f                   	pop    %edi
 790:	5d                   	pop    %ebp
 791:	c3                   	ret    
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 798:	39 cf                	cmp    %ecx,%edi
 79a:	74 54                	je     7f0 <malloc+0xf0>
        p->s.size -= nunits;
 79c:	29 f9                	sub    %edi,%ecx
 79e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7a1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7a4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7a7:	89 15 f4 0a 00 00    	mov    %edx,0xaf4
}
 7ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7b0:	83 c0 08             	add    $0x8,%eax
}
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret    
 7b8:	90                   	nop
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 7c0:	c7 05 f4 0a 00 00 f8 	movl   $0xaf8,0xaf4
 7c7:	0a 00 00 
 7ca:	c7 05 f8 0a 00 00 f8 	movl   $0xaf8,0xaf8
 7d1:	0a 00 00 
    base.s.size = 0;
 7d4:	b8 f8 0a 00 00       	mov    $0xaf8,%eax
 7d9:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 7e0:	00 00 00 
 7e3:	e9 44 ff ff ff       	jmp    72c <malloc+0x2c>
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7f0:	8b 08                	mov    (%eax),%ecx
 7f2:	89 0a                	mov    %ecx,(%edx)
 7f4:	eb b1                	jmp    7a7 <malloc+0xa7>
