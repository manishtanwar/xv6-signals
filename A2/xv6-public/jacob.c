#include "types.h"
#include "stat.h"
#include "user.h"


// #define N 11
// #define E 0.00001
// #define T 100.0
// #define P 6
// #define L 20000

float fabsm(float a){
	if(a<0)
	return -1*a;
return a;
}

int file_d;
int readInt(){
	int N = 0;
	char c;
	while(read(file_d,(void *)(&c),sizeof(char)) > 0){
		if(c == '\n') break;
		N = 10*N + (c-'0');
	}
	return N;
}

float readFloat(){
	float N = 0.0;
	float a = 1.0;
	int flag = 0;
	char c;
	while(read(file_d,(void *)(&c),sizeof(char)) > 0){
		if(c == '\n') break;
		if(c == '.'){
			flag = 1; continue;
		}
		N = 10.0 * N + (float)(c-'0');
		if(flag) a *= 10.0;
	}
	N /= a;
	return N;
}

int main(int argc, char *argv[])
{
	char *filename;
	filename = "assig2a.inp";
	file_d = open(filename, 0);
	int N,P,L;
	float E,T;
	N = readInt();
	E = readFloat();
	T = readFloat();
	P = readInt();
	L = readInt();
	
	printf(1, "%d %d %d %d %d\n",N,(int)(1000000.0 * E),(int)(10000.0 * T),P,L);
	if(P > N-2) P = N-2;

	float diff;
	int i,j;
	float mean;
	float u[N][N];
	float w[N][N];

	int count=0;
	mean = 0.0;
	for (i = 0; i < N; i++){
		u[i][0] = u[i][N-1] = u[0][i] = T;
		u[N-1][i] = 0.0;
		mean += u[i][0] + u[i][N-1] + u[0][i] + u[N-1][i];
	}
	mean /= (4.0 * N);
	for (i = 1; i < N-1; i++ )
		for ( j= 1; j < N-1; j++) u[i][j] = mean;

	int cid = -1;
	int c_index = -1;
	for(i=0;i<P;i++){
		cid = fork();
		if(cid == -1){
			fprintf(stderr, "fork error\n");
			return 1;
		}
		if(cid == 0){
			c_index = i;
			break;
		}
	}

	// for(;;){
	// 	diff = 0.0;
	// 	for(i =1 ; i < N-1; i++){
	// 		for(j =1 ; j < N-1; j++){
	// 			w[i][j] = ( u[i-1][j] + u[i+1][j]+
	// 				    u[i][j-1] + u[i][j+1])/4.0;
	// 			if( fabsm(w[i][j] - u[i][j]) > diff )
	// 				diff = fabsm(w[i][j]- u[i][j]);	
	// 		}
	// 	}
	//     count++;
	       
	// 	if(diff<= E || count > L){ 
	// 		break;
	// 	}
	
	// 	for (i =1; i< N-1; i++)	
	// 		for (j =1; j< N-1; j++) u[i][j] = w[i][j];
	// }
	// for(i =0; i <N; i++){
	// 	for(j = 0; j<N; j++)
	// 		printf(1,"%d ",((int)u[i][j]));
	// 	printf(1,"\n");
	// }
	exit();

}
