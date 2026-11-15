% Abb. 2.22: die drei Szenarien des Ringmodells in der Draufsicht (Buch, Abschnitt 2.5, Gl. 2.34)
% waagrecht die Zellen, senkrecht die Zeitschritte n, Farbe = y1; jede schräge Spur ist eine wandernde Welle
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

namen = 'abc'; nstern = [37 45 41];
weissrot = [linspace(1, 0.43, 64)' linspace(1, 0.04, 64)' linspace(1, 0.12, 64)'];
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
    subplot(1, 3, sp);
    imagesc([1 50], [0 201], Y1, [0 4.2]); axis xy; colormap(weissrot);
    title(sprintf('Szenario %s)', namen(sp))); xlabel('Zelle');
    if sp == 1, ylabel('n'); end
    t = find(Y1(101:202, 1) > 1)' + 99;              % Zeitschritte n >= 100 mit erregter Zelle 1
    s = sprintf('%d, ', t(1:min(6, end)));
    fprintf('Szenario %s): Zeitschritte mit erregter Zelle 1 ab n = 100: [%s]\n', namen(sp), s(1:end-2));
end
colorbar;
