% Abb. 1.35: Wann fällt der Wirkstoffspiegel unter 1 mg/l? (Buch, Abschnitt 1.5, Gl. 1.44)
% c(t) = 5 (exp(-0.2 t) - exp(-t)); Newton-Verfahren für g(t) = c(t) - 1 mit Startwert t_0 = 10 h
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
c = @(t) 5 * (exp(-0.2 * t) - exp(-t));
dc = @(t) 5 * (-0.2 * exp(-0.2 * t) + exp(-t));

t = zeros(1, 6); t(1) = 10;
for k = 1:5
    t(k + 1) = t(k) - (c(t(k)) - 1) / dc(t(k));
end
for k = 1:6
    fprintf('t_%d = %.6f h\n', k - 1, t(k));
end

tt = linspace(0, 24, 500);
plot(tt, c(tt), 'Color', [0.64 0.08 0.18]); hold on
plot([0 24], [1 1], 'k-'); plot(t(end), 1, 'ko', 'MarkerFaceColor', 'k');
text(t(end) + 0.5, 1.15, sprintf('t* = %.2f h', t(end)));
hold off; axis([0 24 0 3]); xlabel('Zeit t (h)'); ylabel('c(t) (mg/l)');
