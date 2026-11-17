% Fig. 4.16: Full system and quasi-steady-state approximation (book, Section 4.3, Eq. 4.12 and 4.14)
% d[S]/dt = -kmax [S]/(k50 + [S]) with kmax = k3 [E]tot; left [E]tot = 0.2 µM, right 0.02 µM
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k1 = 1; k2 = 1e-4; k3 = 0.1;               % rates in 1/(µM s) and 1/s
S0 = 0.5;                                   % µM
k50 = (k2 + k3) / k1;
% z = ([S], [E], [SE], [P]): substrate, enzyme, complex, product
mm = @(t, z) [-k1 * z(1) * z(2) + k2 * z(3); -k1 * z(1) * z(2) + (k2 + k3) * z(3); k1 * z(1) * z(2) - (k2 + k3) * z(3); k3 * z(3)];
opt = odeset('RelTol', 1e-10, 'AbsTol', 1e-13);
opt = odeset('RelTol', 1e-10, 'AbsTol', 1e-14);
E0s = [0.2 0.02]; Ts = [60 600];
for j = 1:2
    E0 = E0s(j); T = Ts(j);
    [t, z] = ode45(mm, linspace(0, T, 4001), [S0; E0; 0; 0], opt);
    kmax = k3 * E0;
    [t, q] = ode45(@(t, S) -kmax * S / (k50 + S), t, S0, odeset('RelTol', 1e-10, 'AbsTol', 1e-13));
    fprintf('[E]tot = %g: largest deviation %.4f µM\n', E0, max(abs(z(:, 1) - q)));
    subplot(1, 2, j);
    plot(t, z(:, 1), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
    plot(t, q, 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
    xlabel('t (s)'); ylabel('Substrate [S] (µM)'); title(sprintf('[E]tot = %g µM', E0)); legend('full system', 'quasi-steady state');
end
