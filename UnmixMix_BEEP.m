function A = UnmixMix_BEEP(mix, timeFrame, E, B, C)

N = length(timeFrame);
[S, L] = size(mix);
A = cell(N, S);
elapsedTime = zeros(1, N);

for t = 1:N
    EB1 = EBkr(C(2), timeFrame(t), E{t, 1}, B{t, 1});
    EB2 = EBkr(C(1:3), timeFrame(t), E{t, 2}, B{t, 2});
    EB3 = EBkr(C, timeFrame(t), E{t, 3}, B{t, 3});
    tic;
    % single laser
    temp = cell(1, L);
    for i = 1:L
        last = C(i)*timeFrame(t);
        temp{i} = mix{1, i}(:, :, 1:last);
    end
    A{t, 3} = NLS(cat(3, temp{:}), EB3, 1);
    % double laser
    temp = cell(1, L/2);
    for i = 1:(L/2)
        last = C(i)*timeFrame(t);
        temp{i} = mix{2, i}(:, :, 1:last);
    end
    A{t, 2} = NLS(cat(3, temp{:}), EB2, 1);
    % single-view
    last = C(2)*timeFrame(t);
    temp = mix{3, 1}(:, :, 1:last);
    A{t, 1} = NLS(temp, EB1, 1);
    elapsedTime(t) = toc;
    fprintf('%2d-timelapse mixture images were unmixed.  (Time taken: %f seconds)\n', ...
        timeFrame(t), elapsedTime(t));
end