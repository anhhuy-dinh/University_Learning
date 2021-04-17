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

# =========================================================================== #
'''
        Exercise 1
'''
# =========================================================================== #
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

def ex1():
    path = '/home/dinh_anh_huy/GitHub/2020-2021/semester-1/data-analysis/week-5/1.jpg'
    input_img = read_img(path)
    method = input('Method you want to do (translate/rotate/flip/crop/resize): ')
    test_function(input_img, method=method)
    cv2.waitKey(0)
# =========================================================================== #
'''
        Exercise 2
'''
# =========================================================================== #
def create_color_img():
    image = np.zeros((256, 256, 3), dtype = "uint8")
    for i in range(256):
        color = np.random.randint(0, high = 256, size=(3,))
        image[:, i] = color
    return image

def convolution(src_img, kernel):
    kernel = np.flipud(np.fliplr(kernel))
    img_h, img_w = src_img.shape[:2]
    kernel_h, kernel_w = kernel.shape
    h = (kernel_h - 1) // 2
    w = (kernel_w - 1) // 2
    out_img = np.zeros_like(src_img)
    for i in np.arange(h, img_h - h):
        for j in np.arange(w, img_w - w):
            out_img[i, j] = (kernel * src_img[i - h: i + h + 1, j - w: j + w + 1]).sum()
    return out_img

def conv(src_img_2D, kernel):
    kernel = np.flipud(np.fliplr(kernel))
    img_h, img_w = src_img_2D.shape[:2]
    kernel_h, kernel_w = kernel.shape
    new_h = img_h + kernel_h - 1
    new_w = img_w + kernel_w - 1
    new_shape_img = np.zeros((new_h, new_w))
    new_shape_img[0:img_h, 0:img_w] = src_img_2Di
    out_img = np.zeros_like(src_img_2D)
    for i in range(img_h):
        for j in range(img_w):
            new_matrix = kernel * new_shape_img[i : i + kernel_h, j : j + kernel_w]
            out_img[i, j] = new_matrix.sum()
    return out_img
    

def blur_img(src_img, kernel_size):
    img = cv2.cvtColor(src_img, cv2.COLOR_RGB2HSV)
    h, w = kernel_size
    kernel = np.ones(kernel_size)/(h*w)
    out_img = conv(img[:, :, 2], kernel)
    img[:,:,2] = out_img
    output = cv2.cvtColor(img, cv2.COLOR_HSV2RGB)
    return output

def get_gauss_kernel(size=3,sigma=1):
    center=(int)(size / 2)
    kernel=np.zeros((size,size))
    for i in range(size):
       for j in range(size):
          diff = np.sqrt((i - center) ** 2 + (j - center) ** 2)
          kernel[i, j] = np.exp(-(diff ** 2) / (2 * sigma ** 2))
    return kernel / (2 * np.pi * (sigma ** 2))

def gauss_blur_img(src_img, kernel_size):
    img = cv2.cvtColor(src_img, cv2.COLOR_RGB2HSV)
    h, w = kernel_size
    if h == w:
        kernel = get_gauss_kernel(h)
        out_img = convolution(img[:, :, 2], kernel)
    img[:,:,2] = out_img
    output = cv2.cvtColor(img, cv2.COLOR_HSV2RGB)
    return output

def median_filter(data, filter_size):
    temp = []
    indexer = filter_size // 2
    data_final = []
    data_final = np.zeros((len(data),len(data[0])))
    for i in range(len(data)):

        for j in range(len(data[0])):

            for z in range(filter_size):
                if i + z - indexer < 0 or i + z - indexer > len(data) - 1:
                    for c in range(filter_size):
                        temp.append(0)
                else:
                    if j + z - indexer < 0 or j + indexer > len(data[0]) - 1:
                        temp.append(0)
                    else:
                        for k in range(filter_size):
                            temp.append(data[i + z - indexer][j + k - indexer])

            temp.sort()
            data_final[i][j] = temp[len(temp) // 2]
            temp = []
    return data_final

def median_blur_img(src_img, kernel_size):
    img = cv2.cvtColor(src_img, cv2.COLOR_RGB2HSV)
    h, w = kernel_size
    if h == w:
        if h % 2 == 0:
            kernel = np.zeros((h+1, w+1))
            kernel[:h, :w] = np.ones(kernel_size) / (h * w)
        else:
            kernel = np.ones(kernel_size) / (h * w)
        out_img = median_filter(img[:, :, 2], h)
    img[:,:,2] = out_img
    output = cv2.cvtColor(img, cv2.COLOR_HSV2RGB)
    return output

# ==================================================================== #
def distance(x, y, i, j):
    return np.sqrt((x-i)**2 + (y-j)**2)

def gaussian(x, sigma):
    return np.exp(- (x ** 2) / (2 * sigma ** 2)) / (2 * np.pi * (sigma ** 2))

def apply_bilateral_filter(src_img, filtered_image, x, y, d, sigma_i, sigma_s):
    h, w = src_img.shape
    hl = d//2
    i_filtered = 0
    Wp = 0
    for i in range(d):
        for j in range(d):
            neightbour_x = (int)(x - (hl - i))
            neightbour_y = (int)(y - (hl - j))
            gi = gaussian(src_img[x][y] - src_img[neightbour_x][neightbour_y], sigma_i)
            gs = gaussian(distance(neightbour_x, neightbour_y, x, y), sigma_s)
            w = gi * gs
            i_filtered += src_img[neightbour_x][neightbour_y] * w
            Wp += w
    i_filtered = i_filtered / Wp
    filtered_image[x][y] = int(i_filtered)

def bilateral_filter_own(src_img, d, sigma_i, sigma_s):
    img = cv2.cvtColor(src_img, cv2.COLOR_RGB2HSV)
    src_image = img[:, :, 2]
    h, w = src_image.shape
    hl = d // 2
    new_h = h + hl * 2
    new_w = w + hl * 2
    new_image = np.zeros((new_h, new_w))
    new_image[hl: new_h - hl, hl: new_w - hl] = src_image
    filtered_image = np.zeros_like(new_image)
    for i in np.arange(hl, new_h - hl):
        for j in np.arange(hl, new_w - hl):
            apply_bilateral_filter(new_image, filtered_image, i, j, d, sigma_i, sigma_s)
    img[:, :, 2] = filtered_image[hl: new_h - hl, hl: new_w - hl] 
    output = cv2.cvtColor(img, cv2.COLOR_HSV2RGB)
    return output

def ex2():
    # image = create_color_img()
    image = cv2.imread('1.jpg')
    # blurred = bilateral_filter_own(image, 9, 41, 41) 
    blurred = cv2.bilateralFilter(image, 9, 41, 41)
    blurred1 = bilateral_filter_own(image, 9, 41, 41)
    # blurred_cv2 = np.hstack([image, cv2.medianBlur(image, 4)])
    cv2.imshow("Blurred Image use OpenCV", blurred)
    cv2.imshow("Blurred Image use Inbuilt-function", blurred1)
    # cv2.imshow("Blurred Image by OpenCV", blurred_cv2)
    cv2.waitKey(0)

# =========================================================================== #
'''
        Main function
'''
# =========================================================================== #
def main():
    # ex1()
    ex2()
    # print(get_gauss_kernel(size=4, sigma=1))

if __name__ == "__main__":
    main()