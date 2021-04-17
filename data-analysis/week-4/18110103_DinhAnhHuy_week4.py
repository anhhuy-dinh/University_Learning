# Import libraries
from __future__ import print_function
import pandas as pd
import numpy as np
from pandas import Series, DataFrame
import matplotlib as mpl
from matplotlib import pyplot as plt
import seaborn as sns
import sys
import argparse
import cv2

def ex1():
    # (i) Load dataframe
    path = 'https://raw.githubusercontent.com/anhhuy-dinh/2020-2021/master/semester-1/data-analysis/week-4/stock_px.csv'
    stock_df = pd.read_csv(path, index_col=0)
    print(stock_df.head())
    # (ii) Giai thich, mo ta tung cot du lieu
    """
    Dataset stock_px la bo du lieu ve gia tri chung khoan cua cac cong ty theo tung ngay. 
    Trong do, moi cot la gia tri chung khoan theo ngay cua cac cong ty AA, AAPL, GE, IBM, JNJ, MSFT, PEP, SPX, XOM.
    """
    print(stock_df.info())
    # (iii) Ve bieu do gia cua tung cot
    print(stock_df.columns)
    column = input("Input company: ")
    if column in stock_df.columns:
        stock_df[column].plot()
    else:
        print("This company is not exist.\n")
    # (iv) Tinh cac dai luong Thong ke mo ta
    print(stock_df.describe())
    # (v) Ve do thi
    stock_df.plot()
    # (vi) Ve histogram
    stock_df.hist()
    # (vii) Ve box-plot
    plt.figure()
    sns.boxplot(data = stock_df)
    plt.show()

def ex2():
    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--image", required = False, help = "/home/dinh_anh_huy/GitHub/2020-2021/semester-1/data-analysis/week-4/Face04.jpg")
    args = vars(ap.parse_args())
    image = cv2.imread(args["image"])
    # color = ('R', 'G', 'B')
    # for channel in range(2):
    #     for i in range(channel+1, 3, 1):
    #         image = cv2.imread(args["image"])
    #         image[:, :, channel] = image[:, :, i] = 0
    #         cv2.imwrite("trcx_{}.png".format(color[i+channel-1]), image)
    cv2.imshow('sourceimage', image)
    cv2.waitKey(0)

def ex3():
    """ Handle missing data on file """
    # Doc file co missing data (file ex5.csv trong chuong 6 - Python for Data Analysis)
    path = 'https://raw.githubusercontent.com/anhhuy-dinh/2020-2021/master/semester-1/data-analysis/week-4/ex5.csv'
    df = pd.read_csv(path)
    print(df.head())
    # Dung ham isnull() de kiem tra gia tri bi mat (tra ve True neu gia tri la NaN/NA)
    print(pd.isnull(df))
    # Loai bo cac hang co missing values
    print(df.dropna())
    # Dung ham fillna() de lap day gia tri tai cac vi tri file khong co du lieu
    ## Thay the cac gia tri NaN/NA (missing values) co type=int64/float64 bang gia tri trung binh cua cot do
    df.fillna(df.mean(), inplace=True)
    print(df.head())
    ## Thay the cac gia tri NaN/NA (missing values) bang cach lay gia tri truoc/sau do trong cung cot bang argument method='ffill'/'bfill'
    print(df.fillna(method='ffill'))
    print(df.fillna(method='bfill'))
    """ Table 6-2. read_csv/read_table function arguments """
    # Ham pandas.read_csv() cho phep doc vao mot file .csv va tra ve 1 dataframe
    ## Cac arguments
    # argument                  description
    # path              Mot chuoi tra ve vi tri cua tep hoac mot dia chi URL
    # sep/delimiter     Thay doi day ngan cach giua cac cot. Mac dinh la dau phay (',')
    # header            Chi dinh file doc vao co header (tieu de cua cac cot) hay khong. Mac dinh la infer
    # index_col         Chi dinh chi so cot nao la cot chi so (so thu tu). Mac dinh la None
    # names             Truyen vao danh sach ten cac cot khi header = None
    # skiprows          Chi dinh so hang (bat dau tu 0) de bo qua
    # na_values         Thay doi cac gia tri chi dinh thanh NA
    # comment           Cac ky tu de tach comments ra cuoi dong
    # parse_dates       Phan tach du lieu thanh du lieu thoi gian. Mac dinh la False.
    # keep_date_col     Tha cac cot da ghep. Mac dinh la True
    # converters        Dict chua ten cot va ham tuong ung. Vi du {'foo': f} se ap dung ham f cho tat ca ca gia tri trong cot 'foo'
    # dayfirst          Dua du lieu ngay thang ve dang chuan quoc te. Mac dinh la False
    # date_parser       Ham su dung de phan tach cac du lieu ngay thang
    # nrows             Chi dinh so ban ghi se doc vao. Mac dinh la None - doc toan bo
    # iterator          Tra ve mot doi tuong TextParser de doc tung phan file
    # chunksize         Tra ve doi tuong TextFileReader de lap lai
    # skip_footer       Chi dinh so dong can bo qua o cuoi tep
    # verbose           Cho biet so gia tri bi mat (missing values) tai cac cot chua gia tri khong phai so
    # encoding          Ma hoa van ban ve dang unicode. Vi du 'utf-8' dua van ban ve dang ma hoa 'UTF-8'
    # squeeze           Neu du lieu duoc truyen vao chi chua mot cot thi tra ve mot Series chua gia tri cua cot do
    # thousands         Chi dinh dau ngan cach phan nghin
# ex1()
ex2()
# ex3()
