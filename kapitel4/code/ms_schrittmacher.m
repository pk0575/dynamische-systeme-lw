% Abb. 4.25: Mitchell-Schaeffer-Modell mit Schrittmacherstrom (Buch, Abschnitt 4.5, Gl. 4.20)
% konstanter Einwärtsstrom J0 > J_c: links periodische Aktionspotentiale für J0 = 0.0022 und 0.003,
% rechts der Grenzzyklus für J0 = 0.0022 mit den Nullklinen (es gibt keinen stationären Zustand mehr)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
hc = 4 * tin / tout;
J = 0.2; dauer = 2; dt = 0.01;
vv = linspace(0, 0.2, 200001);
Jc = -min(vv.^2 .* (1 - vv) / tin - vv / tout);
fprintf('J_c = %.5f\n', Jc);
J0s = [0.0022 0.003]; farben = [0.43 0.04 0.12; 0.89 0.44 0.49];
for j = 1:2
    J0 = J0s(j); T = 3000; reize = [];
    N = round(T / dt); t = dt * (0:N);
    Jt = J0 * ones(1, N + 1);
    for s = reize
        Jt(t >= s - 1e-9 & t < s + dauer - 1e-9) = J0 + J;   % Reiz der Stärke J für 'dauer' ms
    end
    v = zeros(1, N + 1); h = ones(1, N + 1);
    for n = 1:N                                         % Euler-Verfahren
        dv = h(n) * v(n)^2 * (1 - v(n)) / tin - v(n) / tout + Jt(n);
        if v(n) < vgate, dh = (1 - h(n)) / topen; else, dh = -h(n) / tclose; end
        v(n + 1) = v(n) + dt * dv; h(n + 1) = h(n) + dt * dh;
    end
    hoch = t(find(v(1:end-1) < 0.5 & v(2:end) >= 0.5) + 1);   % Beginn jedes Aktionspotentials
    fprintf('J0 = %g: Periode %.0f ms\n', J0, hoch(end) - hoch(end - 1));
    subplot(1, 2, 1); hold on
    m = t >= 400;
    plot(t(m) - 400, v(m), 'Color', farben(j, :), 'LineWidth', 2);
    if j == 1
        subplot(1, 2, 2);
        % Richtungsfeld (Pfeile gleicher Länge) und Nullklinen
        [hg, vg] = meshgrid(linspace(0.05, 1.05, 12), linspace(0.05, 1.0, 11));
        dvg = hg .* vg.^2 .* (1 - vg) / tin - vg / tout + J0;
        dhg = (vg < vgate) .* (1 - hg) / topen - (vg >= vgate) .* hg / tclose;
        L = sqrt(dvg.^2 + dhg.^2);
        quiver(hg, vg, dhg ./ L, dvg ./ L, 0.4, 'Color', [0.2 0.6 0.25]); hold on
        vv = linspace(0.003, 0.997, 2000);
        H = (vv / tout - J0) ./ (vv.^2 .* (1 - vv) / tin);      % dv/dt = 0 nach h aufgelöst
        m = H >= -0.05 & H <= 1.1;
        plot(H(m), vv(m), 'Color', [0 0.447 0.741], 'LineWidth', 2.5);
        if J0 == 0, plot([-0.05 1.1], [0 0], 'Color', [0 0.447 0.741], 'LineWidth', 2.5); end
        plot([1 1], [-0.05 vgate], 'Color', [0.45 0.70 0.90], 'LineWidth', 2.5);
        plot([0 0], [vgate 1.05], 'Color', [0.45 0.70 0.90], 'LineWidth', 2.5);
        m = t >= 1500;
        plot(h(m), v(m), 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold off
        xlim([-0.05 1.1]); ylim([-0.05 1.05]); xlabel('h'); ylabel('v');
    end
end
subplot(1, 2, 1); hold off
xlim([0 2000]); xlabel('t (ms)'); ylabel('v(t)'); legend('J0 = 0.0022', 'J0 = 0.003');
