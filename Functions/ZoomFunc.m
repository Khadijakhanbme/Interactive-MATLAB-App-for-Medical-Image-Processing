function [rImg] = ZoomFunc(Img, a)
% Makes the zoom of the image:
%   Img - represents the initial image
%   a - represents the magnitude of the zoom (a > 1 zoom in, a < 1 zoom out)
%   rImg - represents the resulted image

    [rows, cols, channels] = size(Img);

    % New image size
    newRows = round(rows * a);
    newCols = round(cols * a);

    % Initialize output image
    rImg = zeros(newRows, newCols, channels, class(Img));

    for c = 1:channels
        for i = 1:newRows
            for j = 1:newCols

                % Backward mapping (destination -> source)
                src_i = round(i / a);
                src_j = round(j / a);

                % Boundary check
                if src_i >= 1 && src_i <= rows && src_j >= 1 && src_j <= cols
                    rImg(i, j, c) = Img(src_i, src_j, c);
                end
            end
        end
    end
end
