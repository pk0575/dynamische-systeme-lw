% Fig. 4.17: Nullclines of the predator-prey model (book, Section 4.4, Eq. 4.2)
% x-nullclines: x = 0 and y = (r/c)(1 - x/K);  y-nullclines: y = 0 and x = e/d;  plus direction field and solution
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 1; K = 10; c = 0.5; d = 0.2; e = 1;
f = @(t, z) [r * (1 - z(1) / K) * z(1) - c * z(1) * z(2); d * z(1) * z(2) - e * z(2)];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[X, Y] = meshgrid(linspace(0.4, 10.6, 18), linspace(0.15, 2.85, 10));
U = (r * (1 - X / K) .* X - c * X .* Y) / 11; V = (d * X .* Y - e * Y) / 3; L = sqrt(U.^2 + V.^2);
quiver(X, Y, U ./ L * 0.3, V ./ L * 0.3 * 3 / 11, 0, 'Color', [0.2 0.6 0.25]); hold on
xs = linspace(0, 10, 50);
plot(xs, r / c * (1 - xs / K), 'Color', [0 0.447 0.741], 'LineWidth', 3);
plot([0 0], [0 3], 'Color', [0 0.447 0.741], 'LineWidth', 3);
plot([e / d e / d], [0 3], 'Color', [0.45 0.70 0.90], 'LineWidth', 3);
plot([0 11], [0 0], 'Color', [0.45 0.70 0.90], 'LineWidth', 3);
[t, z] = ode45(f, linspace(0, 40, 2001), [8; 0.5], opt);
plot(z(:, 1), z(:, 2), 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
% Jacobian matrix at the coexistence state (5, 1) and its eigenvalues
xs_ = e / d; ys_ = r / c * (1 - e / (d * K));
J = [r * (1 - 2 * xs_ / K) - c * ys_, -c * xs_; d * ys_, d * xs_ - e];
lam = eig(J); lam = sortrows([imag(lam) real(lam)]);
fprintf('coexistence (%g, %g): trace %g, det %g, eigenvalues %s\n', xs_, ys_, trace(J), det(J), sprintf('%.3f%+.3fi  ', lam(:, [2 1])'));
plot([0 10], [0 0], 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 9); plot(5, 1, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 9); hold off
xlim([0 11]); ylim([0 3]); xlabel('Prey x'); ylabel('Predators y');
legend('', 'dx/dt = 0', '', 'dy/dt = 0', 'Location', 'northeast');
