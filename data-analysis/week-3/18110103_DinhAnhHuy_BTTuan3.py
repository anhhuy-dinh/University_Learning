from pandas import Series, DataFrame
import pandas as pd
import numpy as np 

# creat a dataframe from dictionary (pop) and set index name = year, columns name = state
pop = {'Nevada': {2001: 2.4, 2002: 2.9},
       'Ohio': {2000: 1.5, 2001: 1.7, 2002: 3.6}}
frame3 = DataFrame(pop)
frame3.index.name = 'year'
frame3.columns.name = 'state'

"""Index Objects"""

# creat a Series (obj) with indexs are a, b, c
obj = Series(range(3), index=['a', 'b', 'c']) 
print(obj)

# return index of obj
index = obj.index
print(index) # print all index
print(index[1:]) # print values in index from index 1

# index objects are immutable and thus can't be modified
# index[1] = 'd' (error)

# create index with values in range (0,3) 
index = pd.Index(np.arange(3))
print(index)
# create a Series (obj2) with index is created above
obj2 = Series([1.5, -2.5, 0], index=index)
# return True if index of obj2 = index else return False
print(obj2.index is index)

print(frame3)
# return True if 'Ohio' is in one of columns of frame3 else return False
print('Ohio' in frame3.columns)
# return True if 2003 is in index of frame3 else return False
print(2003 in frame3.index)

## Table 5-3. Index methods and properties
index1 = pd.Index(['a', 'b', 'c']) 
index2 = pd.Index(['d', 'e', 'f', 'a']) 
index3 = pd.Index(['a', 'b', 'c', 'b'])
# append index2 in index1 together, return appended index
index = index1.append(index2) 
print(index)
# corresponding to 'diff' in Table 5-3 - return a new index with elements of index1 not in index2.
print(index1.difference(index2)) 
# return a new index with elements in both index1 and index2
print(index1.intersection(index2)) 
# return a new index with elements in index1 or index2
print(index1.union(index2))
# return a boolean array indicating whether each value in index1 is contained in the index2 
print(index1.isin(index2))
# return a new index with element at index 2 deleted 
print(index1.delete(2)) 
# return a new index by deleting 'a' and 'b' in index1
print(index1.drop(['a', 'b']))
# return a new index by inserting 't' at index 3 
print(index1.insert(3, 't'))
# return True if data in index1 is monotonically increasing else return False 
print(index1.is_monotonic)
# return True if index3 has no duplicate values else return False 
print(index3.is_unique)
# return  a new array with elements are unique values in index3 
print(index3.unique()) 

""" Arithmetic and data alignment """

# create Series s1 and s2
s1 = Series([7.3, -2.5, 3.4, 1.5], index=['a', 'c', 'd', 'e'])
s2 = Series([-2.1, 3.6, -1.5, 4, 3.1], index=['a', 'c', 'e', 'f', 'g'])
print(s1, '\n', s2)
# add s1 and s2 together
print(s1 + s2)
# create dataframe df1 and df2
df1 = DataFrame(np.arange(9.).reshape((3, 3)), columns=list('bcd'), index=['Ohio', 'Texas', 'Colorado'])
df2 = DataFrame(np.arange(12.).reshape((4, 3)), columns=list('bde'), index=['Utah', 'Ohio', 'Texas', 'Oregon'])
print(df1, '\n', df2)
# add df1 and df2 together
print(df1 + df2)
""" Arithmetic methods with fill values """
# create dataframe df1 and df2
df1 = DataFrame(np.arange(12.).reshape((3, 4)), columns=list('abcd'))
df2 = DataFrame(np.arange(20.).reshape((4, 5)), columns=list('abcde'))
print(df1, '\n', df2)
# add df1 and df2 together
print(df1 + df2)
# fill missing (NaN) values with 0 and return addition of df1 and df2
print(df1.add(df2, fill_value=0))
# rearrange df1 according to columns of df2 and fill missing value with 0
print(df1.reindex(columns=df2.columns, fill_value=0))
# fill missing (NaN) values with 0 and return subtraction of df1 and df2
print(df1.sub(df2, fill_value=0))
# fill missing (NaN) values with 0 and return division of df1 and df2
print(df1.div(df2, fill_value=0))
# fill missing (NaN) values with 0 and return multiplication of df1 and df2
print(df1.mul(df2, fill_value=0))
""" Operations between DataFrame and Series """
# create a matrix (3x4) with values in range (0,11)
arr = np.arange(12.).reshape((3, 4))
print(arr)
print(arr[0])
# take each row of arr to sub to arr[0]
print(arr - arr[0])
# create dataframe (frame)
frame = DataFrame(np.arange(12.).reshape((4, 3)), columns=list('bde'), index=['Utah', 'Ohio', 'Texas', 'Oregon'])
# corresponding to pandas.dataframe.ix, return the row of frame at index 0
series = frame.iloc[0]
print(frame)
print(series)
# By default, arithmetic between DataFrame and Series matches the index of the Series on the DataFrame's columns, broadcasting down the rows
# take each rows of frame to sub to series
print(frame - series)
# If an index value is not found in either the DataFrame’s columns or the Series’s index, the objects will be reindexed to form the union
series2 = Series(range(3), index=['b', 'e', 'f'])
# take each rows of frame to add to series2
print(frame + series2)
# take columns d of frame to copy to series3
series3 = frame['d']
print(frame)
print(series3)
# use sub method to return subtraction of frame and series3 over the column
print(frame.sub(series3, axis=0))

""" Function application and mapping """

# create dataframe (frame)
frame = DataFrame(np.random.randn(4, 3), columns=list('bde'), index=['Utah', 'Ohio', 'Texas', 'Oregon'])
print(frame)
# return new dataframe with absolute values of passed dataframe
print(np.abs(frame))
# use lambda function to take result of subtraction of max and min value of x array
f = lambda x: x.max() - x.min()
# use dataframe.apply method to apply f at each column of frame
print(frame.apply(f))
# use dataframe.apply method to apply f at each row of frame
print(frame.apply(f, axis=1))

# f1 function return a Series with min and max values of x passed array
def f1(x):
    return Series([x.min(), x.max()], index=['min', 'max'])
# use apply method to apply f1 at each column of frame
print(frame.apply(f1))

# format function to round values of x to hundredths 
format = lambda x: '%.2f' % x
# use applymap method to apply format function to every element of frame.
print(frame.applymap(format))
# use map method to apply format function to every element of column e of frame
print(frame['e'].map(format))

""" Sorting and ranking """

obj = Series(range(4), index=['d', 'a', 'b', 'c'])
# sort values of obj by index
print(obj.sort_index())

frame = DataFrame(np.arange(8).reshape((2, 4)), index=['three', 'one'], columns=['d', 'a', 'b', 'c'])
# sort dataframe (frame) by column
print(frame.sort_index())
# sort dataframe (frame) by index
print(frame.sort_index(axis=1))
# sort dataframe (frame) in descending order by index 
print(frame.sort_index(axis=1, ascending=False))

obj = Series([4, 7, -3, 2])
# corresponding to obj.order(), sort value of obj in ascending 
print(obj.sort_values())

obj = Series([4, np.nan, 7, np.nan, -3, 2])
# any missing values are sorted to the end of the Series by default
print(obj.sort_values())

frame = DataFrame({'b': [4, 7, -3, 2], 'a': [0, 1, 0, 1]})
print(frame)
# sort values of column 'b' of frame in ascending
print(frame.sort_values(by='b')) 
# sort values of column 'a' and 'b' of frame in ascending
print(frame.sort_values(by=['a', 'b']))

obj = Series([7, -5, 7, 4, 2, 0, 4])
# compute numerical data ranks (1 through 7) along axis. 
# equal values are assigned a rank that is the average of the ranks of those values.
print(obj.rank())
# use method='first' to assign ranks according to the order the values appear in obj
print(obj.rank(method='first'))
# return ranks of each value of obj in descending order
print(obj.rank(ascending=False, method='max'))
# method         desciption
#'avarage'       Default: assign the average rank to each entry in the equal group.
#'min'           Use the minimum rank for the whole group.
#'max'           Use the maximum rank for the whole group.
#'first'         Assign ranks in the order the values appear in the data.

frame = DataFrame({'b': [4.3, 7, -3, 2], 'a': [0, 1, 0, 1], 'c': [-2, 5, 8, -2.5]})
print(frame)
# compute ranks over the rows of dataframe (frame)
print(frame.rank(axis=1))

""" Axis indexes with duplicate values """

obj = Series(range(5), index=['a', 'a', 'b', 'b', 'c'])
print(obj)
# return True if obj.index's values are unique else return false
print(obj.index.is_unique)
# return rows 'a' of obj
print(obj['a'])
# return rows 'c' of obj
print(obj['c'])
# create dataframe with random values
df = DataFrame(np.random.randn(4, 3), index=['a', 'a', 'b', 'b'])
print(df)
# return rows 'b' of dataframe
print(df.loc['b'])

""" Handling Missing Data """

# use the floating point value NaN (Not a Number) to represent missing data in both floating as well as non-floating point arrays
# example for missing data (data at index 2 of string_data is missed)
string_data = Series(['aardvark', 'artichoke', np.nan, 'avocado'])
print(string_data)
# return like-type object containing boolean values indicating which values are missing / NA.
print(string_data.isnull())
# the built-in python None value is also treated as NA in object arrays
string_data[0] = None
print(string_data.isnull())

## Filtering Out Missing Data
# import numpy.nan library as NA
from numpy import nan as NA
# create a Series with NA values
data = Series([1, NA, 3.5, NA, 7])
print(data)
# return a new Series with missing values/NA removed
print(data.dropna())
# removed missing values in data by boolean indexing
print(data[data.notnull()])

# with dataframe
# create a datafame with NA values
data = DataFrame([[1., 6.5, 3.], [1., NA, NA], [NA, NA, NA], [NA, 6.5, 3.]])
# return a new dataframe with any row containing a missing value removed
cleaned = data.dropna()
print(data)
print(cleaned)
# passing how='all' will only drop rows that are all NA
print(data.dropna(how='all'))
# dropping columns in the same way is only a matter of passing axis=1
data[4] = NA
print(data)
print(data.dropna(axis=1, how='all'))

# use thresh argument to drop rows containing many NA values
df = DataFrame(np.random.randn(7, 3))
df.iloc[:4, 1] = NA
df.iloc[:2, 2] = NA
print(df)
# with thresh=2, dropping rows with index 0, 1, 2 that have 2 missing values
print(df.dropna(thresh=2))

## Filling in Missing Data
# replace NA or fill missing data with 0 by fillna method
print(df.fillna(0))
# filling value for each column (fill with 0.5 at column 1 and -1 at column 3)
print(df.fillna({1: 0.5, 3: -1}))

# always returns a reference to the filled object
# inplace argument is a boolean which makes the changes in dataframe itself if True.
_ = df.fillna(0, inplace=True)
print(df)
# create a data frame with random values
# then, replace values that at column 1, index from 2 and column 2, index from 4 with NA values
df = DataFrame(np.random.randn(6, 3))
df.iloc[2:, 1] = NA
df.iloc[4:, 2] = NA
print(df)
# use method argument to fill the missing values with value in the forward index
print(df.fillna(method='ffill'))
# fill 2 of consecutive NA values with value to forward
print(df.fillna(method='ffill', limit=2))
data = Series([1., NA, 3.5, NA, 7])
# fill NA values with mean value of data (just calculate mean of existing datas)
print(data.fillna(data.mean()))

""" Summary Statistics by Level """
# Many descriptive and summary statistics on DataFrame and Series have a level option in which you can specify the level you want to sum by on a particular axis.

# create a data frame (frame) with index names are [key1, key2] and columns names are [state, color]
frame = DataFrame(np.arange(12).reshape((4, 3)), index=[['a', 'a', 'b', 'b'], [1, 2, 1, 2]], columns=[['Ohio', 'Ohio', 'Colorado'], ['Green', 'Red', 'Green']])
frame.index.names = ['key1', 'key2']
frame.columns.names = ['state', 'color']
print(frame)
# sum all values along key2 level (rows at index key2)
print(frame.sum(level='key2'))
# sum all values along color level (color column)
print(frame.sum(level='color', axis=1))

""" Using a DataFrame's Columns """

frame = DataFrame({'a': range(7), 'b': range(7, 0, -1), 'c': ['one', 'one', 'one', 'two', 'two', 'two', 'two'], 'd': [0, 1, 2, 0, 1, 2, 3]})
print(frame)
# create a new DataFrame using its 'c' and 'd' columns as the index of frame2
frame2 = frame.set_index(['c', 'd'])
print(frame2)
# by default the columns are removed from the DataFrame, though you can leave them by drop=False argument
print(frame.set_index(['c', 'd'], drop=False))
#the hierarchical index levels are are moved into the columns (this method does the opposite of set_index)
print(frame2.reset_index())