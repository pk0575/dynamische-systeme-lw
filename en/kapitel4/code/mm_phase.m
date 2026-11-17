% Fig. 4.15: Michaelis-Menten system in the ([S], [SE]) plane (book, Section 4.3, Eq. 4.13)
% solution with time marks and the curve d[SE]/dt = 0, i.e. [SE] = [E]tot [S]/([S] + k50); left [E]tot = 0.2 µM, right 0.02 µM
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k1 = 1; k2 = 1e-4; k3 = 0.1;               % rates in 1/(µM s) and 1/s
S0 = 0.5;                                   % µM
k50 = (k2 + k3) / k1;
% z = ([S], [E], [SE], [P]): substrate, enzyme, complex, product
mm = @(t, z) [-k1 * z(1) * z(2) + k2 * z(3); -k1 * z(1) * z(2) + (k2 + k3) * z(3); k1 * z(1) * z(2) - (k2 + k3) * z(3); k3 * z(3)];
opt = odeset('RelTol', 1e-10, 'AbsTol', 1e-13);
opt = odeset('RelTol', 1e-10, 'AbsTol', 1e-14);
E0s = [0.2 0.02]; Ts = [60 600]; marken = [2 10 30; 5 100 300];
for j = 1:2
    E0 = E0s(j);
    [t, z] = ode45(mm, linspace(0, Ts(j), 4001), [S0; E0; 0; 0], opt);
    S = z(:, 1); C = z(:, 3);
    subplot(1, 2, j);
    Sg = linspace(0, 0.52, 300);
    plot(Sg, E0 * Sg ./ (Sg + k50), 'Color', [0 0.447 0.741], 'LineWidth', 2); hold on
    plot(S, C, 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
    for tm = marken(j, :)
        i = find(t >= tm - 1e-9, 1);
        plot(S(i), C(i), 'ko', 'MarkerFaceColor', 'k'); text(S(i) + 0.01, C(i), sprintf('%d s', tm));
        fprintf('[E]tot = %g: t = %3d s: [S] = %.4f, [SE] = %.5f\n', E0, tm, S(i), C(i));
    end
    hold off
    xlabel('[S] (µM)'); ylabel('[SE] (µM)'); ylim([0 E0]); title(sprintf('[E]tot = %g µM', E0));
    legend('d[SE]/dt = 0', 'Solution', 'Location', 'northwest');
end
