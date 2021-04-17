# Import thu vien numpy
import numpy as np

""" Boolean Indexing """

# Tao mang ten (names) bang ham array trong thu vien numpy (cac ten co the bi trung)
names = np.array(['Bob', 'Joe', 'Will', 'Bob', 'Will', 'Joe', 'Joe'])

# Tao mau ngau nhien (data) tu phan phoi chuan kich thuoc 7x4
data = np.random.randn(7,4)

# In ra mang names
print(names)

# In ra mau data
print(data)

# In ra mang cac ket qua khi so sanh tung phan tu trong mang names voi 'Bob' 
# (tra ve True neu bang, nguoc lai tra ve False)
print(names == 'Bob')

# In ra mau data, nhung chi in ra cac dong co chi so tuong ung voi gia tri True khi so sanh mang names voi 'Bob'
print(data[names == 'Bob'])

# Tuong tu, nhung chi in ra cac cot co chi so tu 2 tro len
print(data[names == 'Bob', 2:])

# Tuong tu, nhung chi in ra cot co chi so la 3
print(data[names == 'Bob', 3])

# In ra mang cac ket qua khi so sanh tung phan tu trong mang names voi 'Bob' 
# (tra ve True neu khac, nguoc lai tra ve False)
print(names != 'Bob')

# In ra mau data, nhung chi in ra cac dong co chi so tuong ung voi gia tri False khi so sanh mang names voi 'Bob'
print(data[~(names == 'Bob')])

# Tao mang mask la mang ket qua cua phep so sanh mang names voi 'Bob' va 'Will' 
# (tra ve True neu tung phan tu bang 'Bob' hoac 'Will', nguoc lai tra ve False)
mask = (names == 'Bob') | (names == 'Will')

# In mang mask
print(mask)

# In ra mau data, nhung chi in cac dong co chi so tuong ung voi gia tri True trong mang mask
print(data[mask])

# Thay cac gia tri nho hon 0 trong mau data bang 0
data[data<0] = 0

# In mau data
print(data)

# Thay cac gia tri cua cac dong co chi so tuong ung voi gia tri True khi so sanh names voi 'Joe' bang 7
data[names != 'Joe'] = 7

# In mau data
print(data)

""" Expressing Conditional Logic as Array Operations """

# Tao mang 2 mang cac gia tri xarr, yarr va mang boolean cond
xarr = np.array([1.1, 1.2, 1.3, 1.4, 1.5])
yarr = np.array([2.1, 2.2, 2.3, 2.4, 2.5])
cond = np.array([True, False, True, True, False])

# Tao mang result lay gia tri tu xarr neu gia tri tuong ung trong cond la True, nguoc lai lay gia tri tu yarr
result = [(x if c else y) for x, y, c in zip(xarr, yarr, cond)]

# In mang result
print(result)

# Tuong tu cach tao mang result o tren, nhung thuc hien bang ham where trong thu vien numpy
result = np.where(cond, xarr, yarr)

# In mang result
print(result)

# Tao mau ngau nhien (arr) kich thuoc 4x4
arr = np.random.randn(4,4)

# In mau arr
print(arr)

# Su dung ham where de thay doi cac gia tri lon hon 0 trong arr bang 2, nguoc lai thay bang -2
print(np.where(arr > 0, 2, -2))

# Tuong tu, nhung chi thay doi cac gia tri duong trong arr bang 2, nguoc lai giu nguyen
print(np.where(arr > 0, 2, arr))

# Tao mang rong (result)
result = []

# Gan n = 5
n = 5

# Tao 2 mang Boolean cond1 va cond2
cond1 = np.array([True, False, True, True, False])
cond2 = np.array([True, False, False, True, True])

# Dung vong lap (for) de xet tung phan tu trong 2 mang:
# - Them 0 vao result neu gia tri tuong ung cua cond1, cond2 tra ve True,
# - Them 1 vao result neu gia tri tuong ung cua cond1 tra ve True,
# - Them 2 vao result neu gia tri tuong ung cua cond2 tra ve True,
# - Truong hop khac, them 3 vao result.
for i in range(n):
    if cond1[i] and cond2[i]:
        result.append(0)
    elif cond1[i]:
        result.append(1)
    elif cond2[i]:
        result.append(2)
    else:
        result.append(3)
print(result)

# Tuong tu, nhung thuc hien bang ham where trong thu vien numpy
print(np.where(cond1 & cond2, 0, np.where(cond1, 1, np.where(cond2, 2, 3))))

# Trong bieu thuc tinh toan, gia tri boolean mang gia tri la 0 hoac 1.
# Thuc hien bieu thuc ben duoi voi tung phan tu cua cond1 va cond2 ta duoc mang result
result = 1 * cond1 + 2 * cond2 + 3 * ~(cond1 | cond2)
print(result)
