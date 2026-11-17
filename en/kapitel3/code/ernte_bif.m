% Fig. 3.16: Fish stock with harvesting, steady states as a function of the harvesting rate (book, Section 3.3)
% dx/dt = r (1 - x/K) x - h x with r = 0.5 per year, K = 100 (1000 t):  x_a* = 0 and x_b* = K (1 - h/r)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 0.5; K = 100;
gruen = [0 0.39 0];
h = linspace(0, 1, 301);
li = h <= r; re = h >= r; nah = h >= r & h <= 0.62;
plot(h(li), 0 * h(li), '--', 'Color', gruen, 'LineWidth', 2); hold on   % x_a* unstable for h < r
plot(h(re), 0 * h(re), 'Color', gruen, 'LineWidth', 3);                % stable for h > r
plot(h(li), K * (1 - h(li) / r), 'Color', gruen, 'LineWidth', 3);      % x_b* stable for h < r
plot(h(nah), K * (1 - h(nah) / r), '--', 'Color', gruen, 'LineWidth', 2);
plot([r r], [-30 105], 'k:'); hold off
for hh = [0.1 0.25 0.4]
    fprintf('h = %g: x_b* = %.0f,  yield h x_b* = %.2f\n', hh, K * (1 - hh / r), hh * K * (1 - hh / r));
end
xlabel('Harvesting rate h (per year)'); ylabel('x* (1000 t)'); ylim([-30 105]);
