#include <math.h>
#include <R.h>
#include <Rinternals.h>
#include <stdio.h>
/* Euclidean distance */
/*q=.C("eucdist",as.integer(c(1,2,3,4,5,6,7,8)),as.integer(4),as.integer(2),as.double(vector("double",6))*/
void eucdist(double *x, int *m, int *n, double *d)
{
  /* Arguement:
    1.  x is a matrix of dimension n by m
    2.  m is the number of rows
    3.  n is the number of coloums
    4.  d is the pointer for output */
  /*
   d = sqrt(sum((XI-XJ).^2,2));            % Euclidean
   */
  int i,j,k; /* **pointer; /* Indexers */
  int local_m, local_n;
  local_m = *m, local_n = *n;
  double theSum; /* size_t is an unsigned integer of size 16 bits */
  /*
  XI for indexing rows
  XJ for indexing columns
  XI0 unknown for now 
  */
  int  XI, XJ, XI0, index; /* pointers as row indexers*/
  // d = malloc( local_m*(local_m - 1)/2);
  // XI0 =  (double *) x; /* we are not tuching x but using its memory address as XI */
  // x = (double) x;
  index = 0;

  for (i=0; i<local_m-1; ++i) {
    XI = i*local_n; //indexing the start of the i the row
    XI0 = XI;
    // Rprintf("XI is %d\n", XI);    
    for (j=i+1; j<local_m; ++j) { 
      XJ = j*local_n; // indexing the start of the start jth row
      // Rprintf("XJ is %d\n", XJ);
      // XI = XI0; /* Index? */
      theSum = 0.0;
      for (k=0;k<local_n;k++,++XI,++XJ){
        theSum += pow((x[XI]- x[XJ]), 2.0);
      }
      XI = XI0;
      d[index++] = sqrt(theSum);
    }
  }
}
