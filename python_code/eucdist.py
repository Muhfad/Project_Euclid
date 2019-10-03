
def e_dist(A, B):
    assert len(A) == len(B), "Invalid input(s)"

    return sqrt(sum((np.array(A) - np.array(B))**2))