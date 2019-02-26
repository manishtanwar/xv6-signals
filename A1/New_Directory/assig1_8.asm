
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
  1a:	0f 8e e2 02 00 00    	jle    302 <main+0x302>
		printf(1,"Need type and input filename\n");
		exit();
	}
	char *filename;
	filename=argv[2];
  20:	8b 78 08             	mov    0x8(%eax),%edi
	int type = atoi(argv[1]);
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	ff 70 04             	pushl  0x4(%eax)
	filename=argv[2];
  29:	89 7d c0             	mov    %edi,-0x40(%ebp)
	int type = atoi(argv[1]);
  2c:	e8 0f 05 00 00       	call   540 <atoi>
	printf(1,"Type is %d and filename is %s\n",type, filename);
  31:	57                   	push   %edi
  32:	50                   	push   %eax
  33:	68 d8 0a 00 00       	push   $0xad8
  38:	6a 01                	push   $0x1
	int type = atoi(argv[1]);
  3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	printf(1,"Type is %d and filename is %s\n",type, filename);
  3d:	e8 0e 07 00 00       	call   750 <printf>

	int tot_sum = 0;	
	float variance = 0.0;

	int size=1000;
	short arr[size];
  42:	81 ec c0 07 00 00    	sub    $0x7c0,%esp
  48:	89 e3                	mov    %esp,%ebx
	char c;
	int fd = open(filename, 0);
  4a:	50                   	push   %eax
  4b:	50                   	push   %eax
  4c:	6a 00                	push   $0x0
  4e:	57                   	push   %edi
  4f:	8d 7d df             	lea    -0x21(%ebp),%edi
	short arr[size];
  52:	89 5d c8             	mov    %ebx,-0x38(%ebp)
	int fd = open(filename, 0);
  55:	e8 98 05 00 00       	call   5f2 <open>
  5a:	89 c6                	mov    %eax,%esi
  5c:	89 d8                	mov    %ebx,%eax
  5e:	83 c4 10             	add    $0x10,%esp
  61:	05 d0 07 00 00       	add    $0x7d0,%eax
  66:	89 45 cc             	mov    %eax,-0x34(%ebp)
  69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for(int i=0; i<size; i++){
		read(fd, &c, 1);
  70:	83 ec 04             	sub    $0x4,%esp
  73:	83 c3 02             	add    $0x2,%ebx
  76:	6a 01                	push   $0x1
  78:	57                   	push   %edi
  79:	56                   	push   %esi
  7a:	e8 4b 05 00 00       	call   5ca <read>
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
  92:	e8 33 05 00 00       	call   5ca <read>
	for(int i=0; i<size; i++){
  97:	83 c4 10             	add    $0x10,%esp
  9a:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
  9d:	75 d1                	jne    70 <main+0x70>
	}	
  	close(fd);
  9f:	83 ec 0c             	sub    $0xc,%esp
  a2:	56                   	push   %esi
  a3:	e8 32 05 00 00       	call   5da <close>
  	// this is to supress warning
  	printf(1,"first elem %d\n", arr[0]);
  a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  ab:	83 c4 0c             	add    $0xc,%esp
  ae:	0f bf 00             	movswl (%eax),%eax
  b1:	50                   	push   %eax
  b2:	68 c6 0a 00 00       	push   $0xac6
  b7:	6a 01                	push   $0x1
  b9:	e8 92 06 00 00       	call   750 <printf>
  
  	//----FILL THE CODE HERE for unicast sum and multicast variance

	  int *cid = (int *)malloc(NO_CHILD * sizeof(int));
  be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  c5:	e8 e6 08 00 00       	call   9b0 <malloc>
  ca:	89 c3                	mov    %eax,%ebx
  	int par_pid;
  	par_pid = getpid();
  cc:	e8 61 05 00 00       	call   632 <getpid>

  	// set the signal handler before forking
  	sig_set(0, &sig_handler);
  d1:	5f                   	pop    %edi
  	par_pid = getpid();
  d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  	sig_set(0, &sig_handler);
  d5:	58                   	pop    %eax
  d6:	68 40 03 00 00       	push   $0x340
  db:	6a 00                	push   $0x0
  dd:	e8 a0 05 00 00       	call   682 <sig_set>

  	for(ind = 0; ind < NO_CHILD; ind++){
  e2:	c7 05 30 0e 00 00 00 	movl   $0x0,0xe30
  e9:	00 00 00 
  ec:	83 c4 10             	add    $0x10,%esp
  ef:	31 c0                	xor    %eax,%eax
  f1:	eb 12                	jmp    105 <main+0x105>
  f3:	90                   	nop
  f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f8:	83 c0 01             	add    $0x1,%eax
  fb:	83 f8 07             	cmp    $0x7,%eax
  fe:	a3 30 0e 00 00       	mov    %eax,0xe30
 103:	7f 16                	jg     11b <main+0x11b>
  		cid[ind] = fork();
 105:	8d 34 83             	lea    (%ebx,%eax,4),%esi
 108:	e8 9d 04 00 00       	call   5aa <fork>
 10d:	89 06                	mov    %eax,(%esi)
  		if(cid[ind] == 0) break;
 10f:	a1 30 0e 00 00       	mov    0xe30,%eax
 114:	8b 34 83             	mov    (%ebx,%eax,4),%esi
 117:	85 f6                	test   %esi,%esi
 119:	75 dd                	jne    f8 <main+0xf8>
  	}

  	if(ind != NO_CHILD){
 11b:	83 3d 30 0e 00 00 08 	cmpl   $0x8,0xe30
 122:	0f 84 dc 00 00 00    	je     204 <main+0x204>
  		// All children will come here
  		int start, end, i, pid;
  		pid = getpid();
 128:	e8 05 05 00 00       	call   632 <getpid>
 12d:	89 c7                	mov    %eax,%edi
  		start = ind * (size / NO_CHILD);
 12f:	a1 30 0e 00 00       	mov    0xe30,%eax
 134:	6b d8 7d             	imul   $0x7d,%eax,%ebx
  		end = start + (size / NO_CHILD);

  		if(ind == NO_CHILD-1)
 137:	83 f8 07             	cmp    $0x7,%eax
 13a:	0f 84 ec 01 00 00    	je     32c <main+0x32c>
  		end = start + (size / NO_CHILD);
 140:	8d 73 7d             	lea    0x7d(%ebx),%esi
  		start = ind * (size / NO_CHILD);
 143:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 146:	8b 7d c8             	mov    -0x38(%ebp),%edi
 149:	89 d8                	mov    %ebx,%eax
 14b:	31 d2                	xor    %edx,%edx
 14d:	8d 76 00             	lea    0x0(%esi),%esi
  			end = size;

  		int partial_sum = 0;
  		for(i = start; i < end; i++)
  			partial_sum += arr[i];
 150:	0f bf 0c 47          	movswl (%edi,%eax,2),%ecx
  		for(i = start; i < end; i++)
 154:	83 c0 01             	add    $0x1,%eax
  			partial_sum += arr[i];
 157:	01 ca                	add    %ecx,%edx
  		for(i = start; i < end; i++)
 159:	39 c6                	cmp    %eax,%esi
 15b:	7f f3                	jg     150 <main+0x150>

  		char *msg = (char *)malloc(MSGSIZE);
 15d:	83 ec 0c             	sub    $0xc,%esp
 160:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 163:	89 55 e0             	mov    %edx,-0x20(%ebp)
 166:	6a 08                	push   $0x8
 168:	e8 43 08 00 00       	call   9b0 <malloc>
 16d:	89 c2                	mov    %eax,%edx

  		// pack the partial_sum in msg
  		for(i = 0; i < 4; i++)
  			msg[i] = *((char *)&partial_sum + i);
 16f:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax

  		// send the partial sum to the co-oridinator process
  		send(pid, par_pid, msg);
 173:	83 c4 0c             	add    $0xc,%esp
 176:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  			msg[i] = *((char *)&partial_sum + i);
 179:	88 02                	mov    %al,(%edx)
 17b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
 17f:	88 42 01             	mov    %al,0x1(%edx)
 182:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
 186:	88 42 02             	mov    %al,0x2(%edx)
 189:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
 18d:	88 42 03             	mov    %al,0x3(%edx)
  		send(pid, par_pid, msg);
 190:	52                   	push   %edx
 191:	ff 75 cc             	pushl  -0x34(%ebp)
 194:	57                   	push   %edi
 195:	e8 d8 04 00 00       	call   672 <send>

  		// pause until msg is received
  		// if(flag_handler == 0) 
      // printf(1, "%p\n",&flag_handler);
      sig_pause(&flag_handler,1);
 19a:	5a                   	pop    %edx
 19b:	59                   	pop    %ecx
 19c:	6a 01                	push   $0x1
 19e:	68 1c 0e 00 00       	push   $0xe1c
 1a3:	e8 ea 04 00 00       	call   692 <sig_pause>
      // while(flag_handler == 0){
        
      // }

  		float partial_var = 0.0;
 1a8:	d9 ee                	fldz   
  		for(i = start; i < end; i++){
 1aa:	83 c4 10             	add    $0x10,%esp
 1ad:	39 de                	cmp    %ebx,%esi
 1af:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  		float partial_var = 0.0;
 1b2:	d9 55 e4             	fsts   -0x1c(%ebp)
  		for(i = start; i < end; i++){
 1b5:	7e 20                	jle    1d7 <main+0x1d7>
  			float diff = (avg_global - (float)arr[i]);
 1b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1ba:	d9 05 20 0e 00 00    	flds   0xe20
 1c0:	df 04 58             	filds  (%eax,%ebx,2)
  		for(i = start; i < end; i++){
 1c3:	83 c3 01             	add    $0x1,%ebx
 1c6:	39 de                	cmp    %ebx,%esi
  			float diff = (avg_global - (float)arr[i]);
 1c8:	d8 e9                	fsubr  %st(1),%st
  			partial_var +=  diff * diff;
 1ca:	d8 c8                	fmul   %st(0),%st
 1cc:	de c2                	faddp  %st,%st(2)
  		for(i = start; i < end; i++){
 1ce:	75 f0                	jne    1c0 <main+0x1c0>
 1d0:	dd d8                	fstp   %st(0)
 1d2:	d9 5d e4             	fstps  -0x1c(%ebp)
 1d5:	eb 02                	jmp    1d9 <main+0x1d9>
 1d7:	dd d8                	fstp   %st(0)
  		}

  		// pack the partial_var in msg
  		for(i = 0; i < 4; i++)
  			msg[i] = *((char*)&partial_var + i);
 1d9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
 1dd:	88 02                	mov    %al,(%edx)
 1df:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
 1e3:	88 42 01             	mov    %al,0x1(%edx)
 1e6:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
 1ea:	88 42 02             	mov    %al,0x2(%edx)
 1ed:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f1:	88 42 03             	mov    %al,0x3(%edx)

  		// send the partial var to the co-oridinator process
  		send(pid, par_pid, msg);
 1f4:	50                   	push   %eax
 1f5:	52                   	push   %edx
 1f6:	ff 75 cc             	pushl  -0x34(%ebp)
 1f9:	57                   	push   %edi
 1fa:	e8 73 04 00 00       	call   672 <send>
  		exit();
 1ff:	e8 ae 03 00 00       	call   5b2 <exit>
  	}
  	else{
  		// Parent : The coordinator Process
		int i;
		char *msg = (char *)malloc(MSGSIZE);
 204:	83 ec 0c             	sub    $0xc,%esp
	int tot_sum = 0;	
 207:	31 ff                	xor    %edi,%edi
		char *msg = (char *)malloc(MSGSIZE);
 209:	6a 08                	push   $0x8
 20b:	e8 a0 07 00 00       	call   9b0 <malloc>
 210:	89 c6                	mov    %eax,%esi
 212:	b8 08 00 00 00       	mov    $0x8,%eax
	int tot_sum = 0;	
 217:	89 5d c8             	mov    %ebx,-0x38(%ebp)
		char *msg = (char *)malloc(MSGSIZE);
 21a:	83 c4 10             	add    $0x10,%esp
	int tot_sum = 0;	
 21d:	89 c3                	mov    %eax,%ebx
 21f:	90                   	nop

  		for(i = 0; i < NO_CHILD; i++){
  			recv(msg);
 220:	83 ec 0c             	sub    $0xc,%esp
 223:	56                   	push   %esi
 224:	e8 51 04 00 00       	call   67a <recv>
  			tot_sum += *((int *)msg);
 229:	8b 06                	mov    (%esi),%eax
  		for(i = 0; i < NO_CHILD; i++){
 22b:	83 c4 10             	add    $0x10,%esp
  			tot_sum += *((int *)msg);
 22e:	01 f8                	add    %edi,%eax
  		for(i = 0; i < NO_CHILD; i++){
 230:	83 eb 01             	sub    $0x1,%ebx
  			tot_sum += *((int *)msg);
 233:	89 c7                	mov    %eax,%edi
  		for(i = 0; i < NO_CHILD; i++){
 235:	75 e9                	jne    220 <main+0x220>
 237:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  		}

  		float avg = (float)tot_sum/size;
 23a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 23d:	db 45 c8             	fildl  -0x38(%ebp)
 240:	89 45 bc             	mov    %eax,-0x44(%ebp)
 243:	d8 35 40 0b 00 00    	fdivs  0xb40
 249:	d9 5d e4             	fstps  -0x1c(%ebp)

  		for(i = 0; i < 4; i++)
  			msg[i] = *((char *)&avg + i);
 24c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
 250:	88 06                	mov    %al,(%esi)
 252:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
 256:	88 46 01             	mov    %al,0x1(%esi)
 259:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
 25d:	88 46 02             	mov    %al,0x2(%esi)
 260:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 264:	88 46 03             	mov    %al,0x3(%esi)

  		send_multi(par_pid, cid, msg, NO_CHILD);
 267:	6a 08                	push   $0x8
 269:	56                   	push   %esi
 26a:	53                   	push   %ebx
 26b:	bb 08 00 00 00       	mov    $0x8,%ebx
 270:	ff 75 cc             	pushl  -0x34(%ebp)
 273:	e8 2a 04 00 00       	call   6a2 <send_multi>
	float variance = 0.0;
 278:	d9 ee                	fldz   
  		send_multi(par_pid, cid, msg, NO_CHILD);
 27a:	83 c4 10             	add    $0x10,%esp
	float variance = 0.0;
 27d:	d9 5d cc             	fstps  -0x34(%ebp)

  		for(i = 0; i < NO_CHILD; i++){
  			recv(msg);
 280:	83 ec 0c             	sub    $0xc,%esp
 283:	56                   	push   %esi
 284:	e8 f1 03 00 00       	call   67a <recv>
  			variance += *((float *)msg);
 289:	d9 45 cc             	flds   -0x34(%ebp)
  		for(i = 0; i < NO_CHILD; i++){
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	83 eb 01             	sub    $0x1,%ebx
  			variance += *((float *)msg);
 292:	d8 06                	fadds  (%esi)
 294:	d9 5d cc             	fstps  -0x34(%ebp)
  		for(i = 0; i < NO_CHILD; i++){
 297:	75 e7                	jne    280 <main+0x280>
  		}

  		variance /= (float)size;
  		for(i = 0; i < NO_CHILD; i++)
  			wait();
 299:	e8 1c 03 00 00       	call   5ba <wait>
 29e:	e8 17 03 00 00       	call   5ba <wait>
 2a3:	e8 12 03 00 00       	call   5ba <wait>
 2a8:	e8 0d 03 00 00       	call   5ba <wait>
 2ad:	e8 08 03 00 00       	call   5ba <wait>
 2b2:	e8 03 03 00 00       	call   5ba <wait>
 2b7:	e8 fe 02 00 00       	call   5ba <wait>
 2bc:	e8 f9 02 00 00       	call   5ba <wait>
  	}

  	//------------------

  	if(type==0){ //unicast sum
 2c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 2c5:	74 4e                	je     315 <main+0x315>
  		variance /= (float)size;
 2c7:	d9 45 cc             	flds   -0x34(%ebp)
		printf(1,"Sum of array for file %s is %d\n", filename, tot_sum);
    // printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
	}
	else{ //mulicast variance
		printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
 2ca:	d9 7d d6             	fnstcw -0x2a(%ebp)
 2cd:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  		variance /= (float)size;
 2d1:	d8 35 40 0b 00 00    	fdivs  0xb40
		printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
 2d7:	80 cc 0c             	or     $0xc,%ah
 2da:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
 2de:	d9 6d d4             	fldcw  -0x2c(%ebp)
 2e1:	db 5d d0             	fistpl -0x30(%ebp)
 2e4:	d9 6d d6             	fldcw  -0x2a(%ebp)
 2e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2ea:	50                   	push   %eax
 2eb:	ff 75 c0             	pushl  -0x40(%ebp)
 2ee:	68 18 0b 00 00       	push   $0xb18
 2f3:	6a 01                	push   $0x1
 2f5:	e8 56 04 00 00       	call   750 <printf>
 2fa:	83 c4 10             	add    $0x10,%esp
	}
	exit();
 2fd:	e8 b0 02 00 00       	call   5b2 <exit>
		printf(1,"Need type and input filename\n");
 302:	50                   	push   %eax
 303:	50                   	push   %eax
 304:	68 a8 0a 00 00       	push   $0xaa8
 309:	6a 01                	push   $0x1
 30b:	e8 40 04 00 00       	call   750 <printf>
		exit();
 310:	e8 9d 02 00 00       	call   5b2 <exit>
		printf(1,"Sum of array for file %s is %d\n", filename, tot_sum);
 315:	ff 75 bc             	pushl  -0x44(%ebp)
 318:	ff 75 c0             	pushl  -0x40(%ebp)
 31b:	68 f8 0a 00 00       	push   $0xaf8
 320:	6a 01                	push   $0x1
 322:	e8 29 04 00 00       	call   750 <printf>
 327:	83 c4 10             	add    $0x10,%esp
 32a:	eb d1                	jmp    2fd <main+0x2fd>
  			end = size;
 32c:	be e8 03 00 00       	mov    $0x3e8,%esi
 331:	e9 0d fe ff ff       	jmp    143 <main+0x143>
 336:	66 90                	xchg   %ax,%ax
 338:	66 90                	xchg   %ax,%ax
 33a:	66 90                	xchg   %ax,%ax
 33c:	66 90                	xchg   %ax,%ax
 33e:	66 90                	xchg   %ax,%ax

00000340 <sig_handler>:
void sig_handler(void *msg){
 340:	55                   	push   %ebp
	flag_handler  = 1;
 341:	c7 05 1c 0e 00 00 01 	movl   $0x1,0xe1c
 348:	00 00 00 
void sig_handler(void *msg){
 34b:	89 e5                	mov    %esp,%ebp
	avg_global = *((float *)msg);
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 350:	5d                   	pop    %ebp
	avg_global = *((float *)msg);
 351:	d9 00                	flds   (%eax)
 353:	d9 1d 20 0e 00 00    	fstps  0xe20
}
 359:	c3                   	ret    
 35a:	66 90                	xchg   %ax,%ax
 35c:	66 90                	xchg   %ax,%ax
 35e:	66 90                	xchg   %ax,%ax

00000360 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 36a:	89 c2                	mov    %eax,%edx
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 370:	83 c1 01             	add    $0x1,%ecx
 373:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 377:	83 c2 01             	add    $0x1,%edx
 37a:	84 db                	test   %bl,%bl
 37c:	88 5a ff             	mov    %bl,-0x1(%edx)
 37f:	75 ef                	jne    370 <strcpy+0x10>
    ;
  return os;
}
 381:	5b                   	pop    %ebx
 382:	5d                   	pop    %ebp
 383:	c3                   	ret    
 384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 38a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 55 08             	mov    0x8(%ebp),%edx
 397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 39a:	0f b6 02             	movzbl (%edx),%eax
 39d:	0f b6 19             	movzbl (%ecx),%ebx
 3a0:	84 c0                	test   %al,%al
 3a2:	75 1c                	jne    3c0 <strcmp+0x30>
 3a4:	eb 2a                	jmp    3d0 <strcmp+0x40>
 3a6:	8d 76 00             	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3b6:	83 c1 01             	add    $0x1,%ecx
 3b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 3bc:	84 c0                	test   %al,%al
 3be:	74 10                	je     3d0 <strcmp+0x40>
 3c0:	38 d8                	cmp    %bl,%al
 3c2:	74 ec                	je     3b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3c4:	29 d8                	sub    %ebx,%eax
}
 3c6:	5b                   	pop    %ebx
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3d2:	29 d8                	sub    %ebx,%eax
}
 3d4:	5b                   	pop    %ebx
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strlen>:

uint
strlen(const char *s)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3e6:	80 39 00             	cmpb   $0x0,(%ecx)
 3e9:	74 15                	je     400 <strlen+0x20>
 3eb:	31 d2                	xor    %edx,%edx
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
 3f0:	83 c2 01             	add    $0x1,%edx
 3f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3f7:	89 d0                	mov    %edx,%eax
 3f9:	75 f5                	jne    3f0 <strlen+0x10>
    ;
  return n;
}
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 400:	31 c0                	xor    %eax,%eax
}
 402:	5d                   	pop    %ebp
 403:	c3                   	ret    
 404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 40a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000410 <memset>:

void*
memset(void *dst, int c, uint n)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 417:	8b 4d 10             	mov    0x10(%ebp),%ecx
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	89 d7                	mov    %edx,%edi
 41f:	fc                   	cld    
 420:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 422:	89 d0                	mov    %edx,%eax
 424:	5f                   	pop    %edi
 425:	5d                   	pop    %ebp
 426:	c3                   	ret    
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <strchr>:

char*
strchr(const char *s, char c)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 43a:	0f b6 10             	movzbl (%eax),%edx
 43d:	84 d2                	test   %dl,%dl
 43f:	74 1d                	je     45e <strchr+0x2e>
    if(*s == c)
 441:	38 d3                	cmp    %dl,%bl
 443:	89 d9                	mov    %ebx,%ecx
 445:	75 0d                	jne    454 <strchr+0x24>
 447:	eb 17                	jmp    460 <strchr+0x30>
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 450:	38 ca                	cmp    %cl,%dl
 452:	74 0c                	je     460 <strchr+0x30>
  for(; *s; s++)
 454:	83 c0 01             	add    $0x1,%eax
 457:	0f b6 10             	movzbl (%eax),%edx
 45a:	84 d2                	test   %dl,%dl
 45c:	75 f2                	jne    450 <strchr+0x20>
      return (char*)s;
  return 0;
 45e:	31 c0                	xor    %eax,%eax
}
 460:	5b                   	pop    %ebx
 461:	5d                   	pop    %ebp
 462:	c3                   	ret    
 463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <gets>:

char*
gets(char *buf, int max)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 476:	31 f6                	xor    %esi,%esi
 478:	89 f3                	mov    %esi,%ebx
{
 47a:	83 ec 1c             	sub    $0x1c,%esp
 47d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 480:	eb 2f                	jmp    4b1 <gets+0x41>
 482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 488:	8d 45 e7             	lea    -0x19(%ebp),%eax
 48b:	83 ec 04             	sub    $0x4,%esp
 48e:	6a 01                	push   $0x1
 490:	50                   	push   %eax
 491:	6a 00                	push   $0x0
 493:	e8 32 01 00 00       	call   5ca <read>
    if(cc < 1)
 498:	83 c4 10             	add    $0x10,%esp
 49b:	85 c0                	test   %eax,%eax
 49d:	7e 1c                	jle    4bb <gets+0x4b>
      break;
    buf[i++] = c;
 49f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4a3:	83 c7 01             	add    $0x1,%edi
 4a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4a9:	3c 0a                	cmp    $0xa,%al
 4ab:	74 23                	je     4d0 <gets+0x60>
 4ad:	3c 0d                	cmp    $0xd,%al
 4af:	74 1f                	je     4d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 4b1:	83 c3 01             	add    $0x1,%ebx
 4b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4b7:	89 fe                	mov    %edi,%esi
 4b9:	7c cd                	jl     488 <gets+0x18>
 4bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c6:	5b                   	pop    %ebx
 4c7:	5e                   	pop    %esi
 4c8:	5f                   	pop    %edi
 4c9:	5d                   	pop    %ebp
 4ca:	c3                   	ret    
 4cb:	90                   	nop
 4cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4d0:	8b 75 08             	mov    0x8(%ebp),%esi
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	01 de                	add    %ebx,%esi
 4d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4da:	c6 03 00             	movb   $0x0,(%ebx)
}
 4dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e0:	5b                   	pop    %ebx
 4e1:	5e                   	pop    %esi
 4e2:	5f                   	pop    %edi
 4e3:	5d                   	pop    %ebp
 4e4:	c3                   	ret    
 4e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f5:	83 ec 08             	sub    $0x8,%esp
 4f8:	6a 00                	push   $0x0
 4fa:	ff 75 08             	pushl  0x8(%ebp)
 4fd:	e8 f0 00 00 00       	call   5f2 <open>
  if(fd < 0)
 502:	83 c4 10             	add    $0x10,%esp
 505:	85 c0                	test   %eax,%eax
 507:	78 27                	js     530 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 509:	83 ec 08             	sub    $0x8,%esp
 50c:	ff 75 0c             	pushl  0xc(%ebp)
 50f:	89 c3                	mov    %eax,%ebx
 511:	50                   	push   %eax
 512:	e8 f3 00 00 00       	call   60a <fstat>
  close(fd);
 517:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 51a:	89 c6                	mov    %eax,%esi
  close(fd);
 51c:	e8 b9 00 00 00       	call   5da <close>
  return r;
 521:	83 c4 10             	add    $0x10,%esp
}
 524:	8d 65 f8             	lea    -0x8(%ebp),%esp
 527:	89 f0                	mov    %esi,%eax
 529:	5b                   	pop    %ebx
 52a:	5e                   	pop    %esi
 52b:	5d                   	pop    %ebp
 52c:	c3                   	ret    
 52d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 530:	be ff ff ff ff       	mov    $0xffffffff,%esi
 535:	eb ed                	jmp    524 <stat+0x34>
 537:	89 f6                	mov    %esi,%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000540 <atoi>:

int
atoi(const char *s)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	53                   	push   %ebx
 544:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 547:	0f be 11             	movsbl (%ecx),%edx
 54a:	8d 42 d0             	lea    -0x30(%edx),%eax
 54d:	3c 09                	cmp    $0x9,%al
  n = 0;
 54f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 554:	77 1f                	ja     575 <atoi+0x35>
 556:	8d 76 00             	lea    0x0(%esi),%esi
 559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 560:	8d 04 80             	lea    (%eax,%eax,4),%eax
 563:	83 c1 01             	add    $0x1,%ecx
 566:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 56a:	0f be 11             	movsbl (%ecx),%edx
 56d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 570:	80 fb 09             	cmp    $0x9,%bl
 573:	76 eb                	jbe    560 <atoi+0x20>
  return n;
}
 575:	5b                   	pop    %ebx
 576:	5d                   	pop    %ebp
 577:	c3                   	ret    
 578:	90                   	nop
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000580 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	56                   	push   %esi
 584:	53                   	push   %ebx
 585:	8b 5d 10             	mov    0x10(%ebp),%ebx
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 58e:	85 db                	test   %ebx,%ebx
 590:	7e 14                	jle    5a6 <memmove+0x26>
 592:	31 d2                	xor    %edx,%edx
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 598:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 59c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 59f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5a2:	39 d3                	cmp    %edx,%ebx
 5a4:	75 f2                	jne    598 <memmove+0x18>
  return vdst;
}
 5a6:	5b                   	pop    %ebx
 5a7:	5e                   	pop    %esi
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret    

000005aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5aa:	b8 01 00 00 00       	mov    $0x1,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <exit>:
SYSCALL(exit)
 5b2:	b8 02 00 00 00       	mov    $0x2,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <wait>:
SYSCALL(wait)
 5ba:	b8 03 00 00 00       	mov    $0x3,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <pipe>:
SYSCALL(pipe)
 5c2:	b8 04 00 00 00       	mov    $0x4,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <read>:
SYSCALL(read)
 5ca:	b8 05 00 00 00       	mov    $0x5,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <write>:
SYSCALL(write)
 5d2:	b8 10 00 00 00       	mov    $0x10,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <close>:
SYSCALL(close)
 5da:	b8 15 00 00 00       	mov    $0x15,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <kill>:
SYSCALL(kill)
 5e2:	b8 06 00 00 00       	mov    $0x6,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <exec>:
SYSCALL(exec)
 5ea:	b8 07 00 00 00       	mov    $0x7,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <open>:
SYSCALL(open)
 5f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mknod>:
SYSCALL(mknod)
 5fa:	b8 11 00 00 00       	mov    $0x11,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <unlink>:
SYSCALL(unlink)
 602:	b8 12 00 00 00       	mov    $0x12,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <fstat>:
SYSCALL(fstat)
 60a:	b8 08 00 00 00       	mov    $0x8,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <link>:
SYSCALL(link)
 612:	b8 13 00 00 00       	mov    $0x13,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mkdir>:
SYSCALL(mkdir)
 61a:	b8 14 00 00 00       	mov    $0x14,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <chdir>:
SYSCALL(chdir)
 622:	b8 09 00 00 00       	mov    $0x9,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <dup>:
SYSCALL(dup)
 62a:	b8 0a 00 00 00       	mov    $0xa,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <getpid>:
SYSCALL(getpid)
 632:	b8 0b 00 00 00       	mov    $0xb,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <sbrk>:
SYSCALL(sbrk)
 63a:	b8 0c 00 00 00       	mov    $0xc,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <sleep>:
SYSCALL(sleep)
 642:	b8 0d 00 00 00       	mov    $0xd,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <uptime>:
SYSCALL(uptime)
 64a:	b8 0e 00 00 00       	mov    $0xe,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <print_count>:
SYSCALL(print_count)
 652:	b8 16 00 00 00       	mov    $0x16,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <toggle>:
SYSCALL(toggle)
 65a:	b8 17 00 00 00       	mov    $0x17,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <add>:
SYSCALL(add)
 662:	b8 18 00 00 00       	mov    $0x18,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <ps>:
SYSCALL(ps)
 66a:	b8 19 00 00 00       	mov    $0x19,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <send>:
SYSCALL(send)
 672:	b8 1a 00 00 00       	mov    $0x1a,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <recv>:
SYSCALL(recv)
 67a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <sig_set>:
SYSCALL(sig_set)
 682:	b8 1d 00 00 00       	mov    $0x1d,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <sig_send>:
SYSCALL(sig_send)
 68a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <sig_pause>:
SYSCALL(sig_pause)
 692:	b8 1f 00 00 00       	mov    $0x1f,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <sig_ret>:
SYSCALL(sig_ret)
 69a:	b8 20 00 00 00       	mov    $0x20,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <send_multi>:
 6a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    
 6aa:	66 90                	xchg   %ax,%ax
 6ac:	66 90                	xchg   %ax,%ax
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6b9:	85 d2                	test   %edx,%edx
{
 6bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6be:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6c0:	79 76                	jns    738 <printint+0x88>
 6c2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6c6:	74 70                	je     738 <printint+0x88>
    x = -xx;
 6c8:	f7 d8                	neg    %eax
    neg = 1;
 6ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6d1:	31 f6                	xor    %esi,%esi
 6d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6d6:	eb 0a                	jmp    6e2 <printint+0x32>
 6d8:	90                   	nop
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 6e0:	89 fe                	mov    %edi,%esi
 6e2:	31 d2                	xor    %edx,%edx
 6e4:	8d 7e 01             	lea    0x1(%esi),%edi
 6e7:	f7 f1                	div    %ecx
 6e9:	0f b6 92 4c 0b 00 00 	movzbl 0xb4c(%edx),%edx
  }while((x /= base) != 0);
 6f0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 6f2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 6f5:	75 e9                	jne    6e0 <printint+0x30>
  if(neg)
 6f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6fa:	85 c0                	test   %eax,%eax
 6fc:	74 08                	je     706 <printint+0x56>
    buf[i++] = '-';
 6fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 703:	8d 7e 02             	lea    0x2(%esi),%edi
 706:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 70a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 70d:	8d 76 00             	lea    0x0(%esi),%esi
 710:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
 716:	83 ee 01             	sub    $0x1,%esi
 719:	6a 01                	push   $0x1
 71b:	53                   	push   %ebx
 71c:	57                   	push   %edi
 71d:	88 45 d7             	mov    %al,-0x29(%ebp)
 720:	e8 ad fe ff ff       	call   5d2 <write>

  while(--i >= 0)
 725:	83 c4 10             	add    $0x10,%esp
 728:	39 de                	cmp    %ebx,%esi
 72a:	75 e4                	jne    710 <printint+0x60>
    putc(fd, buf[i]);
}
 72c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72f:	5b                   	pop    %ebx
 730:	5e                   	pop    %esi
 731:	5f                   	pop    %edi
 732:	5d                   	pop    %ebp
 733:	c3                   	ret    
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 738:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 73f:	eb 90                	jmp    6d1 <printint+0x21>
 741:	eb 0d                	jmp    750 <printf>
 743:	90                   	nop
 744:	90                   	nop
 745:	90                   	nop
 746:	90                   	nop
 747:	90                   	nop
 748:	90                   	nop
 749:	90                   	nop
 74a:	90                   	nop
 74b:	90                   	nop
 74c:	90                   	nop
 74d:	90                   	nop
 74e:	90                   	nop
 74f:	90                   	nop

00000750 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 759:	8b 75 0c             	mov    0xc(%ebp),%esi
 75c:	0f b6 1e             	movzbl (%esi),%ebx
 75f:	84 db                	test   %bl,%bl
 761:	0f 84 b3 00 00 00    	je     81a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 767:	8d 45 10             	lea    0x10(%ebp),%eax
 76a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 76d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 76f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 772:	eb 2f                	jmp    7a3 <printf+0x53>
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 778:	83 f8 25             	cmp    $0x25,%eax
 77b:	0f 84 a7 00 00 00    	je     828 <printf+0xd8>
  write(fd, &c, 1);
 781:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 784:	83 ec 04             	sub    $0x4,%esp
 787:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 78a:	6a 01                	push   $0x1
 78c:	50                   	push   %eax
 78d:	ff 75 08             	pushl  0x8(%ebp)
 790:	e8 3d fe ff ff       	call   5d2 <write>
 795:	83 c4 10             	add    $0x10,%esp
 798:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 79b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 79f:	84 db                	test   %bl,%bl
 7a1:	74 77                	je     81a <printf+0xca>
    if(state == 0){
 7a3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7a5:	0f be cb             	movsbl %bl,%ecx
 7a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7ab:	74 cb                	je     778 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7ad:	83 ff 25             	cmp    $0x25,%edi
 7b0:	75 e6                	jne    798 <printf+0x48>
      if(c == 'd'){
 7b2:	83 f8 64             	cmp    $0x64,%eax
 7b5:	0f 84 05 01 00 00    	je     8c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7c1:	83 f9 70             	cmp    $0x70,%ecx
 7c4:	74 72                	je     838 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7c6:	83 f8 73             	cmp    $0x73,%eax
 7c9:	0f 84 99 00 00 00    	je     868 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7cf:	83 f8 63             	cmp    $0x63,%eax
 7d2:	0f 84 08 01 00 00    	je     8e0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7d8:	83 f8 25             	cmp    $0x25,%eax
 7db:	0f 84 ef 00 00 00    	je     8d0 <printf+0x180>
  write(fd, &c, 1);
 7e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7e4:	83 ec 04             	sub    $0x4,%esp
 7e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7eb:	6a 01                	push   $0x1
 7ed:	50                   	push   %eax
 7ee:	ff 75 08             	pushl  0x8(%ebp)
 7f1:	e8 dc fd ff ff       	call   5d2 <write>
 7f6:	83 c4 0c             	add    $0xc,%esp
 7f9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7ff:	6a 01                	push   $0x1
 801:	50                   	push   %eax
 802:	ff 75 08             	pushl  0x8(%ebp)
 805:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 808:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 80a:	e8 c3 fd ff ff       	call   5d2 <write>
  for(i = 0; fmt[i]; i++){
 80f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 813:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 816:	84 db                	test   %bl,%bl
 818:	75 89                	jne    7a3 <printf+0x53>
    }
  }
}
 81a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 81d:	5b                   	pop    %ebx
 81e:	5e                   	pop    %esi
 81f:	5f                   	pop    %edi
 820:	5d                   	pop    %ebp
 821:	c3                   	ret    
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 828:	bf 25 00 00 00       	mov    $0x25,%edi
 82d:	e9 66 ff ff ff       	jmp    798 <printf+0x48>
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 838:	83 ec 0c             	sub    $0xc,%esp
 83b:	b9 10 00 00 00       	mov    $0x10,%ecx
 840:	6a 00                	push   $0x0
 842:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	8b 17                	mov    (%edi),%edx
 84a:	e8 61 fe ff ff       	call   6b0 <printint>
        ap++;
 84f:	89 f8                	mov    %edi,%eax
 851:	83 c4 10             	add    $0x10,%esp
      state = 0;
 854:	31 ff                	xor    %edi,%edi
        ap++;
 856:	83 c0 04             	add    $0x4,%eax
 859:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 85c:	e9 37 ff ff ff       	jmp    798 <printf+0x48>
 861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 86b:	8b 08                	mov    (%eax),%ecx
        ap++;
 86d:	83 c0 04             	add    $0x4,%eax
 870:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 873:	85 c9                	test   %ecx,%ecx
 875:	0f 84 8e 00 00 00    	je     909 <printf+0x1b9>
        while(*s != 0){
 87b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 87e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 880:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 882:	84 c0                	test   %al,%al
 884:	0f 84 0e ff ff ff    	je     798 <printf+0x48>
 88a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 88d:	89 de                	mov    %ebx,%esi
 88f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 892:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 895:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 898:	83 ec 04             	sub    $0x4,%esp
          s++;
 89b:	83 c6 01             	add    $0x1,%esi
 89e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8a1:	6a 01                	push   $0x1
 8a3:	57                   	push   %edi
 8a4:	53                   	push   %ebx
 8a5:	e8 28 fd ff ff       	call   5d2 <write>
        while(*s != 0){
 8aa:	0f b6 06             	movzbl (%esi),%eax
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	84 c0                	test   %al,%al
 8b2:	75 e4                	jne    898 <printf+0x148>
 8b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8b7:	31 ff                	xor    %edi,%edi
 8b9:	e9 da fe ff ff       	jmp    798 <printf+0x48>
 8be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8c0:	83 ec 0c             	sub    $0xc,%esp
 8c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8c8:	6a 01                	push   $0x1
 8ca:	e9 73 ff ff ff       	jmp    842 <printf+0xf2>
 8cf:	90                   	nop
  write(fd, &c, 1);
 8d0:	83 ec 04             	sub    $0x4,%esp
 8d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8d9:	6a 01                	push   $0x1
 8db:	e9 21 ff ff ff       	jmp    801 <printf+0xb1>
        putc(fd, *ap);
 8e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 8e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8e6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 8e8:	6a 01                	push   $0x1
        ap++;
 8ea:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 8ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 8f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8f3:	50                   	push   %eax
 8f4:	ff 75 08             	pushl  0x8(%ebp)
 8f7:	e8 d6 fc ff ff       	call   5d2 <write>
        ap++;
 8fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8ff:	83 c4 10             	add    $0x10,%esp
      state = 0;
 902:	31 ff                	xor    %edi,%edi
 904:	e9 8f fe ff ff       	jmp    798 <printf+0x48>
          s = "(null)";
 909:	bb 44 0b 00 00       	mov    $0xb44,%ebx
        while(*s != 0){
 90e:	b8 28 00 00 00       	mov    $0x28,%eax
 913:	e9 72 ff ff ff       	jmp    88a <printf+0x13a>
 918:	66 90                	xchg   %ax,%ax
 91a:	66 90                	xchg   %ax,%ax
 91c:	66 90                	xchg   %ax,%ax
 91e:	66 90                	xchg   %ax,%ax

00000920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 920:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 921:	a1 24 0e 00 00       	mov    0xe24,%eax
{
 926:	89 e5                	mov    %esp,%ebp
 928:	57                   	push   %edi
 929:	56                   	push   %esi
 92a:	53                   	push   %ebx
 92b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 92e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	39 c8                	cmp    %ecx,%eax
 93a:	8b 10                	mov    (%eax),%edx
 93c:	73 32                	jae    970 <free+0x50>
 93e:	39 d1                	cmp    %edx,%ecx
 940:	72 04                	jb     946 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	39 d0                	cmp    %edx,%eax
 944:	72 32                	jb     978 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 946:	8b 73 fc             	mov    -0x4(%ebx),%esi
 949:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 94c:	39 fa                	cmp    %edi,%edx
 94e:	74 30                	je     980 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 950:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 953:	8b 50 04             	mov    0x4(%eax),%edx
 956:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 959:	39 f1                	cmp    %esi,%ecx
 95b:	74 3a                	je     997 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 95d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 95f:	a3 24 0e 00 00       	mov    %eax,0xe24
}
 964:	5b                   	pop    %ebx
 965:	5e                   	pop    %esi
 966:	5f                   	pop    %edi
 967:	5d                   	pop    %ebp
 968:	c3                   	ret    
 969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	39 d0                	cmp    %edx,%eax
 972:	72 04                	jb     978 <free+0x58>
 974:	39 d1                	cmp    %edx,%ecx
 976:	72 ce                	jb     946 <free+0x26>
{
 978:	89 d0                	mov    %edx,%eax
 97a:	eb bc                	jmp    938 <free+0x18>
 97c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 980:	03 72 04             	add    0x4(%edx),%esi
 983:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 12                	mov    (%edx),%edx
 98a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 98d:	8b 50 04             	mov    0x4(%eax),%edx
 990:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 993:	39 f1                	cmp    %esi,%ecx
 995:	75 c6                	jne    95d <free+0x3d>
    p->s.size += bp->s.size;
 997:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 99a:	a3 24 0e 00 00       	mov    %eax,0xe24
    p->s.size += bp->s.size;
 99f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9a5:	89 10                	mov    %edx,(%eax)
}
 9a7:	5b                   	pop    %ebx
 9a8:	5e                   	pop    %esi
 9a9:	5f                   	pop    %edi
 9aa:	5d                   	pop    %ebp
 9ab:	c3                   	ret    
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	57                   	push   %edi
 9b4:	56                   	push   %esi
 9b5:	53                   	push   %ebx
 9b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9bc:	8b 15 24 0e 00 00    	mov    0xe24,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c2:	8d 78 07             	lea    0x7(%eax),%edi
 9c5:	c1 ef 03             	shr    $0x3,%edi
 9c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9cb:	85 d2                	test   %edx,%edx
 9cd:	0f 84 9d 00 00 00    	je     a70 <malloc+0xc0>
 9d3:	8b 02                	mov    (%edx),%eax
 9d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9d8:	39 cf                	cmp    %ecx,%edi
 9da:	76 6c                	jbe    a48 <malloc+0x98>
 9dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9e7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9f1:	eb 0e                	jmp    a01 <malloc+0x51>
 9f3:	90                   	nop
 9f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9fa:	8b 48 04             	mov    0x4(%eax),%ecx
 9fd:	39 f9                	cmp    %edi,%ecx
 9ff:	73 47                	jae    a48 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a01:	39 05 24 0e 00 00    	cmp    %eax,0xe24
 a07:	89 c2                	mov    %eax,%edx
 a09:	75 ed                	jne    9f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a0b:	83 ec 0c             	sub    $0xc,%esp
 a0e:	56                   	push   %esi
 a0f:	e8 26 fc ff ff       	call   63a <sbrk>
  if(p == (char*)-1)
 a14:	83 c4 10             	add    $0x10,%esp
 a17:	83 f8 ff             	cmp    $0xffffffff,%eax
 a1a:	74 1c                	je     a38 <malloc+0x88>
  hp->s.size = nu;
 a1c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a1f:	83 ec 0c             	sub    $0xc,%esp
 a22:	83 c0 08             	add    $0x8,%eax
 a25:	50                   	push   %eax
 a26:	e8 f5 fe ff ff       	call   920 <free>
  return freep;
 a2b:	8b 15 24 0e 00 00    	mov    0xe24,%edx
      if((p = morecore(nunits)) == 0)
 a31:	83 c4 10             	add    $0x10,%esp
 a34:	85 d2                	test   %edx,%edx
 a36:	75 c0                	jne    9f8 <malloc+0x48>
        return 0;
  }
}
 a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a3b:	31 c0                	xor    %eax,%eax
}
 a3d:	5b                   	pop    %ebx
 a3e:	5e                   	pop    %esi
 a3f:	5f                   	pop    %edi
 a40:	5d                   	pop    %ebp
 a41:	c3                   	ret    
 a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a48:	39 cf                	cmp    %ecx,%edi
 a4a:	74 54                	je     aa0 <malloc+0xf0>
        p->s.size -= nunits;
 a4c:	29 f9                	sub    %edi,%ecx
 a4e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a51:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a54:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a57:	89 15 24 0e 00 00    	mov    %edx,0xe24
}
 a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a60:	83 c0 08             	add    $0x8,%eax
}
 a63:	5b                   	pop    %ebx
 a64:	5e                   	pop    %esi
 a65:	5f                   	pop    %edi
 a66:	5d                   	pop    %ebp
 a67:	c3                   	ret    
 a68:	90                   	nop
 a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a70:	c7 05 24 0e 00 00 28 	movl   $0xe28,0xe24
 a77:	0e 00 00 
 a7a:	c7 05 28 0e 00 00 28 	movl   $0xe28,0xe28
 a81:	0e 00 00 
    base.s.size = 0;
 a84:	b8 28 0e 00 00       	mov    $0xe28,%eax
 a89:	c7 05 2c 0e 00 00 00 	movl   $0x0,0xe2c
 a90:	00 00 00 
 a93:	e9 44 ff ff ff       	jmp    9dc <malloc+0x2c>
 a98:	90                   	nop
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 aa0:	8b 08                	mov    (%eax),%ecx
 aa2:	89 0a                	mov    %ecx,(%edx)
 aa4:	eb b1                	jmp    a57 <malloc+0xa7>
