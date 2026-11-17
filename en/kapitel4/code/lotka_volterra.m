% Fig. 4.4: Classical Lotka-Volterra model (book, Section 4.1, Eq. 4.3)
% dx/dt = r x - c x y,  dy/dt = d x y - e y  with r = 1, c = 0.5, d = 0.2, e = 1
% left periodic time courses for x(0) = 3, y(0) = 2, right closed orbits for different initial values
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 1; c = 0.5; d = 0.2; e = 1;
f = @(t, z) [r * z(1) - c * z(1) * z(2); d * z(1) * z(2) - e * z(2)];
H = @(x, y) d * x - e * log(x) + c * y - r * log(y);     % remains constant along every solution
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
subplot(1, 2, 1);
[t, z] = ode45(f, linspace(0, 25, 2501), [3; 2], opt);
plot(t, z(:, 1), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, z(:, 2), 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
xlabel('t'); legend('Prey', 'Predators');
subplot(1, 2, 2); hold on
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; x0s = [4 3 1.5];
for i = 1:3
    [t, z] = ode45(f, linspace(0, 12, 1201), [x0s(i); 2], opt);
    plot(z(:, 1), z(:, 2), 'Color', rot(i, :), 'LineWidth', 2);
    fprintf('x(0) = %g: H at the start %.6f, at the end %.6f\n', x0s(i), H(x0s(i), 2), H(z(end, 1), z(end, 2)));
end
plot(e / d, r / c, 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('Prey x'); ylabel('Predators y');
