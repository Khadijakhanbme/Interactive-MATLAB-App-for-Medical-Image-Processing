function [rImg] = ManualSFunc(Img, th)
% Computes the manual segmentation process of the image:
%   Img - represents the initial image
%   th  - represents the threshold
%   rImg - represents the resulted image (binary image)

    % Convert to grayscale if needed
    if size(Img,3) == 3
        Img = rgb2gray(Img);
    end

    % Apply manual threshold segmentation
    rImg = Img > th;

end
