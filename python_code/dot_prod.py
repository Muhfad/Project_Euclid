
def dot_prod(u, v):
    assert(len(u) == len(v), "invalid input(s)")
    return sum(np.array(u)*np.array(v))


def dot_prod_dist(u, v):
    assert(len(u) == len(v), "invalid input(s)")
    A = np.array(u) - np.array(v)
    return sqrt(dot_prod(A, A))
        