

import multiprocessing
import os
import functions
import numpy as np
# os.chdir("python_code")
import pandas as pd 
from random import normalvariate
from functools import lru_cache

m = 5 # number of rows
n = 2 # number of columns
# @lru_cache(1000)
def fib(n):
    if n in [0, 1]:
        return 1
    else:
        return fib(n-1) + fib(n-2)
    # M = np.zeros(shape=[m, n])

# for i in range(m):
#     for j in range(n):
#         M[i, j] = normalvariate(10, 10)




number_of_processors = 4
pool = multiprocessing.Pool(processes=number_of_processors)

l = [500, 100, 35, 11, 300, 112, 34, 57, 397, 123, 237, 487, 456, 482, 442, 482, 682]
s = l*10
pool.map(fib, s)