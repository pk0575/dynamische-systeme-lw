% Fig. 2.11: Disease progression with steady state (book, Section 2.3, Eq. 2.8)
% The steady state x* = A x* is an eigenvector for the eigenvalue 1, scaled to 100000 persons
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65];
[V, D] = eig(A);
w = diag(D);
fprintf('eigenvalues: '); fprintf('%.4f  ', sort(real(w))); fprintf('\n');
[~, i1] = min(abs(w - 1));
v = real(V(:, i1));                      % eigenvector for the eigenvalue 1
xs = v / sum(v) * 100000;
fprintf('steady state x* = (%.0f, %.0f, %.0f)\n', xs);

N = 30;
X = zeros(3, N + 1); X(:, 1) = [100000; 0; 0];
for k = 1:N
    X(:, k + 1) = A * X(:, k);
end
namen = {'g_n', 'l_n', 'k_n'};
farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
for i = 1:3
    subplot(3, 1, i);
    plot(0:N, X(i, :), ['--' marker(i)], 'Color', farben(i, :)); hold on
    plot([0 N], xs(i) * [1 1], 'k--'); hold off
    legend(namen{i}, 'Location', 'southeast');
end
xlabel('n (years)');
