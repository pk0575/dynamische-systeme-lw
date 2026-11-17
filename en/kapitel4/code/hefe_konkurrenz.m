% Fig. 4.5: Competition between two yeast species (book, Section 4.1, Eq. 4.4)
% dx/dt = r1 (1 - x/K1 - g1 y) x,  dy/dt = r2 (1 - y/K2 - g2 x) y  with the parameters after Gause, x(0) = y(0) = 0.5
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r1 = 0.0607; K1 = 5.8; g1 = 0.0757;     % S. kephir
r2 = 0.2183; K2 = 13; g2 = 0.2423;      % S. cerevisiae
f = @(t, z) [r1 * (1 - z(1) / K1 - g1 * z(2)) * z(1); r2 * (1 - z(2) / K2 - g2 * z(1)) * z(2)];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[t, z] = ode45(f, linspace(0, 300, 3001), [0.5; 0.5], opt);
x = z(:, 1); y = z(:, 2);
for tt = [50 100 300]
    i = find(t >= tt - 1e-9, 1);
    fprintf('t = %3d h: x = %.3f,  y = %.3f\n', tt, x(i), y(i));
end
[ym, im] = max(y);
fprintf('y reaches its maximum %.3f at t = %.1f h\n', ym, t(im));
plot(t, x, 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, y, 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
xlabel('t (hours)'); ylabel('Yeast volume'); legend('S. kephir x(t)', 'S. cerevisiae y(t)');
