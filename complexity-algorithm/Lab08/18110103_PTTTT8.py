import numpy as np
import random
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

def fibWord(n, k):
    compare = assign = 0
    f0 = "abc"
    f1 = "def"
    result = ""
    if n < 0 or k < 0:
        raise Exception("Your input is not suitable.")
    if n == 0:
        result = f0
        assign += 1
    elif n == 1:
        result = f1
        assign += 1
    else:    
        for i in range(2, n + 1):
            result = f1
            f1 += f0
            f0 = result
            compare += 1
            assign += 3
        compare += 1

    assign += 3
    compare += 4
    return result, result[k-1], compare, assign

def main():
    n = 5
    k = 5
    words, word, _, _ = fibWord(n, k)
    print("{}th fibonacci string: {}".format(n, words))
    print("{}th char of {}th fibonacci string: {}".format(k, n, word))

    # Plot complexity
    N = np.arange(0,30+1,1)
    
    temp = np.array([fibWord(n, 1) for n in N])

    fig, ax = plt.subplots(figsize=(12,5))
    ax.plot(N, N)
    ax.plot(N, temp[:,2])
    ax.plot(N, temp[:,3])
    ax.set(xlabel="N")
    ax.legend(["O(N)", "compare", "assign"])
    plt.savefig("fibWord.jpg")
    plt.show()

if __name__ == '__main__':
    main()