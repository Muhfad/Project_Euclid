
import numpy as np 
cimport numpy as np
from copy import deepcopy # this is used to avoid the function from changing the input

cdef extern from "eucdist.h":
    bint euc_dist(double* input, int m, int n, double* output)


def dist(input):
    "Input is an nd array and the function returns the distance between any two rows"
    # this helps to prevent changing the nature of the input
    retain_global_input = deepcopy(input)
    m, n = retain_global_input.shape
    length = m*n
    retain_global_input.shape = length
    output = np.empty(int(m*(m-1)/2), dtype=np.float64)
    status = euc_dist(<double*> np.PyArray_DATA(retain_global_input), 
                        m, n, <double*> np.PyArray_DATA(output))

    assert status == 1, "There is a problem with the compilation/linking"
    return output
