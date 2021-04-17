# Import libraries
import numpy as np
import cv2
import argparse
import math

def read_img(path_img):
    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--image", required = False, help = path_img)
    args = vars(ap.parse_args())
    image = cv2.imread(args["image"])
    return image

def distance(x, y, i, j):
    return np.sqrt((x-i)**2 + (y-j)**2)

def gaussian(x, sigma):
    return np.exp(- (x ** 2) / (2 * sigma ** 2)) / (2 * np.pi * (sigma ** 2))

def apply_bilateral_filter(src_img, filtered_image, x, y, d, sigma_i, sigma_s):
    h, w = src_img.shape
    centre = d // 2
    i_filtered = 0
    Wp = 0
    for i in range(d):
        for j in range(d):
            neightbour_x = (int)(x - (centre - i))
            neightbour_y = (int)(y - (centre - j))
            gi = gaussian(src_img[x][y] - src_img[neightbour_x][neightbour_y], sigma_i)
            fs = gaussian(distance(neightbour_x, neightbour_y, x, y), sigma_s)
            w = gi * fs
            i_filtered += src_img[neightbour_x][neightbour_y] * w
            Wp += w
    i_filtered = i_filtered / Wp
    filtered_image[x][y] = int(i_filtered)

def bilateral_filter(src_img, d, sigma_i, sigma_s):
    img = cv2.cvtColor(src_img, cv2.COLOR_RGB2HSV)
    img_v_channel = img[:, :, 2]
    h, w = img_v_channel.shape
    centre = d // 2
    new_h = h + centre * 2
    new_w = w + centre * 2
    new_image = np.zeros((new_h, new_w))
    new_image[centre : new_h - centre, centre : new_w - centre] = img_v_channel
    filtered_image = np.zeros_like(new_image)
    for i in np.arange(centre, new_h - centre):
        for j in np.arange(centre, new_w - centre):
            apply_bilateral_filter(new_image, filtered_image, i, j, d, sigma_i, sigma_s)
    img[:, :, 2] = filtered_image[centre : new_h - centre, centre : new_w - centre] 
    output_img = cv2.cvtColor(img, cv2.COLOR_HSV2RGB)
    return output_img

def main():
    path = '/home/dinh_anh_huy/GitHub/2020-2021/semester-1/data-analysis/week-6/t-rex.jpg'
    image = read_img(path)
    blurred = cv2.bilateralFilter(image, 9, 41, 41)
    blurred_inbuilt = bilateral_filter(image, 9, 41, 41)
    blurred_result = np.hstack([image, blurred, blurred_inbuilt])
    cv2.imwrite("Blurred Image use OpenCV.jpg", blurred)
    cv2.imwrite("Blurred Image use Inbuilt-function.jpg", blurred_inbuilt)
    cv2.imshow("Blurred Image", blurred_result)
    cv2.waitKey(0)

if __name__ == "__main__":
    main()