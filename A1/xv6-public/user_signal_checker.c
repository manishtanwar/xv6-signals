#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8
int fun_called;
void fun(void *a){
	char *b = (char *)a;
	fun_called = 1;
	printf(1, "Here we are : %s\n",b);
}

int main(void)
{	
	int a = sig_set(0,&fun);
	printf(1, "set_code : %d\n", a);
	int par_pid = getpid();
	int cid = fork();
	if(cid==0){
		char *msg_child = (char *)malloc(MSGSIZE);
		msg_child = "DoDoned";
		int a = sig_send(par_pid,0,(void *)msg_child);
		printf(1, "send_code : %d\n", a);
		free(msg_child);
		exit();
	}else{
		// This is parent
		printf(1, "pausing\n");
		int b = 0;
		if(fun_called == 0) sig_pause();
		printf(1, "pause_code : %d\n", b);
		int c = wait();
		printf(1, "wait_code : %d %d\n", c, fun_called);
	}
	
	exit();
}