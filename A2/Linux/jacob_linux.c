#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include<sys/wait.h>

float fabsm(float a){
	if(a<0)
	return -1*a;
return a;
}

void print(int n, float* u, int c_index, int sr){
	if(sr) printf("recv\n");
	else printf("send\n");
	printf("index : %d ",c_index);
	int i;
	for(i=0;i<n;i++)
		printf("%.2f ",*(u+i));
	printf("\n");
	fflush(stdout);
}

int main(int argc, char *argv[])
{
	int N,P,L;
	float E,T;

	FILE *file;

   if ((file = fopen("assig2a.inp","r")) == NULL){
       fprintf(stderr, "file opening error\n");
	   return 1;
   }

	fscanf(file, "%d%f%f%d%d",&N, &E, &T, &P, &L);

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

	if(N <= 2){
		P = 0;
		for(i =0; i <N; i++){
			for(j = 0; j<N; j++)
				printf("%d ",((int)u[i][j]));
			printf("\n");
		}
		exit(0);
	}
	else if(P > N-2) P = N-2;

	//  --------------- Pipes: -------------------
	int pipe_across[P-1][2][2];
	int pipe_parent[P][2][2];

	for(i=0;i<P-1;i++)
		for(j=0;j<2;j++)
			if(pipe(pipe_across[i][j]) < 0){
				fprintf(stderr, "pipe error\n");
				return 1;
			}

	for(i=0;i<P;i++)
		for(j=0;j<2;j++)	
			if(pipe(pipe_parent[i][j]) < 0){
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

	// -----------------------------------------
	if(cid > 0){
		// parent
		// closing all across pipes in parent
		for(i=0;i<P-1;i++)
			for(j=0;j<2;j++){
				close(pipe_across[i][j][0]);
				close(pipe_across[i][j][1]);
			}

		for(i=0;i<P;i++)
			close(pipe_parent[i][1][1]),
			close(pipe_parent[i][0][0]);

		// Start Here:
		float local_diff;
		int terminate;
		for(;;){
			diff = 0.0;
			terminate = 0;
			count++;
			
			for(i=0;i<P;i++){
				read(pipe_parent[i][1][0], &local_diff, sizeof(float));
				if(diff < local_diff)
					diff = local_diff;
			}

			if(diff <= E) terminate = 1;
			for(i=0;i<P;i++)
				write(pipe_parent[i][0][1], &terminate, sizeof(int));
			if(terminate || count > L){ 
				break;
			}
			// ---- debug ----
			// printf("%d\n",count);
			// fflush(stdout);
			// ---------------
		}

		for(i=0;i<P;i++){
			int start, end, extra;
			int n = N-2;
			int terminate = 0;
			extra = n-(n/P)*P;
			start = i * (n/P);
			end = n/P + start;
			if(i >= extra) start += extra, end += extra;
			else start += i, end += i+1;
			start++; end++;
			read(pipe_parent[i][1][0], u[start], (end-start) * sizeof(float) * N);
		}

		for(i =0; i <N; i++){
			for(j = 0; j<N; j++)
				printf("%d ",((int)u[i][j]));
			printf("\n");
		}

		// ---- debug ----
		// printf("no. of iterations : %d\n",count);
		// fflush(stdout);
		// ---------------

		for(i=0;i<P;i++)
			close(pipe_parent[i][0][1]),
			close(pipe_parent[i][1][0]),
			wait(NULL);
	}

	else{
		// child
		for(i=0;i<P-1;i++){
			if(i != c_index)
				close(pipe_across[i][0][1]),
				close(pipe_across[i][1][0]);
			if(i != c_index-1)
				close(pipe_across[i][0][0]),
				close(pipe_across[i][1][1]);
		}
		for(i=0;i<P;i++)
			if(i != c_index)
			for(j=0;j<2;j++)
				close(pipe_parent[i][j][0]),
				close(pipe_parent[i][j][1]);

		close(pipe_parent[c_index][0][1]);
		close(pipe_parent[c_index][1][0]);

		// Start Here:
		int start, end, extra;
		int n = N-2;
		int terminate = 0;
		extra = n-(n/P)*P;
		start = c_index * (n/P);
		end = n/P + start;

		if(c_index >= extra) start += extra, end += extra;
		else start += c_index, end += c_index+1;

		start++; end++;
		
		// ---- debug ----
		// printf("ind : %d, start : %d, end : %d\n", c_index, start, end);
		// fflush(stdout);
		// ---------------

		for(;;){
			diff = 0.0;

			for(i = start; i < end; i++){
				for(j =1 ; j < N-1; j++){
					w[i][j] = ( u[i-1][j] + u[i+1][j]+
						    u[i][j-1] + u[i][j+1])/4.0;
					if( fabsm(w[i][j] - u[i][j]) > diff )
						diff = fabsm(w[i][j]- u[i][j]);	
				}
			}
			// ---- debug ----
			// printf("id : %d, diff : %f\n",c_index, diff);
			// fflush(stdout);
			// ---------------
			count++;
			
			write(pipe_parent[c_index][1][1], &diff, sizeof(float));
			read(pipe_parent[c_index][0][0], &terminate, sizeof(int));
			
			if(terminate || count > L){ 
				break;
			}
		
			for (i = start; i < end; i++)	
				for (j =1; j< N-1; j++) u[i][j] = w[i][j];

			// sending values:
			if(c_index != 0) 	write(pipe_across[c_index-1][1][1], u[start]+1, sizeof(float) * n);
			if(c_index != P-1) 	write(pipe_across[c_index][0][1], u[end-1]+1, sizeof(float) * n);
			
			// receiving values:
			if(c_index != 0) read(pipe_across[c_index-1][0][0], u[start-1]+1, sizeof(float) * n);
			if(c_index != P-1) read(pipe_across[c_index][1][0], u[end]+1, sizeof(float) * n);
		}

		write(pipe_parent[c_index][1][1], u[start], sizeof(float) * N * (end-start));

		close(pipe_parent[c_index][0][0]);
		close(pipe_parent[c_index][1][1]);

		if(c_index != P-1)
			close(pipe_across[c_index][0][1]),
			close(pipe_across[c_index][1][0]);
		if(c_index != 0)
			close(pipe_across[c_index-1][0][0]),
			close(pipe_across[c_index-1][1][1]);

		// printf("id : %d\n",c_index);
		// for(i=start;i<end;i++){
		// 	for(j=0;j<N;j++)
		// 		printf("%d ",((int)u[i][j]));
		// 	printf("\n");
		// }
	}
	exit(0);
}