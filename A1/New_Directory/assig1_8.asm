
_assig1_8:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	avg_global = *((float *)msg);
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
  11:	83 ec 38             	sub    $0x38,%esp
	if(argc< 2){
  14:	83 39 01             	cmpl   $0x1,(%ecx)
{
  17:	8b 41 04             	mov    0x4(%ecx),%eax
	if(argc< 2){
  1a:	0f 8e cd 02 00 00    	jle    2ed <main+0x2ed>
		printf(1,"Need type and input filename\n");
		exit();
	}
	char *filename;
	filename=argv[2];
  20:	8b 70 08             	mov    0x8(%eax),%esi
	int type = atoi(argv[1]);
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	ff 70 04             	pushl  0x4(%eax)
  29:	8d 7d df             	lea    -0x21(%ebp),%edi
	filename=argv[2];
  2c:	89 75 c0             	mov    %esi,-0x40(%ebp)
	int type = atoi(argv[1]);
  2f:	e8 2c 05 00 00       	call   560 <atoi>
	printf(1,"Type is %d and filename is %s\n",type, filename);
  34:	56                   	push   %esi
  35:	50                   	push   %eax
  36:	68 f8 0a 00 00       	push   $0xaf8
  3b:	6a 01                	push   $0x1
	int type = atoi(argv[1]);
  3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	printf(1,"Type is %d and filename is %s\n",type, filename);
  40:	e8 2b 07 00 00       	call   770 <printf>

	int tot_sum = 0;	
	float variance = 0.0;

	int size=1000;
	short arr[size];
  45:	81 ec c0 07 00 00    	sub    $0x7c0,%esp
  4b:	89 e3                	mov    %esp,%ebx
	char c;
	int fd = open(filename, 0);
  4d:	50                   	push   %eax
  4e:	50                   	push   %eax
  4f:	6a 00                	push   $0x0
  51:	56                   	push   %esi
	short arr[size];
  52:	89 5d c8             	mov    %ebx,-0x38(%ebp)
	int fd = open(filename, 0);
  55:	e8 b8 05 00 00       	call   612 <open>
  5a:	89 c6                	mov    %eax,%esi
  5c:	8d 83 d0 07 00 00    	lea    0x7d0(%ebx),%eax
  62:	83 c4 10             	add    $0x10,%esp
  65:	89 45 cc             	mov    %eax,-0x34(%ebp)
  68:	90                   	nop
  69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for(int i=0; i<size; i++){
		read(fd, &c, 1);
  70:	83 ec 04             	sub    $0x4,%esp
  73:	83 c3 02             	add    $0x2,%ebx
  76:	6a 01                	push   $0x1
  78:	57                   	push   %edi
  79:	56                   	push   %esi
  7a:	e8 6b 05 00 00       	call   5ea <read>
		arr[i]=c-'0';
  7f:	66 0f be 45 df       	movsbw -0x21(%ebp),%ax
		read(fd, &c, 1);
  84:	83 c4 0c             	add    $0xc,%esp
		arr[i]=c-'0';
  87:	83 e8 30             	sub    $0x30,%eax
  8a:	66 89 43 fe          	mov    %ax,-0x2(%ebx)
		read(fd, &c, 1);
  8e:	6a 01                	push   $0x1
  90:	57                   	push   %edi
  91:	56                   	push   %esi
  92:	e8 53 05 00 00       	call   5ea <read>
	for(int i=0; i<size; i++){
  97:	83 c4 10             	add    $0x10,%esp
  9a:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
  9d:	75 d1                	jne    70 <main+0x70>
	}	
  	close(fd);
  9f:	83 ec 0c             	sub    $0xc,%esp
  a2:	56                   	push   %esi
  a3:	e8 52 05 00 00       	call   5fa <close>
  	// this is to supress warning
  	printf(1,"first elem %d\n", arr[0]);
  a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  ab:	83 c4 0c             	add    $0xc,%esp
  ae:	0f bf 00             	movswl (%eax),%eax
  b1:	50                   	push   %eax
  b2:	68 e6 0a 00 00       	push   $0xae6
  b7:	6a 01                	push   $0x1
  b9:	e8 b2 06 00 00       	call   770 <printf>
  
  	//----FILL THE CODE HERE for unicast sum and multicast variance

	  int *cid = (int *)malloc(NO_CHILD * sizeof(int));
  be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  c5:	e8 06 09 00 00       	call   9d0 <malloc>
  ca:	89 c6                	mov    %eax,%esi
  	int ind, par_pid;
  	par_pid = getpid();
  cc:	e8 81 05 00 00       	call   652 <getpid>

  	// set the signal handler before forking
  	sig_set(0, &sig_handler);
  d1:	5b                   	pop    %ebx
  d2:	5f                   	pop    %edi
  d3:	68 40 03 00 00       	push   $0x340
  d8:	6a 00                	push   $0x0

  	for(ind = 0; ind < NO_CHILD; ind++){
  da:	31 ff                	xor    %edi,%edi
  	par_pid = getpid();
  dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
  	sig_set(0, &sig_handler);
  df:	e8 be 05 00 00       	call   6a2 <sig_set>
  e4:	83 c4 10             	add    $0x10,%esp
  		cid[ind] = fork();
  e7:	e8 de 04 00 00       	call   5ca <fork>
  		if(cid[ind] == 0) break;
  ec:	85 c0                	test   %eax,%eax
  		cid[ind] = fork();
  ee:	89 04 be             	mov    %eax,(%esi,%edi,4)
  		if(cid[ind] == 0) break;
  f1:	0f 84 12 01 00 00    	je     209 <main+0x209>
  	for(ind = 0; ind < NO_CHILD; ind++){
  f7:	83 c7 01             	add    $0x1,%edi
  fa:	83 ff 08             	cmp    $0x8,%edi
  fd:	75 e8                	jne    e7 <main+0xe7>
  		exit();
  	}
  	else{
  		// Parent : The coordinator Process
		int i;
		char *msg = (char *)malloc(MSGSIZE);
  ff:	83 ec 0c             	sub    $0xc,%esp
	int tot_sum = 0;	
 102:	31 db                	xor    %ebx,%ebx
		char *msg = (char *)malloc(MSGSIZE);
 104:	6a 08                	push   $0x8
 106:	e8 c5 08 00 00       	call   9d0 <malloc>
 10b:	89 c7                	mov    %eax,%edi
 10d:	b8 08 00 00 00       	mov    $0x8,%eax
 112:	89 75 c8             	mov    %esi,-0x38(%ebp)
 115:	83 c4 10             	add    $0x10,%esp
 118:	89 de                	mov    %ebx,%esi
 11a:	89 c3                	mov    %eax,%ebx

  		for(i = 0; i < NO_CHILD; i++){
  			recv(msg);
 11c:	83 ec 0c             	sub    $0xc,%esp
 11f:	57                   	push   %edi
 120:	e8 75 05 00 00       	call   69a <recv>
  			tot_sum += *((int *)msg);
 125:	8b 07                	mov    (%edi),%eax
  		for(i = 0; i < NO_CHILD; i++){
 127:	83 c4 10             	add    $0x10,%esp
  			tot_sum += *((int *)msg);
 12a:	01 f0                	add    %esi,%eax
  		for(i = 0; i < NO_CHILD; i++){
 12c:	83 eb 01             	sub    $0x1,%ebx
  			tot_sum += *((int *)msg);
 12f:	89 c6                	mov    %eax,%esi
  		for(i = 0; i < NO_CHILD; i++){
 131:	75 e9                	jne    11c <main+0x11c>
 133:	8b 75 c8             	mov    -0x38(%ebp),%esi
  		}

  		float avg = (float)tot_sum/size;
 136:	89 45 c8             	mov    %eax,-0x38(%ebp)

  		for(i = 0; i < 4; i++)
  			msg[i] = *((char *)&avg + i);

  		send_multi(par_pid, cid, msg, NO_CHILD);
 139:	bb 08 00 00 00       	mov    $0x8,%ebx
  		float avg = (float)tot_sum/size;
 13e:	db 45 c8             	fildl  -0x38(%ebp)
 141:	89 45 bc             	mov    %eax,-0x44(%ebp)
 144:	d8 35 60 0b 00 00    	fdivs  0xb60
 14a:	d9 5d e4             	fstps  -0x1c(%ebp)
  			msg[i] = *((char *)&avg + i);
 14d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
 151:	88 07                	mov    %al,(%edi)
 153:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
 157:	88 47 01             	mov    %al,0x1(%edi)
 15a:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
 15e:	88 47 02             	mov    %al,0x2(%edi)
 161:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 165:	88 47 03             	mov    %al,0x3(%edi)
  		send_multi(par_pid, cid, msg, NO_CHILD);
 168:	6a 08                	push   $0x8
 16a:	57                   	push   %edi
 16b:	56                   	push   %esi
 16c:	ff 75 cc             	pushl  -0x34(%ebp)
 16f:	e8 4e 05 00 00       	call   6c2 <send_multi>
	float variance = 0.0;
 174:	d9 ee                	fldz   
  		send_multi(par_pid, cid, msg, NO_CHILD);
 176:	83 c4 10             	add    $0x10,%esp
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  		for(i = 0; i < NO_CHILD; i++){
  			recv(msg);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	d9 5d cc             	fstps  -0x34(%ebp)
 186:	57                   	push   %edi
 187:	e8 0e 05 00 00       	call   69a <recv>
  			variance += *((float *)msg);
 18c:	d9 45 cc             	flds   -0x34(%ebp)
  		for(i = 0; i < NO_CHILD; i++){
 18f:	83 c4 10             	add    $0x10,%esp
 192:	83 eb 01             	sub    $0x1,%ebx
  			variance += *((float *)msg);
 195:	d8 07                	fadds  (%edi)
  		for(i = 0; i < NO_CHILD; i++){
 197:	75 e7                	jne    180 <main+0x180>
 199:	d9 5d cc             	fstps  -0x34(%ebp)
  		}

  		variance /= (float)size;
  		for(i = 0; i < NO_CHILD; i++)
  			wait();
 19c:	e8 39 04 00 00       	call   5da <wait>
 1a1:	e8 34 04 00 00       	call   5da <wait>
 1a6:	e8 2f 04 00 00       	call   5da <wait>
 1ab:	e8 2a 04 00 00       	call   5da <wait>
 1b0:	e8 25 04 00 00       	call   5da <wait>
 1b5:	e8 20 04 00 00       	call   5da <wait>
 1ba:	e8 1b 04 00 00       	call   5da <wait>
 1bf:	e8 16 04 00 00       	call   5da <wait>
 1c4:	d9 7d d6             	fnstcw -0x2a(%ebp)
  		variance /= (float)size;
 1c7:	d9 45 cc             	flds   -0x34(%ebp)
 1ca:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
 1ce:	d8 35 60 0b 00 00    	fdivs  0xb60
 1d4:	80 cc 0c             	or     $0xc,%ah
  	}

  	//------------------

  	if(type==0){ //unicast sum
 1d7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 1db:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
 1df:	d9 6d d4             	fldcw  -0x2c(%ebp)
 1e2:	db 5d d0             	fistpl -0x30(%ebp)
 1e5:	d9 6d d6             	fldcw  -0x2a(%ebp)
 1e8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 1eb:	0f 84 0f 01 00 00    	je     300 <main+0x300>
		printf(1,"Sum of array for file %s is %d\n", filename, tot_sum);
    printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
	}
	else{ //mulicast variance
		printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
 1f1:	53                   	push   %ebx
 1f2:	ff 75 c0             	pushl  -0x40(%ebp)
 1f5:	68 38 0b 00 00       	push   $0xb38
 1fa:	6a 01                	push   $0x1
 1fc:	e8 6f 05 00 00       	call   770 <printf>
 201:	83 c4 10             	add    $0x10,%esp
	}
	exit();
 204:	e8 c9 03 00 00       	call   5d2 <exit>
 209:	89 c3                	mov    %eax,%ebx
  		start = ind * (size / NO_CHILD);
 20b:	6b f7 7d             	imul   $0x7d,%edi,%esi
  		pid = getpid();
 20e:	e8 3f 04 00 00       	call   652 <getpid>
  		if(ind == NO_CHILD-1)
 213:	83 ff 07             	cmp    $0x7,%edi
  		pid = getpid();
 216:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  		if(ind == NO_CHILD-1)
 219:	0f 84 0a 01 00 00    	je     329 <main+0x329>
  		end = start + (size / NO_CHILD);
 21f:	8d 7e 7d             	lea    0x7d(%esi),%edi
  		start = ind * (size / NO_CHILD);
 222:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 225:	89 f0                	mov    %esi,%eax
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  			partial_sum += arr[i];
 230:	0f bf 14 41          	movswl (%ecx,%eax,2),%edx
  		for(i = start; i < end; i++)
 234:	83 c0 01             	add    $0x1,%eax
  			partial_sum += arr[i];
 237:	01 d3                	add    %edx,%ebx
  		for(i = start; i < end; i++)
 239:	39 c7                	cmp    %eax,%edi
 23b:	7f f3                	jg     230 <main+0x230>
  		char *msg = (char *)malloc(MSGSIZE);
 23d:	83 ec 0c             	sub    $0xc,%esp
 240:	89 5d e0             	mov    %ebx,-0x20(%ebp)
 243:	6a 08                	push   $0x8
 245:	e8 86 07 00 00       	call   9d0 <malloc>
 24a:	89 c3                	mov    %eax,%ebx
  			msg[i] = *((char *)&partial_sum + i);
 24c:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  		send(pid, par_pid, msg);
 250:	83 c4 0c             	add    $0xc,%esp
  			msg[i] = *((char *)&partial_sum + i);
 253:	88 03                	mov    %al,(%ebx)
 255:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
 259:	88 43 01             	mov    %al,0x1(%ebx)
 25c:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
 260:	88 43 02             	mov    %al,0x2(%ebx)
 263:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
 267:	88 43 03             	mov    %al,0x3(%ebx)
  		send(pid, par_pid, msg);
 26a:	53                   	push   %ebx
 26b:	ff 75 cc             	pushl  -0x34(%ebp)
 26e:	ff 75 c4             	pushl  -0x3c(%ebp)
 271:	e8 1c 04 00 00       	call   692 <send>
      sig_pause(&flag_handler,1);
 276:	5a                   	pop    %edx
 277:	59                   	pop    %ecx
 278:	6a 01                	push   $0x1
 27a:	68 3c 0e 00 00       	push   $0xe3c
 27f:	e8 2e 04 00 00       	call   6b2 <sig_pause>
  		float partial_var = 0.0;
 284:	d9 ee                	fldz   
  		for(i = start; i < end; i++){
 286:	83 c4 10             	add    $0x10,%esp
 289:	39 f7                	cmp    %esi,%edi
  		float partial_var = 0.0;
 28b:	d9 55 e4             	fsts   -0x1c(%ebp)
  		for(i = start; i < end; i++){
 28e:	7e 2e                	jle    2be <main+0x2be>
 290:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 293:	01 f6                	add    %esi,%esi
 295:	01 ff                	add    %edi,%edi
  			float diff = (avg_global - (float)arr[i]);
 297:	d9 05 40 0e 00 00    	flds   0xe40
 29d:	8d 04 31             	lea    (%ecx,%esi,1),%eax
 2a0:	8d 14 39             	lea    (%ecx,%edi,1),%edx
 2a3:	90                   	nop
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a8:	df 00                	filds  (%eax)
 2aa:	83 c0 02             	add    $0x2,%eax
  		for(i = start; i < end; i++){
 2ad:	39 d0                	cmp    %edx,%eax
  			float diff = (avg_global - (float)arr[i]);
 2af:	d8 e9                	fsubr  %st(1),%st
  			partial_var +=  diff * diff;
 2b1:	d8 c8                	fmul   %st(0),%st
 2b3:	de c2                	faddp  %st,%st(2)
  		for(i = start; i < end; i++){
 2b5:	75 f1                	jne    2a8 <main+0x2a8>
 2b7:	dd d8                	fstp   %st(0)
 2b9:	d9 5d e4             	fstps  -0x1c(%ebp)
 2bc:	eb 02                	jmp    2c0 <main+0x2c0>
 2be:	dd d8                	fstp   %st(0)
  			msg[i] = *((char*)&partial_var + i);
 2c0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
 2c4:	88 03                	mov    %al,(%ebx)
 2c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
 2ca:	88 43 01             	mov    %al,0x1(%ebx)
 2cd:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
 2d1:	88 43 02             	mov    %al,0x2(%ebx)
 2d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d8:	88 43 03             	mov    %al,0x3(%ebx)
  		send(pid, par_pid, msg);
 2db:	50                   	push   %eax
 2dc:	53                   	push   %ebx
 2dd:	ff 75 cc             	pushl  -0x34(%ebp)
 2e0:	ff 75 c4             	pushl  -0x3c(%ebp)
 2e3:	e8 aa 03 00 00       	call   692 <send>
  		exit();
 2e8:	e8 e5 02 00 00       	call   5d2 <exit>
		printf(1,"Need type and input filename\n");
 2ed:	50                   	push   %eax
 2ee:	50                   	push   %eax
 2ef:	68 c8 0a 00 00       	push   $0xac8
 2f4:	6a 01                	push   $0x1
 2f6:	e8 75 04 00 00       	call   770 <printf>
		exit();
 2fb:	e8 d2 02 00 00       	call   5d2 <exit>
		printf(1,"Sum of array for file %s is %d\n", filename, tot_sum);
 300:	8b 75 c0             	mov    -0x40(%ebp),%esi
 303:	ff 75 bc             	pushl  -0x44(%ebp)
 306:	56                   	push   %esi
 307:	68 18 0b 00 00       	push   $0xb18
 30c:	6a 01                	push   $0x1
 30e:	e8 5d 04 00 00       	call   770 <printf>
    printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
 313:	53                   	push   %ebx
 314:	56                   	push   %esi
 315:	68 38 0b 00 00       	push   $0xb38
 31a:	6a 01                	push   $0x1
 31c:	e8 4f 04 00 00       	call   770 <printf>
 321:	83 c4 20             	add    $0x20,%esp
 324:	e9 db fe ff ff       	jmp    204 <main+0x204>
  			end = size;
 329:	bf e8 03 00 00       	mov    $0x3e8,%edi
 32e:	e9 ef fe ff ff       	jmp    222 <main+0x222>
 333:	66 90                	xchg   %ax,%ax
 335:	66 90                	xchg   %ax,%ax
 337:	66 90                	xchg   %ax,%ax
 339:	66 90                	xchg   %ax,%ax
 33b:	66 90                	xchg   %ax,%ax
 33d:	66 90                	xchg   %ax,%ax
 33f:	90                   	nop

00000340 <sig_handler>:
void sig_handler(void *msg){
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 08             	sub    $0x8,%esp
	flag_handler  = 1;
 346:	c7 05 3c 0e 00 00 01 	movl   $0x1,0xe3c
 34d:	00 00 00 
  int pid = getpid();
 350:	e8 fd 02 00 00       	call   652 <getpid>
  flag_handler += pid;
 355:	8b 15 3c 0e 00 00    	mov    0xe3c,%edx
 35b:	01 c2                	add    %eax,%edx
 35d:	89 15 3c 0e 00 00    	mov    %edx,0xe3c
  flag_handler -= pid;
 363:	8b 15 3c 0e 00 00    	mov    0xe3c,%edx
 369:	29 c2                	sub    %eax,%edx
	avg_global = *((float *)msg);
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
  flag_handler -= pid;
 36e:	89 15 3c 0e 00 00    	mov    %edx,0xe3c
	avg_global = *((float *)msg);
 374:	d9 00                	flds   (%eax)
 376:	d9 1d 40 0e 00 00    	fstps  0xe40
}
 37c:	c9                   	leave  
 37d:	c3                   	ret    
 37e:	66 90                	xchg   %ax,%ax

00000380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 38a:	89 c2                	mov    %eax,%edx
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 390:	83 c1 01             	add    $0x1,%ecx
 393:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 397:	83 c2 01             	add    $0x1,%edx
 39a:	84 db                	test   %bl,%bl
 39c:	88 5a ff             	mov    %bl,-0x1(%edx)
 39f:	75 ef                	jne    390 <strcpy+0x10>
    ;
  return os;
}
 3a1:	5b                   	pop    %ebx
 3a2:	5d                   	pop    %ebp
 3a3:	c3                   	ret    
 3a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	8b 55 08             	mov    0x8(%ebp),%edx
 3b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3ba:	0f b6 02             	movzbl (%edx),%eax
 3bd:	0f b6 19             	movzbl (%ecx),%ebx
 3c0:	84 c0                	test   %al,%al
 3c2:	75 1c                	jne    3e0 <strcmp+0x30>
 3c4:	eb 2a                	jmp    3f0 <strcmp+0x40>
 3c6:	8d 76 00             	lea    0x0(%esi),%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3d6:	83 c1 01             	add    $0x1,%ecx
 3d9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 3dc:	84 c0                	test   %al,%al
 3de:	74 10                	je     3f0 <strcmp+0x40>
 3e0:	38 d8                	cmp    %bl,%al
 3e2:	74 ec                	je     3d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3e4:	29 d8                	sub    %ebx,%eax
}
 3e6:	5b                   	pop    %ebx
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3f2:	29 d8                	sub    %ebx,%eax
}
 3f4:	5b                   	pop    %ebx
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <strlen>:

uint
strlen(const char *s)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 406:	80 39 00             	cmpb   $0x0,(%ecx)
 409:	74 15                	je     420 <strlen+0x20>
 40b:	31 d2                	xor    %edx,%edx
 40d:	8d 76 00             	lea    0x0(%esi),%esi
 410:	83 c2 01             	add    $0x1,%edx
 413:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 417:	89 d0                	mov    %edx,%eax
 419:	75 f5                	jne    410 <strlen+0x10>
    ;
  return n;
}
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 420:	31 c0                	xor    %eax,%eax
}
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 42a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000430 <memset>:

void*
memset(void *dst, int c, uint n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 437:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 d7                	mov    %edx,%edi
 43f:	fc                   	cld    
 440:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 442:	89 d0                	mov    %edx,%eax
 444:	5f                   	pop    %edi
 445:	5d                   	pop    %ebp
 446:	c3                   	ret    
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <strchr>:

char*
strchr(const char *s, char c)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 45a:	0f b6 10             	movzbl (%eax),%edx
 45d:	84 d2                	test   %dl,%dl
 45f:	74 1d                	je     47e <strchr+0x2e>
    if(*s == c)
 461:	38 d3                	cmp    %dl,%bl
 463:	89 d9                	mov    %ebx,%ecx
 465:	75 0d                	jne    474 <strchr+0x24>
 467:	eb 17                	jmp    480 <strchr+0x30>
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 470:	38 ca                	cmp    %cl,%dl
 472:	74 0c                	je     480 <strchr+0x30>
  for(; *s; s++)
 474:	83 c0 01             	add    $0x1,%eax
 477:	0f b6 10             	movzbl (%eax),%edx
 47a:	84 d2                	test   %dl,%dl
 47c:	75 f2                	jne    470 <strchr+0x20>
      return (char*)s;
  return 0;
 47e:	31 c0                	xor    %eax,%eax
}
 480:	5b                   	pop    %ebx
 481:	5d                   	pop    %ebp
 482:	c3                   	ret    
 483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000490 <gets>:

char*
gets(char *buf, int max)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 496:	31 f6                	xor    %esi,%esi
 498:	89 f3                	mov    %esi,%ebx
{
 49a:	83 ec 1c             	sub    $0x1c,%esp
 49d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4a0:	eb 2f                	jmp    4d1 <gets+0x41>
 4a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ab:	83 ec 04             	sub    $0x4,%esp
 4ae:	6a 01                	push   $0x1
 4b0:	50                   	push   %eax
 4b1:	6a 00                	push   $0x0
 4b3:	e8 32 01 00 00       	call   5ea <read>
    if(cc < 1)
 4b8:	83 c4 10             	add    $0x10,%esp
 4bb:	85 c0                	test   %eax,%eax
 4bd:	7e 1c                	jle    4db <gets+0x4b>
      break;
    buf[i++] = c;
 4bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4c3:	83 c7 01             	add    $0x1,%edi
 4c6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4c9:	3c 0a                	cmp    $0xa,%al
 4cb:	74 23                	je     4f0 <gets+0x60>
 4cd:	3c 0d                	cmp    $0xd,%al
 4cf:	74 1f                	je     4f0 <gets+0x60>
  for(i=0; i+1 < max; ){
 4d1:	83 c3 01             	add    $0x1,%ebx
 4d4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4d7:	89 fe                	mov    %edi,%esi
 4d9:	7c cd                	jl     4a8 <gets+0x18>
 4db:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4dd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4e0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e6:	5b                   	pop    %ebx
 4e7:	5e                   	pop    %esi
 4e8:	5f                   	pop    %edi
 4e9:	5d                   	pop    %ebp
 4ea:	c3                   	ret    
 4eb:	90                   	nop
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f0:	8b 75 08             	mov    0x8(%ebp),%esi
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	01 de                	add    %ebx,%esi
 4f8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4fa:	c6 03 00             	movb   $0x0,(%ebx)
}
 4fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 500:	5b                   	pop    %ebx
 501:	5e                   	pop    %esi
 502:	5f                   	pop    %edi
 503:	5d                   	pop    %ebp
 504:	c3                   	ret    
 505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000510 <stat>:

int
stat(const char *n, struct stat *st)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	56                   	push   %esi
 514:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 515:	83 ec 08             	sub    $0x8,%esp
 518:	6a 00                	push   $0x0
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 f0 00 00 00       	call   612 <open>
  if(fd < 0)
 522:	83 c4 10             	add    $0x10,%esp
 525:	85 c0                	test   %eax,%eax
 527:	78 27                	js     550 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 529:	83 ec 08             	sub    $0x8,%esp
 52c:	ff 75 0c             	pushl  0xc(%ebp)
 52f:	89 c3                	mov    %eax,%ebx
 531:	50                   	push   %eax
 532:	e8 f3 00 00 00       	call   62a <fstat>
  close(fd);
 537:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 53a:	89 c6                	mov    %eax,%esi
  close(fd);
 53c:	e8 b9 00 00 00       	call   5fa <close>
  return r;
 541:	83 c4 10             	add    $0x10,%esp
}
 544:	8d 65 f8             	lea    -0x8(%ebp),%esp
 547:	89 f0                	mov    %esi,%eax
 549:	5b                   	pop    %ebx
 54a:	5e                   	pop    %esi
 54b:	5d                   	pop    %ebp
 54c:	c3                   	ret    
 54d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 550:	be ff ff ff ff       	mov    $0xffffffff,%esi
 555:	eb ed                	jmp    544 <stat+0x34>
 557:	89 f6                	mov    %esi,%esi
 559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000560 <atoi>:

int
atoi(const char *s)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	53                   	push   %ebx
 564:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 567:	0f be 11             	movsbl (%ecx),%edx
 56a:	8d 42 d0             	lea    -0x30(%edx),%eax
 56d:	3c 09                	cmp    $0x9,%al
  n = 0;
 56f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 574:	77 1f                	ja     595 <atoi+0x35>
 576:	8d 76 00             	lea    0x0(%esi),%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 580:	8d 04 80             	lea    (%eax,%eax,4),%eax
 583:	83 c1 01             	add    $0x1,%ecx
 586:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 58a:	0f be 11             	movsbl (%ecx),%edx
 58d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 590:	80 fb 09             	cmp    $0x9,%bl
 593:	76 eb                	jbe    580 <atoi+0x20>
  return n;
}
 595:	5b                   	pop    %ebx
 596:	5d                   	pop    %ebp
 597:	c3                   	ret    
 598:	90                   	nop
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	56                   	push   %esi
 5a4:	53                   	push   %ebx
 5a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ae:	85 db                	test   %ebx,%ebx
 5b0:	7e 14                	jle    5c6 <memmove+0x26>
 5b2:	31 d2                	xor    %edx,%edx
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5c2:	39 d3                	cmp    %edx,%ebx
 5c4:	75 f2                	jne    5b8 <memmove+0x18>
  return vdst;
}
 5c6:	5b                   	pop    %ebx
 5c7:	5e                   	pop    %esi
 5c8:	5d                   	pop    %ebp
 5c9:	c3                   	ret    

000005ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ca:	b8 01 00 00 00       	mov    $0x1,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <exit>:
SYSCALL(exit)
 5d2:	b8 02 00 00 00       	mov    $0x2,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <wait>:
SYSCALL(wait)
 5da:	b8 03 00 00 00       	mov    $0x3,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <pipe>:
SYSCALL(pipe)
 5e2:	b8 04 00 00 00       	mov    $0x4,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <read>:
SYSCALL(read)
 5ea:	b8 05 00 00 00       	mov    $0x5,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <write>:
SYSCALL(write)
 5f2:	b8 10 00 00 00       	mov    $0x10,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <close>:
SYSCALL(close)
 5fa:	b8 15 00 00 00       	mov    $0x15,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <kill>:
SYSCALL(kill)
 602:	b8 06 00 00 00       	mov    $0x6,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <exec>:
SYSCALL(exec)
 60a:	b8 07 00 00 00       	mov    $0x7,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <open>:
SYSCALL(open)
 612:	b8 0f 00 00 00       	mov    $0xf,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mknod>:
SYSCALL(mknod)
 61a:	b8 11 00 00 00       	mov    $0x11,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <unlink>:
SYSCALL(unlink)
 622:	b8 12 00 00 00       	mov    $0x12,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <fstat>:
SYSCALL(fstat)
 62a:	b8 08 00 00 00       	mov    $0x8,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <link>:
SYSCALL(link)
 632:	b8 13 00 00 00       	mov    $0x13,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <mkdir>:
SYSCALL(mkdir)
 63a:	b8 14 00 00 00       	mov    $0x14,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <chdir>:
SYSCALL(chdir)
 642:	b8 09 00 00 00       	mov    $0x9,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <dup>:
SYSCALL(dup)
 64a:	b8 0a 00 00 00       	mov    $0xa,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <getpid>:
SYSCALL(getpid)
 652:	b8 0b 00 00 00       	mov    $0xb,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <sbrk>:
SYSCALL(sbrk)
 65a:	b8 0c 00 00 00       	mov    $0xc,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <sleep>:
SYSCALL(sleep)
 662:	b8 0d 00 00 00       	mov    $0xd,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <uptime>:
SYSCALL(uptime)
 66a:	b8 0e 00 00 00       	mov    $0xe,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <print_count>:
SYSCALL(print_count)
 672:	b8 16 00 00 00       	mov    $0x16,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <toggle>:
SYSCALL(toggle)
 67a:	b8 17 00 00 00       	mov    $0x17,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <add>:
SYSCALL(add)
 682:	b8 18 00 00 00       	mov    $0x18,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <ps>:
SYSCALL(ps)
 68a:	b8 19 00 00 00       	mov    $0x19,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <send>:
SYSCALL(send)
 692:	b8 1a 00 00 00       	mov    $0x1a,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <recv>:
SYSCALL(recv)
 69a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <sig_set>:
SYSCALL(sig_set)
 6a2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <sig_send>:
SYSCALL(sig_send)
 6aa:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <sig_pause>:
SYSCALL(sig_pause)
 6b2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <sig_ret>:
SYSCALL(sig_ret)
 6ba:	b8 20 00 00 00       	mov    $0x20,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <send_multi>:
 6c2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    
 6ca:	66 90                	xchg   %ax,%ax
 6cc:	66 90                	xchg   %ax,%ax
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6d9:	85 d2                	test   %edx,%edx
{
 6db:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6de:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6e0:	79 76                	jns    758 <printint+0x88>
 6e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6e6:	74 70                	je     758 <printint+0x88>
    x = -xx;
 6e8:	f7 d8                	neg    %eax
    neg = 1;
 6ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6f1:	31 f6                	xor    %esi,%esi
 6f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6f6:	eb 0a                	jmp    702 <printint+0x32>
 6f8:	90                   	nop
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 700:	89 fe                	mov    %edi,%esi
 702:	31 d2                	xor    %edx,%edx
 704:	8d 7e 01             	lea    0x1(%esi),%edi
 707:	f7 f1                	div    %ecx
 709:	0f b6 92 6c 0b 00 00 	movzbl 0xb6c(%edx),%edx
  }while((x /= base) != 0);
 710:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 712:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 715:	75 e9                	jne    700 <printint+0x30>
  if(neg)
 717:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 71a:	85 c0                	test   %eax,%eax
 71c:	74 08                	je     726 <printint+0x56>
    buf[i++] = '-';
 71e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 723:	8d 7e 02             	lea    0x2(%esi),%edi
 726:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 72a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 72d:	8d 76 00             	lea    0x0(%esi),%esi
 730:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
 736:	83 ee 01             	sub    $0x1,%esi
 739:	6a 01                	push   $0x1
 73b:	53                   	push   %ebx
 73c:	57                   	push   %edi
 73d:	88 45 d7             	mov    %al,-0x29(%ebp)
 740:	e8 ad fe ff ff       	call   5f2 <write>

  while(--i >= 0)
 745:	83 c4 10             	add    $0x10,%esp
 748:	39 de                	cmp    %ebx,%esi
 74a:	75 e4                	jne    730 <printint+0x60>
    putc(fd, buf[i]);
}
 74c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 74f:	5b                   	pop    %ebx
 750:	5e                   	pop    %esi
 751:	5f                   	pop    %edi
 752:	5d                   	pop    %ebp
 753:	c3                   	ret    
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 758:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 75f:	eb 90                	jmp    6f1 <printint+0x21>
 761:	eb 0d                	jmp    770 <printf>
 763:	90                   	nop
 764:	90                   	nop
 765:	90                   	nop
 766:	90                   	nop
 767:	90                   	nop
 768:	90                   	nop
 769:	90                   	nop
 76a:	90                   	nop
 76b:	90                   	nop
 76c:	90                   	nop
 76d:	90                   	nop
 76e:	90                   	nop
 76f:	90                   	nop

00000770 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 779:	8b 75 0c             	mov    0xc(%ebp),%esi
 77c:	0f b6 1e             	movzbl (%esi),%ebx
 77f:	84 db                	test   %bl,%bl
 781:	0f 84 b3 00 00 00    	je     83a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 787:	8d 45 10             	lea    0x10(%ebp),%eax
 78a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 78d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 78f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 792:	eb 2f                	jmp    7c3 <printf+0x53>
 794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 798:	83 f8 25             	cmp    $0x25,%eax
 79b:	0f 84 a7 00 00 00    	je     848 <printf+0xd8>
  write(fd, &c, 1);
 7a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 7a4:	83 ec 04             	sub    $0x4,%esp
 7a7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 7aa:	6a 01                	push   $0x1
 7ac:	50                   	push   %eax
 7ad:	ff 75 08             	pushl  0x8(%ebp)
 7b0:	e8 3d fe ff ff       	call   5f2 <write>
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 7bb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7bf:	84 db                	test   %bl,%bl
 7c1:	74 77                	je     83a <printf+0xca>
    if(state == 0){
 7c3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7c5:	0f be cb             	movsbl %bl,%ecx
 7c8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7cb:	74 cb                	je     798 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7cd:	83 ff 25             	cmp    $0x25,%edi
 7d0:	75 e6                	jne    7b8 <printf+0x48>
      if(c == 'd'){
 7d2:	83 f8 64             	cmp    $0x64,%eax
 7d5:	0f 84 05 01 00 00    	je     8e0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7db:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7e1:	83 f9 70             	cmp    $0x70,%ecx
 7e4:	74 72                	je     858 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7e6:	83 f8 73             	cmp    $0x73,%eax
 7e9:	0f 84 99 00 00 00    	je     888 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ef:	83 f8 63             	cmp    $0x63,%eax
 7f2:	0f 84 08 01 00 00    	je     900 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7f8:	83 f8 25             	cmp    $0x25,%eax
 7fb:	0f 84 ef 00 00 00    	je     8f0 <printf+0x180>
  write(fd, &c, 1);
 801:	8d 45 e7             	lea    -0x19(%ebp),%eax
 804:	83 ec 04             	sub    $0x4,%esp
 807:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 80b:	6a 01                	push   $0x1
 80d:	50                   	push   %eax
 80e:	ff 75 08             	pushl  0x8(%ebp)
 811:	e8 dc fd ff ff       	call   5f2 <write>
 816:	83 c4 0c             	add    $0xc,%esp
 819:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 81c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 81f:	6a 01                	push   $0x1
 821:	50                   	push   %eax
 822:	ff 75 08             	pushl  0x8(%ebp)
 825:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 828:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 82a:	e8 c3 fd ff ff       	call   5f2 <write>
  for(i = 0; fmt[i]; i++){
 82f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 833:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 836:	84 db                	test   %bl,%bl
 838:	75 89                	jne    7c3 <printf+0x53>
    }
  }
}
 83a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 83d:	5b                   	pop    %ebx
 83e:	5e                   	pop    %esi
 83f:	5f                   	pop    %edi
 840:	5d                   	pop    %ebp
 841:	c3                   	ret    
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 848:	bf 25 00 00 00       	mov    $0x25,%edi
 84d:	e9 66 ff ff ff       	jmp    7b8 <printf+0x48>
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 858:	83 ec 0c             	sub    $0xc,%esp
 85b:	b9 10 00 00 00       	mov    $0x10,%ecx
 860:	6a 00                	push   $0x0
 862:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 865:	8b 45 08             	mov    0x8(%ebp),%eax
 868:	8b 17                	mov    (%edi),%edx
 86a:	e8 61 fe ff ff       	call   6d0 <printint>
        ap++;
 86f:	89 f8                	mov    %edi,%eax
 871:	83 c4 10             	add    $0x10,%esp
      state = 0;
 874:	31 ff                	xor    %edi,%edi
        ap++;
 876:	83 c0 04             	add    $0x4,%eax
 879:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 87c:	e9 37 ff ff ff       	jmp    7b8 <printf+0x48>
 881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 88b:	8b 08                	mov    (%eax),%ecx
        ap++;
 88d:	83 c0 04             	add    $0x4,%eax
 890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 893:	85 c9                	test   %ecx,%ecx
 895:	0f 84 8e 00 00 00    	je     929 <printf+0x1b9>
        while(*s != 0){
 89b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 89e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 8a0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 8a2:	84 c0                	test   %al,%al
 8a4:	0f 84 0e ff ff ff    	je     7b8 <printf+0x48>
 8aa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 8ad:	89 de                	mov    %ebx,%esi
 8af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8b2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 8b5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8b8:	83 ec 04             	sub    $0x4,%esp
          s++;
 8bb:	83 c6 01             	add    $0x1,%esi
 8be:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8c1:	6a 01                	push   $0x1
 8c3:	57                   	push   %edi
 8c4:	53                   	push   %ebx
 8c5:	e8 28 fd ff ff       	call   5f2 <write>
        while(*s != 0){
 8ca:	0f b6 06             	movzbl (%esi),%eax
 8cd:	83 c4 10             	add    $0x10,%esp
 8d0:	84 c0                	test   %al,%al
 8d2:	75 e4                	jne    8b8 <printf+0x148>
 8d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8d7:	31 ff                	xor    %edi,%edi
 8d9:	e9 da fe ff ff       	jmp    7b8 <printf+0x48>
 8de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8e0:	83 ec 0c             	sub    $0xc,%esp
 8e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8e8:	6a 01                	push   $0x1
 8ea:	e9 73 ff ff ff       	jmp    862 <printf+0xf2>
 8ef:	90                   	nop
  write(fd, &c, 1);
 8f0:	83 ec 04             	sub    $0x4,%esp
 8f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8f9:	6a 01                	push   $0x1
 8fb:	e9 21 ff ff ff       	jmp    821 <printf+0xb1>
        putc(fd, *ap);
 900:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 903:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 906:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 908:	6a 01                	push   $0x1
        ap++;
 90a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 90d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 910:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 913:	50                   	push   %eax
 914:	ff 75 08             	pushl  0x8(%ebp)
 917:	e8 d6 fc ff ff       	call   5f2 <write>
        ap++;
 91c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 91f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 922:	31 ff                	xor    %edi,%edi
 924:	e9 8f fe ff ff       	jmp    7b8 <printf+0x48>
          s = "(null)";
 929:	bb 64 0b 00 00       	mov    $0xb64,%ebx
        while(*s != 0){
 92e:	b8 28 00 00 00       	mov    $0x28,%eax
 933:	e9 72 ff ff ff       	jmp    8aa <printf+0x13a>
 938:	66 90                	xchg   %ax,%ax
 93a:	66 90                	xchg   %ax,%ax
 93c:	66 90                	xchg   %ax,%ax
 93e:	66 90                	xchg   %ax,%ax

00000940 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 940:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 941:	a1 44 0e 00 00       	mov    0xe44,%eax
{
 946:	89 e5                	mov    %esp,%ebp
 948:	57                   	push   %edi
 949:	56                   	push   %esi
 94a:	53                   	push   %ebx
 94b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 94e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 958:	39 c8                	cmp    %ecx,%eax
 95a:	8b 10                	mov    (%eax),%edx
 95c:	73 32                	jae    990 <free+0x50>
 95e:	39 d1                	cmp    %edx,%ecx
 960:	72 04                	jb     966 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 962:	39 d0                	cmp    %edx,%eax
 964:	72 32                	jb     998 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 966:	8b 73 fc             	mov    -0x4(%ebx),%esi
 969:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 96c:	39 fa                	cmp    %edi,%edx
 96e:	74 30                	je     9a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 970:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 973:	8b 50 04             	mov    0x4(%eax),%edx
 976:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 979:	39 f1                	cmp    %esi,%ecx
 97b:	74 3a                	je     9b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 97d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 97f:	a3 44 0e 00 00       	mov    %eax,0xe44
}
 984:	5b                   	pop    %ebx
 985:	5e                   	pop    %esi
 986:	5f                   	pop    %edi
 987:	5d                   	pop    %ebp
 988:	c3                   	ret    
 989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 990:	39 d0                	cmp    %edx,%eax
 992:	72 04                	jb     998 <free+0x58>
 994:	39 d1                	cmp    %edx,%ecx
 996:	72 ce                	jb     966 <free+0x26>
{
 998:	89 d0                	mov    %edx,%eax
 99a:	eb bc                	jmp    958 <free+0x18>
 99c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 9a0:	03 72 04             	add    0x4(%edx),%esi
 9a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a6:	8b 10                	mov    (%eax),%edx
 9a8:	8b 12                	mov    (%edx),%edx
 9aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9ad:	8b 50 04             	mov    0x4(%eax),%edx
 9b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9b3:	39 f1                	cmp    %esi,%ecx
 9b5:	75 c6                	jne    97d <free+0x3d>
    p->s.size += bp->s.size;
 9b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9ba:	a3 44 0e 00 00       	mov    %eax,0xe44
    p->s.size += bp->s.size;
 9bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9c5:	89 10                	mov    %edx,(%eax)
}
 9c7:	5b                   	pop    %ebx
 9c8:	5e                   	pop    %esi
 9c9:	5f                   	pop    %edi
 9ca:	5d                   	pop    %ebp
 9cb:	c3                   	ret    
 9cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	57                   	push   %edi
 9d4:	56                   	push   %esi
 9d5:	53                   	push   %ebx
 9d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9dc:	8b 15 44 0e 00 00    	mov    0xe44,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	8d 78 07             	lea    0x7(%eax),%edi
 9e5:	c1 ef 03             	shr    $0x3,%edi
 9e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9eb:	85 d2                	test   %edx,%edx
 9ed:	0f 84 9d 00 00 00    	je     a90 <malloc+0xc0>
 9f3:	8b 02                	mov    (%edx),%eax
 9f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9f8:	39 cf                	cmp    %ecx,%edi
 9fa:	76 6c                	jbe    a68 <malloc+0x98>
 9fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 a02:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a07:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 a0a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 a11:	eb 0e                	jmp    a21 <malloc+0x51>
 a13:	90                   	nop
 a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a1a:	8b 48 04             	mov    0x4(%eax),%ecx
 a1d:	39 f9                	cmp    %edi,%ecx
 a1f:	73 47                	jae    a68 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a21:	39 05 44 0e 00 00    	cmp    %eax,0xe44
 a27:	89 c2                	mov    %eax,%edx
 a29:	75 ed                	jne    a18 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a2b:	83 ec 0c             	sub    $0xc,%esp
 a2e:	56                   	push   %esi
 a2f:	e8 26 fc ff ff       	call   65a <sbrk>
  if(p == (char*)-1)
 a34:	83 c4 10             	add    $0x10,%esp
 a37:	83 f8 ff             	cmp    $0xffffffff,%eax
 a3a:	74 1c                	je     a58 <malloc+0x88>
  hp->s.size = nu;
 a3c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a3f:	83 ec 0c             	sub    $0xc,%esp
 a42:	83 c0 08             	add    $0x8,%eax
 a45:	50                   	push   %eax
 a46:	e8 f5 fe ff ff       	call   940 <free>
  return freep;
 a4b:	8b 15 44 0e 00 00    	mov    0xe44,%edx
      if((p = morecore(nunits)) == 0)
 a51:	83 c4 10             	add    $0x10,%esp
 a54:	85 d2                	test   %edx,%edx
 a56:	75 c0                	jne    a18 <malloc+0x48>
        return 0;
  }
}
 a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a5b:	31 c0                	xor    %eax,%eax
}
 a5d:	5b                   	pop    %ebx
 a5e:	5e                   	pop    %esi
 a5f:	5f                   	pop    %edi
 a60:	5d                   	pop    %ebp
 a61:	c3                   	ret    
 a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a68:	39 cf                	cmp    %ecx,%edi
 a6a:	74 54                	je     ac0 <malloc+0xf0>
        p->s.size -= nunits;
 a6c:	29 f9                	sub    %edi,%ecx
 a6e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a71:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a74:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a77:	89 15 44 0e 00 00    	mov    %edx,0xe44
}
 a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a80:	83 c0 08             	add    $0x8,%eax
}
 a83:	5b                   	pop    %ebx
 a84:	5e                   	pop    %esi
 a85:	5f                   	pop    %edi
 a86:	5d                   	pop    %ebp
 a87:	c3                   	ret    
 a88:	90                   	nop
 a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a90:	c7 05 44 0e 00 00 48 	movl   $0xe48,0xe44
 a97:	0e 00 00 
 a9a:	c7 05 48 0e 00 00 48 	movl   $0xe48,0xe48
 aa1:	0e 00 00 
    base.s.size = 0;
 aa4:	b8 48 0e 00 00       	mov    $0xe48,%eax
 aa9:	c7 05 4c 0e 00 00 00 	movl   $0x0,0xe4c
 ab0:	00 00 00 
 ab3:	e9 44 ff ff ff       	jmp    9fc <malloc+0x2c>
 ab8:	90                   	nop
 ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 ac0:	8b 08                	mov    (%eax),%ecx
 ac2:	89 0a                	mov    %ecx,(%edx)
 ac4:	eb b1                	jmp    a77 <malloc+0xa7>
