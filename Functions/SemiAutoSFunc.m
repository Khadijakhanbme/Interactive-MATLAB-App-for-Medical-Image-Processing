function [rImg] = SemiAutoSFunc(Img, perc)
% Computes the semi-automatic segmentation process of the image:
%   Img  - represents the initial image
%   perc - represents the percentage of pixels belonging to objects
%   rImg - represents the resulted image (binary image)

    % Convert to grayscale if needed
    if size(Img,3) == 3
        Img = rgb2gray(Img);
    end

    % Convert image to vector
    imgVec = double(Img(:));

    % Sort pixel intensities
    imgVec = sort(imgVec);

    % Compute threshold index based on percentage
    idx = round((100 - perc) / 100 * numel(imgVec));

    % Safety check
    idx = max(1, min(idx, numel(imgVec)));

    % Compute threshold
    T = imgVec(idx);

    % Apply threshold segmentation
    rImg = Img > T;

end
