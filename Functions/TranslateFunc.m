function [rImg] = TranslateFunc(Img, a, b)
% Makes the translation of the image:
%   Img - represents the initial image
%   a - represents the x axis shift value (horizontal)
%   b - represent the y axis shift value (vertical)
%   rImg - represents the resulted image

    [rows, cols, channels] = size(Img);

    % Initialize output image
    rImg = zeros(rows, cols, channels, class(Img));

    for c = 1:channels
        for i = 1:rows
            for j = 1:cols

                % Forward translation
                new_i = i + b;   % vertical shift
                new_j = j + a;   % horizontal shift

                % Boundary check
                if new_i >= 1 && new_i <= rows && new_j >= 1 && new_j <= cols
                    rImg(new_i, new_j, c) = Img(i, j, c);
                end
            end
        end
    end
end
