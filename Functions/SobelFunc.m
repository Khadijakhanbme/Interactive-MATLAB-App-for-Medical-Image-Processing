function [rImg] = SobelFunc(Img)
% Computes the Sobel operator on the image:
%   Img - represents the initial image
%   rImg - represents the resulted image (edge image)

    % Convert to grayscale if needed
    if size(Img,3) == 3
        Img = rgb2gray(Img);
    end

    % Convert to double for computation
    Img = double(Img);

    % Sobel kernels
    Gx = [-1 0 1; -2 0 2; -1 0 1];
    Gy = [ 1 2 1;  0 0 0; -1 -2 -1];

    [rows, cols] = size(Img);
    rImg = zeros(rows, cols);

    % Apply Sobel operator
    for i = 2:rows-1
        for j = 2:cols-1
            region = Img(i-1:i+1, j-1:j+1);
            sx = sum(sum(Gx .* region));
            sy = sum(sum(Gy .* region));
            rImg(i,j) = sqrt(sx^2 + sy^2);
        end
    end

    % Normalize to uint8 for display
    rImg = uint8(255 * mat2gray(rImg));

end
