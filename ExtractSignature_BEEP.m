function [E, B]...
    =  ExtractSignature_BEEP(ref, ref_2L, ref_3L, name, range, C)

[I, R] = size(ref);
N = length(range);
E = cell(N, 3);
B = cell(N, 3);
elapsedTime = zeros(N, R);
for t = 1:N
    E{t, 3} = zeros(sum(C), R);
    B{t, 3} = zeros(range(t)*I, R);
    E{t, 2} = zeros(sum(C(1:3)), R);
    B{t, 2} = zeros(range(t)*I/2, R);
    E{t, 1} = zeros(sum(C(2)), R);
    B{t, 1} = zeros(range(t), R);
    for r = 1:R
        tic;
        % uni-laser
        temp = cell(1, I);
        for i = 1:I
            last = C(i)*range(t);
            temp{i} = reshape(ref{i, r}(:, :, 1:last), [], C(i), range(t));
        end
        [~, E{t, 3}(:, r), B{t, 3}(:, r)] = BEEP(temp, 1);
        % bi-laser
        temp = cell(1, I/2);
        for i = 1:(I/2)
            last = C(i)*range(t);
            temp{i} = reshape(ref_2L{i, r}(:, :, 1:last), [], C(i), range(t));
        end
        [~, E{t, 2}(:, r), B{t, 2}(:, r)] = BEEP(temp, 1);
        % single view
        last = C(2)*range(t);
        temp = cell(1);
        temp{1} = reshape(ref_3L{r}(:, :, 1:last), [], C(2), range(t));
        [~, E{t, 1}(:, r), B{t, 1}(:, r)] = BEEP(temp, 1);
        elapsedTime(t, r) = toc;
        fprintf('%2d-timelapse signatures of %s were extracted.  (Time taken: %f seconds)\n', ...
            range(t), name{r}, elapsedTime(t, r));
    end
end
