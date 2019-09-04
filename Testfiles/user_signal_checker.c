#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8
#define NN 20
volatile int fun_called;
int cid[NN];
int child_no;
int i;
void fun(void *a){
	// int *b = (int *)a;
	fun_called = 1;
	// printf(1, "Child %dth : %d, %d\n",child_no,b[0],b[1]);
	// printf(1, "%d\n",i+1);
}

void fun1(void *a){
	// char *b = (char *)a;
	fun_called = 1;
	// printf(1, "Child %dth : %s\n",child_no,b);
}

int main(void)
{	
	while(sig_set(0,&fun1) < 0);
	while(sig_set(1,&fun) < 0);

	for(i=0;i<NN;i++)
		cid[i] = -1;

	fun_called = 0;

	// printf(1, "par1 : %d\n",getpid());

	for(i=0;i<NN;i++){
		cid[i] = fork();
		if(cid[i] == 0) {child_no = i; break;}
	}

	if(cid[NN-1] <= 0){
		// if(fun_called == 0) sig_pause();
		// while(fun_called == 0);
		// printf(1,"cc: %d\n",i+1);
		exit();
	}else{
		// This is parent
		// printf(1, "par2 : %d\n",getpid());

		// char *msg = "HeyGuys";
		// send_multi(getpid(), cid, msg, n);0.
		// sleep(20);

		int a[NN][2];
		for(i=0;i<NN;i++)
			a[i][0] = i+1, a[i][1] = -(i+1);

		for(i=0;i<NN;i++){
			char *msg_child;
			msg_child = (char *)a[i];

			sig_send(cid[i], 1, (void *)msg_child);
			free(msg_child);
			// sleep(20);
		}

		// printf(1, "Parent\n");
		for(i=0;i<NN;i++)
			wait();
	}
	
	exit();
}