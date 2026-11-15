% Abb. 2.20: Ausbreitung des Aktionspotentials auf einem Ring (Buch, Abschnitt 2.5, Gl. 2.34)
% N = 50 Zellen, a = 0.89, b = 0.6, c = 0.28, k = 0.02, d = 0.4; zu Beginn wird Zelle 1 angeregt
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

n_stoer = -1;                                        % keine zweite Anregung
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

winkel = linspace(0, 2 * pi, 51); winkel = winkel(1:50);
cx = cos(winkel); cy = sin(winkel);                  % Zellen gegen den Uhrzeigersinn
fprintf('erregte Zellen (y1 > 1):\n');
zeiten = [0 4 10 20 31 35];
for p = 1:6
    n = zeiten(p);
    subplot(2, 3, p);
    stem3(cx, cy, Y1(n+1, :), 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18], 'MarkerEdgeColor', [0.64 0.08 0.18], 'MarkerSize', 3);
    zlim([0 4.5]); set(gca, 'XTick', [], 'YTick', []); title(sprintf('n = %d', n));
    s = sprintf('%d, ', find(Y1(n+1, :) > 1));
    fprintf('  n = %2d: [%s]\n', n, s(1:end-2));
end
