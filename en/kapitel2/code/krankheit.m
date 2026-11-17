% Fig. 2.7: Disease progression as a linear system (book, Section 2.2, Eq. 2.8)
% x_{n+1} = A x_n with x = (healthy, mildly ill, severely ill), x_0 = (100000, 0, 0), one step = one year
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65];
N = 20;
X = zeros(3, N + 1);
X(:, 1) = [100000; 0; 0];
for k = 1:N
    X(:, k + 1) = A * X(:, k);           % matrix times vector
end
fprintf('x_20 = (%.0f, %.0f, %.0f)\n', X(:, end));
fprintf('column sums of A: %g %g %g -> the total number is conserved: %.0f\n', sum(A), sum(X(:, end)));

namen = {'healthy g_n', 'mildly ill l_n', 'severely ill k_n'};
farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
for i = 1:3
    subplot(3, 1, i);
    plot(0:N, X(i, :), ['--' marker(i)], 'Color', farben(i, :)); legend(namen{i}, 'Location', 'southeast');
end
xlabel('n (years)');
