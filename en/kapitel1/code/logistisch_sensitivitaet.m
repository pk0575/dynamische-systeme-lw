% Fig. 1.24: Sensitivity to the initial value (book, Section 1.3, Eq. 1.28)
% y_{n+1} = a y_n (1 - y_n) with y_0 = 0.05 and ~y_0 = 0.06 for a = 2, 3.1, 3.55, 4
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N = 30;
n = 0:N;
as = [2 3.1 3.55 4];
for p = 1:4
    a = as(p);
    y = zeros(1, N + 1); yt = zeros(1, N + 1);
    y(1) = 0.05; yt(1) = 0.06;
    for k = 1:N
        y(k + 1) = a * y(k) * (1 - y(k));
        yt(k + 1) = a * yt(k) * (1 - yt(k));
    end
    subplot(2, 2, p);
    plot(n, y, '--o', 'Color', [0.43 0.04 0.12]); hold on
    plot(n, yt, '--s', 'Color', [0.89 0.44 0.49]);
    plot([0 N], [1 - 1/a, 1 - 1/a], 'k-'); hold off
    xlabel('n'); legend(sprintf('y_n, a = %g', a), sprintf('~y_n, a = %g', a), 'Location', 'southeast');
    fprintf('a = %g:  |y_30 - ~y_30| = %.4f\n', a, abs(y(N + 1) - yt(N + 1)));
end
