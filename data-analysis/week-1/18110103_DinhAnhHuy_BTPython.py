import numpy as np
import math as m

def mean(data):
    data1 = np.array(data)
    mean = np.sum(data1)/data1.size
    return mean

def var(data):
    data1 = np.array(data - mean(data))**2
    var = (1/(data1.size - 1))*np.sum(data1)
    return var

def std(data):
    std = np.sqrt(var(data))
    return std
    
def _min(data):
    data1 = sorted(np.array(data).flatten())
    return data1[0]
    
def _max(data):
    data1 = sorted(np.array(data).flatten())
    return data1[-1]
    
def _range(data):
    range_data = _max(data) - _min(data)
    return range_data

def quantile(data, q=0.5):
    data1 = sorted(np.array(data).flatten())
    n = len(data1)
    if q == 0.5:
        if n % 2 == 0:
            value = (data1[m.floor(q*(n+1))] + data1[m.ceil(q*(n+1))])/2
        else:
            value = data1[round(q*(n+1))]
    else:
        value = data1[m.floor(q*(n+1))]
    return value

def mode(data):
    data1 = np.array(data).flatten()
    d = dict([(item, data1[data1 == item].size) for item in data1])
    mode = [key for key in d.keys() if d[key] == max(d.values())]
    return mode

