% Abb. 1.18: Ratenfunktion des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.26)
% R(x) = r (1 - x/K): bei kleinem Bestand wächst er fast mit der Rate r, bei x = K kommt das Wachstum zum Erliegen
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r = 1; K = 5;
R = @(x) r * (1 - x / K);
for x = [0 1 2.5 5]
    fprintf('R(%g) = %.2f\n', x, R(x));
end

x = linspace(0, K, 100);
plot(x, R(x), 'Color', [0 0.447 0.741]);
set(gca, 'XTick', [0 K], 'XTickLabel', {'0', 'K'}, 'YTick', [0 r], 'YTickLabel', {'0', 'r'});
xlabel('x'); ylabel('R(x)');
