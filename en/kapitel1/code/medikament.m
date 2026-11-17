% Fig. 1.16: Drug level with a daily dose (book, Section 1.2, Eq. 1.23)
% x_{n+1} = a x_n + b_n, b_n = d if n is divisible by 24, otherwise 0;  a = 0.99, d = 0.4, x_0 = 0, n in hours
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a = 0.99; d = 0.4; x0 = 0;
N = 504;                                 % 21 days
x = zeros(1, N + 1);
x(1) = x0;                               % x(1) is x_0
for k = 1:N
    n = k - 1;                           % time step n
    if mod(n, 24) == 0                   % one dose every 24 hours
        b = d;
    else
        b = 0;
    end
    x(k + 1) = a * x(k) + b;
end

xmax = d / (1 - a^24);                   % limit of the peak values
fprintf('x_max = %.4f\n', xmax);
fprintf('peak value after 20 days: x_481 = %.4f\n', x(482));

rot = [0.64 0.08 0.18];
enden = [73 N + 1];
for p = 1:2
    subplot(2, 1, p);
    plot(0:enden(p) - 1, x(1:enden(p)), '--o', 'Color', rot, 'MarkerSize', 3); hold on
    plot([0 enden(p) - 1], [xmax xmax], 'k-'); hold off
    xlabel('n (hours)'); ylabel('x_n');
end
