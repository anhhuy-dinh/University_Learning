import numpy as np
from matplotlib import pyplot as plt

def random_walks(number_steps):
    """ Ham random_walks thuc hien tao Random Walks qua 3 buoc:
    - Tao ngau nhien mot mang (draws) cac gia tri 0 hoac 1 voi kich thuoc duoc truyen vao.
    - Tao mang steps co cung kich thuoc voi draws, voi cac gia tri la 1 hoac -1 tuong ung voi cac gia tri 1 hoac 0 trong draws.
    - Tao mang walk voi cac phan tu co gia tri la tong cac phan tu truoc do co gia tri tuong ung trong mang steps."""
    draws = np.random.binomial(1,0.5,size = number_steps)
    steps = np.where(draws > 0, 1, -1)
    walk = steps.cumsum()
    return walk

def plot_random_walks(walk):
    """ Mo ta Random Walks bang do thi """
    print(walk)
    plt.figure()
    plt.plot(walk)
    plt.show()

plot_random_walks(random_walks(1000))
