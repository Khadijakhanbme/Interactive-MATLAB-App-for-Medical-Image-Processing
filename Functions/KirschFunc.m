function [rImg] = KirschFunc(Img)
% Computes the Kirsch operator on the image:
%   Img - represents the initial image
%   rImg - represents the resulted image (edge image)

    % Convert to grayscale if needed
    if size(Img,3) == 3
        Img = rgb2gray(Img);
    end

    % Convert to double for computation
    Img = double(Img);

    % Kirsch masks (8 directions)
    K(:,:,1) = [ 5  5  5; -3  0 -3; -3 -3 -3];
    K(:,:,2) = [ 5  5 -3;  5  0 -3; -3 -3 -3];
    K(:,:,3) = [ 5 -3 -3;  5  0 -3;  5 -3 -3];
    K(:,:,4) = [-3 -3 -3;  5  0 -3;  5  5 -3];
    K(:,:,5) = [-3 -3 -3; -3  0 -3;  5  5  5];
    K(:,:,6) = [-3 -3 -3; -3  0  5; -3  5  5];
    K(:,:,7) = [-3 -3  5; -3  0  5; -3 -3  5];
    K(:,:,8) = [-3  5  5; -3  0  5; -3 -3 -3];

    [rows, cols] = size(Img);
    rImg = zeros(rows, cols);

    % Apply Kirsch operator
    for i = 2:rows-1
        for j = 2:cols-1
            region = Img(i-1:i+1, j-1:j+1);
            responses = zeros(1,8);
            for k = 1:8
                responses(k) = sum(sum(K(:,:,k) .* region));
            end
            rImg(i,j) = max(responses);
        end
    end

    % Normalize to uint8 for display
    rImg = uint8(255 * mat2gray(rImg));

end
