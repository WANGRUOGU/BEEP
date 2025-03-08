function [ref_regt, mix_regt]...
    = imregt(ref, mix, name, laser, strategy)

[optimizer,metric] = imregconfig("multimodal");
optimizer.MaximumIterations = 1e3;
[L, R] = size(ref);
tform = cell(L, R); % geometric transformations
elapsedTime = zeros(L, R+1);
ref_temp = cell(1, L);
ref_regt = cell(L, R);
view = cell(1, L);
int_sum = zeros(L, 1); % total intensity of each image
for r = 1:R
    for l = 1:L
        view{l} = imref2d(size(ref{l, r}));
        ref_temp{l} = max(ref{l, r}, [], 3);
        int_sum(l) = sum(ref_temp{l}, 'all');
    end
    [~, ind] = max(int_sum);
    fixed = ref_temp{ind};
    for l = [1:(ind-1), (ind+1):L]
        tic;
        tform{l, r} = imregtform(ref_temp{l},fixed, "translation", ...
            optimizer,metric);
        elapsedTime(l, r) = toc;
        fprintf('%s reference image of %s at laser %s were transformed.  (Time taken: %f seconds)\n'...
            , strategy, name{r}, laser{l}, elapsedTime(l, r));
        ref_regt{l, r} = imwarp(ref{l, r}, tform{l, r},...
            "OutputView", view{l});
    end
    ref_regt{ind, r} = ref{ind, r};
end
% mixture image
mix_temp = cell(1, L);
mix_regt = cell(1, L);
tform_mix = cell(1, L);
for l = 1:L
    view{l} = imref2d(size(mix{l}));
    mix_temp{l} = max(mix{l}, [], 3);
    int_sum(l) = sum(mix_temp{l}, 'all');
end
[~, ind] = max(int_sum);
fixed = mix_temp{ind};
for l = [1:(ind-1), (ind+1):L]
    tic;
    tform_mix{l} = imregtform(mix_temp{l},fixed, "translation", ...
        optimizer,metric);
    elapsedTime(l, R+1) = toc;
    fprintf('%s mixture image at laser %s were transformed.  (Time taken: %f seconds)\n'...
        , strategy, laser{l}, elapsedTime(l, R+1));
    mix_regt{l} = imwarp(mix{l}, tform_mix{l},"OutputView", view{l});
end
mix_regt{ind} = mix{ind};