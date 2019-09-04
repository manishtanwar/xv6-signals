typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define BUFFER_SIZE 256
#define MSGSIZE 8
#define SIG_QUE_SIZE 256

typedef void (*sighandler_t)(void*);