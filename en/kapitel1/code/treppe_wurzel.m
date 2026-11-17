% Fig. 1.26: Staircase diagrams for x_{n+1} = sqrt(x_n) (book, Section 1.4, Eq. 1.31)
% x_0 = 0.5 (left) and x_0 = 1.4 (right); the staircase runs toward the intersection of f(x) = sqrt(x) with y = x
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
xx = linspace(0, 1.5, 300);
starts = [0.5 1.4]; N = 4;
for p = 1:2
    x = zeros(1, N + 1); x(1) = starts(p);
    for k = 1:N
        x(k + 1) = sqrt(x(k));
    end
    fprintf('x_0 = %g: ', starts(p)); fprintf('%.4f  ', x); fprintf('\n');
    px = x(1); py = 0;
    for k = 1:N
        px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
    end
    subplot(1, 2, p);
    plot(xx, sqrt(xx), 'Color', [0 0.447 0.741]); hold on
    plot([0 1.5], [0 1.5], 'k-');
    plot(px, py, 'Color', [0.64 0.08 0.18]); hold off
    axis equal; axis([0 1.5 0 1.5]); xlabel('x'); ylabel('f(x)');
end
