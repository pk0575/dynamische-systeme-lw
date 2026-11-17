% Fig. 1.27: Steady states of x_{n+1} = sqrt(x_n) (book, Section 1.4, Eq. 1.31)
% left: start at 0.01 near the unstable state 0;  right: start at 1.01 near the stable state 1
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
starts = [0.01 1.01]; grenzen = [0 1.5; 0.99 1.01]; N = 4;
for p = 1:2
    lo = grenzen(p, 1); hi = grenzen(p, 2);
    x = zeros(1, N + 1); x(1) = starts(p);
    for k = 1:N
        x(k + 1) = sqrt(x(k));
    end
    fprintf('x_0 = %g: ', starts(p)); fprintf('%.5f  ', x); fprintf('\n');
    px = x(1); py = lo;
    for k = 1:N
        px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
    end
    xx = linspace(lo, hi, 300);
    subplot(1, 2, p);
    plot(xx, sqrt(xx), 'Color', [0 0.447 0.741]); hold on
    plot([lo hi], [lo hi], 'k-');
    plot(px, py, 'Color', [0.64 0.08 0.18]); hold off
    axis equal; axis([lo hi lo hi]); xlabel('x'); ylabel('f(x)');
end
disp('f''(x) = 1/(2 sqrt(x)):  f''(1) = 0.5 < 1 (stabil), f''(x) -> unendlich für x -> 0 (instabil)');
