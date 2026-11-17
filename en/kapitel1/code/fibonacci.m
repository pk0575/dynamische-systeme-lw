% Fig. 1.4: Fibonacci sequence (book, Section 1.1, Eq. 1.5 and 1.6)
% x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N = 10;                         % number of months
x = zeros(1, N + 1);
x(1) = 1; x(2) = 1;             % two initial values x_0 and x_1 (MATLAB counts from 1)
for k = 2:N
    x(k + 1) = x(k) + x(k - 1); % recursion rule
end

n = 0:N;
phi = (1 + sqrt(5)) / 2; psi = (1 - sqrt(5)) / 2;
formel = (phi.^(n + 1) - psi.^(n + 1)) / sqrt(5);   % solution formula (Eq. 1.6)
disp(x)                         % 1 1 2 3 5 8 13 21 34 55 89
disp(round(formel))             % the solution formula gives the same numbers

rot = [0.64 0.08 0.18];
plot(n, x, 'o--', 'Color', rot, 'MarkerFaceColor', rot); hold on
for k = 1:numel(n)
    text(n(k), x(k) + 3, sprintf('%d', x(k)), 'HorizontalAlignment', 'center', 'Color', rot)
end
hold off
xlabel('n (months)'); ylabel('Rabbit pairs x_n'); xticks(n)
