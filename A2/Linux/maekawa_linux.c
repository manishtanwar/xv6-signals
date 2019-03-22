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

int cmp(msg a,msg b){
	if(a.timestamp < b.timestamp)
		return 1;
	else if(a.timestamp == b.timestamp && a.pid < b.pid)
		return 1;
	return 0;
}

msg getTop(priority_queue *q){
	// assumes q->size > 0(which is ensured)
	int ind = 0, i;
	msg ans = q->arr[0];
	for(i=1;i<q->size;i++){
		if(cmp(ans, q->arr[i])){
			ans = q->arr[i];
			ind = i;
		}
	}
	for(i=ind;i<q->size-1;i++){
		q->arr[i] = q->arr[i+1];
	}
	q->size--;

	return ans;
}

void push(priority_queue *q, msg *m){
	// assumes queue won't get full(which is ensured)
	q->arr[q->size] = *m;
	q->size++;
}

// process index
int pid = -1;
// input
int P,P1,P2,P3;
int sqrtP = 0;

// subset of each process
int lSi;
int *status;
int *subset;
int *index_subset;

int get_proc_type(int pid){
	if(pid < P1) return 1;
	else if(pid < P2) return 2;
	return 3;	
}

int main(int argc, char *argv[])
{
	int i,j;
	scanf("%d%d%d%d",&P,&P1,&P2,&P3);
	while(1){
		sqrtP++;
		if(sqrtP * sqrtP == P) break;
	}
	lSi = 2*sqrtP - 1;

	if(P != P1+P2+P3){
		fprintf(stderr, "error : P != P1+P2+P3\n");
		return 1;
	}

	// --------------- Data: -------------------
	status = (int *)malloc(sizeof(int) * lSi);
	for(i=0;i<lSi;i++)
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

	int proc_type = get_proc_type(pid);

	subset = (int *)malloc(sizeof(int) * lSi);
	index_subset = (int *)malloc(sizeof(int) * P);
	int bound = (pid / sqrtP) * sqrtP;

	i = 0;
	j = pid;
	while(j >= 0) subset[i++] = j, j -= sqrtP;
	j = pid + sqrtP;
	while(j < P) subset[i++] = j, j += sqrtP;
	j = pid - 1;
	while(j >= bound) subset[i++] = j, j--;
	j = pid + 1;
	while(j <= bound+sqrtP) subset[i++] = j, j++;

	for(i=0;i<lSi;i++){
		index_subset[subset[i]] = i;	
	}

	// ---- debug ----
	printf("pid : %d\n",pid);
	fflush(stdout);
	// ---------------

	// // Closing unnecessary pipes
	for(i=0;i<P;i++){
		if(i != pid) close(pipe_[i][0]);
	}

	msg initial_msg = {REQUEST, pid, ++max_timestamp};
	msg i_am_done_msg = {IAMDONE, pid, -1};

	if(proc_type == 1){
		write(pipe_[0][1], &i_am_done_msg, sizeof(msg));
	}
	else{
		for(i=0;i<lSi;i++)
			write(pipe_[subset[i]][1], &initial_msg, sizeof(msg));
	}

	msg read_msg;
	int done_cnt = 0;
	int looping = 1;
	int am_i_done = 0;
	int inquire_sent_already = 0;
	if(proc_type == 1) am_i_done = 1;

	msg locked_msg = {LOCKED, pid, -1};
	msg failed_msg = {FAILED, pid, -1};
	msg inquire_msg = {INQUIRE, pid, -1};
	msg relinquish_msg = {RELINQUISH, pid, -1};
	msg release_msg = {RELEASE, pid, -1};
	
	while(looping){
		if(done_cnt == P) break;
		if(read(pipe_[pid][0], &read_msg, sizeof(msg)) <= 0) continue;

		switch (read_msg.type)
		{
			case REQUEST:{
				if(max_timestamp < read_msg.timestamp)
					max_timestamp = read_msg.timestamp;

				if(state == UNLOCKED_STATE){
					state = LOCKED_STATE;
					locking_req.pid = read_msg.pid;
					locking_req.timestamp = read_msg.timestamp;
					inquire_sent_already = 0;
					write(pipe_[read_msg.pid][1], &locked_msg, sizeof(msg));
				}
				else{
					int precede_flag = 0;
					if(cmp(locking_req, read_msg))
						precede_flag = 1;
					for(i = 0; i < wq.size-1; i++)
						if(cmp(wq.arr[i], read_msg))
							precede_flag = 1;
					push(&wq, &read_msg);

					if(precede_flag){
						write(pipe_[read_msg.pid][1], &failed_msg, sizeof(msg));
					}
					else{
						if(inquire_sent_already == 0){
							inquire_sent_already = 1;
							write(pipe_[locking_req.pid][1], &inquire_msg, sizeof(msg));
						}
					}
				}
				break;
			}
			case INQUIRE:{
				if(am_i_done)
					break;
				int failed_avail = 0;
				int unknown_avail = 0;

				for(i = 0; i < lSi; i++){
					if(status[index_subset[i]] == ST_FAILED)
						failed_avail = 1;
					if(status[index_subset[i]] == ST_UNKNOWN)
						unknown_avail = 1;
				}

				if(failed_avail){
					write(pipe_[read_msg.pid][1], &relinquish_msg, sizeof(msg));
					status[index_subset[read_msg.pid]] = ST_FAILED;
				}
				else if(unknown_avail){
					push(&iq, &read_msg);
				}
				break;
			}
			case LOCKED:{
				status[index_subset[read_msg.pid]] = ST_LOCKED;
				int all_locked = 1;
				for(i=0;i<lSi;i++)
					if(status[i] != ST_LOCKED) all_locked = 0;
				
				if(all_locked){
					critical_section(pid);
					am_i_done = 1;
					write(pipe_[0][1], &i_am_done_msg, sizeof(msg));
					for(i=0;i<lSi;i++)
						write(pipe_[subset[i]][1], &release_msg, sizeof(msg));
				}
				break;
			}
			case RELEASE:{
				if(wq.size==0){
					state = UNLOCKED_STATE;
				}
				else{
					msg top = getTop(&wq);
					locking_req.pid = top.pid;
					locking_req.timestamp = top.timestamp;
					inquire_sent_already = 0;
					write(pipe_[top.pid][1], &locked_msg, sizeof(msg));
				}			
				break;
			}
			case RELINQUISH:{
				// bug : not updating the timestamp of locking element
				break;
			}
			case FAILED:{
				break;
			}
			case IAMDONE:{
				if(pid == 0) done_cnt++;
				if(done_cnt == P) looping = 0;
				break;
			}
			case KILL:{
				looping = 0;
				break;
			}
		}
	}

	if(pid == 0){
		msg kill_msg = {KILL, pid, -1};
		for(i=0;i<P;i++){
			if(i != pid) write(pipe_[i][1], &kill_msg, sizeof(msg));
		}
	}

	for(i=0;i<P;i++){
		if(i == pid) close(pipe_[i][0]);
		close(pipe_[i][1]);
	}

	free(subset);
	free(status);
	free(wq.arr);
	free(iq.arr);
	exit(0);
}