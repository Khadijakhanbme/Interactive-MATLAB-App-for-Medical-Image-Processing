function [rImg] = HistEqFunc(Img)
% Makes the Equalized Histogram of the image:
%   Img - represents the initial image
%   rImg - represents the resulted image

    % Convert to grayscale if needed
    if size(Img,3) == 3
        Img = rgb2gray(Img);
    end

    % Ensure uint8 (0..255)
    Img = im2uint8(Img);

    [nRows, nCols] = size(Img);

    % Compute histogram
    h = zeros(1,256);
    for i = 1:nRows
        for j = 1:nCols
            h(Img(i,j) + 1) = h(Img(i,j) + 1) + 1;
        end
    end

    % Compute CDF
    cdf = cumsum(h);

    % Optional but recommended: normalize using cdf_min (classic HE)
    cdfMin = min(cdf(cdf > 0));
    totalPixels = nRows * nCols;
    cdfNorm = (cdf - cdfMin) / (totalPixels - cdfMin);
    cdfNorm(cdfNorm < 0) = 0;

    % Compute LUT
    LUT = round(cdfNorm * 255);

    % Apply LUT
    rImg = LUT(double(Img) + 1);
    rImg = uint8(rImg);

end
