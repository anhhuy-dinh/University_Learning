import numpy as np
import random
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

def search(arr, value):
    for idx, val in enumerate(arr):
        if value == val:
            return idx
    return -1

def sum_of_squares_of_digits(value):
    return sum(int(c) ** 2 for c in str(value))

def min_cycle_permutation(N):
    seq = [N]
    while True:
        current = sum_of_squares_of_digits(seq[-1])
        seq.append(current)
        temp_seq = seq[:-1]
        idx = search(temp_seq, current)
        if idx != -1:
            return seq[idx:-1]
        else:
            continue

def main():
    N = int(input("Input your number: "))
    print("Results : ", min_cycle_permutation(N))

if __name__ == "__main__":
    main()