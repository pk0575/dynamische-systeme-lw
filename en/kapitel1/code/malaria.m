% Fig. 1.3: Malaria parasites after n days (book, Section 1.1, Eq. 1.2 and 1.3)
% recursion rule x_{n+1} = 8 x_n, x_0 = 1
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N = 4;                          % number of days
x = zeros(1, N + 1);
x(1) = 1;                       % initial value x_0 = 1 (MATLAB counts from 1: x(1) is x_0)
for k = 1:N
    x(k + 1) = 8 * x(k);        % recursion rule
end

n = 0:N;
disp(x)                         % 1  8  64  512  4096
disp(8.^n * x(1))               % solution formula x_n = 8^n x_0 gives the same

rot = [0.64 0.08 0.18];
plot(n, x, 'o--', 'Color', rot, 'MarkerFaceColor', rot); hold on
for k = 1:numel(n)
    text(n(k), x(k) + 100, sprintf('%d', x(k)), 'HorizontalAlignment', 'center', 'Color', rot)
end
hold off
xlabel('n (days)'); ylabel('Number of parasites x_n'); xticks(n)
