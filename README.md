# 图像二值化中的规则抖动算法 | Using Bayer Dither to Binarize the Digital Image

<div align="center">
   <img src="https://github.com/divertingPan/Bayer_Dither/blob/master/sample/fig_0.jpg" >
</div>

## 更新 | Latest Update
在ChatGPT的帮助下，我用python对Bayer抖动的这几个方法重写了一下，这样更方便大家研究使用。并且借助numpy，使得处理的速度也有了一些提升。在脚本里面的各个方法的输出效果预览见上图。

With the assistance of ChatGPT, I have rewritten these Bayer dithering methods in Python. This has made the code easier to develop and research further. Additionally, using numpy has improved the speed of the code. The above image shows a preview of each method in the Python script.


## 使用说明 | Notification
MATLAB源码可直接运行，想要生成自己的图像可以将/data目录中的img图像换成自己的，文件名使用同名的，不要改变。<br>
或者添加进新图像之后修改MATLAB中的读取文件名称。/output为输出文件目录。<br>
processing程序使用方法同上。<br>
原文链接：<a href="https://divertingpan.github.io/post/bayer_dither/" target="_blank">数字图像处理 | 图像二值化中的规则抖动算法</a><br>

Run the MATLAB code with just putting your image in /data folder, and the filename should not be modified. 
Or you can add your file and change the pathname in the code where the image is loaded. 
Same as the Processing code.

Link (Chinese): https://divertingpan.github.io/post/bayer_dither/

## 目录说明 | File Discription
/data：存放原始图像<br>
/output：存放输出图像<br>
/sample：对灰阶图使用抖动的示例<br>
XXXX.m：代码文件<br>

/data：original image file<br>
/output：output image file<br>
/sample：sample files<br>
XXXX.m：source code<br>
