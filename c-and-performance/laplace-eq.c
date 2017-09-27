// Authors: Alfredo Hernández <aldomann.designs@gmail.com>
//          Alejandro Jiménez <aljrico@gmail.com>

// define n and m
// declare global variables: A and Anew
int main(int argc, char** argv) {
		// declare local variables: error, iter_max ...
		// get iter_max from command line at execution time
		// set all values in matrix as zero
		// set boundary conditions
		// Main loop: iterate until error <= tol or a maximum of iter_max iterations
	while ( error > tol && iter < iter_max ) {
		// Compute new values using main matrix and writing into auxiliary matrix
		// Compute error = maximum of the square root of the absolute differences
		// Copy from auxiliary matrix to main matrix
		// if number of iterations is multiple of 10 then print error on the screen
	} // while
}
