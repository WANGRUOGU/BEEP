function refAbundances(A, name)

[T, M, R] = size(A);
% colormap
idx = 1:R;
idx(1:2:R) = 1:((R+1)/2);
idx(2:2:R) = round(R/2+1):R;
map = jet(R);
map = map(idx, :);
c = [zeros(1, 3); map];

nameMethod = cell(2, 3);
nameMethod{1, 3} = 'Multi-excitation (HIS)';
nameMethod{1, 2} = 'Multi-excitation (MIS)';
nameMethod{1, 1} = 'Single-view';
nameMethod{2, 3} = 'BEEP (HIS)';
nameMethod{2, 2} = 'BEEP (MIS)';
nameMethod{2, 1} = 'Bleaching';

sz = sqrt(size(A{1, 1, 1}, 1));
colorI = zeros(sz, sz, 3);
for r = 1:R
    fig = figure;
    set(fig, 'Position', [0, 0, 1400, 1200]);
    tiledlayout(2, 3, 'TileSpacing', 'compact')
    for t = 1:T
        for m = 1:M
            I = reshape(A{t, m, r}, sz, sz, R);
            [MAX, idx] = max(I, [], 3);
            MAX = MAX / max(MAX, [], 'all');
            idx = idx + 1;
            for i = 1:sz
                for j = 1:sz
                    colorI(i, j, :) = c(idx(i, j), :) * MAX(i, j);
                end
            end
            if m == M && t == T
                scale_height = 1;
                scale_length = 12.8965;
                margin = 5; 
                start_x = 50 - scale_length - margin;
                start_y = 50 - scale_height - margin;
                end_x = start_x + scale_length;
                end_y = start_y + scale_height;
                colorI(start_y:end_y, start_x:end_x, :) = 255;
            end
            nexttile, imshow(colorI)
            title(nameMethod{t, m}, 'FontSize', 25)
        end
    end
    colormap(gca, c);
    clim([1, R+2]);
    cb = colorbar('YTickLabel', ["Background", name], ...
        'YTick', 1.5:(R+1.5), 'FontSize', 25);
    cb.Layout.Tile = 'east';
end
