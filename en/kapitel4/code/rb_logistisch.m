% Fig. 4.2: Continuous predator-prey model (book, Section 4.1, Eq. 4.2)
% dx/dt = r (1 - x/K) x - c x y,  dy/dt = d x y - e y  with r = 1, K = 10, c = 0.5, d = 0.2, e = 1, x(0) = 8, y(0) = 0.5
% left time courses, right the same solution in the phase plane
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 1; K = 10; c = 0.5; d = 0.2; e = 1;
f = @(t, z) [r * (1 - z(1) / K) * z(1) - c * z(1) * z(2); d * z(1) * z(2) - e * z(2)];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
t = linspace(0, 40, 2001);
[t, z] = ode45(f, t, [8; 0.5], opt);                     % row i of z: solution at time t(i)
x = z(:, 1); y = z(:, 2);
for tt = [10 20 40]
    i = find(t >= tt - 1e-9, 1);
    fprintf('t = %2d: x = %.3f,  y = %.3f\n', tt, x(i), y(i));
end
fprintf('steady state (e/d, r/c (1 - e/(d K))) = (%g, %g)\n', e / d, r / c * (1 - e / (d * K)));
subplot(1, 2, 1);
plot(t, x, 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, y, 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
xlabel('t'); legend('Prey x(t)', 'Predators y(t)');
subplot(1, 2, 2);
plot(x, y, 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold on
plot([x(1) 5], [y(1) 1], 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('Prey x'); ylabel('Predators y');
