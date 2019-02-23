/* signal.h
   file with all the constants needed for signal handling and usage */
   
   

#define NUM_OF_SIGNALS 32
#define SIG_IGN -1
#define SIG_DFL -2
#define SIGINT 0
#define SIGCHLD 3

/*
#ifndef sighandler_t
typedef void (*sighandler_t)(void);
#endif

*/