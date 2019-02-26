#include "types.h"
#include "stat.h"
#include "user.h"

#define NO_CHILD 8

float avg_global = 0.0;
volatile int flag_handler = 0;
int ind; 

void sig_handler(void *msg){
	flag_handler  = 1;
  // int pid = getpid();
  // printf(1, "h %d\n", ind);
	// get avg from msg
	avg_global = *((float *)msg);
}

int
main(int argc, char *argv[])
{
	if(argc< 2){
		printf(1,"Need type and input filename\n");
		exit();
	}
	char *filename;
	filename=argv[2];
	int type = atoi(argv[1]);
	printf(1,"Type is %d and filename is %s\n",type, filename);

	int tot_sum = 0;	
	float variance = 0.0;

	int size=1000;
	short arr[size];
	char c;
	int fd = open(filename, 0);
	for(int i=0; i<size; i++){
		read(fd, &c, 1);
		arr[i]=c-'0';
		read(fd, &c, 1);
	}	
  	close(fd);
  	// this is to supress warning
  	printf(1,"first elem %d\n", arr[0]);
  
  	//----FILL THE CODE HERE for unicast sum and multicast variance

	  int *cid = (int *)malloc(NO_CHILD * sizeof(int));
  	int par_pid;
  	par_pid = getpid();

  	// set the signal handler before forking
  	sig_set(0, &sig_handler);

  	for(ind = 0; ind < NO_CHILD; ind++){
  		cid[ind] = fork();
  		if(cid[ind] == 0) break;
  	}

  	if(ind != NO_CHILD){
  		// All children will come here
  		int start, end, i, pid;
  		pid = getpid();
  		start = ind * (size / NO_CHILD);
  		end = start + (size / NO_CHILD);

  		if(ind == NO_CHILD-1)
  			end = size;

  		int partial_sum = 0;
  		for(i = start; i < end; i++)
  			partial_sum += arr[i];

  		char *msg = (char *)malloc(MSGSIZE);

  		// pack the partial_sum in msg
  		for(i = 0; i < 4; i++)
  			msg[i] = *((char *)&partial_sum + i);

  		// send the partial sum to the co-oridinator process
  		send(pid, par_pid, msg);

  		// pause until msg is received
  		// if(flag_handler == 0) 
      // printf(1, "%p\n",&flag_handler);
      sig_pause(&flag_handler,1);
      // while(flag_handler == 0){
        
      // }

  		float partial_var = 0.0;
  		for(i = start; i < end; i++){
  			float diff = (avg_global - (float)arr[i]);
  			partial_var +=  diff * diff;
  		}

  		// pack the partial_var in msg
  		for(i = 0; i < 4; i++)
  			msg[i] = *((char*)&partial_var + i);

  		// send the partial var to the co-oridinator process
  		send(pid, par_pid, msg);
  		exit();
  	}
  	else{
  		// Parent : The coordinator Process
		int i;
		char *msg = (char *)malloc(MSGSIZE);

  		for(i = 0; i < NO_CHILD; i++){
  			recv(msg);
  			tot_sum += *((int *)msg);
  		}

  		float avg = (float)tot_sum/size;

  		for(i = 0; i < 4; i++)
  			msg[i] = *((char *)&avg + i);

  		send_multi(par_pid, cid, msg, NO_CHILD);

  		for(i = 0; i < NO_CHILD; i++){
  			recv(msg);
  			variance += *((float *)msg);
  		}

  		variance /= (float)size;
  		for(i = 0; i < NO_CHILD; i++)
  			wait();
  	}

  	//------------------

  	if(type==0){ //unicast sum
		printf(1,"Sum of array for file %s is %d\n", filename, tot_sum);
    // printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
	}
	else{ //mulicast variance
		printf(1,"Variance of array for file %s is %d\n", filename, (int)variance);
	}
	exit();
}