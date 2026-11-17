% Fig. 1.34: Newton's method without convergence (book, Section 1.5, Eq. 1.44)
% g(x) = x^3 - 2x + 2 with x_0 = 0: the approximations jump between 0 and 1, the root at -1.769 is not found
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
g = @(x) x.^3 - 2 * x + 2;
dg = @(x) 3 * x.^2 - 2;

x = zeros(1, 7);
for k = 1:6
    x(k + 1) = x(k) - g(x(k)) / dg(x(k));
end
fprintf('x_0 ... x_6 = '); fprintf('%g  ', x); fprintf('\n');

xs = -1;                                 % with a better initial value it works
for k = 1:8
    xs = xs - g(xs) / dg(xs);
end
fprintf('start at -1: root x* = %.6f\n', xs);

xx = linspace(-2.2, 1.8, 400);
plot(xx, g(xx), 'Color', [0 0.447 0.741]); hold on
plot([-2.2 1.8], [0 0], 'k-');
zz = linspace(-0.6, 1.6, 10);
for a = [0 1]                            % the two tangents
    plot(zz, g(a) + dg(a) * (zz - a), 'k-');
end
plot([0 1], [0 0], 'o', 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18]);
plot(xs, 0, 'ko', 'MarkerFaceColor', 'k');
hold off; ylim([-2.2 4.5]); xlabel('x');
