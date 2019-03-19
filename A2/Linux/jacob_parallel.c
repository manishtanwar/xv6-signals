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

	int pid_acorss[P-1][2][2];
	int pid_parent[P][2][2];

	for(i=0;i<P-1;i++)
		for(j=0;j<2;j++)
			if(pipe(pid_acorss[i][j]) < 0){
				fprintf(stderr, "pipe error\n");
				return 1;
			}

	for(i=0;i<P;i++)
		for(j=0;j<2;j++)	
			if(pipe(pid_parent[i][j]) < 0){
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
		for(i=0;i<P-1;i++)
			for(j=0;j<2;j++){
				close(pid_acorss[i][j][0]);
				close(pid_acorss[i][j][1]);
			}
		for(i=0;i<P;i++)
			close(pid_parent[i][1][1]),
			close(pid_parent[i][0][0]);

		for(i=0;i<P;i++){
			char msg[4];
			read(pid_parent[i][1][0], msg, 4);
			int index = (int)(*msg);
			printf("%d\n",index);
		}
		for(i=0;i<P;i++){
			char *msg = "Papa";
			write(pid_parent[i][0][1], msg, 4);
		}

		for(i=0;i<P;i++)
			close(pid_parent[i][0][1]),
			close(pid_parent[i][1][0]),
			wait(NULL);
	}
	else{
		// child
		for(i=0;i<P-1;i++)
			for(j=0;j<2;j++){
				close(pid_acorss[i][j][0]);
				close(pid_acorss[i][j][1]);
			}
		for(i=0;i<P;i++)
			if(i != c_index)
			for(j=0;j<2;j++)
				close(pid_parent[i][j][0]),
				close(pid_parent[i][j][1]);

		close(pid_parent[c_index][0][1]);
		close(pid_parent[c_index][1][0]);

		write(pid_parent[c_index][1][1], (char *)(&c_index), 4);
		char msg[4];

		read(pid_parent[c_index][0][0], msg, 4);
		printf("%s\n", msg);

		close(pid_parent[c_index][0][0]);
		close(pid_parent[c_index][1][1]);
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
