% Abb. 3.10: Wachstum von E. coli mit der Verdopplungszeit 20 Minuten (Buch, Abschnitt 3.2, Gl. 3.18)
% x(t) = 1000 · 2^(t/20) = 1000 e^(r t) mit r = ln(2)/20 pro Minute
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tV = 20; x0 = 1000;
r = log(2) / tV;
t = linspace(0, 120, 300);
plot(t, x0 * exp(r * t), 'Color', [0.64 0.08 0.18], 'LineWidth', 2.5); hold on
for k = 1:6
    plot([tV * k tV * k], [0 x0 * 2^k], ':', 'Color', [0.5 0.5 0.5]); plot(tV * k, x0 * 2^k, 'ko', 'MarkerFaceColor', 'k');
end
hold off
fprintf('r = ln(2)/20 = %.5f pro Minute;  x(120) = %.0f Zellen\n', r, x0 * exp(r * 120));
xlabel('t (min)'); ylabel('Zellen'); set(gca, 'XTick', 0:20:120);
