% Abb. 1.40: Aktualisierungsfunktion des APD-Modells (Buch, Abschnitt 1.6, Gl. 1.49 und 1.50)
% f(APD) = r(m PCL - APD) mit m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
DImin = 5;
r = @(DI) 220 - 180 * exp(-DI / 60);
f = @(APD, PCL) r(ceil((APD + DImin) / PCL) * PCL - APD);   % ceil: nach wie vielen Perioden der nächste Reiz wirkt

APD = linspace(0, 800, 4001);
farben = [0 0.447 0.741; 0.45 0.70 0.90];
PCLliste = {400, [400 220]};
for p = 1:2
    subplot(1, 2, p); hold on
    PCLs = PCLliste{p};
    for i = 1:numel(PCLs)
        y = f(APD, PCLs(i));
        y([false abs(diff(y)) > 20]) = NaN;          % Sprungstellen nicht verbinden
        plot(APD, y, 'Color', farben(i, :), 'DisplayName', sprintf('PCL = %d ms', PCLs(i)));
    end
    hold off; xlabel('APD (ms)'); ylabel('f(APD)'); legend('show', 'Location', 'southwest');
end
disp('Sprungstellen bei APD = k PCL - DI_min, z. B. 395 und 795 ms für PCL = 400 ms');
