% Abb. 3.1: vom zeitdiskreten zum kontinuierlichen Wachstum (Buch, Abschnitt 3.1, Gl. 3.1 und 3.2)
% x(t + dt) = (1 + r dt) x(t) mit r = 0.5, x(0) = 1 für dt = 1, 0.5, 0.1; für dt -> 0 entsteht x(t) = e^(r t)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r = 0.5;
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'os^'; dts = [1 0.5 0.1];
hold on
for i = 1:3
    dt = dts(i);
    n = 0:round(4 / dt);
    x = (1 + r * dt).^n;                                 % Lösung der Differenzengleichung
    plot(n * dt, x, marker(i), 'Color', rot(i, :), 'MarkerFaceColor', rot(i, :), 'DisplayName', sprintf('\\Delta t = %g', dt));
    fprintf('dt = %g: x(4) = %.4f\n', dt, x(end));
end
t = linspace(0, 4, 300);
plot(t, exp(r * t), 'Color', rot(1, :), 'LineWidth', 2, 'DisplayName', 'x(t) = e^{rt}'); hold off
fprintf('e^(0.5*4) = %.4f\n', exp(2));
xlabel('t'); ylabel('x'); legend('show', 'Location', 'northwest');
