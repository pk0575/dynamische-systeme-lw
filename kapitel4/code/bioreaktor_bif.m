% Abb. 4.21: Auswaschen im Bioreaktor (Buch, Abschnitt 4.4, Gl. 4.17)
% stationäre Biomasse b* = (n_in - D k50/(kmax - D))/nu in Abhängigkeit von D; oberhalb von D_c = K(n_in) wird die Biomasse ausgewaschen
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
D = 0.2; nin = 10; nu = 2; kmax = 1; k50 = 0.5;      % D in 1/h, Konzentrationen in g/l
K = @(n) kmax * n ./ (k50 + n);                        % Wachstumsrate nach Monod
Dc = K(nin);
bst = @(D) (nin - D * k50 ./ (kmax - D)) / nu;
gruen = [0 0.39 0];
Dg = linspace(0.001, 1.2, 600);
D1 = Dg(Dg <= Dc); D2 = Dg(Dg >= Dc & Dg <= 0.985);
plot(D1, bst(D1), 'Color', gruen, 'LineWidth', 3); hold on
plot(D2, bst(D2), '--', 'Color', gruen, 'LineWidth', 2);
plot([0 Dc], [0 0], '--', 'Color', gruen, 'LineWidth', 2);
plot([Dc 1.2], [0 0], 'Color', gruen, 'LineWidth', 3);
plot([Dc Dc], [-1.5 5.5], ':', 'Color', [0.5 0.5 0.5]); plot(D, bst(D), 'ko', 'MarkerFaceColor', 'k'); hold off
fprintf('D_c = K(n_in) = %.4f pro Stunde\n', Dc);
for DD = [0.2 0.5 0.9]
    fprintf('D = %g: b* = %.4f g/l,  Ertrag D b* = %.4f g/(l h)\n', DD, bst(DD), DD * bst(DD));
end
xlim([0 1.2]); ylim([-1.5 5.5]); xlabel('Verdünnungsrate D (pro Stunde)'); ylabel('b* (g/l)');
legend('stabil', '', 'instabil', 'Location', 'southwest');
