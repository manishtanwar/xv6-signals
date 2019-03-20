#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

// msg types:
#define REQUEST 		1
#define INQUIRE 		2
#define LOCKED 			3
#define RELEASE 		4
#define RELINQUISH		5
#define FAILED 			6
#define IAMDONE			7
#define KILL			8
#define LOCKED_ELE  	9

// status type:
#define ST_UNKNOWN		1
#define ST_FAILED		2
#define ST_LOCKED		3

// state type:
#define UNLOCKED_STATE 	1
#define LOCKED_STATE 	2

// Datatypes:
typedef struct msg
{
	int type;
	int pid;
	int timestamp;
}msg;

typedef struct priority_queue
{
	msg *arr;
	int size;
}priority_queue;

void allocQueue(priority_queue *q, int size){
	q->size = 0;
	q->arr = (msg *)malloc(size * sizeof(msg));
}

// process index
int pid = -1;
// input
int P,P1,P2,P3;
int sqrtP = 0;

// subset of each process
int lSi;
int *status;

int main(int argc, char *argv[])
{
	int i,j;
	scanf("%d%d%d%d",&P,&P1,&P2,&P3);
	while(sqrtP++){
		if(sqrtP * sqrtP == P) break;
	}
	lSi = 2*sqrtP - 1;

	if(P != P1+P2+P3){
		fprintf(stderr, "error : P != P1+P2+P3\n");
		return 1;
	}

	// --------------- Data: -------------------
	status = (int *)malloc(sizeof(int) * P);
	for(i=0;i<P;i++)
		status[i] = ST_UNKNOWN;
	
	// waiting queue and inquire queue
	priority_queue wq,iq;
	allocQueue(&wq, lSi);
	allocQueue(&iq, lSi);

	// state for each process
	int state = UNLOCKED_STATE;

	// locking variable
	msg locking_req = {LOCKED_ELE, -1, -1};

	int max_timestamp = 1;

	//  --------------- Pipes: -------------------
	int pipe_[P][2];

	for(i=0;i<P-1;i++)
		if(pipe(pipe_[i]) < 0){
			fprintf(stderr, "pipe error\n");
			return 1;
		}

	// --------------- Fork: ---------------------
	int cid = -1;
	for(i=0;i<P-1;i++){
		cid = fork();
		if(cid == -1){
			fprintf(stderr, "fork error\n");
			return 1;
		}
		if(cid == 0){
			pid = i;
			break;
		}
	}

	// -----------------------------------------
	if(cid > 0){
		// parent
		pid = P-1;	
	}

	printf("%d\n",pid);


	free(status);
	exit(0);
}