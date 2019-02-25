typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define BUFFER_SIZE 32
#define MSGSIZE 8
#define SIG_QUE_SIZE 8

typedef void (*sighandler_t)(void*);