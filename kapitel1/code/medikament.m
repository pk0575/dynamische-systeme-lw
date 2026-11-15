% Abb. 1.16: Medikamentenspiegel mit täglicher Dosis (Buch, Abschnitt 1.2, Gl. 1.23)
% x_{n+1} = a x_n + b_n, b_n = d falls n durch 24 teilbar, sonst 0;  a = 0.99, d = 0.4, x_0 = 0, n in Stunden
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a = 0.99; d = 0.4; x0 = 0;
N = 504;                                 % 21 Tage
x = zeros(1, N + 1);
x(1) = x0;                               % x(1) ist x_0
for k = 1:N
    n = k - 1;                           % Zeitschritt n
    if mod(n, 24) == 0                   % alle 24 Stunden eine Dosis
        b = d;
    else
        b = 0;
    end
    x(k + 1) = a * x(k) + b;
end

xmax = d / (1 - a^24);                   % Grenzwert der Spitzenwerte
fprintf('x_max = %.4f\n', xmax);
fprintf('Spitzenwert nach 20 Tagen: x_481 = %.4f\n', x(482));

rot = [0.64 0.08 0.18];
enden = [73 N + 1];
for p = 1:2
    subplot(2, 1, p);
    plot(0:enden(p) - 1, x(1:enden(p)), '--o', 'Color', rot, 'MarkerSize', 3); hold on
    plot([0 enden(p) - 1], [xmax xmax], 'k-'); hold off
    xlabel('n (Stunden)'); ylabel('x_n');
end
