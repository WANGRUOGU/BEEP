function I_bg = BackgroundRemover(I)

if ismatrix(I)
    sz = sqrt(size(I, 1));
    I = reshape(I, sz, sz, size(I, 2));
end
I_gray = max(I, [], 3);
BW = imbinarize(I_gray); % thresholding
BW2 = medfilt2(BW); % median filter
BW3 = bwareaopen(BW2,50); % Remove small objects
M = reshape(I,[],size(I,3));
M(~BW3, :) = 0;
I_bg = reshape(M, size(I));

