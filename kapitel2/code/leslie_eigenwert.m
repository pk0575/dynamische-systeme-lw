% Abb. 2.13: dominanter Eigenwert des Leslie-Modells in Abhängigkeit von b_2 (Buch, Abschnitt 2.3, Gl. 2.19)
% b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; bei R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, also b_2 = 4.6, ist lambda_1 = 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
b2 = linspace(0, 10, 201);
lam = zeros(size(b2));
for i = 1:numel(b2)
    lam(i) = max(abs(eig([0 b2(i) 9; 0.1 0 0; 0 0.6 0])));
end
fprintf('b_2 mit R = 1: %.2f\n', (1 - 0.54) / 0.1);
fprintf('lambda_1 bei b_2 = 4.6: %.6f\n', max(abs(eig([0 4.6 9; 0.1 0 0; 0 0.6 0]))));

plot(b2, lam, 'Color', [0 0.447 0.741]); hold on
plot([0 10], [1 1], 'k-'); plot([4.6 4.6], [0.75 1.2], 'k:'); hold off
xlabel('b_2'); ylabel('\lambda_1');
