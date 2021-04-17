import cv2

def main():
    image = cv2.imread('children3.jpg')
    cv2.imshow('Image', image)
    cv2.waitKey(0)

if __name__ == '__main__':
    main()