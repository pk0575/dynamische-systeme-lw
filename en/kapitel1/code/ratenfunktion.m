% Fig. 1.18: Rate function of the logistic growth model (book, Section 1.3, Eq. 1.26)
% R(x) = r (1 - x/K): a small stock grows almost at the rate r, at x = K growth comes to a halt
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 1; K = 5;
R = @(x) r * (1 - x / K);
for x = [0 1 2.5 5]
    fprintf('R(%g) = %.2f\n', x, R(x));
end

x = linspace(0, K, 100);
plot(x, R(x), 'Color', [0 0.447 0.741]);
set(gca, 'XTick', [0 K], 'XTickLabel', {'0', 'K'}, 'YTick', [0 r], 'YTickLabel', {'0', 'r'});
xlabel('x'); ylabel('R(x)');
