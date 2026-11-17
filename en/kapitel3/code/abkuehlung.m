% Fig. 3.4: Cooling of a dish in the refrigerator (book, Section 3.1, Eq. 3.3 and 3.12)
% dT/dt = k (T^u - T) with k = 0.03 per minute, T^u = 5 °C, T(0) = 80 °C:  T(t) = 75 e^(-0.03 t) + 5
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k = 0.03; Tu = 5; T0 = 80;
t = linspace(0, 180, 400);
T = Tu + (T0 - Tu) * exp(-k * t);
ts = log((T0 - Tu) / (10 - Tu)) / k;                     % time at which T = 10 °C is reached
fprintf('T = 10 °C after t = ln(15)/k = %.1f min\n', ts);
plot(t, T, 'Color', [0.64 0.08 0.18], 'LineWidth', 2.5); hold on
plot([0 180], [Tu Tu], 'k--');
plot([ts ts], [0 10], ':', 'Color', [0.5 0.5 0.5]); plot(ts, 10, 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('t (min)'); ylabel('T (°C)'); legend('T(t)');
