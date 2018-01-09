#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mpi.h>

// Simple stencil function
float stencil ( float v1, float v2, float v3, float v4 ) {
	return (v1 + v2 + v3 + v4) * 0.25f;
}

// Function that compares the new error and the old, and outputs the larger one
float max_error ( float prev_error, float old, float new ) {
	float t= fabsf( new - old );
	return t>prev_error? t: prev_error;
}

// Initialisation of the main matrix
void laplace_init( float *in, int n ) {
	int i;
	const float pi = 2.0f * asinf(1.0f);
	memset(in, 0, n * n * sizeof(float));
	for ( i = 0; i < n; i++ ) {
		float V = in[i*n] = sinf(pi * i / (n-1));
		in[ i*n+n-1 ] = V * expf(-pi);
	}
}

// Classical function to find the maximum in an array
float maximum( float *array, int size ) {
	int i;
	float max=0;
	for( i = 0; i < size; i++ ) {
		if ( array[i]>max ) {
			max = array[i];
		}
	}
	return max;
}

// Main function
int main( int argc, char** argv ) {
	// Declare program variables
	int n = 4096;
	int i, j;
	int iter_max = 1000;
	float *A, *temp;

	const float tol = 1.0e-5f;
	float global_error= 1.0f;

	// Variables needed for MPI
	int rank, size;

	// Get runtime arguments
	if ( argc>1 ) {
		n        = atoi(argv[1]);
	}
	if ( argc>2 ) {
		iter_max = atoi(argv[2]);
	}

	// Initialisation of A & temp matrices
	A    = (float*) malloc( n*n*sizeof(float) );
	temp = (float*) malloc( n*n*sizeof(float) );

	// Set boundary conditions
	laplace_init (A, n);
	laplace_init (temp, n);
	// A[(n/128)*n+n/128] = 1.0f; // set singular point

	printf("Jacobi relaxation Calculation: %d x %d mesh, "
		   " maximum of %d iterations\n",
		   n, n, iter_max );

	// Initialisation of MPI parallel region
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Status status;

	// Define the partition of the matrix
	int m = n/size; // MUST BE INTEGER!!!
	int ri = rank * m;
	int rf = (rank+1) * m-1;

	// Initialisation of errors vector
	float *errors;
	errors = (float*)malloc(size*sizeof(float));

	// Main loop
	int iter = 0;
	while ( global_error > tol*tol && iter < iter_max ) {
		iter++;
		float error=0.0f;

		// Interchange of messages between consecutive rows
		if ( rank > 0 ) {
			MPI_Send(&A[ri*n], n, MPI_FLOAT, rank-1, 1, MPI_COMM_WORLD);
			MPI_Recv(&A[(ri-1)*n], n, MPI_FLOAT, rank-1, 2, MPI_COMM_WORLD, &status);
		}
		if ( rank < size-1 ) {
			MPI_Send(&A[rf*n], n, MPI_FLOAT, rank+1, 2, MPI_COMM_WORLD);
			MPI_Recv(&A[(rf+1)*n], n, MPI_FLOAT, rank+1, 1, MPI_COMM_WORLD, &status);
		}

		// Computation of the laplace step using MPI
		if ( rank == 0 ) {
			for ( j = ri+1; j <= rf; j++ ) {
				for ( i = 1; i < n-1; i++ ) {
					temp[j*n+i] = stencil(A[j*n+i+1], A[j*n+i-1], A[(j-1)*n+i], A[(j+1)*n+i]);
					error = max_error( error, temp[j*n+i], A[j*n+i] );
				}
			}
		}
		if ( rank == (size-1) ) {
			for ( j = ri; j < rf; j++ ) {
				for ( i=1; i < n-1; i++ ) {
					temp[j*n+i] = stencil(A[j*n+i+1], A[j*n+i-1], A[(j-1)*n+i], A[(j+1)*n+i]);
					error = max_error( error, temp[j*n+i], A[j*n+i] );
				}
			}
		}
		if ( rank != 0 && rank != (size-1) ) {
			for ( j = ri; j <= rf; j++ ) {
				for ( i = 1; i < n-1; i++ ) {
					temp[j*n+i] = stencil(A[j*n+i+1], A[j*n+i-1], A[(j-1)*n+i], A[(j+1)*n+i]);
					error = max_error( error, temp[j*n+i], A[j*n+i] );
				}
			}
		}

		// Sending partial errors to the master and computing the maximum to find the global error
		if ( rank != 0 ) {
				MPI_Send(&error, 1, MPI_FLOAT, 0, 3, MPI_COMM_WORLD);
		} else {
			errors[0] =error;
			for (i = 1; i < size; i++ ) {
				MPI_Recv(&errors[i], 1, MPI_FLOAT, i, 3, MPI_COMM_WORLD, &status);
			}
		}
		global_error = maximum(errors, size);

		// Sending back the resulting error
		if ( rank == 0 ) {
			for(i = 1; i<size; i++ ) MPI_Send(&global_error, 1, MPI_FLOAT, i, 4, MPI_COMM_WORLD);
		} else {
			MPI_Recv(&global_error, 1, MPI_FLOAT, 0, 4, MPI_COMM_WORLD, &status);
		}

		// Swap pointers A & temp
		float *swap = A;
		A = temp;
		temp = swap;
	}

	MPI_Finalize();
	global_error = sqrtf( global_error );
	printf("Total Iterations: %5d, ERROR: %0.6f\n", iter, global_error);
	free(A); free(temp);
}
