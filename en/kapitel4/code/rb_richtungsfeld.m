% Fig. 4.3: Direction field of the predator-prey model (book, Section 4.1, Eq. 4.2)
% arrows in the direction (dx/dt, dy/dt), all of equal length; plus the solution from Fig. 4.2 and the steady states
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 1; K = 10; c = 0.5; d = 0.2; e = 1;
f = @(t, z) [r * (1 - z(1) / K) * z(1) - c * z(1) * z(2); d * z(1) * z(2) - e * z(2)];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[X, Y] = meshgrid(linspace(0.4, 10.6, 18), linspace(0.15, 2.85, 10));
U = (r * (1 - X / K) .* X - c * X .* Y) / 11;            % relative to the axis lengths, so that all arrows have equal length
V = (d * X .* Y - e * Y) / 3;
L = sqrt(U.^2 + V.^2);
quiver(X, Y, U ./ L * 0.3, V ./ L * 0.3 * 3 / 11, 0, 'Color', [0.2 0.6 0.25]); hold on
[t, z] = ode45(f, linspace(0, 40, 2001), [8; 0.5], opt);
plot(z(:, 1), z(:, 2), 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
plot([0 10], [0 0], 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 9);      % unstable
plot(5, 1, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 9); hold off      % stable
P = [0 0; 10 0; 5 1];
for i = 1:3
    w = f(0, P(i, :)');
    fprintf('(%2d, %d): dx/dt = %g, dy/dt = %g\n', P(i, 1), P(i, 2), w(1), w(2));
end
xlim([0 11]); ylim([0 3]); xlabel('Prey x'); ylabel('Predators y');
