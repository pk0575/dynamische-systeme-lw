% Fig. 1.1: Fish length after n years (book, Section 1.1, Eq. 1.1)
% explicit sequence x_n = 60 n / (n + 2)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
n = 0:10;                       % n = 0, 1, ..., 10
x = 60 * n ./ (n + 2);          % formula for the n-th term (elementwise ./)

fprintf('%.1f  ', x); fprintf('\n')   % 0.0  20.0  30.0  36.0  40.0  42.9  45.0 ...

rot = [0.64 0.08 0.18];
plot(n, x, 'o--', 'Color', rot, 'MarkerFaceColor', rot); hold on
for k = 1:numel(n)
    text(n(k), x(k) + 1.5, sprintf('%.1f', x(k)), 'HorizontalAlignment', 'center', 'Color', rot)
end
hold off
xlabel('n (years)'); ylabel('Fish length x_n (cm)'); ylim([-3 60])
