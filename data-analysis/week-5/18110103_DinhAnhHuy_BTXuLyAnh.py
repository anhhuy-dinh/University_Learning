# Import libraries
import numpy as np
import cv2
import argparse
import math

def translation_img(src_img, shift_distance):
    h, w = src_img.shape[:2]
    x_distance = shift_distance[0]
    y_distance = shift_distance[1]
    ts_mat = np.array([[1, 0, x_distance], [0, 1, y_distance]])
    out_img = np.zeros(src_img.shape, dtype='u1')
    for i in range(h):
        for j in range(w):
            origin_x = j
            origin_y = i
            origin_xy = np.array([origin_x, origin_y, 1])
            new_xy = np.dot(ts_mat, origin_xy)
            new_x = new_xy[0]
            new_y = new_xy[1]
            if 0 <= new_x < w and 0 <= new_y < h:
                out_img[new_y, new_x] = src_img[i, j]
    return out_img

def rotation_img(src_img, angle):
    angle = math.radians(angle)
    cosine = math.cos(angle)
    sine = math.sin(angle)
    h, w = src_img.shape[:2]
    output_img = np.zeros_like(src_img)
    original_center_height = round(((h + 1) / 2) - 1)
    original_center_width = round(((w + 1) / 2) - 1)
    for i in range(h):
        for j in range(w):
            y = i - original_center_height
            x = j - original_center_width
            new_y = round(-x * sine + y * cosine)
            new_x = round(x *cosine + y * sine)
            new_y += original_center_height
            new_x += original_center_width
            if 0 <= new_x < w and 0 <= new_y < h:
                output_img[new_y,new_x,:] = src_img[i,j,:]
    return output_img

def cropping_img(src_img, start_point, crop_distance):
    xd, yd = crop_distance[:]
    xp, yp = start_point[:]
    return src_img[xp : xp + xd, yp : yp + yd]

def flipping_img(src_img, flipcode = 1): 
    h, w = src_img.shape[:2]
    x_distance = w
    y_distance = h
    if flipcode == 0:
        ts_mat = np.array([[1, 0, 0], [0, -1, y_distance]])
    elif flipcode == 1:
        ts_mat = np.array([[-1, 0, x_distance], [0, 1, 0]])
    else:
        ts_mat = np.array([[-1, 0, x_distance], [0, -1, y_distance]])
    output_img = np.zeros(src_img.shape, dtype='u1')
    for i in range(h):
        for j in range(w):
            origin_x = j
            origin_y = i
            origin_xy = np.array([origin_x, origin_y, 1])
            new_xy = np.dot(ts_mat, origin_xy)
            new_x = new_xy[0]
            new_y = new_xy[1]
            if 0 <= new_x < w and 0 <= new_y < h:
                output_img[new_y, new_x] = src_img[i, j]
    return output_img

def resize_img(src_img, scale = None, dsize = None): 
    h, w = src_img.shape[:2]; 
    if scale != None:
        x_new = int(w * scale) 
        y_new = int(h * scale) 
    elif dsize != None:
        x_new, y_new = dsize[:]
    x_scale = x_new / (w - 1)
    y_scale = y_new / (h - 1)
    output_img = np.zeros([y_new, x_new, src_img.shape[2]], dtype='u1')
    for i in range(y_new - 1): 
        for j in range(x_new - 1): 
            output_img[i + 1, j + 1]= src_img[1 + int(i / y_scale), 1 + int(j / x_scale)] 
    return output_img

def test_function(src_img, method='flip'):
    if method == 'translate':
        x_shift = int(input('Horizontal shift: '))
        y_shift = int(input('Vertical shift: '))
        shift_dis = np.array((x_shift, y_shift))
        M = np.float32([[1, 0, shift_dis[0]], [0, 1, shift_dis[1]]])
        bf_img = cv2.warpAffine(src_img, M, (src_img.shape[1], src_img.shape[0]))
        shifted_img = translation_img(src_img, shift_dis)
        cv2.imshow('Original Image', src_img)
        cv2.imshow('Inbuilt-function Image', shifted_img)
        cv2.imshow('Built-function Image', bf_img)
    elif method == 'rotate':
        angle = float(input('Input angle: '))
        h, w = src_img.shape[:2]
        center = (w // 2, h // 2)
        M = cv2.getRotationMatrix2D(center, angle, 1.0)
        bf_img = cv2.warpAffine(src_img, M, (w, h))
        rotated_img = rotation_img(src_img, angle)
        cv2.imshow('Original Image', src_img)
        cv2.imshow('Inbuilt-function Image', rotated_img)
        cv2.imshow('Built-function Image', bf_img)
    elif method == 'crop':
        x_point = int(input('Input x of start point: '))
        y_point = int(input('Input y of start point: '))
        w_crop = int(input('Input width to crop: '))
        h_crop = int(input('Input height to crop: '))
        bf_img = src_img[x_point:x_point+w_crop, y_point:y_point+h_crop]
        start_point = np.array((x_point, y_point))
        size_to_crop = np.array((w_crop, h_crop))
        cropped_img = cropping_img(src_img, start_point, size_to_crop)
        cv2.imshow('Original Image', src_img)
        cv2.imshow('Inbuilt-function Image', cropped_img)
        cv2.imshow('Built-function Image', bf_img)
    elif method == 'flip':
        flip_type = int(input('Input type to flip (0 - vertical, 1 - horiontal, -1 - both): '))
        bf_img = cv2.flip(src_img, flip_type)
        flipped_img = flipping_img(src_img, flip_type)
        cv2.imshow('Original Image', src_img)
        cv2.imshow('Inbuilt-function Image', flipped_img)
        cv2.imshow('Built-function Image', bf_img)
    elif method == 'resize':
        w_size = int(input('Input new width: '))
        h_size = int(input('Input new height: '))
        new_size = (w_size, h_size)
        bf_img = cv2.resize(src_img, new_size, interpolation= cv2.INTER_AREA)
        resized_img = resize_img(src_img, dsize=new_size)
        cv2.imshow('Original Image', src_img)
        cv2.imshow('Inbuilt-function Image', resized_img)
        cv2.imshow('Built-function Image', bf_img)
    cv2.waitKey(0)

def main():
    input_img = cv2.imread('1.jpg')
    method = input('Method you want to do (translate/rotate/flip/crop/resize): ')
    test_function(input_img, method=method)
    cv2.waitKey(0)
    
if __name__ == "__main__":
    main()