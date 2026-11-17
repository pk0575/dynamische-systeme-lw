% Fig. 3.6: Initial value problems without a unique or without a global solution (book, Section 3.1)
% left dx/dt = t/x, x(0) = 0: x(t) = t and x(t) = -t both solve it;  right dx/dt = x^2, x(0) = 1: x(t) = 1/(1 - t) only for t < 1
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
subplot(1, 2, 1);
t = linspace(0, 2, 100);
plot(t, t, 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, -t, '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); plot(0, 0, 'ko', 'MarkerFaceColor', 'k'); hold off
title('dx/dt = t/x, x(0) = 0'); legend('x_1(t) = t', 'x_2(t) = -t'); xlabel('t');
subplot(1, 2, 2);
t = linspace(0, 0.95, 200);
plot(t, 1 ./ (1 - t), 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold on
plot([1 1], [0 20], 'k--'); plot(0, 1, 'ko', 'MarkerFaceColor', 'k'); hold off
ylim([0 20]); xlim([0 1.2]); title('dx/dt = x^2, x(0) = 1'); xlabel('t');
for tt = [0.5 0.9 0.99]
    fprintf('x(%g) = 1/(1 - %g) = %.0f\n', tt, tt, 1 / (1 - tt));
end
