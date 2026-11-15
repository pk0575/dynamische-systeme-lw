% Abb. 4.15: Michaelis-Menten-System in der ([S], [SE])-Ebene (Buch, Abschnitt 4.3, Gl. 4.13)
% Lösung mit Zeitmarken und die Kurve d[SE]/dt = 0, also [SE] = [E]tot [S]/([S] + k50); links [E]tot = 0.2 µM, rechts 0.02 µM
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k1 = 1; k2 = 1e-4; k3 = 0.1;               % Raten in 1/(µM s) bzw. 1/s
S0 = 0.5;                                   % µM
k50 = (k2 + k3) / k1;
% z = ([S], [E], [SE], [P]): Substrat, Enzym, Komplex, Produkt
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
    legend('d[SE]/dt = 0', 'Lösung', 'Location', 'northwest');
end
