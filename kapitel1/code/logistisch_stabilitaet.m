% Abb. 1.29: stationäre Zustände des logistischen Modells und ihre Stabilität (Buch, Abschnitt 1.4, Gl. 1.35)
% y*_alpha = 0 und y*_beta = 1 - 1/a (durchgezogen stabil, gestrichelt instabil) mit dem Bifurkationsdiagramm
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
blau = [0 0.447 0.741];
a = linspace(3.0, 4.0, 1001);            % Bifurkationsdiagramm (hellgrün) für 3 <= a <= 4
y = 0.5 * ones(size(a));
for k = 1:2000
    y = a .* y .* (1 - y);
end
A = []; Y = [];
for k = 1:300
    y = a .* y .* (1 - y);
    A = [A a]; Y = [Y y];
end
plot(A, Y, '.', 'Color', [0.47 0.71 0.47], 'MarkerSize', 1); hold on

plot([0 1], [0 0], '-', 'Color', blau); plot([1 4], [0 0], '--', 'Color', blau);    % y*_alpha = 0
aa = linspace(0.8, 1, 50);  plot(aa, 1 - 1 ./ aa, '--', 'Color', blau);           % y*_beta = 1 - 1/a
aa = linspace(1, 3, 200);   plot(aa, 1 - 1 ./ aa, '-', 'Color', blau);
aa = linspace(3, 4, 100);   plot(aa, 1 - 1 ./ aa, '--', 'Color', blau);
plot([1 1], [-0.25 1.05], ':', 'Color', [0.6 0.6 0.6]); plot([3 3], [-0.25 1.05], ':', 'Color', [0.6 0.6 0.6]);
hold off; axis([0 4 -0.25 1.05]); xlabel('a'); ylabel('y');
disp('f''(y) = a (1 - 2y):  f''(0) = a, f''(1 - 1/a) = 2 - a');
disp('y*_alpha stabil für a < 1, y*_beta stabil für 1 < a < 3');
