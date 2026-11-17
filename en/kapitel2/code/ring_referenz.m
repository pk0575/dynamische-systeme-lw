% Fig. 2.20: Propagation of the action potential on a ring (book, Section 2.5, Eq. 2.34)
% N = 50 cells, a = 0.89, b = 0.6, c = 0.28, k = 0.02, d = 0.4; at the start cell 1 is stimulated
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4;
f1 = @(y1, y2) y1.^2 .* exp(y2 - y1) + k;

% resting state: compute a single cell for 180 steps starting from (0.2, c/(1 - a))
y1r = 0.2; y2r = c / (1 - a);
for j = 1:180
    y1neu = f1(y1r, y2r); y2r = a * y2r - b * y1r + c; y1r = y1neu;
end
Z = 50; schritte = 201;
rechts = [2:Z 1]; links = [Z 1:Z-1];                 % neighbors on the ring

n_stoer = -1;                                        % no second stimulation
Y1 = y1r * ones(schritte + 1, Z); Y2 = y2r * ones(schritte + 1, Z);   % row n+1 = time step n
Y1(1, 1) = 0.3;                                  % cell 1 starts excited
for n = 0:schritte-1
    F = f1(Y1(n+1, :), Y2(n+1, :));
    Y1(n+2, :) = (1 - d) * F + d / 2 * (F(rechts) + F(links));
    Y2(n+2, :) = a * Y2(n+1, :) - b * Y1(n+1, :) + c;
    if n + 1 == n_stoer
        Y1(n+2, 36) = 0.3;                       % second stimulation of cell 36
    end
end

winkel = linspace(0, 2 * pi, 51); winkel = winkel(1:50);
cx = cos(winkel); cy = sin(winkel);                  % cells counterclockwise
fprintf('excited cells (y1 > 1):\n');
zeiten = [0 4 10 20 31 35];
for p = 1:6
    n = zeiten(p);
    subplot(2, 3, p);
    stem3(cx, cy, Y1(n+1, :), 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18], 'MarkerEdgeColor', [0.64 0.08 0.18], 'MarkerSize', 3);
    zlim([0 4.5]); set(gca, 'XTick', [], 'YTick', []); title(sprintf('n = %d', n));
    s = sprintf('%d, ', find(Y1(n+1, :) > 1));
    fprintf('  n = %2d: [%s]\n', n, s(1:end-2));
end
