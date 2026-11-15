% Abb. 4.7: Euler-Verfahren für das Lotka-Volterra-Modell (Buch, Abschnitt 4.1, Gl. 4.7)
% x_{n+1} = x_n + h (r x_n - c x_n y_n),  y_{n+1} = y_n + h (d x_n y_n - e y_n)  mit h = 0.1; die exakte Bahn ist geschlossen
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r = 1; c = 0.5; d = 0.2; e = 1;
f = @(t, z) [r * z(1) - c * z(1) * z(2); d * z(1) * z(2) - e * z(2)];
h = 0.1; N = 160;
x = zeros(1, N + 1); y = zeros(1, N + 1); x(1) = 3; y(1) = 2;
for n = 1:N
    x(n + 1) = x(n) + h * (r * x(n) - c * x(n) * y(n));
    y(n + 1) = y(n) + h * (d * x(n) * y(n) - e * y(n));
end
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[t, z] = ode45(f, linspace(0, 6.5, 651), [3; 2], opt);
H = @(x, y) d * x - e * log(x) + c * y - r * log(y);
fprintf('H exakt (konstant): %.4f\n', H(3, 2));
fprintf('H Euler nach 40, 80, 160 Schritten: %.4f  %.4f  %.4f\n', H(x([41 81 161]), y([41 81 161])));
plot(x, y, '-o', 'Color', [0.89 0.44 0.49], 'MarkerSize', 3); hold on
plot(z(:, 1), z(:, 2), 'Color', [0.43 0.04 0.12], 'LineWidth', 2.5);
plot([3 5], [2 2], 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('Beute x'); ylabel('Räuber y'); legend('Euler, h = 0.1', 'exakt');
