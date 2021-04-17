import pandas as pd
from pandas import Series
import numpy as np

# data = pd.DataFrame({'k1': ['one', 'two']*3 + ['two'],
#                     'k2': [1, 1, 2, 3, 3, 4, 4]})
# print(data)
# print(data.duplicated())
# print(data.drop_duplicates())
# data['v1'] = range(7)
# print(data)
# print(data.drop_duplicates(['k1']))
# print(data.drop_duplicates(['k1', 'k2'], keep='last'))

# data = pd.DataFrame({'food': ['bacon', 'pulled pork', 'bacon', 'Pastrami', 'corned beef', 'Bacon', 'pastrami', 'honey ham', 'nova lox'],
#                      'ounces': [4, 3, 12, 6, 7.5, 8, 3, 5, 6]})
# print(data)
# meat_to_animal = {
# 'bacon': 'pig',
# 'pulled pork': 'pig',
# 'pastrami': 'cow',
# 'corned beef': 'cow',
# 'honey ham': 'pig',
# 'nova lox': 'salmon'
# }
# data['animal'] = data['food'].map(str.lower).map(meat_to_animal)
# print(data)
# print(data['food'].map(lambda x: meat_to_animal[x.lower()]))

# data = Series([1., -999., 2., -999., -1000., 3.])
# print(data)
# print(data.replace(-999, np.nan))
# print(data.replace([-999, -1000], np.nan))
# print(data.replace([-999, -1000], [np.nan, 0]))
# print(data.replace({-999: np.nan, -1000: 0}))

# data = pd.DataFrame(np.arange(12).reshape((3, 4)), 
#                  index=['Ohio', 'Colorado', 'New York'],
#                  columns=['one', 'two', 'three', 'four'])
# # print(data)                 
# # print(data.rename(index=str.title, columns=str.upper))
# data = data.rename(index=str.upper)
# # print(data.rename(index={'OHIO': 'INDIANA'}, columns={'three': 'peekaboo'}))
# _ = data.rename(index={'OHIO': 'INDIANA'}, inplace=True)
# print(data)

# ages = [20, 22, 25, 27, 21, 23, 37, 31, 61, 45, 41, 32]
# bins = [18, 25, 35, 60, 100]
# cats = pd.cut(ages, bins)
# print(cats)
# print(cats.codes)
# print(cats.categories)
# print(pd.value_counts(cats))
# print(pd.cut(ages, [18, 26, 36, 61, 100], right=False))
# group_names = ['Youth', 'YoungAdult', 'MiddleAged', 'Senior']
# print(pd.cut(ages, bins, labels=group_names))
# data = np.random.rand(20)
# print(pd.cut(data, 4, precision=2))
# data = np.random.randn(1000) # Normally distributed
# cats = pd.qcut(data, 4) # Cut into quartiles
# print(cats)
# data = pd.DataFrame(np.random.randn(1000, 4))
# print(data.describe())
# col = data[3]
# print(col[np.abs(col) > 3])
# print(np.sign(0))
# df = pd.DataFrame(np.arange(5 * 4).reshape(5, 4))
# print(df)
# sampler = np.random.permutation(5)
# print(sampler)
# print(df.take(sampler))

# choices = pd.Series([5, 7, -1, 6, 4])
# draws = choices.sample(n=10, replace=True)
# print(draws)
df1 = pd.DataFrame({'key': ['b', 'b', 'a', 'c', 'a', 'a', 'b'],
                    'data1': range(7)})
df2 = pd.DataFrame({'key': ['a', 'b', 'd'],
                    'data2': range(3)})

df = pd.merge(df1, df2, on='key', how='left')
print(df)
df3 = pd.DataFrame()