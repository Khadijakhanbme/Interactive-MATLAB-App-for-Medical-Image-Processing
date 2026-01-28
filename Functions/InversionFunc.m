function [rImg] = InversionFunc(Img)
% Makes the inversion of the image:
%   Img - represents the initial image
%   rImg - represents the resulted image

    % Ensure image is uint8
    if ~isa(Img, 'uint8')
        Img = im2uint8(Img);
    end

    % Invert image
    rImg = 255 - Img;

end
