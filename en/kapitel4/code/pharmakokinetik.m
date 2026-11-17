% Fig. 4.9: Drug in stomach and blood (book, Section 4.2, Eq. 4.9)
% dm/dt = -ka m,  db/dt = ka m - ke b  with ka = 1, ke = 0.2 per hour, m(0) = 4, b(0) = 0:  m(t) = 4 e^(-t), b(t) = 5 (e^(-0.2t) - e^(-t))
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
t = linspace(0, 20, 600);
m = 4 * exp(-t);
b = 5 * (exp(-0.2 * t) - exp(-t));
tmax = log(5) / 0.8;                                     % db/dt = 0: e^(-0.2t) = 5 e^(-t)
fprintf('highest level in the blood b = %.3f mg after t = %.3f h\n', 5 * (exp(-0.2 * tmax) - exp(-tmax)), tmax);
A = [-1 0; 1 -0.2];
fprintf('eigenvalues of A: %g  %g\n', sort(eig(A)));
plot(t, m, 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, b, 'Color', [0.89 0.44 0.49], 'LineWidth', 2); hold off
xlabel('t (hours)'); ylabel('Drug (mg)'); legend('Stomach m(t)', 'Blood b(t)');
