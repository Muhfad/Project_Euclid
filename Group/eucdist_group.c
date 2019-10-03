#include <math.h>
#include <R.h>
#include <Rinternals.h>
#include <stdio.h>
#include <stdlib.h>
// #include <string.h>

void eucdist_group(double *x, int *m, int *n, double *d, int *unique_group, int *l, int *group_vec, int *lg)
{
  /* Arguement:
    1.  x is a matrix of dimension n by m
    2.  m is the number of rows
    3.  n is the number of coloums
    4.  d is the pointer for output 
    5.  unique_group is the pointer for the unique groups
    6.  l is the number of elements in the unique groups
    7.  group_vec is the grouping vector(
      it's length must be the same as the number of rows of x)
    */

  /*
  counter: for picking out the indices of a group
  indexer1: for filling the vector containing the indicies of where a particular group occurs
  indexer2: for indexing the output vector d
   */

  
  int local_m = *m, local_n = *n, counter = 0, unique_length = *l, 
  indexer1, indexer2 = 0, g, h, i, j, k, XI, XJ, XI0, group_length;
  double theSum; 

  for(i=0; i < unique_length; i++){
    group_length = lg[i];
    int group_index[group_length];
    counter = 0;
    indexer1 = -1;
    for(j=0; j<local_m; j++, counter++){

      if( unique_group[i] == group_vec[j] ){
        indexer1 += 1;
        group_index[indexer1] = counter;
        
      }
    }
      for(g=0; g < group_length; g++){
          XI = local_n* group_index[g];
          XI0 = XI;

        for(h=g+1; h < group_length; h++){
          XJ = local_n* group_index[h];

          theSum = 0.0;
          for (k=0;k<local_n;k++,++XI,++XJ){
            theSum += pow((x[XI]- x[XJ]), 2.0);
          }
          XI = XI0;
          d[indexer2++] = sqrt(theSum);

        }
      }
      
    }
}
