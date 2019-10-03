import numpy as np
import pandas as pd 
import os
os.chdir('/home/medfad/Desktop/WD/2019/Abdul/Project_Euclid/CyPy')
from random import normalvariate
from math import sqrt
from mymodule2 import dist
import sys
import timeit
from functions import *


def wrapper(func, *args, **kwargs):
    ''' wrapper for timing functions 
    '''
    def wrapped():
        return func(*args, **kwargs)
    return wrapped



# time_dict = dict()
nrows = [100, 500, 1000, 1500, 3000]
n = 2
print('The times are calculated by taking the average time of 100 replications of the same function')

time_rows = pd.DataFrame(columns = ["Cython", "eucdist", "dotprod", "base_times"], dtype=np.float64)
# time_rows["eucdist"] = np.ones(len(nrows))
row_index = 0
for m in nrows:
        M = np.empty([m, n])
        for i in range(m):
                for j in range(n):
                        M[i, j] = normalvariate(10, 10)
        t_base = round(timeit.timeit(wrapper(the_loop, M, e_dist), number=100), 3) # this is taken to be the base python equivalent of dist in R 
        t1 = round(timeit.timeit(wrapper(the_loop, M, dot_prod_dist), number=100), 3)
        relative1 = round(t_base/t1, 3)
        t2 = round(timeit.timeit(wrapper(dist, M), number=100), 3)
        relative2 = round(t_base/t2, 3)
        time_rows.loc[row_index] = [relative2, 1, relative1, t_base]
        row_index += 1

        print('\n', 80*'*', '\n')

        print(f'{m} by {n}\n')
        print(f'python function without dot product\n\ttime\trelative\n\t{t_base}\t{1}\n')
        
        print(f'using C\n\ttime\trelative\n\t{t2}\t{relative2}\n')
    
        print(f'using dot product\n\ttime\trelative\n\t{t1}\t{relative1}\n')

        
# writing saving the time_row object


import pickle 
file_time = open('time_rows.obj', 'w') 
pickle.dump(file_time, time_rows)