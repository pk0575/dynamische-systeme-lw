% Fig. 1.7: Update function of Heron's method (book, Section 1.1, Eq. 1.4)
% f(x) = (x + 2/x)/2 and first step x_0 = 0.5 -> x_1 = f(x_0)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
f = @(x) 0.5 * (x + 2 ./ x);
x0 = 0.5;
x1 = f(x0);
fprintf('x_0 = %g,  x_1 = f(x_0) = %g\n', x0, x1);    % x_1 = 2.25

rot = [0.64 0.08 0.18]; blau = [0 0.447 0.741];
x = linspace(0.16, 4.3, 400);
plot(x, f(x), 'Color', blau); hold on
plot([x0 x0 0], [0 x1 x1], '--', 'Color', rot);      % up to the curve, then to the y-axis
plot([x0 0], [0 x1], 'o', 'Color', rot, 'MarkerFaceColor', rot);
hold off
xlim([0 4.3]); ylim([0 6.5]);
xlabel('x'); ylabel('f(x)'); legend('f(x) = (x + 2/x)/2');
