% Fig. 1.32: Steady state of x_{n+1} = exp(-x_n) (book, Section 1.5)
% left: intersection of f(x) = exp(-x) with y = x;  right: equivalently the root of g(x) = exp(-x) - x
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
x = 0.5;
for n = 1:100                            % fixed-point iteration x_{n+1} = exp(-x_n)
    x = exp(-x);
end
fprintf('fixed-point iteration after 100 steps: x = %.10f\n', x);
fprintf('g(x) = exp(-x) - x = %.1e\n', exp(-x) - x);

blau = [0 0.447 0.741];
xx = linspace(0, 1, 200);
subplot(1, 2, 1);
plot(xx, exp(-xx), 'Color', blau); hold on
plot([0 1], [0 1], 'k-'); plot(x, x, 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('x'); legend('f(x) = exp(-x)', 'y = x');
subplot(1, 2, 2);
plot(xx, exp(-xx) - xx, 'Color', blau); hold on
plot([0 1], [0 0], 'k-'); plot(x, 0, 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('x'); legend('g(x) = exp(-x) - x');
