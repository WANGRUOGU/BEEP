function EB = EBkr(C, T, E, B)

V = length(C);
if isscalar(T)
    T = T * ones(V, 1);
end
CT = C .* T;
R = size(E, 2);
EB = zeros(sum(CT), R);
for v = 1:V
    c_range = (1+sum(C(1:(v-1)))):(sum(C(1:v)));
    t_range = (1+sum(T(1:(v-1)))):(sum(T(1:v)));
    EB_range = (1+sum(CT(1:(v-1)))):(sum(CT(1:v)));
    EB(EB_range, :) = kr(B(t_range, :), E(c_range, :));
end
EB = EB ./ max(EB);