function [rImg] = RotateFunc(Img, a, b, angle)
% Makes the rotation of the image:
%   Img - represents the initial image
%   a - represents the x axis rotation point coordinate
%   b - represent the y axis rotation point coordinate
%   angle - represent the angle of rotation
%   rImg - represents the resulted image

    % Convert angle to radians
    theta = angle * pi / 180;

    [rows, cols, channels] = size(Img);

    % Initialize output image
    rImg = zeros(size(Img), class(Img));

    cosine = cos(theta);
    sine   = sin(theta);

    for c = 1:channels
        for i = 1:rows
            for j = 1:cols

                % BACKWARD mapping (destination -> source)
                x =  (i - a) * cosine + (j - b) * sine + a;
                y = -(i - a) * sine   + (j - b) * cosine + b;

                % Nearest neighbor
                x = round(x);
                y = round(y);

                % Boundary check
                if x >= 1 && x <= rows && y >= 1 && y <= cols
                    rImg(i,j,c) = Img(x,y,c);
                end
            end
        end
    end
end
