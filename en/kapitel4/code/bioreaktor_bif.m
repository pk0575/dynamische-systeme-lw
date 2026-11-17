% Fig. 4.21: Washout in the bioreactor (book, Section 4.4, Eq. 4.17)
% steady-state biomass b* = (n_in - D k50/(kmax - D))/nu as a function of D; above D_c = K(n_in) the biomass is washed out
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
D = 0.2; nin = 10; nu = 2; kmax = 1; k50 = 0.5;      % D in 1/h, concentrations in g/l
K = @(n) kmax * n ./ (k50 + n);                        % Monod growth rate
Dc = K(nin);
bst = @(D) (nin - D * k50 ./ (kmax - D)) / nu;
gruen = [0 0.39 0];
Dg = linspace(0.001, 1.2, 600);
D1 = Dg(Dg <= Dc); D2 = Dg(Dg >= Dc & Dg <= 0.985);
plot(D1, bst(D1), 'Color', gruen, 'LineWidth', 3); hold on
plot(D2, bst(D2), '--', 'Color', gruen, 'LineWidth', 2);
plot([0 Dc], [0 0], '--', 'Color', gruen, 'LineWidth', 2);
plot([Dc 1.2], [0 0], 'Color', gruen, 'LineWidth', 3);
plot([Dc Dc], [-1.5 5.5], ':', 'Color', [0.5 0.5 0.5]); plot(D, bst(D), 'ko', 'MarkerFaceColor', 'k'); hold off
fprintf('D_c = K(n_in) = %.4f per hour\n', Dc);
for DD = [0.2 0.5 0.9]
    fprintf('D = %g: b* = %.4f g/l,  yield D b* = %.4f g/(l h)\n', DD, bst(DD), DD * bst(DD));
end
xlim([0 1.2]); ylim([-1.5 5.5]); xlabel('Dilution rate D (per hour)'); ylabel('b* (g/l)');
legend('stable', '', 'unstable', 'Location', 'southwest');
