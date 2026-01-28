function [rImg] = SaltAndPaperFunc(Img, perc)
% Add salt and pepper noise to the image:
%   Img  - represents the initial image
%   perc - represents the percentage of image which is affected (0–100)
%   rImg - represents the resulted image

    % Ensure uint8 image
    if ~isa(Img, 'uint8')
        Img = im2uint8(Img);
    end

    [rows, cols, channels] = size(Img);
    rImg = Img;

    % Total number of pixels
    totalPixels = rows * cols;
    numNoisy = round((perc / 100) * totalPixels);

    % Random pixel indices
    idx = randperm(totalPixels, numNoisy);

    % Convert linear indices to subscripts
    [r, c] = ind2sub([rows, cols], idx);

    for ch = 1:channels
        for k = 1:numNoisy
            if rand < 0.5
                % Pepper noise
                rImg(r(k), c(k), ch) = 0;
            else
                % Salt noise
                rImg(r(k), c(k), ch) = 255;
            end
        end
    end
end
