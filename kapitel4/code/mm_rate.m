% Abb. 4.14: Michaelis-Menten-Rate (Buch, Abschnitt 4.3, Gl. 4.14)
% K([S]) = kmax [S]/(k50 + [S]) mit kmax = k3 [E]tot = 0.02 µM/s und k50 = (k2 + k3)/k1 ≈ 0.1 µM
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k1 = 1; k2 = 1e-4; k3 = 0.1; Etot = 0.2;
kmax = k3 * Etot; k50 = (k2 + k3) / k1;
fprintf('kmax = %g µM/s,  k50 = %.4f µM\n', kmax, k50);
S = linspace(0, 1, 400);
plot(S, kmax * S ./ (k50 + S), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot([0 1], [kmax kmax], 'k--'); plot([k50 k50 0], [0 kmax / 2 kmax / 2], 'k:'); hold off
xlabel('Substrat [S] (µM)'); ylabel('Rate (µM/s)'); ylim([0 0.024]);
legend('K([S]) = k_{max} [S]/(k_{50} + [S])', 'Location', 'southeast');
