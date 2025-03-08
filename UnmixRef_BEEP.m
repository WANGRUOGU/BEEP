function [A, p, elapsedTime]...
    = UnmixRef_BEEP(ref, ref_2L, ref_3L, name, range, E, B, C, row, col)

T = length(range);
[I, R] = size(ref);

A = cell(T, 3, R);
p = zeros(T, 3, R);
elapsedTime = zeros(T, R);
for t = 1:T
    EB1 = EBkr(C(2), range(t), E{t, 1}, B{t, 1});
    EB2 = EBkr(C(1:3), range(t), E{t, 2}, B{t, 2});
    EB3 = EBkr(C, range(t), E{t, 3}, B{t, 3});
    for r = 1:R
        tic;
        % uni-laser
        temp = cell(1, I);
        for i = 1:I
            last = C(i)*range(t);
            temp{i} = reshape(ref{i, r}(row{1, r}, col{1, r}, 1:last), [], last);
        end
        A_temp = NLS(cat(2, temp{:}), EB3, 0);
        A{t, 3, r} = A_temp;
        idx = any(A_temp, 2);
        p(t, 3, r) = mean(A_temp(idx, r)./ sum(A_temp(idx, :), 2));
        % bi-laser
        temp = cell(1, I/2);
        for i = 1:(I/2)
            last = C(i)*range(t);
            temp{i} = reshape(ref_2L{i, r}(row{2, r}, col{2, r}, 1:last), [], last);
        end
        A_temp = NLS(cat(2, temp{:}), EB2, 0);
        A{t, 2, r} = A_temp;
        idx = any(A_temp, 2);
        p(t, 2, r) = mean(A_temp(idx, r)./ sum(A_temp(idx, :), 2));
        % single view
        last = C(2)*range(t);
        temp = reshape(ref_3L{r}(row{3, r}, col{3, r}, 1:last), [], last);
        A_temp = NLS(cat(2, temp), EB1, 0);
        A{t, 1, r} = A_temp;
        idx = any(A_temp, 2);
        p(t, 1, r) = mean(A_temp(idx, r)./ sum(A_temp(idx, :), 2));
        elapsedTime(t, r) = toc;
        fprintf('%2d-timelapse reference images of %s were unmixed.  (Time taken: %f seconds)\n', ...
            range(t), name{r}, elapsedTime(t, r));
    end
end