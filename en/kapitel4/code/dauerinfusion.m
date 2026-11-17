% Fig. 4.12: Continuous infusion (book, Section 4.2, Eq. 4.11)
% dm/dt = -ka m,  db/dt = ka m - ke b + u  with u = 1 mg per hour, m(0) = b(0) = 0:  b(t) = (u/ke)(1 - e^(-ke t)), b* = u/ke = 5
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
ke = 0.2; u = 1;
t = linspace(0, 30, 600);
b = u / ke * (1 - exp(-ke * t));
for tt = [5 10 20 30]
    fprintf('t = %2d h: b = %.3f mg\n', tt, u / ke * (1 - exp(-ke * tt)));
end
plot([0 30], [u / ke u / ke], 'k--'); hold on
plot(t, b, 'Color', [0.64 0.08 0.18], 'LineWidth', 2.5); hold off
xlabel('t (hours)'); ylabel('Drug (mg)'); ylim([0 6]); legend('b* = u/k_e', 'Blood b(t)', 'Location', 'southeast');
