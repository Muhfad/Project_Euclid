import numpy as np 
import pandas as pd 
from random import normalvariate
from math import sqrt

m = 5 # number of rows
n = 2 # number of columns

M = np.zeros(shape=[m, n])

for i in range(m):
    for j in range(n):
        M[i, j] = normalvariate(10, 10)


