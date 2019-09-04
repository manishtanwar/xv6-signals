#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8
#define NN 1
volatile int fun_called;
int cid[NN];
int child_no;
int i, gol;
void fun(void *a){
	int *b = (int *)a;
	gol += *b;
	fun_called++;
	printf(1, "%d, %d\n",b[0],b[1]);
}

int main(void)
{	
	sig_set(1,&fun);

	for(i=0;i<NN;i++)
		cid[i] = -1;

	fun_called = 0;
	for(i=0;i<NN;i++){
		cid[i] = fork();
		if(cid[i] == 0) {child_no = i; break;}
	}

	if(cid[NN-1] <= 0){
		sleep(500);
		// if(fun_called <= 9) sig_pause();
		printf(1, "%d\n", gol);
		exit();
	}else{
		int a[10][2];
		for(i=0;i<10;i++)
			a[i][0] = i+1, a[i][1] = -(i+1);

		for(i=0;i<NN;i++){
			int j;
			for(j=0;j<10;j++){
				char *msg_child;
				msg_child = (char *)a[j];

				sig_send(cid[i], 1, (void *)msg_child);
				free(msg_child);
			}
		}

		for(i=0;i<NN;i++)
			wait();
	}
	
	exit();
}