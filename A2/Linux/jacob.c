#include <stdlib.h>
#include <stdio.h>
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
int main(int argc, char *argv[])
{
	int N,P,L;
	float E,T;

	scanf("%d%f%f%d%d",&N, &E, &T, &P, &L);
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
	for(;;){
		diff = 0.0;
		for(i =1 ; i < N-1; i++){
			float local_diff = 0.0;
			for(j =1 ; j < N-1; j++){
				w[i][j] = ( u[i-1][j] + u[i+1][j]+
					    u[i][j-1] + u[i][j+1])/4.0;
				if( fabsm(w[i][j] - u[i][j]) > local_diff )
					local_diff = fabsm(w[i][j]- u[i][j]);	
			}
			if(diff < local_diff) diff = local_diff;
			// printf("%d - %f\n",i-1,local_diff);
		}
	    count++;
	       
		if(diff<= E || count > L){ 
			// printf("%d\n", count);
			break;
		}
	
		for (i =1; i< N-1; i++)	
			for (j =1; j< N-1; j++) u[i][j] = w[i][j];
	}

	for(i =0; i <N; i++){
		for(j = 0; j<N; j++)
			printf("%d ",((int)u[i][j]));
		printf("\n");
	}
	// ---- debug ----
	printf("no. of iterations : %d\n",count);
	// ---------------
	exit(0);
}
