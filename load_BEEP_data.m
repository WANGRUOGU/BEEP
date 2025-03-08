function [ref, ref_2L, ref_3L, mix, C, elapsedTime] =...
    load_BEEP_data(name, laser, path, T)

R = length(name);
L = length(laser);
ref = cell(L, R); % uni-laser
mix = cell(3, L);
C = zeros(L, 1);
tic;
for i = 1:L
    for r = 1:R
        filename = [path,name{r},'_L',laser{i},'.tif'];
        fprintf('Processing %s...\n', filename);
        ref{i, r} = tiffreadVolume(filename);
    end
    filename = [path, 'mix_L',laser{i},'.tif'];
    fprintf('Processing %s...\n', filename);
    mix{1, i} = tiffreadVolume(filename);
    C(i) = size(mix{1, i}, 3) / T;
end
ref_2L = cell(3, R); % bi-laser
ref_3L = cell(1, R); % tri-laser
for i = 1:(L/2)
    for r = 1:R
        filename = [path,name{r},'_L',laser{i},'_L',laser{i+3},'.tif'];
        fprintf('Processing %s...\n', filename);
        ref_2L{i, r} = tiffreadVolume(filename);
    end
    filename = [path, 'mix_L',laser{i},'_L',laser{i+3},'.tif'];
    fprintf('Processing %s...\n', filename);
    mix{2, i} = tiffreadVolume(filename);
end
for r = 1:R
    filename = [path, name{r},'_L',laser{2},'_L',laser{4},'_L',laser{6}, '.tif'];
    ref_3L{r} = tiffreadVolume(filename);
    fprintf('Processing %s...\n', filename);
end
mix{3, 1} = tiffreadVolume([path, 'mix_L',laser{2},'_L',laser{4},'_L',laser{6},'.tif']);

elapsedTime = toc;