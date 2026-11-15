% Abb. 4.18: Konkurrenzmodell in der Phasenebene (Buch, Abschnitt 4.4, Gl. 4.4)
% Nullklinen y = (1 - x/K1)/g1 und y = K2 (1 - g2 x), stationäre Zustände (gefüllt: stabil, offen: instabil) und die Lösung aus Abb. 4.5
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r1 = 0.0607; K1 = 5.8; g1 = 0.0757;     % S. kephir
r2 = 0.2183; K2 = 13; g2 = 0.2423;      % S. cerevisiae
f = @(t, z) [r1 * (1 - z(1) / K1 - g1 * z(2)) * z(1); r2 * (1 - z(2) / K2 - g2 * z(1)) * z(2)];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
xs = linspace(0, 6.5, 50);
plot(xs, (1 - xs / K1) / g1, 'Color', [0 0.447 0.741], 'LineWidth', 3); hold on
plot(xs, K2 * (1 - g2 * xs), 'Color', [0.45 0.70 0.90], 'LineWidth', 3);
[t, z] = ode45(f, linspace(0, 400, 4001), [0.5; 0.5], opt);
plot(z(:, 1), z(:, 2), 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
plot(0.5, 0.5, 'o', 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18]);
P = [0 0; 0 K2; K1 0];
for i = 1:3
    x = P(i, 1); y = P(i, 2);
    J = [r1 * (1 - 2 * x / K1 - g1 * y), -r1 * g1 * x; -r2 * g2 * y, r2 * (1 - 2 * y / K2 - g2 * x)];
    lam = sort(real(eig(J)));
    if max(lam) < 0, art = 'stabil'; fc = 'k'; else, art = 'instabil'; fc = 'w'; end
    plot(x, y, 'ko', 'MarkerFaceColor', fc, 'MarkerSize', 10);
    fprintf('(%g, %g): Eigenwerte %.4f  %.4f -> %s\n', x, y, lam, art);
end
hold off
xlim([0 6.5]); ylim([0 15]); xlabel('S. kephir x'); ylabel('S. cerevisiae y');
legend('dx/dt = 0', 'dy/dt = 0');
