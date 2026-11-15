% Abb. 3.16: Fischbestand mit Ernte, stationäre Zustände in Abhängigkeit von der Ernterate (Buch, Abschnitt 3.3)
% dx/dt = r (1 - x/K) x - h x mit r = 0.5 pro Jahr, K = 100 (1000 t):  x_a* = 0 und x_b* = K (1 - h/r)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r = 0.5; K = 100;
gruen = [0 0.39 0];
h = linspace(0, 1, 301);
li = h <= r; re = h >= r; nah = h >= r & h <= 0.62;
plot(h(li), 0 * h(li), '--', 'Color', gruen, 'LineWidth', 2); hold on   % x_a* instabil für h < r
plot(h(re), 0 * h(re), 'Color', gruen, 'LineWidth', 3);                % stabil für h > r
plot(h(li), K * (1 - h(li) / r), 'Color', gruen, 'LineWidth', 3);      % x_b* stabil für h < r
plot(h(nah), K * (1 - h(nah) / r), '--', 'Color', gruen, 'LineWidth', 2);
plot([r r], [-30 105], 'k:'); hold off
for hh = [0.1 0.25 0.4]
    fprintf('h = %g: x_b* = %.0f,  Ertrag h x_b* = %.2f\n', hh, K * (1 - hh / r), hh * K * (1 - hh / r));
end
xlabel('Ernterate h (pro Jahr)'); ylabel('x* (1000 t)'); ylim([-30 105]);
