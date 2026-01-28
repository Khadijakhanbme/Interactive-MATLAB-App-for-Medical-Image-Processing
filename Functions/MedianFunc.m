function [rImg] = MedianFunc(Img, ws)
% Computes the Median Filter of the image:
%   Img - represents the initial image
%   ws  - represents the window size (odd)
%   rImg - represents the resulted image

    % Ensure odd window size
    if mod(ws,2) == 0
        error('Window size must be odd.');
    end

    % Convert to uint8 if needed
    if ~isa(Img,'uint8')
        Img = im2uint8(Img);
    end

    [rows, cols, channels] = size(Img);
    rImg = Img;

    n = floor(ws/2);

    for c = 1:channels
        for i = 1+n : rows-n
            for j = 1+n : cols-n

                % Extract neighborhood
                window = Img(i-n:i+n, j-n:j+n, c);

                % Compute median
                rImg(i,j,c) = median(window(:));
            end
        end
    end
end
