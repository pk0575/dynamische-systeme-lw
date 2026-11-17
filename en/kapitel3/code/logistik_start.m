% Fig. 3.15: Solutions of the logistic model for different initial values (book, Section 3.3)
% r = 0.55, K = 210; the steady-state solutions x = 0 and x = K are neither reached nor crossed by any other solution
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 0.55; K = 210;
x = @(t, x0) x0 * K ./ (x0 + (K - x0) * exp(-r * t));
t = linspace(0, 20, 300);
plot(t, 0 * t, 'Color', [0.43 0.04 0.12], 'LineWidth', 3); hold on
plot(t, 0 * t + K, 'Color', [0.43 0.04 0.12], 'LineWidth', 3);
plot(t, x(t, 30), '--', 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
plot(t, x(t, 300), '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
for x0 = [30 300]
    fprintf('x0 = %d: x(20) = %.3f,  distance to K: %.3f\n', x0, x(20, x0), abs(x(20, x0) - K));
end
xlabel('t (h)'); ylabel('x(t)'); legend('x0 = 0', 'x0 = K', 'x0 = 30', 'x0 = 300', 'Location', 'east');
