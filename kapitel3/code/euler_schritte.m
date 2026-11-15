% Abb. 3.20: das Euler-Verfahren folgt der Steigung des Richtungsfelds (Buch, Abschnitt 3.4, Gl. 3.26)
% dT/dt = 0.03 (5 - T), T(0) = 80, Schrittweite h = 20:  T_{n+1} = T_n + h · 0.03 (5 - T_n)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k = 0.03; Tu = 5; T0 = 80; h = 20;
N = 6;
t = h * (0:N);
T = zeros(1, N + 1); T(1) = T0;
for n = 1:N
    T(n + 1) = T(n) + h * k * (Tu - T(n));
end
tt = linspace(0, 120, 300);
plot(tt, Tu + (T0 - Tu) * exp(-k * tt), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, T, 'Color', [0.2 0.6 0.25], 'LineWidth', 2);
plot(t, T, 'o', 'Color', [0.89 0.44 0.49], 'MarkerFaceColor', [0.89 0.44 0.49], 'MarkerSize', 9); hold off
for n = 1:N + 1
    fprintf('t = %5.0f: T_n = %6.2f,  exakt %6.2f\n', t(n), T(n), Tu + (T0 - Tu) * exp(-k * t(n)));
end
set(gca, 'XTick', t); xlabel('t (min)'); ylabel('T (°C)'); legend('exakte Lösung T(t)', 'Tangentenstücke', 'Euler T_n, h = 20');
