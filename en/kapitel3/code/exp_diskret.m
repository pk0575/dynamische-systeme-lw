% Fig. 3.9: Continuous and discrete exponential growth (book, Section 3.2, Eq. 3.17)
% x(t) = e^(0.5 t) and x_n = a^n with a = e^0.5: at the times t = n both agree
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
t = linspace(0, 6, 300); n = 0:6;
a = exp(0.5);
plot(t, exp(0.5 * t), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(n, a.^n, 'o', 'Color', [0.89 0.44 0.49], 'MarkerFaceColor', [0.89 0.44 0.49], 'MarkerSize', 9); hold off
fprintf('a = e^0.5 = %.4f;  a^6 = %.4f,  e^3 = %.4f\n', a, a^6, exp(3));
xlabel('t or n'); ylabel('x'); legend('x(t) = e^{0.5t}', sprintf('x_n = a^n, a = %.4f', a), 'Location', 'northwest');
