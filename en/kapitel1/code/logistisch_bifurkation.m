% Fig. 1.23: Bifurcation diagram of the logistic growth model (book, Section 1.3, Eq. 1.28)
% y_{n+1} = a y_n (1 - y_n): for each value of a, the long-term behavior after n_* = 10000 steps is plotted
% top: 2.8 <= a <= 4;  bottom: detail 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (the pattern recurs)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
gruen = [0 0.39 0];
bereiche = {linspace(2.8, 4.0, 2401), linspace(3.8538, 3.8541, 1501)};
behalten = [200 6000];
fenster = [0 1; 0.494 0.506];
for p = 1:2
    a = bereiche{p};
    y = 0.9 * ones(size(a));             % all parameter values at once (vector)
    for k = 1:10000                      % transient
        y = a .* y .* (1 - y);
    end
    A = []; Y = [];
    for k = 1:behalten(p)                % collect long-term behavior
        y = a .* y .* (1 - y);
        m = (y > fenster(p, 1)) & (y < fenster(p, 2));
        A = [A a(m)]; Y = [Y y(m)];
    end
    subplot(2, 1, p);
    plot(A, Y, '.', 'Color', gruen, 'MarkerSize', 1);
    xlabel('a'); ylabel('y_n for n > 10000');
end

a = 3.2; y = 0.9;                        % example a = 3.2: two values alternate (2-cycle)
for k = 1:10000
    y = a * y * (1 - y);
end
fprintf('a = 3.2:  2-cycle %.4f <-> %.4f\n', y, a * y * (1 - y));
