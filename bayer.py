import os
import cv2
import numpy as np


class Bayer(object):
    """
    This is a class for Bayer image dithering
    For more dither methods, please see: https://en.wikipedia.org/wiki/Dither

    Args:
        input_img (str): The file path of input image.
        save_dir (str): The folder to save the outputs. Default: 'output'
        scale (int): The scale factor to enlarge the output for better visualization. Default: 4
    """

    def __init__(self,
                 input_img,
                 save_dir='output',
                 scale=4
                 ):
        self.img = cv2.imread(input_img)
        self.gray_image = cv2.cvtColor(self.img, cv2.COLOR_BGR2GRAY)
        self.height, self.width = self.gray_image.shape[0:2]

        self.save_dir = save_dir
        self.scale = scale

        m1 = np.array([[0, 2],
                       [3, 1]])
        u1 = np.ones((2, 2))
        self.m2 = np.block([[4 * m1, 4 * m1 + 2 * u1],
                            [4 * m1 + 3 * u1, 4 * m1 + u1]])
        u2 = np.ones((4, 4))
        self.m3 = np.block([[4 * self.m2, 4 * self.m2 + 2 * u2],
                            [4 * self.m2 + 3 * u2, 4 * self.m2 + u2]])

        self.mask2 = np.tile(self.m2,
                             (self.height // 4 + 1,
                              self.width // 4 + 1))[:self.height, :self.width]
        self.mask3 = np.tile(self.m3,
                             (self.height // 8 + 1,
                              self.width // 8 + 1))[:self.height, :self.width]

        self.mask3_rgb = np.expand_dims(self.mask3, 2).repeat(3, axis=2)

        if not os.path.exists(self.save_dir):
            os.makedirs(self.save_dir)

    def save_img(self, img, path):
        img = cv2.resize(img.astype("float"),
                         (self.width * self.scale, self.height * self.scale),
                         interpolation=cv2.INTER_NEAREST)
        cv2.imencode('.png', img)[1].tofile(path)

    def gray_2_step(self):
        output_m2 = np.where(self.gray_image / 16 <= self.mask2, 0, 255)
        output_m3 = np.where(self.gray_image / 4 <= self.mask3, 0, 255)
        self.save_img(output_m2, '{}/M2_Gray_2step.png'.format(self.save_dir))
        self.save_img(output_m3, '{}/M3_Gray_2step.png'.format(self.save_dir))

    def gray_4_step(self):
        bayer_mask_1 = np.float32(self.mask3) * (1 / 3)
        bayer_mask_2 = np.float32(bayer_mask_1) + 21
        bayer_mask_3 = np.float32(bayer_mask_2) + 21

        image_color = self.gray_image / 4.0
        output = np.zeros_like(self.gray_image)

        output[(image_color >= 0) & (image_color < 21) &
               (image_color > bayer_mask_1)] = 85

        output[(image_color >= 0) & (image_color < 21) &
               (image_color <= bayer_mask_1)] = 0

        output[(image_color >= 21) & (image_color < 43) &
               (image_color >= bayer_mask_2)] = 170

        output[(image_color >= 21) & (image_color < 43) &
               (image_color < bayer_mask_2)] = 85

        output[(image_color >= 43) &
               (image_color >= bayer_mask_3)] = 255

        output[(image_color >= 43) &
               (image_color < bayer_mask_3)] = 170

        self.save_img(output, '{}/M3_Gray_4step.png'.format(self.save_dir))

    def rgb_2_step(self):
        output_m3_rgb = np.where(self.img / 4 <= self.mask3_rgb, 0, 255)
        self.save_img(output_m3_rgb, '{}/M3_RGB_2step.png'.format(self.save_dir))

    def rgb_4_step(self):
        bayer_mask_1_rgb = np.float32(self.mask3_rgb) * (1 / 3)
        bayer_mask_2_rgb = np.float32(bayer_mask_1_rgb) + 21
        bayer_mask_3_rgb = np.float32(bayer_mask_2_rgb) + 21

        image_color = self.img / 4.0
        output = np.zeros_like(self.img)

        output[(image_color >= 0) & (image_color < 21) &
               (image_color > bayer_mask_1_rgb)] = 85

        output[(image_color >= 0) & (image_color < 21) &
               (image_color <= bayer_mask_1_rgb)] = 0

        output[(image_color >= 21) & (image_color < 43) &
               (image_color >= bayer_mask_2_rgb)] = 170

        output[(image_color >= 21) & (image_color < 43) &
               (image_color < bayer_mask_2_rgb)] = 85

        output[(image_color >= 43) &
               (image_color >= bayer_mask_3_rgb)] = 255

        output[(image_color >= 43) &
               (image_color < bayer_mask_3_rgb)] = 170

        self.save_img(output, '{}/M3_RGB_4step.png'.format(self.save_dir))

    def color_mapping(self,
                      colormap=np.array([[102, 50, 124],
                                         [0, 137, 167],
                                         [251, 150, 110],
                                         [250, 214, 137]])
                      ):
        """
        :param colormap: The colors to mapping grayscale to rgb color, from dark to light
        """
        bayer_mask_1 = np.float32(self.mask3) * (1 / 3)
        bayer_mask_2 = np.float32(bayer_mask_1) + 21
        bayer_mask_3 = np.float32(bayer_mask_2) + 21

        image_color = self.gray_image / 4.0
        output = np.zeros_like(self.img)

        output[(image_color >= 0) & (image_color < 21) &
               (image_color > bayer_mask_1)] = colormap[1]

        output[(image_color >= 0) & (image_color < 21) &
               (image_color <= bayer_mask_1)] = colormap[0]

        output[(image_color >= 21) & (image_color < 43) &
               (image_color >= bayer_mask_2)] = colormap[2]

        output[(image_color >= 21) & (image_color < 43) &
               (image_color < bayer_mask_2)] = colormap[1]

        output[(image_color >= 43) &
               (image_color >= bayer_mask_3)] = colormap[3]

        output[(image_color >= 43) &
               (image_color < bayer_mask_3)] = colormap[2]

        output = cv2.cvtColor(output, cv2.COLOR_BGR2RGB)
        self.save_img(output, '{}/M3_mapping_4step.png'.format(self.save_dir))


if __name__ == '__main__':
    bayer = Bayer(input_img='data/img-3.jpg')
    bayer.gray_2_step()
    bayer.gray_4_step()
    bayer.rgb_2_step()
    bayer.rgb_4_step()
    bayer.color_mapping()
