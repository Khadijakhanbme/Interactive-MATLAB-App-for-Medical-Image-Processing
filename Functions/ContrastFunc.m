function [rImg] = ContrastFunc(Img, a)
% Computes the contrast operation on the image:
%   Img - represents the initial image
%   a   - represents the contrast value (a > 1 increase, 0 < a < 1 decrease)
%   rImg - represents the resulted image

    % Ensure uint8 image
    if ~isa(Img, 'uint8')
        Img = im2uint8(Img);
    end

    % Convert to double for computation
    ImgD = double(Img);

    % Compute mean intensity
    meanVal = mean(ImgD(:));

    % Apply contrast formula
    temp = meanVal + a * (ImgD - meanVal);

    % Clip values to valid range
    temp(temp > 255) = 255;
    temp(temp < 0)   = 0;

    % Convert back to uint8
    rImg = uint8(temp);

end
