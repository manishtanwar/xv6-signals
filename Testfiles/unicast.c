#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8

int main(void)
{
	printf(1,"%s\n","IPC Test case");
	// int par_pid = getpid();
	int cid = fork();

	if(cid==0){
		// This is child
		char *msg1 = (char *)malloc(MSGSIZE);
		int stat=-1;
		while(stat==-1){
			stat = recv((void *)msg1);
		}
		char *msg = (char *)malloc(MSGSIZE);
		msg = "bithere";
		send(getpid(),*((int*)msg1),(void *)msg);	
		printf(1,"1 CHILD: msg sent is: %s \n", msg );
		
		free(msg);
		exit();
	}else{
		// This is parent

		int par_pid[2];
		par_pid[0] = getpid();
		send(par_pid[0],cid,(void *)par_pid);

		char *msg = (char *)malloc(MSGSIZE);
		int stat=-1;
		while(stat==-1){
			stat = recv(msg);
		}
		printf(1,"2 PARENT: msg recv is: %s \n", msg );
	}
	
	exit();
}

// #include "types.h"
// #include "stat.h"
// #include "user.h"

// #define MSGSIZE 8

// int main(void)
// {
// 	printf(1,"%s\n","IPC Test case");
// 	int par_pid = getpid();
// 	int cid = fork();

// 	if(cid==0){
// 		// This is child
// 		char *msg = (char *)malloc(MSGSIZE);
// 		msg = "hithere";
// 		send(getpid(),par_pid,msg);	
// 		printf(1,"1 CHILD: msg sent is: %s \n", msg );
		
// 		free(msg);
// 		exit();
// 	}else{
// 		// This is parent

// 		char *msg = (char *)malloc(MSGSIZE);
// 		int stat=-1;
// 		while(stat==-1){
// 			stat = recv(msg);
// 		}
// 		printf(1,"2 PARENT: msg recv is: %s \n", msg );
// 	}
	
// 	exit();
// }