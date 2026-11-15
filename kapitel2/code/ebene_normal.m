% Abb. 2.23: Ausbreitung in der Ebene, reguläre Welle (Buch, Abschnitt 2.5, Gl. 2.35)
% 100 x 100 Zellen, Parameter wie beim Ring; der linke Rand wird angeregt, die Welle läuft nach rechts und verlässt das Gebiet
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
blockade = false; schritte = 201;
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4;
f1 = @(y1, y2) y1.^2 .* exp(y2 - y1) + k;
y1r = 0.2; y2r = c / (1 - a);
for j = 1:180                                        % Ruhezustand der einzelnen Zelle
    y1neu = f1(y1r, y2r); y2r = a * y2r - b * y1r + c; y1r = y1neu;
end

Z = 100;
Y1 = y1r * ones(Z); Y2 = y2r * ones(Z);
Y1(1, :) = 0.3;                                      % linker Rand (i = 1) startet erregt
vor = [2:Z Z]; zur = [1 1:Z-1];                      % Nachbarindizes, am Rand die Zelle selbst (kein Fluss)
Y = zeros(Z, Z, schritte + 1); Y(:, :, 1) = Y1;      % Y(:, :, n+1) = Zustand y1 nach n Schritten
for n = 1:schritte
    D = d * ones(Z);
    if blockade && n >= 50 && n <= 52
        D(28:30, 1:50) = 0;                          % Blockade im Gebiet [28, 30] x [1, 50]
    end
    F = f1(Y1, Y2);
    Y1neu = (1 - D) .* F + D / 4 .* (F(vor, :) + F(zur, :) + F(:, vor) + F(:, zur));
    Y2 = a * Y2 - b * Y1 + c;
    Y1 = Y1neu;
    Y(:, :, n + 1) = Y1;
end
weissrot = [linspace(1, 0.43, 64)' linspace(1, 0.04, 64)' linspace(1, 0.12, 64)'];

zeiten = [3 36 69 102 135 168];
for p = 1:6
    n = zeiten(p);
    subplot(2, 3, p);
    imagesc([1 100], [1 100], Y(:, :, n + 1)', [0 4]); axis xy; colormap(weissrot); title(sprintf('n = %d', n));
    [~, i] = max(max(Y(:, :, n + 1), [], 2));
    fprintf('n = %3d: Wellenfront bei i = %d\n', n, i);
end
