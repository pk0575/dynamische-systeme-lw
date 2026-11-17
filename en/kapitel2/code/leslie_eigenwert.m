% Fig. 2.13: Dominant eigenvalue of the Leslie model as a function of b_2 (book, Section 2.3, Eq. 2.19)
% b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; for R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, i.e. b_2 = 4.6, lambda_1 = 1
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
b2 = linspace(0, 10, 201);
lam = zeros(size(b2));
for i = 1:numel(b2)
    lam(i) = max(abs(eig([0 b2(i) 9; 0.1 0 0; 0 0.6 0])));
end
fprintf('b_2 with R = 1: %.2f\n', (1 - 0.54) / 0.1);
fprintf('lambda_1 at b_2 = 4.6: %.6f\n', max(abs(eig([0 4.6 9; 0.1 0 0; 0 0.6 0]))));

plot(b2, lam, 'Color', [0 0.447 0.741]); hold on
plot([0 10], [1 1], 'k-'); plot([4.6 4.6], [0.75 1.2], 'k:'); hold off
xlabel('b_2'); ylabel('\lambda_1');
