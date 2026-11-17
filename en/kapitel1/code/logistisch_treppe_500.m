% Fig. 1.31: Staircase diagrams of the logistic model over 500 steps (book, Section 1.4)
% initial value 0.05; a = 2 (fixed point), 3.3 (2-cycle), 3.55 (8-cycle), 4 (aperiodic)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N = 500; as = [2 3.3 3.55 4];
xx = linspace(0, 1, 400);
for p = 1:4
    a = as(p);
    f = @(y) a * y .* (1 - y);
    y = zeros(1, N + 1); y(1) = 0.05;
    for k = 1:N
        y(k + 1) = f(y(k));
    end
    px = zeros(1, 2 * N + 1); py = zeros(1, 2 * N + 1);
    px(1) = y(1);
    for k = 1:N
        px(2 * k) = y(k); py(2 * k) = y(k + 1);
        px(2 * k + 1) = y(k + 1); py(2 * k + 1) = y(k + 1);
    end
    subplot(2, 2, p);
    plot(xx, f(xx), 'Color', [0 0.447 0.741]); hold on
    plot([0 1], [0 1], 'k-');
    if a < 4, lw = 1.5; else, lw = 0.3; end
    plot(px, py, 'Color', [0.64 0.08 0.18], 'LineWidth', lw); hold off
    axis equal; axis([0 1 0 1]); xlabel('x_n'); ylabel('f(x_n)'); title(sprintf('a = %g', a));
    werte = unique(round(y(end-15:end) * 1e4) / 1e4);     % long-term behavior: distinct values at the end
    if numel(werte) <= 8
        fprintf('a = %g:  %d distinct values at the end: ', a, numel(werte)); fprintf('%.4f ', werte); fprintf('\n');
    else
        fprintf('a = %g:  %d distinct values at the end: aperiodic\n', a, numel(werte));
    end
end
