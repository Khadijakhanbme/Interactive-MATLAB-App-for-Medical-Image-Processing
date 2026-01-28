function [rImg] = AutomaticSFunc(Img)
% Computes the automatic segmentation process of the image:
%   Img - represents the initial image
%   rImg - represents the resulted image (binary image)

    % Convert to grayscale if needed
    if size(Img,3) == 3
        Img = rgb2gray(Img);
    end

    % Convert to double for processing
    Img = im2double(Img);

    % Automatic threshold detection using Otsu's method
    level = graythresh(Img);

    % Binarize image
    rImg = imbinarize(Img, level);

end
