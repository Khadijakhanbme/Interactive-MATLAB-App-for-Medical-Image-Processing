DigiMat — MATLAB Image Processing App (Custom Functions)

DigiMat is a MATLAB App Designer–based GUI application developed to explore and apply fundamental image processing techniques in an interactive way. The application allows users to load an image and apply a wide range of operations using menu-driven controls, while visualizing the original and processed images side by side.

A key objective of this project is to strengthen understanding of image processing fundamentals by implementing most operations as custom MATLAB functions, rather than relying solely on built-in toolbox functions.

---

Purpose of the Application

The purpose of DigiMat is to:

- Provide a user-friendly platform for experimenting with image processing algorithms.
- Demonstrate algorithm-level implementation of common image processing techniques.
- Enable step-by-step and chained image transformations through an interactive GUI.
- Serve as an extendable framework where new image processing functions can be easily added.

This app is suitable for educational use, academic demonstrations, and as a base template for more advanced image processing projects.

---

Key Features

File Operations
- Load grayscale or RGB images (`.png`, `.jpg`, `.jpeg`, `.bmp`)
- Automatic RGB-to-grayscale conversion
- Save processed images
- Save As option for exporting results

Noise Models
- Uniform noise (percentage and amplitude based)
- Salt & Pepper noise (percentage based)

Point Operations
- Image inversion
- Brightness adjustment
- Contrast enhancement
- Histogram equalization

Spatial Filtering
- Average (mean) filtering with user-defined window size
- Median filtering with user-defined window size

Segmentation
- Manual threshold-based segmentation
- Semi-automatic segmentation
- Fully automatic segmentation

Edge Detection
- Sobel gradient operator
- Kirsch gradient operator

Geometric Transformations
- Zoom (scaling)
- Translation (x and y shifts)
- Rotation (about a specified center and angle)

Iterative Processing
- Copy Result → Original feature for chaining multiple operations sequentially

---


Demo

A short demo video of the application is available below: 

https://drive.google.com/file/d/13eubUcMqB0ZTM18p633yXzOuL4aqWewD/view

Requirements

MATLAB with App Designer support (R2020 or newer recommended)

Image Processing Toolbox (basic functions only)


Note: The `.mlapp` file is provided for running and editing the app in MATLAB App Designer.
The exported `.m` file is included to allow code inspection directly on GitHub.

