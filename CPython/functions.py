import numpy as np 
from math import sqrt


def dist_func(A, B,  func):
        ''' apply a distance calculating function two list'''
        return func(A, B)


# using vectorization
def e_dist(A, B):
        assert len(A) == len(B), "Invalid input(s)"
        return sqrt(sum([(A[i] - B[i])**2 for i in range(len(A))]))

#using dot product
def dot_prod(u, v):
        assert len(u) == len(v), "invalid input(s)"
        return sum(np.array(u)*np.array(v))


def dot_prod_dist(u, v):
        assert len(u) == len(v), "invalid input(s)"
        A = np.array(u) - np.array(v)
        return sqrt(dot_prod(A, A))
        


def the_loop(M, func):
        # M is a numpy nd array
        m = M.shape[0]
        distance = np.zeros(int(m*(m-1)//2))
        k = 0
        for i in range(m-1):
                A = M[i, ]
                for j in range(i+1, m):
                        distance[k] = dist_func(A, M[j, ], func)
                        k += 1
        return distance