% Fig. 3.14: Phase line of the logistic model (book, Section 3.3, Eq. 3.22)
% f(x) = r (1 - x/K) x with r = 0.55, K = 210; where f > 0, x grows (arrow to the right), where f < 0, x decreases
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 0.55; K = 210;
f = @(x) r * (1 - x / K) .* x;
df = @(x) r * (1 - 2 * x / K);                           % derivative f'(x)
x = linspace(-30, 280, 400);
plot(x, f(x), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot([-30 280], [0 0], 'k');
von = [20 275 -8]; nach = [185 225 -28];                 % phase line: direction of motion of x
for i = 1:3
    if nach(i) > von(i), spitze = '>'; else, spitze = '<'; end
    plot([von(i) nach(i)], [0 0], 'Color', [0.64 0.08 0.18], 'LineWidth', 2.5);
    plot(nach(i), 0, spitze, 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18], 'MarkerSize', 9);
end
plot(0, 0, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10); plot(K, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 10); hold off
for xs = [0 K]
    if df(xs) < 0, art = 'stable'; else, art = 'unstable'; end
    fprintf('x* = %3d: f''(x*) = %5.2f -> %s\n', xs, df(xs), art);
end
xlabel('x'); legend('f(x) = r (1 - x/K) x');
