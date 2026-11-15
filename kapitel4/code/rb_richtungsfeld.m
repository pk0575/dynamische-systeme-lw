% Abb. 4.3: Richtungsfeld des Räuber-Beute-Modells (Buch, Abschnitt 4.1, Gl. 4.2)
% Pfeile in Richtung (dx/dt, dy/dt), alle gleich lang; dazu die Lösung aus Abb. 4.2 und die stationären Zustände
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r = 1; K = 10; c = 0.5; d = 0.2; e = 1;
f = @(t, z) [r * (1 - z(1) / K) * z(1) - c * z(1) * z(2); d * z(1) * z(2) - e * z(2)];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[X, Y] = meshgrid(linspace(0.4, 10.6, 18), linspace(0.15, 2.85, 10));
U = (r * (1 - X / K) .* X - c * X .* Y) / 11;            % auf die Achsenlängen bezogen, damit alle Pfeile gleich lang sind
V = (d * X .* Y - e * Y) / 3;
L = sqrt(U.^2 + V.^2);
quiver(X, Y, U ./ L * 0.3, V ./ L * 0.3 * 3 / 11, 0, 'Color', [0.2 0.6 0.25]); hold on
[t, z] = ode45(f, linspace(0, 40, 2001), [8; 0.5], opt);
plot(z(:, 1), z(:, 2), 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
plot([0 10], [0 0], 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 9);      % instabil
plot(5, 1, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 9); hold off      % stabil
P = [0 0; 10 0; 5 1];
for i = 1:3
    w = f(0, P(i, :)');
    fprintf('(%2d, %d): dx/dt = %g, dy/dt = %g\n', P(i, 1), P(i, 2), w(1), w(2));
end
xlim([0 11]); ylim([0 3]); xlabel('Beute x'); ylabel('Räuber y');
