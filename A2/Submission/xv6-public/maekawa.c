#include "types.h"
#include "stat.h"
#include "user.h"

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
// process index
int pid = -1;

msg getTop(priority_queue *q){
	// assumes q->size > 0(which is ensured)
	int ind = 0, i;
	msg ans = q->arr[0];
	// printf("pq : pid : %d, pq_pid : %d, timestamp : %d\n", pid, q->arr[0].pid, q->arr[0].timestamp);
	for(i=1;i<q->size;i++){
		// printf("pq : pid : %d, pq_pid : %d, timestamp : %d\n", pid, q->arr[i].pid, q->arr[i].timestamp);
		if(!cmp(ans, q->arr[i])){
			ans = q->arr[i];
			ind = i;
		}
	}
	// printf("pid : %d, pq.size : %d, chosen_pid : %d, \n", pid, q->size, ans.pid);
	// fflush(stdout);

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

// input
int P,P1,P2,P3;
int sqrtP = 0;

// subset of each process
int lSi;
int *status;
int *subset;
int *index_subset;

int get_proc_type(){
	if(pid < P1) return 1;
	else if(pid < P1+P2) return 2;
	return 3;	
}

void critical_section(int proc_type){
	int proc_id = getpid();
	if(proc_type == 2){
		printf(1, "%d acquired the lock at time %d.\n",proc_id,uptime());
		sleep(200);
		printf(1, "%d released the lock at time %d.\n",proc_id,uptime());

	}
	else{
		printf(1, "%d acquired the lock at time %d.\n",proc_id,uptime());
		printf(1, "%d released the lock at time %d.\n",proc_id,uptime());
	}
}

int file_d;

// read unsigned int
int readUint(){
	int N = 0;
	char c;
	while(read(file_d,(void *)(&c),sizeof(char)) > 0){
		if(c == '\n') break;
		N = 10*N + (c-'0');
	}
	return N;
}

int main(int argc, char *argv[])
{
	char *filename;
	filename = "assig2b.inp";

	file_d = open(filename, 0);
	P = readUint();
	P1 = readUint();
	P2 = readUint();
	P3 = readUint();

	int i,j;
	while(1){
		sqrtP++;
		if(sqrtP * sqrtP == P) break;
	}
	lSi = 2*sqrtP - 1;

	if(P != P1+P2+P3){
		printf(2, "error : P != P1+P2+P3\n");
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

	for(i=0;i<P;i++)
		if(pipe(pipe_[i]) < 0){
			printf(2, "pipe error\n");
			return 1;
		}

	// --------------- Fork: ---------------------
	int cid = -1;
	for(i=0;i<P-1;i++){
		cid = fork();
		if(cid == -1){
			printf(2, "fork error\n");
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

	int proc_type = get_proc_type();

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
	while(j < bound+sqrtP) subset[i++] = j, j++;

	for(i=0;i<lSi;i++){
		index_subset[subset[i]] = i;	
	}

	// ---- debug ----
	// printf("pid : %d\n",pid);
	// for(i=0;i<lSi;i++)
	// 	printf("%d ",subset[i]);
	// printf("\n");
	// fflush(stdout);
	// ---------------

	// // Closing unnecessary pipes
	for(i=0;i<P;i++){
		if(i != pid) close(pipe_[i][0]);
	}

	msg initial_msg = {REQUEST, pid, ++max_timestamp};
	msg i_am_done_msg = {IAMDONE, pid, -1};

	if(proc_type == 1){
		if(write(pipe_[0][1], &i_am_done_msg, sizeof(msg)) <= 0){
			printf(2, "write error\n");
			return 1;
		}
	}
	else{
		for(i=0;i<lSi;i++){
			if(write(pipe_[subset[i]][1], &initial_msg, sizeof(msg)) <= 0){
				printf(2, "write error\n");
				return 1;
			}
		}
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
	
	// ---- debug ----
	// printf("pid : %d\n", pid);
	// fflush(stdout);
	// ---------------

	while(looping){
		if(done_cnt == P) break;
		// sleep(pid+1);
		// ---- debug ----
		// if(pid == 2){
		// 	printf("pid : %d\n", pid);
		// 	fflush(stdout);
		// }
		// ---------------
		if(read(pipe_[pid][0], &read_msg, sizeof(msg)) <= 0) continue;
		
		// ---- debug ----
		// printf("pid : %d => state : %d, locking_req : %d\n", pid, state,locking_req.pid);
		// fflush(stdout);
		// printf("pid : %d, type : %d, sender : %d\n",pid,read_msg.type, read_msg.pid);
		// fflush(stdout);
		// ---------------
		
		switch (read_msg.type)
		{
			case REQUEST:{
				// ---- debug ----
				// printf("pid : %d, sender : %d\n", pid, read_msg.pid);
				// fflush(stdout);
				// ---------------

				if(max_timestamp < read_msg.timestamp)
					max_timestamp = read_msg.timestamp;

				if(state == UNLOCKED_STATE){
					state = LOCKED_STATE;
					locking_req.pid = read_msg.pid;
					locking_req.timestamp = read_msg.timestamp;
					inquire_sent_already = 0;
					if(write(pipe_[read_msg.pid][1], &locked_msg, sizeof(msg)) <= 0){
						printf(2, "write error\n");
						return 1;	
					}
				}
				else{
					int precede_flag = 0;
					if(cmp(locking_req, read_msg))
						precede_flag = 1;
					for(i = 0; i < wq.size; i++)
						if(cmp(wq.arr[i], read_msg))
							precede_flag = 1;
					push(&wq, &read_msg);

					if(precede_flag){
						if(write(pipe_[read_msg.pid][1], &failed_msg, sizeof(msg)) <= 0){
							printf(2, "write error\n");
							return 1;
						}
					}
					else{
						if(inquire_sent_already == 0){
							inquire_sent_already = 1;
							if(write(pipe_[locking_req.pid][1], &inquire_msg, sizeof(msg)) <= 0){
								printf(2, "write error\n");
								return 1;
							}
						}
					}
				}
				break;
			}
			case INQUIRE:{
				if(am_i_done == 0){
					int failed_avail = 0;
					int unknown_avail = 0;

					for(i = 0; i < lSi; i++){
						if(status[index_subset[i]] == ST_FAILED)
							failed_avail = 1;
						if(status[index_subset[i]] == ST_UNKNOWN)
							unknown_avail = 1;
					}

					if(failed_avail){
						if(write(pipe_[read_msg.pid][1], &relinquish_msg, sizeof(msg)) <= 0){
							printf(2, "write error\n");
							return 1;
						}
						status[index_subset[read_msg.pid]] = ST_FAILED;
					}
					else if(unknown_avail){
						push(&iq, &read_msg);
					}
				}
				break;
			}
			case LOCKED:{
				status[index_subset[read_msg.pid]] = ST_LOCKED;
				int all_locked = 1;
				for(i=0;i<lSi;i++)
					if(status[i] != ST_LOCKED) all_locked = 0;
				
				// ---- debug ----
				// printf("pid : %d, all : %d\n",pid,all_locked);
				// for(i=0;i<lSi;i++){
				// 	printf("status : %d ", status[i]);
				// }
				// printf("\n");
				// fflush(stdout);
				// ---------------

				if(all_locked){
					critical_section(proc_type);
					am_i_done = 1;
					iq.size = 0;
					if(write(pipe_[0][1], &i_am_done_msg, sizeof(msg)) <= 0){
						printf(2, "write error\n");
						return 1;
					}
					for(i=0;i<lSi;i++){
						if(write(pipe_[subset[i]][1], &release_msg, sizeof(msg)) <= 0){
							printf(2, "write error\n");
							return 1;
						}
					}
				}
				break;
			}
			case RELEASE:{
				// ---- debug ----
				// printf("pid : %d, sender : %d\n", pid, read_msg.pid);
				// fflush(stdout);
				// ---------------
				if(wq.size==0){
					// ---- debug ----
					// printf("pid : %d\n",pid);
					// fflush(stdout);
					// ---------------
					state = UNLOCKED_STATE;
				}
				else{
					msg top = getTop(&wq);
					locking_req.pid = top.pid;
					locking_req.timestamp = top.timestamp;
					inquire_sent_already = 0;
					if(write(pipe_[top.pid][1], &locked_msg, sizeof(msg)) <= 0){
						printf(2, "write error\n");
						return 1;
					}
				}		
				break;
			}
			case RELINQUISH:{
				// bug : not updating the timestamp of locking element
				msg top = getTop(&wq);
				locking_req.type = REQUEST;
				push(&wq, &locking_req);
				locking_req.type = LOCKED_ELE;

				locking_req.pid = top.pid;
				locking_req.timestamp = top.timestamp;
				inquire_sent_already = 0;
				if(write(pipe_[top.pid][1], &locked_msg, sizeof(msg)) <= 0){
					printf(2, "write error\n");
					return 1;
				}
				break;
			}
			case FAILED:{
				status[index_subset[read_msg.pid]] = ST_FAILED;
				for(i=0;i<iq.size;i++){
					if(write(pipe_[iq.arr[i].pid][1], &relinquish_msg, sizeof(msg)) <= 0){
						printf(2, "write error\n");
						return 1;
					}
					status[index_subset[iq.arr[i].pid]] = ST_FAILED;
				}
				iq.size = 0;
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

	// ---- debug ----
	// printf("pid : %d\n",pid);
	// fflush(stdout);
	// ---------------

	if(pid == 0){
		msg kill_msg = {KILL, pid, -1};
		for(i=0;i<P;i++){
			if(i != pid){
				if(write(pipe_[i][1], &kill_msg, sizeof(msg)) <= 0){
					printf(2, "write error\n");
					return 1;
				}
			}
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

	if(pid == P-1){
		for(i=0;i<P-1;i++)
			wait();
	}

	exit();
}