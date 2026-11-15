% Abb. 3.17: Ernte mit fester Fangquote (Buch, Abschnitt 3.3)
% dx/dt = r (1 - x/K) x - q mit r = 0.5, K = 100;  stationär bei x* = K/2 (1 ± sqrt(1 - 4q/(rK))), solange q <= rK/4 = 12.5
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r = 0.5; K = 100;
gruen = [0 0.39 0];
subplot(1, 2, 1);
x = linspace(0, 100, 300);
plot(x, r * x .* (1 - x / K), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
qs = [8 12.5 16]; stil = {'-', '--', ':'};
for i = 1:3
    plot([0 100], [qs(i) qs(i)], stil{i}, 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
end
hold off
xlabel('x (1000 t)'); title('Zuwachs r x (1 - x/K) und Fang q'); legend('Zuwachs', 'q = 8', 'q = 12.5', 'q = 16');
subplot(1, 2, 2);
q = linspace(0, 12.5, 300);
w = sqrt(1 - 4 * q / (r * K));
plot(q, K / 2 * (1 + w), 'Color', gruen, 'LineWidth', 3); hold on
plot(q, K / 2 * (1 - w), '--', 'Color', gruen, 'LineWidth', 2); plot(12.5, 50, 'ko', 'MarkerFaceColor', 'k'); hold off
xlim([0 21]); xlabel('Fangquote q (1000 t/Jahr)'); title('Bifurkationsdiagramm');
legend('x_+^* stabil', 'x_-^* instabil', 'Location', 'southeast');
for qq = [8 12.5]
    ww = sqrt(1 - 4 * qq / (r * K));
    fprintf('q = %g: x_- = %.2f,  x_+ = %.2f\n', qq, K / 2 * (1 - ww), K / 2 * (1 + ww));
end
fprintf('größte Fangquote (MSY): q = rK/4 = %g\n', r * K / 4);
