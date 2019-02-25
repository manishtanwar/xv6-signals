
_user_signal_checker:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	fun_called[child_no] = 1;
	// printf(1, "Child %dth : %s\n",child_no,b);
}

int main(void)
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
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while(sig_set(0,&fun1) < 0);
  18:	83 ec 08             	sub    $0x8,%esp
  1b:	68 50 01 00 00       	push   $0x150
  20:	6a 00                	push   $0x0
  22:	e8 6b 04 00 00       	call   492 <sig_set>
  27:	83 c4 10             	add    $0x10,%esp
  2a:	85 c0                	test   %eax,%eax
  2c:	78 ea                	js     18 <main+0x18>
  2e:	66 90                	xchg   %ax,%ax
	while(sig_set(1,&fun) < 0);
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 30 01 00 00       	push   $0x130
  38:	6a 01                	push   $0x1
  3a:	e8 53 04 00 00       	call   492 <sig_set>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	85 c0                	test   %eax,%eax
  44:	78 ea                	js     30 <main+0x30>
  46:	bb 40 0c 00 00       	mov    $0xc40,%ebx
  4b:	89 d8                	mov    %ebx,%eax
  4d:	8d 76 00             	lea    0x0(%esi),%esi

	int i;
	int n = 15;
	for(i=0;i<n;i++)
		cid[i] = -1;
  50:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  56:	83 c0 04             	add    $0x4,%eax
	for(i=0;i<n;i++)
  59:	3d 7c 0c 00 00       	cmp    $0xc7c,%eax
  5e:	75 f0                	jne    50 <main+0x50>

	for(i=0;i<n;i++){
  60:	31 f6                	xor    %esi,%esi
  62:	eb 0c                	jmp    70 <main+0x70>
  64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  68:	83 c6 01             	add    $0x1,%esi
  6b:	83 fe 0f             	cmp    $0xf,%esi
  6e:	74 10                	je     80 <main+0x80>
		cid[i] = fork();
  70:	e8 45 03 00 00       	call   3ba <fork>
		if(cid[i] == 0) break;
  75:	85 c0                	test   %eax,%eax
		cid[i] = fork();
  77:	89 04 b5 40 0c 00 00 	mov    %eax,0xc40(,%esi,4)
		if(cid[i] == 0) break;
  7e:	75 e8                	jne    68 <main+0x68>
	}

	if(cid[n-1] <= 0){
  80:	8b 0d 78 0c 00 00    	mov    0xc78,%ecx
  86:	85 c9                	test   %ecx,%ecx
  88:	7e 77                	jle    101 <main+0x101>
		child_no = i;
		if(fun_called[i] == 0) sig_pause();
		printf(1,"%d\n",i+1);
		exit();
	}else{
  8a:	89 e6                	mov    %esp,%esi
		// This is parent

		// char *msg = "HeyGuys";
		// send_multi(getpid(), cid, msg, n);

		int a[n][2];
  8c:	83 c4 80             	add    $0xffffff80,%esp
		for(i=0;i<n;i++)
  8f:	31 c0                	xor    %eax,%eax
		int a[n][2];
  91:	89 e7                	mov    %esp,%edi
  93:	90                   	nop
  94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			a[i][0] = i+1, a[i][1] = -(i+1);
  98:	83 c0 01             	add    $0x1,%eax
  9b:	89 c2                	mov    %eax,%edx
  9d:	89 44 c7 f8          	mov    %eax,-0x8(%edi,%eax,8)
  a1:	f7 da                	neg    %edx
		for(i=0;i<n;i++)
  a3:	83 f8 0f             	cmp    $0xf,%eax
			a[i][0] = i+1, a[i][1] = -(i+1);
  a6:	89 54 c7 fc          	mov    %edx,-0x4(%edi,%eax,8)
		for(i=0;i<n;i++)
  aa:	75 ec                	jne    98 <main+0x98>
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

		for(i=0;i<n;i++){
			char *msg_child;
			msg_child = (char *)a[i];

			sig_send(cid[i], 1, (void *)msg_child);
  b0:	83 ec 04             	sub    $0x4,%esp
  b3:	83 c3 04             	add    $0x4,%ebx
  b6:	57                   	push   %edi
  b7:	6a 01                	push   $0x1
  b9:	ff 73 fc             	pushl  -0x4(%ebx)
  bc:	e8 d9 03 00 00       	call   49a <sig_send>
			free(msg_child);
  c1:	89 3c 24             	mov    %edi,(%esp)
  c4:	83 c7 08             	add    $0x8,%edi
  c7:	e8 64 06 00 00       	call   730 <free>
		for(i=0;i<n;i++){
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	81 fb 7c 0c 00 00    	cmp    $0xc7c,%ebx
  d5:	75 d9                	jne    b0 <main+0xb0>
			// sleep(20);
		}

		printf(1, "Parent\n");
  d7:	50                   	push   %eax
  d8:	50                   	push   %eax
  d9:	bb 0f 00 00 00       	mov    $0xf,%ebx
  de:	68 bc 08 00 00       	push   $0x8bc
  e3:	6a 01                	push   $0x1
  e5:	e8 76 04 00 00       	call   560 <printf>
  ea:	83 c4 10             	add    $0x10,%esp
  ed:	8d 76 00             	lea    0x0(%esi),%esi
		for(i=0;i<n;i++)
			wait();
  f0:	e8 d5 02 00 00       	call   3ca <wait>
		for(i=0;i<n;i++)
  f5:	83 eb 01             	sub    $0x1,%ebx
  f8:	75 f6                	jne    f0 <main+0xf0>
  fa:	89 f4                	mov    %esi,%esp
	}
	
	exit();
  fc:	e8 c1 02 00 00       	call   3c2 <exit>
		if(fun_called[i] == 0) sig_pause();
 101:	83 3c b5 00 0c 00 00 	cmpl   $0x0,0xc00(,%esi,4)
 108:	00 
		child_no = i;
 109:	89 35 e0 0b 00 00    	mov    %esi,0xbe0
		if(fun_called[i] == 0) sig_pause();
 10f:	74 16                	je     127 <main+0x127>
		printf(1,"%d\n",i+1);
 111:	83 c6 01             	add    $0x1,%esi
 114:	52                   	push   %edx
 115:	56                   	push   %esi
 116:	68 b8 08 00 00       	push   $0x8b8
 11b:	6a 01                	push   $0x1
 11d:	e8 3e 04 00 00       	call   560 <printf>
		exit();
 122:	e8 9b 02 00 00       	call   3c2 <exit>
		if(fun_called[i] == 0) sig_pause();
 127:	e8 76 03 00 00       	call   4a2 <sig_pause>
 12c:	eb e3                	jmp    111 <main+0x111>
 12e:	66 90                	xchg   %ax,%ax

00000130 <fun>:
	fun_called[child_no] = 1;
 130:	a1 e0 0b 00 00       	mov    0xbe0,%eax
void fun(void *a){
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
	fun_called[child_no] = 1;
 138:	c7 04 85 00 0c 00 00 	movl   $0x1,0xc00(,%eax,4)
 13f:	01 00 00 00 
}
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <fun1>:
 150:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
 158:	c7 04 85 00 0c 00 00 	movl   $0x1,0xc00(,%eax,4)
 15f:	01 00 00 00 
 163:	5d                   	pop    %ebp
 164:	c3                   	ret    
 165:	66 90                	xchg   %ax,%ax
 167:	66 90                	xchg   %ax,%ax
 169:	66 90                	xchg   %ax,%ax
 16b:	66 90                	xchg   %ax,%ax
 16d:	66 90                	xchg   %ax,%ax
 16f:	90                   	nop

00000170 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17a:	89 c2                	mov    %eax,%edx
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 180:	83 c1 01             	add    $0x1,%ecx
 183:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 187:	83 c2 01             	add    $0x1,%edx
 18a:	84 db                	test   %bl,%bl
 18c:	88 5a ff             	mov    %bl,-0x1(%edx)
 18f:	75 ef                	jne    180 <strcpy+0x10>
    ;
  return os;
}
 191:	5b                   	pop    %ebx
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
 194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 19a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
 1a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1aa:	0f b6 02             	movzbl (%edx),%eax
 1ad:	0f b6 19             	movzbl (%ecx),%ebx
 1b0:	84 c0                	test   %al,%al
 1b2:	75 1c                	jne    1d0 <strcmp+0x30>
 1b4:	eb 2a                	jmp    1e0 <strcmp+0x40>
 1b6:	8d 76 00             	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1c6:	83 c1 01             	add    $0x1,%ecx
 1c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 1cc:	84 c0                	test   %al,%al
 1ce:	74 10                	je     1e0 <strcmp+0x40>
 1d0:	38 d8                	cmp    %bl,%al
 1d2:	74 ec                	je     1c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1d4:	29 d8                	sub    %ebx,%eax
}
 1d6:	5b                   	pop    %ebx
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1e2:	29 d8                	sub    %ebx,%eax
}
 1e4:	5b                   	pop    %ebx
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <strlen>:

uint
strlen(const char *s)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1f6:	80 39 00             	cmpb   $0x0,(%ecx)
 1f9:	74 15                	je     210 <strlen+0x20>
 1fb:	31 d2                	xor    %edx,%edx
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	83 c2 01             	add    $0x1,%edx
 203:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 207:	89 d0                	mov    %edx,%eax
 209:	75 f5                	jne    200 <strlen+0x10>
    ;
  return n;
}
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    
 20d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 210:	31 c0                	xor    %eax,%eax
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 21a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 227:	8b 4d 10             	mov    0x10(%ebp),%ecx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 d7                	mov    %edx,%edi
 22f:	fc                   	cld    
 230:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 232:	89 d0                	mov    %edx,%eax
 234:	5f                   	pop    %edi
 235:	5d                   	pop    %ebp
 236:	c3                   	ret    
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <strchr>:

char*
strchr(const char *s, char c)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 24a:	0f b6 10             	movzbl (%eax),%edx
 24d:	84 d2                	test   %dl,%dl
 24f:	74 1d                	je     26e <strchr+0x2e>
    if(*s == c)
 251:	38 d3                	cmp    %dl,%bl
 253:	89 d9                	mov    %ebx,%ecx
 255:	75 0d                	jne    264 <strchr+0x24>
 257:	eb 17                	jmp    270 <strchr+0x30>
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 260:	38 ca                	cmp    %cl,%dl
 262:	74 0c                	je     270 <strchr+0x30>
  for(; *s; s++)
 264:	83 c0 01             	add    $0x1,%eax
 267:	0f b6 10             	movzbl (%eax),%edx
 26a:	84 d2                	test   %dl,%dl
 26c:	75 f2                	jne    260 <strchr+0x20>
      return (char*)s;
  return 0;
 26e:	31 c0                	xor    %eax,%eax
}
 270:	5b                   	pop    %ebx
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    
 273:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <gets>:

char*
gets(char *buf, int max)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	56                   	push   %esi
 285:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 286:	31 f6                	xor    %esi,%esi
 288:	89 f3                	mov    %esi,%ebx
{
 28a:	83 ec 1c             	sub    $0x1c,%esp
 28d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 290:	eb 2f                	jmp    2c1 <gets+0x41>
 292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 298:	8d 45 e7             	lea    -0x19(%ebp),%eax
 29b:	83 ec 04             	sub    $0x4,%esp
 29e:	6a 01                	push   $0x1
 2a0:	50                   	push   %eax
 2a1:	6a 00                	push   $0x0
 2a3:	e8 32 01 00 00       	call   3da <read>
    if(cc < 1)
 2a8:	83 c4 10             	add    $0x10,%esp
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7e 1c                	jle    2cb <gets+0x4b>
      break;
    buf[i++] = c;
 2af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2b3:	83 c7 01             	add    $0x1,%edi
 2b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2b9:	3c 0a                	cmp    $0xa,%al
 2bb:	74 23                	je     2e0 <gets+0x60>
 2bd:	3c 0d                	cmp    $0xd,%al
 2bf:	74 1f                	je     2e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 2c1:	83 c3 01             	add    $0x1,%ebx
 2c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2c7:	89 fe                	mov    %edi,%esi
 2c9:	7c cd                	jl     298 <gets+0x18>
 2cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e0:	8b 75 08             	mov    0x8(%ebp),%esi
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	01 de                	add    %ebx,%esi
 2e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 2ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f0:	5b                   	pop    %ebx
 2f1:	5e                   	pop    %esi
 2f2:	5f                   	pop    %edi
 2f3:	5d                   	pop    %ebp
 2f4:	c3                   	ret    
 2f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <stat>:

int
stat(const char *n, struct stat *st)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	56                   	push   %esi
 304:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 305:	83 ec 08             	sub    $0x8,%esp
 308:	6a 00                	push   $0x0
 30a:	ff 75 08             	pushl  0x8(%ebp)
 30d:	e8 f0 00 00 00       	call   402 <open>
  if(fd < 0)
 312:	83 c4 10             	add    $0x10,%esp
 315:	85 c0                	test   %eax,%eax
 317:	78 27                	js     340 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 319:	83 ec 08             	sub    $0x8,%esp
 31c:	ff 75 0c             	pushl  0xc(%ebp)
 31f:	89 c3                	mov    %eax,%ebx
 321:	50                   	push   %eax
 322:	e8 f3 00 00 00       	call   41a <fstat>
  close(fd);
 327:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 32a:	89 c6                	mov    %eax,%esi
  close(fd);
 32c:	e8 b9 00 00 00       	call   3ea <close>
  return r;
 331:	83 c4 10             	add    $0x10,%esp
}
 334:	8d 65 f8             	lea    -0x8(%ebp),%esp
 337:	89 f0                	mov    %esi,%eax
 339:	5b                   	pop    %ebx
 33a:	5e                   	pop    %esi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 340:	be ff ff ff ff       	mov    $0xffffffff,%esi
 345:	eb ed                	jmp    334 <stat+0x34>
 347:	89 f6                	mov    %esi,%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <atoi>:

int
atoi(const char *s)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 357:	0f be 11             	movsbl (%ecx),%edx
 35a:	8d 42 d0             	lea    -0x30(%edx),%eax
 35d:	3c 09                	cmp    $0x9,%al
  n = 0;
 35f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 364:	77 1f                	ja     385 <atoi+0x35>
 366:	8d 76 00             	lea    0x0(%esi),%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 370:	8d 04 80             	lea    (%eax,%eax,4),%eax
 373:	83 c1 01             	add    $0x1,%ecx
 376:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 37a:	0f be 11             	movsbl (%ecx),%edx
 37d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 380:	80 fb 09             	cmp    $0x9,%bl
 383:	76 eb                	jbe    370 <atoi+0x20>
  return n;
}
 385:	5b                   	pop    %ebx
 386:	5d                   	pop    %ebp
 387:	c3                   	ret    
 388:	90                   	nop
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
 395:	8b 5d 10             	mov    0x10(%ebp),%ebx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39e:	85 db                	test   %ebx,%ebx
 3a0:	7e 14                	jle    3b6 <memmove+0x26>
 3a2:	31 d2                	xor    %edx,%edx
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3b2:	39 d3                	cmp    %edx,%ebx
 3b4:	75 f2                	jne    3a8 <memmove+0x18>
  return vdst;
}
 3b6:	5b                   	pop    %ebx
 3b7:	5e                   	pop    %esi
 3b8:	5d                   	pop    %ebp
 3b9:	c3                   	ret    

000003ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ba:	b8 01 00 00 00       	mov    $0x1,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <exit>:
SYSCALL(exit)
 3c2:	b8 02 00 00 00       	mov    $0x2,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <wait>:
SYSCALL(wait)
 3ca:	b8 03 00 00 00       	mov    $0x3,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <pipe>:
SYSCALL(pipe)
 3d2:	b8 04 00 00 00       	mov    $0x4,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <read>:
SYSCALL(read)
 3da:	b8 05 00 00 00       	mov    $0x5,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <write>:
SYSCALL(write)
 3e2:	b8 10 00 00 00       	mov    $0x10,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <close>:
SYSCALL(close)
 3ea:	b8 15 00 00 00       	mov    $0x15,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <kill>:
SYSCALL(kill)
 3f2:	b8 06 00 00 00       	mov    $0x6,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <exec>:
SYSCALL(exec)
 3fa:	b8 07 00 00 00       	mov    $0x7,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <open>:
SYSCALL(open)
 402:	b8 0f 00 00 00       	mov    $0xf,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <mknod>:
SYSCALL(mknod)
 40a:	b8 11 00 00 00       	mov    $0x11,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <unlink>:
SYSCALL(unlink)
 412:	b8 12 00 00 00       	mov    $0x12,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <fstat>:
SYSCALL(fstat)
 41a:	b8 08 00 00 00       	mov    $0x8,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <link>:
SYSCALL(link)
 422:	b8 13 00 00 00       	mov    $0x13,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <mkdir>:
SYSCALL(mkdir)
 42a:	b8 14 00 00 00       	mov    $0x14,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <chdir>:
SYSCALL(chdir)
 432:	b8 09 00 00 00       	mov    $0x9,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <dup>:
SYSCALL(dup)
 43a:	b8 0a 00 00 00       	mov    $0xa,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <getpid>:
SYSCALL(getpid)
 442:	b8 0b 00 00 00       	mov    $0xb,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <sbrk>:
SYSCALL(sbrk)
 44a:	b8 0c 00 00 00       	mov    $0xc,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <sleep>:
SYSCALL(sleep)
 452:	b8 0d 00 00 00       	mov    $0xd,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <uptime>:
SYSCALL(uptime)
 45a:	b8 0e 00 00 00       	mov    $0xe,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <print_count>:
SYSCALL(print_count)
 462:	b8 16 00 00 00       	mov    $0x16,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <toggle>:
SYSCALL(toggle)
 46a:	b8 17 00 00 00       	mov    $0x17,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <add>:
SYSCALL(add)
 472:	b8 18 00 00 00       	mov    $0x18,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <ps>:
SYSCALL(ps)
 47a:	b8 19 00 00 00       	mov    $0x19,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <send>:
SYSCALL(send)
 482:	b8 1a 00 00 00       	mov    $0x1a,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <recv>:
SYSCALL(recv)
 48a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <sig_set>:
SYSCALL(sig_set)
 492:	b8 1c 00 00 00       	mov    $0x1c,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <sig_send>:
SYSCALL(sig_send)
 49a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <sig_pause>:
SYSCALL(sig_pause)
 4a2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <sig_ret>:
SYSCALL(sig_ret)
 4aa:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <send_multi>:
 4b2:	b8 20 00 00 00       	mov    $0x20,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    
 4ba:	66 90                	xchg   %ax,%ax
 4bc:	66 90                	xchg   %ax,%ax
 4be:	66 90                	xchg   %ax,%ax

000004c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c9:	85 d2                	test   %edx,%edx
{
 4cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 4ce:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 4d0:	79 76                	jns    548 <printint+0x88>
 4d2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4d6:	74 70                	je     548 <printint+0x88>
    x = -xx;
 4d8:	f7 d8                	neg    %eax
    neg = 1;
 4da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4e1:	31 f6                	xor    %esi,%esi
 4e3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4e6:	eb 0a                	jmp    4f2 <printint+0x32>
 4e8:	90                   	nop
 4e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 4f0:	89 fe                	mov    %edi,%esi
 4f2:	31 d2                	xor    %edx,%edx
 4f4:	8d 7e 01             	lea    0x1(%esi),%edi
 4f7:	f7 f1                	div    %ecx
 4f9:	0f b6 92 cc 08 00 00 	movzbl 0x8cc(%edx),%edx
  }while((x /= base) != 0);
 500:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 502:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 505:	75 e9                	jne    4f0 <printint+0x30>
  if(neg)
 507:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 50a:	85 c0                	test   %eax,%eax
 50c:	74 08                	je     516 <printint+0x56>
    buf[i++] = '-';
 50e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 513:	8d 7e 02             	lea    0x2(%esi),%edi
 516:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 51a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 51d:	8d 76 00             	lea    0x0(%esi),%esi
 520:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 523:	83 ec 04             	sub    $0x4,%esp
 526:	83 ee 01             	sub    $0x1,%esi
 529:	6a 01                	push   $0x1
 52b:	53                   	push   %ebx
 52c:	57                   	push   %edi
 52d:	88 45 d7             	mov    %al,-0x29(%ebp)
 530:	e8 ad fe ff ff       	call   3e2 <write>

  while(--i >= 0)
 535:	83 c4 10             	add    $0x10,%esp
 538:	39 de                	cmp    %ebx,%esi
 53a:	75 e4                	jne    520 <printint+0x60>
    putc(fd, buf[i]);
}
 53c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5f                   	pop    %edi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 548:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 54f:	eb 90                	jmp    4e1 <printint+0x21>
 551:	eb 0d                	jmp    560 <printf>
 553:	90                   	nop
 554:	90                   	nop
 555:	90                   	nop
 556:	90                   	nop
 557:	90                   	nop
 558:	90                   	nop
 559:	90                   	nop
 55a:	90                   	nop
 55b:	90                   	nop
 55c:	90                   	nop
 55d:	90                   	nop
 55e:	90                   	nop
 55f:	90                   	nop

00000560 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 569:	8b 75 0c             	mov    0xc(%ebp),%esi
 56c:	0f b6 1e             	movzbl (%esi),%ebx
 56f:	84 db                	test   %bl,%bl
 571:	0f 84 b3 00 00 00    	je     62a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 577:	8d 45 10             	lea    0x10(%ebp),%eax
 57a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 57d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 57f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 582:	eb 2f                	jmp    5b3 <printf+0x53>
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 588:	83 f8 25             	cmp    $0x25,%eax
 58b:	0f 84 a7 00 00 00    	je     638 <printf+0xd8>
  write(fd, &c, 1);
 591:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 594:	83 ec 04             	sub    $0x4,%esp
 597:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 59a:	6a 01                	push   $0x1
 59c:	50                   	push   %eax
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 3d fe ff ff       	call   3e2 <write>
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 5ab:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5af:	84 db                	test   %bl,%bl
 5b1:	74 77                	je     62a <printf+0xca>
    if(state == 0){
 5b3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 5b5:	0f be cb             	movsbl %bl,%ecx
 5b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5bb:	74 cb                	je     588 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5bd:	83 ff 25             	cmp    $0x25,%edi
 5c0:	75 e6                	jne    5a8 <printf+0x48>
      if(c == 'd'){
 5c2:	83 f8 64             	cmp    $0x64,%eax
 5c5:	0f 84 05 01 00 00    	je     6d0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5cb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5d1:	83 f9 70             	cmp    $0x70,%ecx
 5d4:	74 72                	je     648 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5d6:	83 f8 73             	cmp    $0x73,%eax
 5d9:	0f 84 99 00 00 00    	je     678 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5df:	83 f8 63             	cmp    $0x63,%eax
 5e2:	0f 84 08 01 00 00    	je     6f0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	0f 84 ef 00 00 00    	je     6e0 <printf+0x180>
  write(fd, &c, 1);
 5f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5f4:	83 ec 04             	sub    $0x4,%esp
 5f7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5fb:	6a 01                	push   $0x1
 5fd:	50                   	push   %eax
 5fe:	ff 75 08             	pushl  0x8(%ebp)
 601:	e8 dc fd ff ff       	call   3e2 <write>
 606:	83 c4 0c             	add    $0xc,%esp
 609:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 60c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 60f:	6a 01                	push   $0x1
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 618:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 61a:	e8 c3 fd ff ff       	call   3e2 <write>
  for(i = 0; fmt[i]; i++){
 61f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 623:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 626:	84 db                	test   %bl,%bl
 628:	75 89                	jne    5b3 <printf+0x53>
    }
  }
}
 62a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62d:	5b                   	pop    %ebx
 62e:	5e                   	pop    %esi
 62f:	5f                   	pop    %edi
 630:	5d                   	pop    %ebp
 631:	c3                   	ret    
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 638:	bf 25 00 00 00       	mov    $0x25,%edi
 63d:	e9 66 ff ff ff       	jmp    5a8 <printf+0x48>
 642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 648:	83 ec 0c             	sub    $0xc,%esp
 64b:	b9 10 00 00 00       	mov    $0x10,%ecx
 650:	6a 00                	push   $0x0
 652:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	8b 17                	mov    (%edi),%edx
 65a:	e8 61 fe ff ff       	call   4c0 <printint>
        ap++;
 65f:	89 f8                	mov    %edi,%eax
 661:	83 c4 10             	add    $0x10,%esp
      state = 0;
 664:	31 ff                	xor    %edi,%edi
        ap++;
 666:	83 c0 04             	add    $0x4,%eax
 669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 66c:	e9 37 ff ff ff       	jmp    5a8 <printf+0x48>
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 67b:	8b 08                	mov    (%eax),%ecx
        ap++;
 67d:	83 c0 04             	add    $0x4,%eax
 680:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 683:	85 c9                	test   %ecx,%ecx
 685:	0f 84 8e 00 00 00    	je     719 <printf+0x1b9>
        while(*s != 0){
 68b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 68e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 690:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 692:	84 c0                	test   %al,%al
 694:	0f 84 0e ff ff ff    	je     5a8 <printf+0x48>
 69a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 69d:	89 de                	mov    %ebx,%esi
 69f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6a5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6a8:	83 ec 04             	sub    $0x4,%esp
          s++;
 6ab:	83 c6 01             	add    $0x1,%esi
 6ae:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 6b1:	6a 01                	push   $0x1
 6b3:	57                   	push   %edi
 6b4:	53                   	push   %ebx
 6b5:	e8 28 fd ff ff       	call   3e2 <write>
        while(*s != 0){
 6ba:	0f b6 06             	movzbl (%esi),%eax
 6bd:	83 c4 10             	add    $0x10,%esp
 6c0:	84 c0                	test   %al,%al
 6c2:	75 e4                	jne    6a8 <printf+0x148>
 6c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6c7:	31 ff                	xor    %edi,%edi
 6c9:	e9 da fe ff ff       	jmp    5a8 <printf+0x48>
 6ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d8:	6a 01                	push   $0x1
 6da:	e9 73 ff ff ff       	jmp    652 <printf+0xf2>
 6df:	90                   	nop
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6e9:	6a 01                	push   $0x1
 6eb:	e9 21 ff ff ff       	jmp    611 <printf+0xb1>
        putc(fd, *ap);
 6f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 6f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6f6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 6f8:	6a 01                	push   $0x1
        ap++;
 6fa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 6fd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 703:	50                   	push   %eax
 704:	ff 75 08             	pushl  0x8(%ebp)
 707:	e8 d6 fc ff ff       	call   3e2 <write>
        ap++;
 70c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 70f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 712:	31 ff                	xor    %edi,%edi
 714:	e9 8f fe ff ff       	jmp    5a8 <printf+0x48>
          s = "(null)";
 719:	bb c4 08 00 00       	mov    $0x8c4,%ebx
        while(*s != 0){
 71e:	b8 28 00 00 00       	mov    $0x28,%eax
 723:	e9 72 ff ff ff       	jmp    69a <printf+0x13a>
 728:	66 90                	xchg   %ax,%ax
 72a:	66 90                	xchg   %ax,%ax
 72c:	66 90                	xchg   %ax,%ax
 72e:	66 90                	xchg   %ax,%ax

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 c0 0b 00 00       	mov    0xbc0,%eax
{
 736:	89 e5                	mov    %esp,%ebp
 738:	57                   	push   %edi
 739:	56                   	push   %esi
 73a:	53                   	push   %ebx
 73b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 73e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	39 c8                	cmp    %ecx,%eax
 74a:	8b 10                	mov    (%eax),%edx
 74c:	73 32                	jae    780 <free+0x50>
 74e:	39 d1                	cmp    %edx,%ecx
 750:	72 04                	jb     756 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	39 d0                	cmp    %edx,%eax
 754:	72 32                	jb     788 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 756:	8b 73 fc             	mov    -0x4(%ebx),%esi
 759:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75c:	39 fa                	cmp    %edi,%edx
 75e:	74 30                	je     790 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 760:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 763:	8b 50 04             	mov    0x4(%eax),%edx
 766:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 769:	39 f1                	cmp    %esi,%ecx
 76b:	74 3a                	je     7a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 76d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 76f:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 774:	5b                   	pop    %ebx
 775:	5e                   	pop    %esi
 776:	5f                   	pop    %edi
 777:	5d                   	pop    %ebp
 778:	c3                   	ret    
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 d0                	cmp    %edx,%eax
 782:	72 04                	jb     788 <free+0x58>
 784:	39 d1                	cmp    %edx,%ecx
 786:	72 ce                	jb     756 <free+0x26>
{
 788:	89 d0                	mov    %edx,%eax
 78a:	eb bc                	jmp    748 <free+0x18>
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 790:	03 72 04             	add    0x4(%edx),%esi
 793:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 12                	mov    (%edx),%edx
 79a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a3:	39 f1                	cmp    %esi,%ecx
 7a5:	75 c6                	jne    76d <free+0x3d>
    p->s.size += bp->s.size;
 7a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7aa:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    p->s.size += bp->s.size;
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7b5:	89 10                	mov    %edx,(%eax)
}
 7b7:	5b                   	pop    %ebx
 7b8:	5e                   	pop    %esi
 7b9:	5f                   	pop    %edi
 7ba:	5d                   	pop    %ebp
 7bb:	c3                   	ret    
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7cc:	8b 15 c0 0b 00 00    	mov    0xbc0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8d 78 07             	lea    0x7(%eax),%edi
 7d5:	c1 ef 03             	shr    $0x3,%edi
 7d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7db:	85 d2                	test   %edx,%edx
 7dd:	0f 84 9d 00 00 00    	je     880 <malloc+0xc0>
 7e3:	8b 02                	mov    (%edx),%eax
 7e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7e8:	39 cf                	cmp    %ecx,%edi
 7ea:	76 6c                	jbe    858 <malloc+0x98>
 7ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7f7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7fa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 801:	eb 0e                	jmp    811 <malloc+0x51>
 803:	90                   	nop
 804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 80a:	8b 48 04             	mov    0x4(%eax),%ecx
 80d:	39 f9                	cmp    %edi,%ecx
 80f:	73 47                	jae    858 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 811:	39 05 c0 0b 00 00    	cmp    %eax,0xbc0
 817:	89 c2                	mov    %eax,%edx
 819:	75 ed                	jne    808 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 81b:	83 ec 0c             	sub    $0xc,%esp
 81e:	56                   	push   %esi
 81f:	e8 26 fc ff ff       	call   44a <sbrk>
  if(p == (char*)-1)
 824:	83 c4 10             	add    $0x10,%esp
 827:	83 f8 ff             	cmp    $0xffffffff,%eax
 82a:	74 1c                	je     848 <malloc+0x88>
  hp->s.size = nu;
 82c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 82f:	83 ec 0c             	sub    $0xc,%esp
 832:	83 c0 08             	add    $0x8,%eax
 835:	50                   	push   %eax
 836:	e8 f5 fe ff ff       	call   730 <free>
  return freep;
 83b:	8b 15 c0 0b 00 00    	mov    0xbc0,%edx
      if((p = morecore(nunits)) == 0)
 841:	83 c4 10             	add    $0x10,%esp
 844:	85 d2                	test   %edx,%edx
 846:	75 c0                	jne    808 <malloc+0x48>
        return 0;
  }
}
 848:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 84b:	31 c0                	xor    %eax,%eax
}
 84d:	5b                   	pop    %ebx
 84e:	5e                   	pop    %esi
 84f:	5f                   	pop    %edi
 850:	5d                   	pop    %ebp
 851:	c3                   	ret    
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 858:	39 cf                	cmp    %ecx,%edi
 85a:	74 54                	je     8b0 <malloc+0xf0>
        p->s.size -= nunits;
 85c:	29 f9                	sub    %edi,%ecx
 85e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 861:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 864:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 867:	89 15 c0 0b 00 00    	mov    %edx,0xbc0
}
 86d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 870:	83 c0 08             	add    $0x8,%eax
}
 873:	5b                   	pop    %ebx
 874:	5e                   	pop    %esi
 875:	5f                   	pop    %edi
 876:	5d                   	pop    %ebp
 877:	c3                   	ret    
 878:	90                   	nop
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 880:	c7 05 c0 0b 00 00 c4 	movl   $0xbc4,0xbc0
 887:	0b 00 00 
 88a:	c7 05 c4 0b 00 00 c4 	movl   $0xbc4,0xbc4
 891:	0b 00 00 
    base.s.size = 0;
 894:	b8 c4 0b 00 00       	mov    $0xbc4,%eax
 899:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 8a0:	00 00 00 
 8a3:	e9 44 ff ff ff       	jmp    7ec <malloc+0x2c>
 8a8:	90                   	nop
 8a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b1                	jmp    867 <malloc+0xa7>
