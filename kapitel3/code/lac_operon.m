% Abb. 3.18: Genschalter des lac-Operons (Buch, Abschnitt 3.3, Gl. 3.23)
% dX/dt = (a + X^2)/(1 + X^2) - r X mit a = 0.02; links Import und Abbau für r = 0.4, rechts X* in Abhängigkeit von r (Hysterese)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a = 0.02;
imp = @(X) (a + X.^2) ./ (1 + X.^2);
subplot(1, 2, 1);
X = linspace(0, 3, 400); r = 0.4;
plot(X, imp(X), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot(X, r * X, '--', 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
% stationär: (a + X^2) = r X (1 + X^2), also -r X^3 + X^2 - r X + a = 0
xs = sort(real(roots([-r 1 -r a])));
for i = 1:3
    if i == 2, fc = 'w'; else, fc = 'k'; end
    plot(xs(i), r * xs(i), 'ko', 'MarkerFaceColor', fc, 'MarkerSize', 9);
end
hold off
fprintf('r = 0.4: X* = %.3f  %.3f  %.3f  (aus, Schwelle, an)\n', xs);
xlabel('X'); legend('Import (a + X^2)/(1 + X^2)', 'Abbau r X, r = 0.4', 'Location', 'northwest');
% Bifurkationsdiagramm: zu jedem X* gehört r = Import(X*)/X*
subplot(1, 2, 2);
Xs = linspace(0.005, 4, 4000); R = imp(Xs) ./ Xs;
Rk = R; Rk(Xs >= 0.5) = Inf; [~, i1] = min(Rk);          % Umkehrpunkte der Kurve: kleinstes r auf dem unteren Ast,
Rg = R; Rg(Xs <= 0.5 | Xs >= 2) = 0; [~, i2] = max(Rg);  % größtes r auf dem mittleren Ast
gruen = [0 0.39 0];
plot(R(1:i1), Xs(1:i1), 'Color', gruen, 'LineWidth', 3); hold on
plot(R(i1:i2), Xs(i1:i2), '--', 'Color', gruen, 'LineWidth', 2);
plot(R(i2:end), Xs(i2:end), 'Color', gruen, 'LineWidth', 3); hold off
fprintf('bistabil für %.2f < r < %.2f\n', R(i1), R(i2));
xlim([0.1 0.82]); ylim([-0.1 3.2]); xlabel('Abbaurate r'); ylabel('X*');
