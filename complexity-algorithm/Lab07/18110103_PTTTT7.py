import numpy as np
import random
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

def lan_chiem_cap_10(A):
    compare = assign = 0
    n = len(A)
    counts = {}
    for i in range(n):
        if A[i] in counts:
            counts[A[i]] += 1
        else:
            counts[A[i]] = 1
        compare += 2
        assign += 1
    
    result = []
    for value in counts:
        if counts[value] >= n//10:
            result.append(value)
            assign += 1
        compare += 2
        
    compare += 2
    assign += 3
    return result, compare, assign

def merge_sorted_arrays(A, B):
    compare = assign = 0
    n = len(A)
    C = []
    i = j = 0
 
    # Traverse both array
    while i < n and j < n:
        if A[i] < B[j]:
            C.append(A[i])
            i = i + 1
        else:
            C.append(B[j])
            j = j + 1
        compare += 3
        assign += 2
     
    # Store remaining elements of first array
    while i < n:
        C.append(A[i])
        i = i + 1
        compare += 1
        assign += 2
 
    # Store remaining elements of second array
    while j < n:
        C.append(B[j])
        j = j + 1
        compare += 1
        assign += 2

    assign += 4
    compare += 4
    return C, compare, assign


def main():
    np.random.seed(3)
    ''' 
    ******************************************
    *               Exercise 1               *
    ******************************************
    '''
    # Test
    print(" "*15+"Exercise 1")
    print("*"*40)
    A = np.random.randint(1,10, 20)
    res, _, _ = lan_chiem_cap_10(A)
    print("Array A: ", A)
    print("Cac phan tu lan chiem cap đo 10 trong A: ", res)

    # Plot complexity
    N = np.arange(1,1000+1,10)
    
    AA = np.array([np.random.randint(0, 500, n) for n in N])
    temp = np.array([lan_chiem_cap_10(A) for A in AA])

    fig, ax = plt.subplots(figsize=(12,5))
    ax.plot(N, N, linewidth=3, color='gold')
    ax.plot(N, temp[:,1])
    ax.plot(N, temp[:,2], color='k')
    ax.set(xlabel="N")
    ax.legend(["O(N)", "compare", "assign"])
    plt.savefig("ex_1.jpg")
    plt.show()
    ''' 
    ******************************************
    *               Exercise 2               *
    ******************************************
    '''
    # Test
    print(" "*15+"Exercise 2")
    print("*"*40)
    A = np.sort(np.random.randint(1,10,5))
    B = np.sort(np.random.randint(1,10,5))
    C, _, _ = merge_sorted_arrays(A,B)
    print("A sorted A = ", A)
    print("A sorted B = ", B)
    print("Merged array = ", C)

    # Plot complexity
    N = np.arange(1,1000+1,10)
    AA = np.array([np.random.randint(0, 500, n) for n in N])
    BB = np.array([np.random.randint(0, 500, n) for n in N])
    temp = np.array([merge_sorted_arrays(A, B) for A, B in zip(AA, BB)])

    fig, ax = plt.subplots(figsize=(12,5))
    # ax.plot(N, N*S)
    ax.plot(N, N)
    ax.plot(N, temp[:,1])
    ax.plot(N, temp[:,2])
    ax.set(xlabel="N")
    ax.legend(["O(N)", "compare", "assign"])
    plt.savefig("ex_2.jpg")
    plt.show()

if __name__ == '__main__':
    main()