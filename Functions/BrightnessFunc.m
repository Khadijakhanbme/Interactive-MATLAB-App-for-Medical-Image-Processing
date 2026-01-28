function [rImg] = BrightnessFunc(Img, a)
% Computes the brightness operation on the image:
%   Img - represents the initial image
%   a   - represents the brightness value
%   rImg - represents the resulted image

    % Ensure uint8 image
    if ~isa(Img, 'uint8')
        Img = im2uint8(Img);
    end

    % Convert to double for computation
    temp = double(Img) + a;

    % Clip values to valid range [0, 255]
    temp(temp > 255) = 255;
    temp(temp < 0)   = 0;

    % Convert back to uint8
    rImg = uint8(temp);

end
