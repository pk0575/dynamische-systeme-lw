% Fig. 1.17: Geometric growth with growth rate r (book, Section 1.3, Eq. 1.24)
% x_{n+1} = (1 + r) x_n with x_0 = 100; left x_n, right ln(x_n)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
x0 = 100; N = 30;
n = 0:N;
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'osd';
rs = [1 0.1 -0.5];
for i = 1:3
    r = rs(i);
    x = x0 * (1 + r) .^ n;
    subplot(1, 2, 1); hold on
    plot(n(1:5), x(1:5), ['--' marker(i)], 'Color', rot(i, :), 'DisplayName', sprintf('r = %g', r));
    subplot(1, 2, 2); hold on
    plot(n, log(x), ['--' marker(i)], 'Color', rot(i, :), 'DisplayName', sprintf('r = %g', r));
    fprintf('r = %g:  slope of ln(x_n) = ln(1 + r) = %.4f\n', r, log(1 + r));
end
subplot(1, 2, 1); hold off; xlabel('n'); ylabel('x_n'); legend('show');
subplot(1, 2, 2); hold off; xlabel('n'); ylabel('ln(x_n)'); legend('show');
