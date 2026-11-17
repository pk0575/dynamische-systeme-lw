% Fig. 3.17: Harvesting with a fixed catch quota (book, Section 3.3)
% dx/dt = r (1 - x/K) x - q with r = 0.5, K = 100;  steady at x* = K/2 (1 ± sqrt(1 - 4q/(rK))) as long as q <= rK/4 = 12.5
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
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
xlabel('x (1000 t)'); title('Growth r x (1 - x/K) and catch q'); legend('Growth', 'q = 8', 'q = 12.5', 'q = 16');
subplot(1, 2, 2);
q = linspace(0, 12.5, 300);
w = sqrt(1 - 4 * q / (r * K));
plot(q, K / 2 * (1 + w), 'Color', gruen, 'LineWidth', 3); hold on
plot(q, K / 2 * (1 - w), '--', 'Color', gruen, 'LineWidth', 2); plot(12.5, 50, 'ko', 'MarkerFaceColor', 'k'); hold off
xlim([0 21]); xlabel('Catch quota q (1000 t/year)'); title('bifurcation diagram');
legend('x_+^* stable', 'x_-^* unstable', 'Location', 'southeast');
for qq = [8 12.5]
    ww = sqrt(1 - 4 * qq / (r * K));
    fprintf('q = %g: x_- = %.2f,  x_+ = %.2f\n', qq, K / 2 * (1 - ww), K / 2 * (1 + ww));
end
fprintf('largest catch quota (MSY): q = rK/4 = %g\n', r * K / 4);
