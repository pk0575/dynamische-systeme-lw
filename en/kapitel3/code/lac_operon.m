% Fig. 3.18: Gene switch of the lac operon (book, Section 3.3, Eq. 3.23)
% dX/dt = (a + X^2)/(1 + X^2) - r X with a = 0.02; left import and degradation for r = 0.4, right X* as a function of r (hysteresis)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a = 0.02;
imp = @(X) (a + X.^2) ./ (1 + X.^2);
subplot(1, 2, 1);
X = linspace(0, 3, 400); r = 0.4;
plot(X, imp(X), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot(X, r * X, '--', 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
% steady state: (a + X^2) = r X (1 + X^2), i.e. -r X^3 + X^2 - r X + a = 0
xs = sort(real(roots([-r 1 -r a])));
for i = 1:3
    if i == 2, fc = 'w'; else, fc = 'k'; end
    plot(xs(i), r * xs(i), 'ko', 'MarkerFaceColor', fc, 'MarkerSize', 9);
end
hold off
fprintf('r = 0.4: X* = %.3f  %.3f  %.3f  (off, threshold, on)\n', xs);
xlabel('X'); legend('Import (a + X^2)/(1 + X^2)', 'Degradation r X, r = 0.4', 'Location', 'northwest');
% bifurcation diagram: each X* belongs to r = Import(X*)/X*
subplot(1, 2, 2);
Xs = linspace(0.005, 4, 4000); R = imp(Xs) ./ Xs;
Rk = R; Rk(Xs >= 0.5) = Inf; [~, i1] = min(Rk);          % turning points of the curve: smallest r on the lower branch,
Rg = R; Rg(Xs <= 0.5 | Xs >= 2) = 0; [~, i2] = max(Rg);  % largest r on the middle branch
gruen = [0 0.39 0];
plot(R(1:i1), Xs(1:i1), 'Color', gruen, 'LineWidth', 3); hold on
plot(R(i1:i2), Xs(i1:i2), '--', 'Color', gruen, 'LineWidth', 2);
plot(R(i2:end), Xs(i2:end), 'Color', gruen, 'LineWidth', 3); hold off
fprintf('bistable for %.2f < r < %.2f\n', R(i1), R(i2));
xlim([0.1 0.82]); ylim([-0.1 3.2]); xlabel('Degradation rate r'); ylabel('X*');
