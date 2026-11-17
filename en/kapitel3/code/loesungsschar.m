% Fig. 3.3: Family of solutions of a linear differential equation (book, Section 3.1, Eq. 3.6 and 3.7)
% dx/dt = a x + b with a = -0.5, b = 1; solutions x(t) = C e^(at) - b/a for different initial values, x* = -b/a = 2
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a = -0.5; b = 1;
xs = -b / a;                                             % constant solution
t = linspace(0, 8, 400);
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49];
x0s = [5 3.5 2.5 1 0];
hold on
for i = 1:5
    C = x0s(i) - xs;
    plot(t, C * exp(a * t) + xs, 'Color', rot(mod(i - 1, 3) + 1, :), 'LineWidth', 2);
    fprintf('x(0) = %g: C = %4.1f, x(8) = %.4f\n', x0s(i), C, C * exp(8 * a) + xs);
end
plot([0 8], [xs xs], 'k', 'LineWidth', 1.5); hold off
xlabel('t'); ylabel('x(t)'); title('black: x* = -b/a = 2');
