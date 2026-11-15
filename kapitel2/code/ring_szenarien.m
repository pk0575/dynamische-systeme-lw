% Abb. 2.21: zweite Anregung der Zelle 36 im Ringmodell (Buch, Abschnitt 2.5, Gl. 2.34)
% Szenario a) n* = 37: Signal erlischt;  b) n* = 45: breitet sich in beide Richtungen aus;  c) n* = 41: kreist dauerhaft
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4;
f1 = @(y1, y2) y1.^2 .* exp(y2 - y1) + k;

% Ruhezustand: einzelne Zelle 180 Schritte lang ab (0.2, c/(1 - a)) rechnen
y1r = 0.2; y2r = c / (1 - a);
for j = 1:180
    y1neu = f1(y1r, y2r); y2r = a * y2r - b * y1r + c; y1r = y1neu;
end
Z = 50; schritte = 201;
rechts = [2:Z 1]; links = [Z 1:Z-1];                 % Nachbarn auf dem Ring

winkel = linspace(0, 2 * pi, 51); winkel = winkel(1:50);
cx = cos(winkel); cy = sin(winkel);
namen = 'abc'; nstern = [37 45 41];
zeiten = [37 39 41 43; 45 52 72 81; 41 52 75 100];
for sp = 1:3
    n_stoer = nstern(sp);
    Y1 = y1r * ones(schritte + 1, Z); Y2 = y2r * ones(schritte + 1, Z);   % Zeile n+1 = Zeitschritt n
    Y1(1, 1) = 0.3;                                  % Zelle 1 startet erregt
    for n = 0:schritte-1
        F = f1(Y1(n+1, :), Y2(n+1, :));
        Y1(n+2, :) = (1 - d) * F + d / 2 * (F(rechts) + F(links));
        Y2(n+2, :) = a * Y2(n+1, :) - b * Y1(n+1, :) + c;
        if n + 1 == n_stoer
            Y1(n+2, 36) = 0.3;                       % zweite Anregung der Zelle 36
        end
    end
    s = sprintf('%d, ', find(Y1(201, :) > 1));
    fprintf('Szenario %s) n* = %d: erregte Zellen nach 200 Schritten: [%s]\n', namen(sp), n_stoer, s(1:end-2));
    for z = 1:4
        n = zeiten(sp, z);
        subplot(4, 3, 3 * (z - 1) + sp);
        stem3(cx, cy, Y1(n+1, :), 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18], 'MarkerEdgeColor', [0.64 0.08 0.18], 'MarkerSize', 3);
        zlim([0 4.5]); set(gca, 'XTick', [], 'YTick', []); title(sprintf('%s) n = %d', namen(sp), n));
    end
end
