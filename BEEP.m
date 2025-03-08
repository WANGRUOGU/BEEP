function [A_out, E, B] = BEEP(Y, R)
% Y: BEEP data, R: number of endmembers
V = length(Y);
C = zeros(V, 1);
T = zeros(V, 1);
N = size(Y{1}, 1);
for v = 1:V
    [~, C(v), T(v)] = size(Y{v}); % channels and time points
end
CT = C .* T;
M_A = zeros(sum(CT), R);
idx = cell(V, 1);
for v = 1:V
    idx{v} = any(Y{v}, [2, 3]);
end
idx = any(cat(2,idx{:}), 2);
for v = 1:V
    Y{v} = double(Y{v}(idx, :));
end
N_any = size(Y{1}, 1);
Y_N = cell(V, 1);
Y_C = cell(V, 1);
Y_T = cell(V, 1);
for v = 1:V
    Y_N{v} = reshape(Y{v}, N_any, []);
    Y_C{v} = reshape(permute(Y{v}, [2, 1, 3]), C(v), []); % C*NT
    Y_T{v} = reshape(Y{v}, [], T(v)).'; % T*CN
end
Y_N = cat(2, Y_N{:});
A = rand(N_any, R);
E = rand(sum(C), R);
B = rand(sum(T), R);
iter = 1e3;
fit = 0;
for i = 1:iter
    fit_old = fit;
    for v = 1:V
        c_range = (1+sum(C(1:(v-1)))):(sum(C(1:v)));
        t_range = (1+sum(T(1:(v-1)))):(sum(T(1:v)));
        M_A_range = (1+sum(CT(1:(v-1)))):(sum(CT(1:v)));
        M_A(M_A_range, :) = kr(B(t_range, :), E(c_range, :)); % CT*R
    end
    A = A .* (Y_N*M_A) ./ (A*(M_A.')*M_A);
    for v = 1:V
        c_range = (1+sum(C(1:(v-1)))):(sum(C(1:v)));
        t_range = (1+sum(T(1:(v-1)))):(sum(T(1:v)));
        M_E = kr(B(t_range, :), A); % NT*R
        E(c_range, :) = E(c_range, :) .* (Y_C{v}*M_E) ./ (E(c_range, :)*(M_E.')*M_E);
        M_B = kr(E(c_range, :), A); % CN*R
        B(t_range, :) = B(t_range, :) .* (Y_T{v}*M_B) ./ (B(t_range, :)*(M_B.')*M_B);
    end
    E = E ./ max(E);
    B = B ./ max(B);
    A = A .* max(E) .* max(B);
    for v = 1:V
        c_range = (1+sum(C(1:(v-1)))):(sum(C(1:v)));
        t_range = (1+sum(T(1:(v-1)))):(sum(T(1:v)));
        M_A_range = (1+sum(CT(1:(v-1)))):(sum(CT(1:v)));
        M_A(M_A_range, :) = kr(B(t_range, :), E(c_range, :)); % CT*R
    end
    fit = norm(Y_N - A * M_A.', 'fro');
    change = abs(fit_old - fit);
    % change = abs(fit_old - fit)/fit_old;
   % fprintf('Iter %2d: fit = %e fitdelta = %7.1e\n', ...
   %     i, fit, change);
    if (change < 1e-8) || (isnan(fit))
        break;
    end
end
A_out = zeros(N, R);
A = A / max(max(A));
A_out(idx, :) = A;