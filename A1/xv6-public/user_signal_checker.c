#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8
int fun_called = 0;
void fun(void *a){
	char *b = (char *)a;
	fun_called = 1;
	printf(1, "Here we are : %s %d\n",b,fun_called);
	int aa = getpid();
	printf(1, "%d\n", aa);
}

int main(void)
{	
	int a = sig_set(0,&fun);
	a++;
	// printf(1, "set_code,pid : %d %d\n", a, par_pid);
	int cid = fork();
	if(cid==0){

		if(fun_called == 0) sig_pause();
		int a = 13;
		printf(1,"%d\n",a);
		exit();
	}else{
		// This is parent

		char *msg_child = (char *)malloc(MSGSIZE);
		msg_child = "DoDoned";
		sig_send(cid,0,(void *)msg_child);
		msg_child = "Dasdk";
		sig_send(cid,0,(void *)msg_child);
		free(msg_child);

		wait();
	}
	
	exit();
}