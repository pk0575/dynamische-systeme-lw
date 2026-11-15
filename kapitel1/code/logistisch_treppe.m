% Abb. 1.21: Aktualisierungsfunktion und Treppendiagramm (Buch, Abschnitt 1.3, Gl. 1.30)
% f(y) = a y (1 - y) mit a = 2.5, Startwert y_0 = 0.1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a = 2.5; y0 = 0.1; N = 12;
f = @(y) a * y .* (1 - y);

y = linspace(0, 1, 200);
plot(y, f(y), 'Color', [0 0.447 0.741]); hold on
plot([0 1], [0 1], 'k-');

% Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
yn = y0;
px = yn; py = 0;
for k = 1:N
    yneu = f(yn);
    px = [px yn yneu]; py = [py yneu yneu];
    yn = yneu;
end
plot(px, py, 'Color', [0.64 0.08 0.18]);
fprintf('y_%d = %.6f,  stationärer Zustand 1 - 1/a = %.6f\n', N, yn, 1 - 1/a);

xlabel('y_n'); ylabel('y_{n+1}'); legend('f(y) = a y (1 - y)', 'y_{n+1} = y_n', 'Location', 'northwest');
hold off
