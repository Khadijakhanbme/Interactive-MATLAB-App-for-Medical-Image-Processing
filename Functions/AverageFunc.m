%% ----------------- Procedural Average Filter -----------------
function [rImg] = AverageFunc(Img, ws)

% Computes the Average Filter of the image:
%   Img - represents the initial image
%   ws  - represents the window size
%   rImg - represents the resulted image  

[nRows, nCols, nCh] = size(Img);
    rImg = Img;

    n = floor(ws/2);
    area = (2*n + 1) * (2*n + 1);

    for c = 1:nCh
        for i = 1+n : nRows-n
            for j = 1+n : nCols-n
                sumVal = 0;
                for x = -n:n
                    for y = -n:n
                        sumVal = sumVal + double(Img(i+x, j+y, c));
                    end
                end
                rImg(i, j, c) = sumVal / area;
            end
        end
    end
end
