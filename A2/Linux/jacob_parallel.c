#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include<sys/wait.h>

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

	float diff;
	int i,j;
	float mean;
	float u[N][N];
	float w[N][N];

	int pid_acorss1[P-1][2];
	int pid_acorss2[P-1][2];
	int pid_parent[2*P][2];

	for(i=0;i<P-1;i++){
		if(pipe(pid_acorss1[i]) < 0){
			fprintf(stderr, "pipe error\n");
			return 1;
		}
		if(pipe(pid_acorss2[i]) < 0){
			fprintf(stderr, "pipe error\n");
			return 1;
		}
	}
	for(i=0;i<2*P;i++)
		if(pipe(pid_parent[i]) < 0){
			fprintf(stderr, "pipe error\n");
			return 1;
		}

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

	if(cid > 0){
		// parent
		for(i = 0; i < P; i++)
			wait(NULL);
	}
	else{
		// child
		for(i = 0; i < P-1; i++){
			if(i > 0 || c_index > 1){
				close(pid_acorss1[i][0]);
				close(pid_acorss1[i][1]);
			}
			close(pid_acorss2[i][0]);
			close(pid_acorss2[i][1]);
		}

		if(c_index == 0){
			char *msg = "Hey!";
			close(pid_acorss1[0][0]);
			write(pid_acorss1[0][1], msg, 4);
			printf("send done\n");
			close(pid_acorss1[0][1]);
		}
		else if(c_index == 1){
			close(pid_acorss1[0][1]);
			char msg[4];
			read(pid_acorss1[0][0], msg, 4);
			printf("recv done : %s\n",msg);
			close(pid_acorss1[0][0]);
		}
	}
	exit(0);

	// int count=0;
	// mean = 0.0;
	// for (i = 0; i < N; i++){
	// 	u[i][0] = u[i][N-1] = u[0][i] = T;
	// 	u[N-1][i] = 0.0;
	// 	mean += u[i][0] + u[i][N-1] + u[0][i] + u[N-1][i];
	// }
	// mean /= (4.0 * N);
	// for (i = 1; i < N-1; i++ )
	// 	for ( j= 1; j < N-1; j++) u[i][j] = mean;

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
	// 		printf("%d ",((int)u[i][j]));
	// 	printf("\n");
	// }
	// exit();
}
