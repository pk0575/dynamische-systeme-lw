% Abb. 3.3: Lösungsschar einer linearen Differentialgleichung (Buch, Abschnitt 3.1, Gl. 3.6 und 3.7)
% dx/dt = a x + b mit a = -0.5, b = 1; Lösungen x(t) = C e^(at) - b/a für verschiedene Startwerte, x* = -b/a = 2
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a = -0.5; b = 1;
xs = -b / a;                                             % konstante Lösung
t = linspace(0, 8, 400);
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49];
x0s = [5 3.5 2.5 1 0];
hold on
for i = 1:5
    C = x0s(i) - xs;
    plot(t, C * exp(a * t) + xs, 'Color', rot(mod(i - 1, 3) + 1, :), 'LineWidth', 2);
    fprintf('x(0) = %g: C = %4.1f, x(8) = %.4f\n', x0s(i), C, C * exp(8 * a) + xs);
end
plot([0 8], [xs xs], 'k', 'LineWidth', 1.5); hold off
xlabel('t'); ylabel('x(t)'); title('schwarz: x* = -b/a = 2');
