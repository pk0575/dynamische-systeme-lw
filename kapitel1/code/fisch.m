% Abb. 1.1: Fischlänge nach n Jahren (Buch, Abschnitt 1.1, Gl. 1.1)
% explizite Folge x_n = 60 n / (n + 2)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
n = 0:10;                       % n = 0, 1, ..., 10
x = 60 * n ./ (n + 2);          % Formel für das n-te Folgenglied (elementweise ./)

fprintf('%.1f  ', x); fprintf('\n')   % 0.0  20.0  30.0  36.0  40.0  42.9  45.0 ...

rot = [0.64 0.08 0.18];
plot(n, x, 'o--', 'Color', rot, 'MarkerFaceColor', rot); hold on
for k = 1:numel(n)
    text(n(k), x(k) + 1.5, sprintf('%.1f', x(k)), 'HorizontalAlignment', 'center', 'Color', rot)
end
hold off
xlabel('n (Jahre)'); ylabel('Fischlänge x_n (cm)'); ylim([-3 60])
