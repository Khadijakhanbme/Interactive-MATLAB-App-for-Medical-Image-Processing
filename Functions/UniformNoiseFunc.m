function [rImg] = UniformNoiseFunc(Img, perc, amp)
% Add uniform noise to the image:
%   Img  - represents the initial image
%   perc - represents the percentage of pixels affected (0–100)
%   amp  - represents the amplitude of the noise
%   rImg - represents the resulted image

    % Ensure uint8 image
    if ~isa(Img, 'uint8')
        Img = im2uint8(Img);
    end

    [rows, cols, channels] = size(Img);
    rImg = Img;

    % Total number of pixels (per channel)
    totalPixels = rows * cols;
    numNoisy = round((perc / 100) * totalPixels);

    for c = 1:channels

        % Random pixel indices
        idx = randperm(totalPixels, numNoisy);

        % Convert linear indices to subscripts
        [r, col] = ind2sub([rows, cols], idx);

        for k = 1:numNoisy
            % Generate uniform noise in range [-amp, amp]
            noise = (2 * rand - 1) * amp;

            % Add noise with saturation
            val = double(rImg(r(k), col(k), c)) + noise;
            val = min(max(val, 0), 255);

            rImg(r(k), col(k), c) = uint8(val);
        end
    end
end
