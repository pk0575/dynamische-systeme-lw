% Abb. 4.22: Genregulation mit Aktivator und Repressor (Buch, Abschnitt 4.4, Gl. 4.18)
% dA/dt = k A^2/(A^2 + 10 (1 + 5R)) - A + 0.4,  dR/dt = 0.3 A^2/(A^2 + 10 (1 + 5R)) - 0.2 R  mit A(0) = 3, R(0) = 0.2
% links k = 9.5: gedämpfte Schwingung; rechts k = 10.5: Grenzzyklus
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
ks = [9.5 10.5];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
t = linspace(0, 400, 4001)';
for j = 1:2
    k = ks(j);
    f = @(t, z) [k * z(1)^2 / (z(1)^2 + 10 * (1 + 5 * z(2))) - z(1) + 0.4;
                 0.3 * z(1)^2 / (z(1)^2 + 10 * (1 + 5 * z(2))) - 0.2 * z(2)];
    [t, z] = ode45(f, t, [3; 0.2], opt);
    A = z(:, 1);
    subplot(1, 2, j);
    plot(t, A, 'Color', [0.64 0.08 0.18], 'LineWidth', 2); title(sprintf('k = %g', k)); xlabel('t (min)');
    if j == 1, ylabel('Aktivator A'); end
    spaet = t > 200;                                     % Maxima nach dem Einschwingen
    i = find(A(2:end-1) > A(1:end-2) & A(2:end-1) > A(3:end) & spaet(2:end-1)) + 1;
    schwankung = max(A(spaet)) - min(A(spaet));
    if schwankung > 0.01
        fprintf('k = %g: Schwankung von A für t > 200: %.3f, Periode %.1f min\n', k, schwankung, mean(diff(t(i))));
    else
        fprintf('k = %g: Schwankung von A für t > 200: %.3f (stationärer Zustand)\n', k, schwankung);
    end
end
