% Fig. 2.21: Second stimulation of cell 36 in the ring model (book, Section 2.5, Eq. 2.34)
% scenario a) n* = 37: signal dies out;  b) n* = 45: spreads in both directions;  c) n* = 41: circulates permanently
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

winkel = linspace(0, 2 * pi, 51); winkel = winkel(1:50);
cx = cos(winkel); cy = sin(winkel);
namen = 'abc'; nstern = [37 45 41];
zeiten = [37 39 41 43; 45 52 72 81; 41 52 75 100];
for sp = 1:3
    n_stoer = nstern(sp);
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
    s = sprintf('%d, ', find(Y1(201, :) > 1));
    fprintf('Scenario %s) n* = %d: excited cells after 200 steps: [%s]\n', namen(sp), n_stoer, s(1:end-2));
    for z = 1:4
        n = zeiten(sp, z);
        subplot(4, 3, 3 * (z - 1) + sp);
        stem3(cx, cy, Y1(n+1, :), 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18], 'MarkerEdgeColor', [0.64 0.08 0.18], 'MarkerSize', 3);
        zlim([0 4.5]); set(gca, 'XTick', [], 'YTick', []); title(sprintf('%s) n = %d', namen(sp), n));
    end
end
