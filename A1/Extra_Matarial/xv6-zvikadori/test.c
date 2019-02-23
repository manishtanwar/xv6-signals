#include "types.h"
#include "stat.h"
#include "user.h"
#include "signal.h"
/*
#ifndef sighandler_t
typedef void (*sighandler_t)(void);
#endif
*/

int main (void){
	sighandler_t firstHandler = (sighandler_t) 5;
	//int pid;
	signal(10, firstHandler);
	signal(SIGINT, (sighandler_t) SIG_DFL);
	sleep(50);
	printf(2, "getpid is: %d\n", getpid());
	//sigsend(getpid(), SIGINT);
	//kill(getpid());
	//exit();
	for(;;);
	//kill(getpid());
	//sigsend(2, 0);
	//sigsend(2, 3);
	//sigsend(2, 1);
	
	//sigsend(2, 2);
	printf(1,"afffffffffffff");
	
	
	exit();
}
