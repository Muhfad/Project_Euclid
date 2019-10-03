

def e_dist(M, func):
    # M is a numpy nd array
    m, n = M.shape
    distance = np.zeros(n*(n-1)//2)
    k = 0
    for i in range(n - 1):
        for j in range(i+1, n):
            distance[k] = dist_func(M[i, ], M[j, ], func)
            k += 1
    return distance