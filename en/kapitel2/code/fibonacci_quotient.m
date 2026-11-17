% Fig. 2.10: Quotient of consecutive Fibonacci numbers (book, Section 2.3, Eq. 2.15)
% system j_{n+1} = e_n, e_{n+1} = e_n + j_n; the quotient e_{n+1}/e_n tends to the dominant eigenvalue (golden ratio)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
A = [0 1;
     1 1];
x = [1; 0];                              % (j_0, e_0): one young pair
e = x(2);
for k = 1:16
    x = A * x;
    e(end + 1) = x(2);
end
q = e(3:end) ./ e(2:end-1);
fprintf('eigenvalues of A: %.6f  %.6f\n', sort(eig(A)));
fprintf('e_{n+1}/e_n: '); fprintf('%.6f  ', q(end-3:end)); fprintf(' golden ratio: %.6f\n', (1 + sqrt(5)) / 2);

n = 1:numel(q);
plot(n, q, '--o', 'Color', [0.64 0.08 0.18]); hold on
plot([1 n(end)], (1 + sqrt(5)) / 2 * [1 1], 'k--'); hold off
xlabel('n'); legend('e_{n+1}/e_n', '\lambda_1 = 1.618');
