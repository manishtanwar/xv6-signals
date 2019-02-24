#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8
int fun_called[15], cid[15];
int child_no;

void fun(void *a){
	int *b = (int *)a;
	fun_called[child_no] = 1;
	printf(1, "Child %dth : %d, %d\n",child_no,b[0],b[1]);
}

int main(void)
{	
	while(sig_set(0,&fun) < 0);

	int i;
	for(i=0;i<15;i++)
		cid[i] = -1;

	for(i=0;i<15;i++){
		cid[i] = fork();
		if(cid[i] == 0) goto children;
	}


	if(cid[0]==0){
		children:
		child_no = i;
		if(fun_called[i] == 0) sig_pause();
		printf(1,"%dth child ended\n",i+1);
		exit();
	}else{
		// This is parent

		int a[15][2];
		for(i=0;i<15;i++)
			a[i][0] = i+1, a[i][1] = -(i+1);

		for(i=0;i<15;i++){
			char *msg_child;
			msg_child = (char *)a[i];

			sig_send(cid[i], 0, (void *)msg_child);
			free(msg_child);
			sleep(20);
		}

		for(i=0;i<15;i++)
			wait();
	}
	
	exit();
}