% Fig. 1.33: The first steps of Newton's method (book, Section 1.5, Eq. 1.44)
% x_{n+1} = x_n - g(x_n)/g'(x_n) for g(x) = exp(-5x) - x with x_0 = 0.05
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
g = @(x) exp(-5 * x) - x;
dg = @(x) -5 * exp(-5 * x) - 1;

x = zeros(1, 7); x(1) = 0.05;
for k = 1:6
    x(k + 1) = x(k) - g(x(k)) / dg(x(k));
end
for k = 1:7
    fprintf('x_%d = %.12f\n', k - 1, x(k));   % the number of correct digits roughly doubles per step
end

xx = linspace(0, 0.35, 300);
for p = 1:2
    subplot(1, 2, p);
    plot(xx, g(xx), 'Color', [0 0.447 0.741]); hold on
    plot([0 0.35], [0 0], 'k-');
    for j = 1:p                          % tangent at x_{j-1}, its root is x_j
        plot(xx, g(x(j)) + dg(x(j)) * (xx - x(j)), 'k-');
        plot([x(j) x(j)], [0 g(x(j))], 'k:');
    end
    plot(x(1:p + 1), zeros(1, p + 1), 'o', 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18]);
    hold off; axis([0 0.35 -0.35 1]); xlabel('x');
end
