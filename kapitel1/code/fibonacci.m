% Abb. 1.4: Fibonacci-Folge (Buch, Abschnitt 1.1, Gl. 1.5 und 1.6)
% x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N = 10;                         % Anzahl der Monate
x = zeros(1, N + 1);
x(1) = 1; x(2) = 1;             % zwei Startwerte x_0 und x_1 (MATLAB zählt ab 1)
for k = 2:N
    x(k + 1) = x(k) + x(k - 1); % Rekursionsvorschrift
end

n = 0:N;
phi = (1 + sqrt(5)) / 2; psi = (1 - sqrt(5)) / 2;
formel = (phi.^(n + 1) - psi.^(n + 1)) / sqrt(5);   % Lösungsformel (Gl. 1.6)
disp(x)                         % 1 1 2 3 5 8 13 21 34 55 89
disp(round(formel))             % Lösungsformel liefert dieselben Zahlen

rot = [0.64 0.08 0.18];
plot(n, x, 'o--', 'Color', rot, 'MarkerFaceColor', rot); hold on
for k = 1:numel(n)
    text(n(k), x(k) + 3, sprintf('%d', x(k)), 'HorizontalAlignment', 'center', 'Color', rot)
end
hold off
xlabel('n (Monate)'); ylabel('Hasenpaare x_n'); xticks(n)
