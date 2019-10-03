import numpy as np
from math import sqrt

# using vectrization
def e_dist(A, B):
    assert len(A) == len(B), "Invalid input(s)"

    return sqrt(sum((np.array(A) - np.array(B))**2))

# using dot product
def dot_prod_dist(u, v):
    assert len(u) == len(v), "invalid input(s)"
    A = np.array(u) - np.array(v)
    return sqrt(sum(A*A))

def dist_func(A, B,  func):
    return func(A, B)

def euc_func(M, func):
    # M is a numpy nd array
    m, n = M.shape
    distance = np.zeros(n*(n-1)//2)
    k = 0
    for i in range(n - 1):
        for j in range(i+1, n):
            distance[k] = dist_func(M[i, ], M[j, ], func)
            k += 1
    return distance
        