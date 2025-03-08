function [ref_BR, ref_2L_BR, ref_3L_BR, elapsedTime]...
    = RemoveBackground_BEEP(ref, ref_2L, ref_3L, name, C, T)

[L, R] = size(ref);
ref_BR = cell(L, R);
ref_2L_BR = cell(L/2, R);
ref_3L_BR = cell(1, R);
elapsedTime = zeros(1, R);
for r = 1:R
    tic;
    ref_cat = BackgroundRemover(cat(3, ref{:, r}));
    for i = 1:L
        range = (1+T*sum(C(1:(i-1)))):(T*sum(C(1:i)));
        ref_BR{i, r} = ref_cat(:, :, range);
    end
    ref_cat = BackgroundRemover(cat(3, ref_2L{:, r}));
    for i = 1:(L/2)
        range = (1+T*sum(C(1:(i-1)))):(T*sum(C(1:i)));
        ref_2L_BR{i, r} = ref_cat(:, :, range);
    end
    ref_3L_BR{r} = BackgroundRemover(ref_3L{r});
    elapsedTime(r) = toc;
    fprintf('The reference images of %s were cleaned. (Time taken: %f seconds)\n', ...
        name{r}, elapsedTime(r));
end
end