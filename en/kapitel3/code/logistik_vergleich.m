% Fig. 3.13: Continuous and discrete-time logistic model (book, Section 3.2, Eq. 3.20)
% line: solution of dx/dt = r (1 - x/K) x;  points: x_{n+1} = x_n + r x_n (1 - x_n/K);  K = 210, x0 = 0.2
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
K = 210; x0 = 0.2;
t = linspace(0, 30, 400); rs = [0.55 2.1 2.6 3.0];
for i = 1:4
    r = rs(i);
    subplot(2, 2, i);
    plot(t, x0 * K ./ (x0 + (K - x0) * exp(-r * t)), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
    x = zeros(1, 31); x(1) = x0;
    for n = 1:30
        x(n + 1) = x(n) + r * x(n) * (1 - x(n) / K);
    end
    plot(0:30, x, '--o', 'Color', [0.89 0.44 0.49], 'MarkerSize', 4); hold off
    title(sprintf('r = %g', r)); ylim([-10 300]);
    if i > 2, xlabel('t or n'); end
    fprintf('r = %g: x_27 ... x_30 = %s\n', r, sprintf('%.1f  ', x(28:31)));
end
