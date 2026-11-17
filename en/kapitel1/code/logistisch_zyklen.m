% Fig. 1.30: Iterates f^2 and f^3 of the logistic model (book, Section 1.4, Eq. 1.38)
% left: f^2 with a = 3.1 (stable 2-cycle);  right: f^3 with a = 3.835 (stable 3-cycle)
% fixed points of f^k: filled black = stable (|(f^k)'| < 1), white = unstable
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
as = [3.1 3.835]; ks = [2 3];
x = linspace(0, 1, 2000);
for p = 1:2
    a = as(p); k = ks(p);
    f = @(y) a * y .* (1 - y);
    if k == 2
        fk = @(y) f(f(y));               % f^2
    else
        fk = @(y) f(f(f(y)));            % f^3
    end
    subplot(1, 2, p);
    plot(x, fk(x), 'Color', [0 0.447 0.741]); hold on
    plot([0 1], [0 1], 'k-');
    % fixed points: look for sign changes of f^k(x) - x, then determine precisely with fzero
    xg = linspace(0, 1, 20001); g = fk(xg) - xg;
    idx = find(sign(g(1:end-1)) ~= sign(g(2:end)));
    pts = 0;
    for i = idx
        pts(end + 1) = fzero(@(z) fk(z) - z, [xg(i) xg(i + 1)]);
    end
    pts = unique(round(pts * 1e10) / 1e10);
    for q = pts
        e = 1e-7; ableitung = (fk(q + e) - fk(q - e)) / (2 * e);
        if abs(ableitung) < 1
            plot(q, q, 'ko', 'MarkerFaceColor', 'k'); art = 'stable';
        else
            plot(q, q, 'ko', 'MarkerFaceColor', 'w'); art = 'unstable';
        end
        fprintf('a = %g, f^%d:  x = %.4f  %s  (derivative %.3f)\n', a, k, q, art, ableitung);
    end
    hold off; axis equal; axis([0 1 0 1]);
    xlabel('x'); ylabel(sprintf('f^%d(x)', k)); title(sprintf('a = %g', a));
end

