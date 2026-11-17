% Fig. 3.24: Action potential of the Mitchell-Schaeffer model (book, Section 3.5, Eq. 3.29 and 3.30)
% stimulus at t = 0; left v(t) and h(t), right steady states of v as a function of h and the path of the action potential
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % parameters in ms
hc = 4 * tin / tout;
J = 0.2; dauer = 2; dt = 0.01;

T = 500; reize = 0; h_fest = false;
N = round(T / dt); t = dt * (0:N);
Jt = zeros(1, N + 1);
for s = reize
    Jt(t >= s - 1e-9 & t < s + dauer - 1e-9) = J;  % stimulus current J for 'dauer' ms from each stimulus
end
v = zeros(1, N + 1); h = ones(1, N + 1);
for n = 1:N                                         % Euler's method
    dv = h(n) * v(n)^2 * (1 - v(n)) / tin - v(n) / tout + Jt(n);
    if h_fest, dh = 0;
    elseif v(n) < vgate, dh = (1 - h(n)) / topen;
    else, dh = -h(n) / tclose;
    end
    v(n + 1) = v(n) + dt * dv; h(n + 1) = h(n) + dt * dh;
end
d = t(find(diff(sign(v - 0.1)) ~= 0));              % start and end of the action potentials (v = 0.1)
apd = d(2) - d(1);
tf = tclose * log(1 / hc);
fprintf('APD = %.1f ms,  h = h_c after tclose ln(1/h_c) = %.1f ms\n', apd, tf);
subplot(1, 2, 1);
plot(t, v, 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
plot(t, h, 'Color', [0.89 0.44 0.49], 'LineWidth', 2);
plot([0 500], [hc hc], ':', 'Color', [0.4 0.4 0.4]); plot([tf tf], [0 1], '-.', 'Color', [0.4 0.4 0.4]); hold off
xlabel('t (ms)'); legend('v(t)', 'h(t)');
subplot(1, 2, 2);
gruen = [0 0.39 0];
H = linspace(hc, 1.05, 400); W = sqrt(1 - hc ./ H);
plot(H, (1 + W) / 2, 'Color', gruen, 'LineWidth', 2.5); hold on
plot(H, (1 - W) / 2, '--', 'Color', gruen, 'LineWidth', 2.5);
plot([0 1.05], [0 0], 'Color', gruen, 'LineWidth', 2.5);
plot(h, v, 'Color', [0.64 0.08 0.18], 'LineWidth', 1.5); hold off
xlabel('h'); ylabel('v*'); legend('stable', 'unstable', '', 'Action potential', 'Location', 'east');
