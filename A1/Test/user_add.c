#include "types.h"
#include "user.h"
#include "date.h"
int
main(int argc, char *argv[])
{
	if(argc < 3){
		printf(2,"Less Arguments\n");
		exit();
	}
	int a,b;
	a = atoi(argv[1]);
	b = atoi(argv[2]);
	// printf(1,"%s %s\n", argv[1], argv[2]);
	// printf(1,"%d + %d = ",a,b);
	int c = add(a, b);
	c += d;
	printf(1,"%d\n",c);
	exit();
}