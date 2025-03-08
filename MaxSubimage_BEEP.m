function [row, col] = MaxSubimage_BEEP(ref, ref_2L, ref_3L, sz_unmix)

R = size(ref, 2);
row = cell(3, R);
col = cell(3, R);
for r = 1:R
    [~, row{1, r}, col{1, r}]...
        = find_max_nonzero_submatrix(cat(3, ref{:, r}), sz_unmix);
    [~, row{2, r}, col{2, r}]...
        = find_max_nonzero_submatrix(cat(3, ref_2L{:, r}), sz_unmix);
    [~, row{3, r}, col{3, r}]...
        = find_max_nonzero_submatrix(cat(3, ref_3L{r}), sz_unmix);
end