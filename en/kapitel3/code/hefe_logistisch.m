% Fig. 3.12: Logistic growth of yeast (book, Section 3.2, Eq. 3.19 and 3.20)
% dx/dt = r (1 - x/K) x with r = 0.55 per hour, K = 210 (million cells per ml); solution x(t) = x0 K / (x0 + (K - x0) e^(-rt))
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 0.55; K = 210;
x = @(t, x0) x0 * K ./ (x0 + (K - x0) * exp(-r * t));
t = linspace(0, 20, 300);
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; stil = {'-', '--', '-.'}; x0s = [5 50 300];
hold on
for i = 1:3
    plot(t, x(t, x0s(i)), stil{i}, 'Color', rot(i, :), 'LineWidth', 2, 'DisplayName', sprintf('x0 = %d', x0s(i)));
    fprintf('x0 = %3d: x(5) = %6.2f,  x(20) = %6.2f\n', x0s(i), x(5, x0s(i)), x(20, x0s(i)));
end
plot([0 20], [K K], 'k--', 'HandleVisibility', 'off'); hold off
xlabel('t (h)'); ylabel('x(t)'); legend('show', 'Location', 'southeast');
