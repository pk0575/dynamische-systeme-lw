% Abb. 3.23: schnelle Dynamik des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.31)
% dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) mit festem h = 1; links f(v) mit Ruhe, Schwelle und erregtem Zustand,
% rechts Antwort auf einen Reiz der Dauer 2 ms unter (J = 0.02) und über (J = 0.04) der Schwelle
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
hc = 4 * tin / tout;
J = 0.2; dauer = 2; dt = 0.01;

f = @(v) v.^2 .* (1 - v) / tin - v / tout;
w = sqrt(1 - hc); vs = (1 - w) / 2; ve = (1 + w) / 2;    % Schwelle und erregter Zustand
fprintf('h_c = %.2f,  Schwelle v_s* = %.4f,  erregt v_e* = %.4f\n', hc, vs, ve);
subplot(1, 2, 1);
vv = linspace(-0.05, 1.05, 500);
plot(vv, f(vv), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot([-0.05 1.05], [0 0], 'k');
plot([0 ve], [0 0], 'ko', 'MarkerFaceColor', 'k'); plot(vs, 0, 'ko', 'MarkerFaceColor', 'w'); hold off
xlabel('v'); legend('f(v), h = 1', 'Location', 'northwest');
subplot(1, 2, 2);
fill([1 3 3 1], [0 0 1 1], [0.88 0.88 0.88], 'EdgeColor', 'none'); hold on
Js = [0.02 0.04]; farben = [0.89 0.44 0.49; 0.43 0.04 0.12];
for i = 1:2
    J = Js(i); T = 15; reize = 1; h_fest = true;
    N = round(T / dt); t = dt * (0:N);
    Jt = zeros(1, N + 1);
    for s = reize
        Jt(t >= s - 1e-9 & t < s + dauer - 1e-9) = J;  % Reizstrom J für 'dauer' ms ab jedem Reiz
    end
    v = zeros(1, N + 1); h = ones(1, N + 1);
    for n = 1:N                                         % Euler-Verfahren
        dv = h(n) * v(n)^2 * (1 - v(n)) / tin - v(n) / tout + Jt(n);
        if h_fest, dh = 0;
        elseif v(n) < vgate, dh = (1 - h(n)) / topen;
        else, dh = -h(n) / tclose;
        end
        v(n + 1) = v(n) + dt * dv; h(n + 1) = h(n) + dt * dh;
    end
    d = t(find(diff(sign(v - 0.1)) ~= 0));              % Beginn und Ende der Aktionspotentiale (v = 0.1)
    plot(t, v, 'Color', farben(i, :), 'LineWidth', 2);
    fprintf('J = %g: v(15) = %.3f\n', J, v(end));
end
plot([0 15], [vs vs], ':', 'Color', [0.4 0.4 0.4]); hold off
xlabel('t (ms)'); ylabel('v(t)');
