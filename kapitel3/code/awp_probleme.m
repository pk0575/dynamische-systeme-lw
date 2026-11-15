% Abb. 3.6: Anfangswertprobleme ohne eindeutige oder ohne globale Lösung (Buch, Abschnitt 3.1)
% links dx/dt = t/x, x(0) = 0: x(t) = t und x(t) = -t lösen beide;  rechts dx/dt = x^2, x(0) = 1: x(t) = 1/(1 - t) nur für t < 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
subplot(1, 2, 1);
t = linspace(0, 2, 100);
plot(t, t, 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, -t, '--', 'Color', [0.89 0.44 0.49], 'LineWidth', 2); plot(0, 0, 'ko', 'MarkerFaceColor', 'k'); hold off
title('dx/dt = t/x, x(0) = 0'); legend('x_1(t) = t', 'x_2(t) = -t'); xlabel('t');
subplot(1, 2, 2);
t = linspace(0, 0.95, 200);
plot(t, 1 ./ (1 - t), 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold on
plot([1 1], [0 20], 'k--'); plot(0, 1, 'ko', 'MarkerFaceColor', 'k'); hold off
ylim([0 20]); xlim([0 1.2]); title('dx/dt = x^2, x(0) = 1'); xlabel('t');
for tt = [0.5 0.9 0.99]
    fprintf('x(%g) = 1/(1 - %g) = %.0f\n', tt, tt, 1 / (1 - tt));
end
