% Fig. 1.8: Staircase diagram of Heron's method (book, Section 1.1, Eq. 1.4)
% x_{n+1} = (x_n + 2/x_n)/2 with x_0 = 0.5; the staircase runs into the intersection with y = x at sqrt(2)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
f = @(x) 0.5 * (x + 2 ./ x);
x0 = 0.5; N = 4;

x = zeros(1, N + 1);
x(1) = x0;                               % MATLAB counts from 1: x(1) is x_0
for k = 1:N
    x(k + 1) = f(x(k));
end
for k = 1:N + 1
    fprintf('x_%d = %.6f\n', k - 1, x(k));
end
fprintf('sqrt(2) = %.6f\n', sqrt(2));

rot = [0.64 0.08 0.18]; blau = [0 0.447 0.741];
xx = linspace(0.3, 3, 400);
schrittzahl = [1 N];
for p = 1:2
    subplot(1, 2, p);
    plot(xx, f(xx), 'Color', blau); hold on
    plot([0 3], [0 3], 'k-');
    s = schrittzahl(p);
    px = x(1); py = 0;                   % staircase: vertically to the graph, horizontally to the diagonal
    for k = 1:s
        px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
    end
    px = [px x(s + 1)]; py = [py 0];     % value back to the x-axis
    plot(px, py, 'Color', rot);
    hold off
    axis([0 3 0 3]); xlabel('x'); ylabel('f(x)');
    title(sprintf('%d step(s)', s));
end
