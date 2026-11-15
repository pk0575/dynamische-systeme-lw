% Abb. 1.36: Aktualisierungsfunktion des AV-Knoten-Modells (Buch, Abschnitt 1.6, Gl. 1.47)
% f(V) = c V falls c V > V_g, sonst c V + u;  V_g = 1, u = 1;  links c = 1/3, rechts zusätzlich c = 0.6
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
Vg = 1; u = 1;
farben = [0 0.447 0.741; 0.45 0.70 0.90];
cliste = {1/3, [1/3 0.6]};
for p = 1:2
    subplot(1, 2, p); hold on
    cs = cliste{p};
    for i = 1:numel(cs)
        c = cs(i);
        s = Vg / c;                      % Sprungstelle: c V = V_g
        a = linspace(0, min(s, 4), 200); b = linspace(s, 4, 200);
        plot(a, c * a + u, 'Color', farben(i, :), 'DisplayName', sprintf('c = %.3g', c));
        plot(b, c * b, 'Color', farben(i, :), 'HandleVisibility', 'off');
        plot(s, c * s + u, 'o', 'Color', farben(i, :), 'MarkerFaceColor', farben(i, :), 'HandleVisibility', 'off');
        if p == 2
            fprintf('c = %.3g: Sprungstelle bei V = V_g/c = %.3f\n', c, s);
        end
    end
    hold off; axis([0 4 0 2.7]); xlabel('V'); ylabel('f(V)'); legend('show', 'Location', 'northwest');
end
