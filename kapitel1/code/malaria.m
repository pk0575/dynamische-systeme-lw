% Abb. 1.3: Malaria-Parasiten nach n Tagen (Buch, Abschnitt 1.1, Gl. 1.2 und 1.3)
% Rekursionsvorschrift x_{n+1} = 8 x_n, x_0 = 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N = 4;                          % Anzahl der Tage
x = zeros(1, N + 1);
x(1) = 1;                       % Startwert x_0 = 1 (MATLAB zählt ab 1: x(1) ist x_0)
for k = 1:N
    x(k + 1) = 8 * x(k);        % Rekursionsvorschrift
end

n = 0:N;
disp(x)                         % 1  8  64  512  4096
disp(8.^n * x(1))               % Lösungsformel x_n = 8^n x_0 liefert dasselbe

rot = [0.64 0.08 0.18];
plot(n, x, 'o--', 'Color', rot, 'MarkerFaceColor', rot); hold on
for k = 1:numel(n)
    text(n(k), x(k) + 100, sprintf('%d', x(k)), 'HorizontalAlignment', 'center', 'Color', rot)
end
hold off
xlabel('n (Tage)'); ylabel('Anzahl Parasiten x_n'); xticks(n)
