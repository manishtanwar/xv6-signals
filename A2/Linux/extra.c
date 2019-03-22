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