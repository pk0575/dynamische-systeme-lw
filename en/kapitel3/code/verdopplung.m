% Fig. 3.10: Growth of E. coli with a doubling time of 20 minutes (book, Section 3.2, Eq. 3.18)
% x(t) = 1000 · 2^(t/20) = 1000 e^(r t) with r = ln(2)/20 per minute
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tV = 20; x0 = 1000;
r = log(2) / tV;
t = linspace(0, 120, 300);
plot(t, x0 * exp(r * t), 'Color', [0.64 0.08 0.18], 'LineWidth', 2.5); hold on
for k = 1:6
    plot([tV * k tV * k], [0 x0 * 2^k], ':', 'Color', [0.5 0.5 0.5]); plot(tV * k, x0 * 2^k, 'ko', 'MarkerFaceColor', 'k');
end
hold off
fprintf('r = ln(2)/20 = %.5f per minute;  x(120) = %.0f cells\n', r, x0 * exp(r * 120));
xlabel('t (min)'); ylabel('cells'); set(gca, 'XTick', 0:20:120);
