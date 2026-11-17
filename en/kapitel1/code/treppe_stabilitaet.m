% Fig. 1.28: Staircase diagrams with stable and unstable steady states (book, Section 1.4, Eq. 1.34)
% top: f(x) = x - 2x(0.5 - x)(1 - x) with fixed points 0 and 1 (stable) and 0.5 (unstable)
% bottom: f(x) = exp(-2x) (spiral approach) and f(x) = exp(-5x) (spiral divergence), each with x_0 = 0.2
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
g = @(x) x - 2 * x .* (0.5 - x) .* (1 - x);
fs = {g, g, @(x) exp(-2 * x), @(x) exp(-5 * x)};
namen = {'f(x) = x - 2x(0.5-x)(1-x)', 'f(x) = x - 2x(0.5-x)(1-x)', 'f(x) = exp(-2x)', 'f(x) = exp(-5x)'};
starts = {0.6, [0.4 0.6], 0.2, 0.2};
schritte = [20 20 20 7];
grenzen = [0.5 1; 0 1; 0 1; 0 1];
for p = 1:4
    f = fs{p}; N = schritte(p); lo = grenzen(p, 1); hi = grenzen(p, 2);
    xx = linspace(lo, hi, 400);
    subplot(2, 2, p);
    plot(xx, f(xx), 'Color', [0 0.447 0.741]); hold on
    plot([lo hi], [lo hi], 'k-');
    for x0 = starts{p}
        x = zeros(1, N + 1); x(1) = x0;
        for k = 1:N
            x(k + 1) = f(x(k));
        end
        px = x(1); py = lo;
        for k = 1:N
            px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
        end
        plot(px, py, 'Color', [0.64 0.08 0.18]);
        fprintf('%s, x_0 = %g:  x_%d = %.4f\n', namen{p}, x0, N, x(end));
    end
    hold off; axis equal; axis([lo hi lo hi]);
    xlabel('x_n'); ylabel('f(x_n)'); title(namen{p});
end

% stability criterion |f'(x*)| < 1 at the fixed points
for c = [2 5]
    xs = 0.5;
    for k = 1:100                        % fixed point with Newton's method
        xs = xs - (exp(-c * xs) - xs) / (-c * exp(-c * xs) - 1);
    end
    fprintf('f(x) = exp(-%dx):  x* = %.4f,  f''(x*) = %.4f\n', c, xs, -c * exp(-c * xs));
end
