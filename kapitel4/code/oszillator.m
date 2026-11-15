% Abb. 4.6: gedämpfter Oszillator (Buch, Abschnitt 4.1, Gl. 4.5 und 4.6)
% m x'' + mu x' + k x = 0 als System dx1/dt = x2, dx2/dt = -(k x1 + mu x2)/m  mit m = 1, mu = 0.4, k = 4, x1(0) = 1, x2(0) = 0
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
m = 1; mu = 0.4; k = 4;
f = @(t, z) [z(2); -(k * z(1) + mu * z(2)) / m];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[t, z] = ode45(f, linspace(0, 20, 2001), [1; 0], opt);
x1 = z(:, 1); x2 = z(:, 2);
for tt = [5 10 20]
    i = find(t >= tt - 1e-9, 1);
    fprintf('t = %2d: x1 = %7.4f,  x2 = %7.4f\n', tt, x1(i), x2(i));
end
subplot(1, 2, 1);
plot([0 20], [0 0], 'k'); hold on
plot(t, x1, 'Color', [0.43 0.04 0.12], 'LineWidth', 2);
plot(t, x2, 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
xlabel('t'); legend('', 'Ort x1', 'Geschwindigkeit x2');
subplot(1, 2, 2);
plot(x1, x2, 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold on
plot([1 0], [0 0], 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('Ort x1'); ylabel('Geschwindigkeit x2');
