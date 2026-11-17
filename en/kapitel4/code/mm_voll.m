% Fig. 4.13: Michaelis-Menten system with all four concentrations (book, Section 4.3, Eq. 4.12)
% k1 = 1, k2 = 1e-4, k3 = 0.1, [S]0 = 0.5 µM, [E]0 = 0.2 µM, [SE]0 = [P]0 = 0
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k1 = 1; k2 = 1e-4; k3 = 0.1;               % rates in 1/(µM s) and 1/s
S0 = 0.5;                                   % µM
k50 = (k2 + k3) / k1;
% z = ([S], [E], [SE], [P]): substrate, enzyme, complex, product
mm = @(t, z) [-k1 * z(1) * z(2) + k2 * z(3); -k1 * z(1) * z(2) + (k2 + k3) * z(3); k1 * z(1) * z(2) - (k2 + k3) * z(3); k3 * z(3)];
opt = odeset('RelTol', 1e-10, 'AbsTol', 1e-13);
E0 = 0.2;
[t, z] = ode45(mm, linspace(0, 60, 3001), [S0; E0; 0; 0], opt);
if max(abs(z(:, 2) + z(:, 3) - E0)) < 1e-12, ok = 'yes'; else, ok = 'no'; end
fprintf('conservation [E] + [SE] = E0 up to rounding errors (< 1e-12): %s\n', ok);
for tt = [5 20 60]
    i = find(t >= tt - 1e-9, 1);
    fprintf('t = %2d s: [S] = %.4f, [E] = %.4f, [SE] = %.4f, [P] = %.4f\n', tt, z(i, :));
end
farben = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49; 0.95 0.70 0.73]; marker = 'osd^';
hold on
for j = 1:4
    plot(t, z(:, j), 'Color', farben(j, :), 'LineWidth', 2);
    plot(t(1:250:end), z(1:250:end, j), marker(j), 'Color', farben(j, :), 'MarkerFaceColor', farben(j, :), 'HandleVisibility', 'off');
end
hold off
xlabel('t (s)'); ylabel('Concentration (µM)'); legend('Substrate [S]', 'Enzyme [E]', 'Complex [SE]', 'Product [P]');
