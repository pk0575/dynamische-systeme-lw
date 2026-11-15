% Abb. 3.25: Restitutionskurve des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.33)
% Formel r_MS(DI), simulierte S1-S2-Messung (drei S1-Reize im Abstand von 400 ms, dann S2 nach der Pause DI) und r(DI) aus Kapitel 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
hc = 4 * tin / tout;
J = 0.2; dauer = 2; dt = 0.01;

h_fest = false;
T = 500; reize = 0;
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
apd = d(2) - d(1);
he = h(find(t >= d(2), 1));                               % h am Ende des Aktionspotentials
Delta = apd - tclose * log(1 / hc);
r_ms = @(DI) Delta + tclose * log((1 - (1 - he) * exp(-DI / topen)) / hc);
r_k1 = @(DI) 220 - 180 * exp(-DI / 60);
T = 1250; reize = [0 400 800];
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
ende = d(find(d > 805, 1));                               % Ende des dritten Aktionspotentials
DIs = [10 20 40 60 80 100 150 200 250 300]; sim = zeros(size(DIs));
for k = 1:numel(DIs)
    s2 = ende + DIs(k);
    T = s2 + 400; reize = [0 400 800 s2];
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
    d = d(d > s2 - 1);
    sim(k) = d(2) - d(1);
end
fprintf('h_e = %.4f,  Delta = %.2f ms\n', he, Delta);
fprintf('DI:         %s\n', sprintf('%5d  ', DIs));
fprintf('Simulation: %s\n', sprintf('%5.1f  ', sim));
fprintf('Formel:     %s\n', sprintf('%5.1f  ', r_ms(DIs)));
DI = linspace(4.8, 300, 400);
plot(DI, r_ms(DI), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot(DI, r_k1(DI), 'Color', [0.45 0.70 0.90], 'LineWidth', 2);
plot(DIs, sim, 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('DI (ms)'); ylabel('APD (ms)'); ylim([40 235]);
legend('r_{MS}(DI)', 'r(DI) aus Kapitel 1', 'S1-S2-Simulation', 'Location', 'southeast');
