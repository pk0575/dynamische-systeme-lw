% Abb. 1.25: Treppendiagramm zu x_{n+1} = x_n + 0.5 (Buch, Abschnitt 1.4)
% x_0 = 0.25; links ein Schritt, rechts vier Schritte. Der Graph von f schneidet y = x nicht: kein stationärer Zustand.
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
f = @(x) x + 0.5;
x = zeros(1, 5); x(1) = 0.25;
for k = 1:4
    x(k + 1) = f(x(k));
end
fprintf('x_0 ... x_4 = '); fprintf('%g  ', x); fprintf('\n');

rot = [0.64 0.08 0.18];
schrittzahl = [1 4];
for p = 1:2
    s = schrittzahl(p);
    subplot(1, 2, p);
    plot([0 3], [f(0) f(3)], 'Color', [0 0.447 0.741]); hold on
    plot([0 3], [0 3], 'k-');
    px = x(1); py = 0;
    for k = 1:s
        px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
    end
    plot(px, py, 'Color', rot);
    plot(x(1:s), x(2:s + 1), 'o', 'Color', rot, 'MarkerFaceColor', rot);   % Punkte (x_n, x_{n+1})
    hold off; axis equal; axis([0 3 0 3]); xlabel('x'); ylabel('f(x)');
end
