% Fig. 1.39: S1-S2 protocol and restitution curve (book, Section 1.6, Eq. 1.48)
% left: periodic stimulation (S1, PCL = 400 ms) is followed by a stimulus S2 after a shorter or longer interval
% right: measured pairs (DI, APD) and restitution curve r(DI) = 220 - 180 exp(-DI/60)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13; vref = 0.1; dt = 0.01;
farben = [0.43 0.04 0.12; 0.89 0.44 0.49];
tS2liste = [300 430];

subplot(1, 2, 1); hold on
for p = 1:2
    tS2 = tS2liste(p);
    reize = [0 400 800 800 + tS2];
    t = 0:dt:1600 - dt; v = zeros(size(t)); vv = 0; h = 1;
    for i = 2:numel(t)
        J = 0.2 * any(reize <= t(i) & t(i) < reize + 2);
        dv = h * vv^2 * (1 - vv) / tin - vv / tout + J;
        if vv < vgate, dh = (1 - h) / topen; else, dh = -h / tclose; end
        vv = vv + dt * dv; h = h + dt * dh; v(i) = vv;
    end
    m = t >= 760;
    plot(t(m) - 800, v(m), 'Color', farben(p, :), 'DisplayName', sprintf('S2 at %d ms', tS2));
    s = sign(v - vref); kreuz = t(find(diff(s) ~= 0)) - 800;
    ende_s1 = kreuz(find(kreuz > 50 & kreuz < tS2, 1));            % end of the last S1 action potential
    ende_s2 = kreuz(find(kreuz > tS2 + 20, 1));                    % end of the S2 action potential
    fprintf('S2 at %d ms:  DI = %.1f ms,  APD = %.1f ms\n', tS2, tS2 - ende_s1, ende_s2 - tS2);
end
plot([-40 800], [vref vref], ':', 'Color', [0.35 0.35 0.35], 'HandleVisibility', 'off');
hold off; xlabel('t (ms)'); ylabel('v'); legend('show');

r = @(DI) 220 - 180 * exp(-DI / 60);
daten = [60 150; 80 178; 100 182; 120 190; 140 198; 160 204; 180 208; ...
         200 214; 220 214; 240 219; 260 212; 280 223];          % (DI, APD) in ms
DI = linspace(50, 300, 300);
subplot(1, 2, 2);
plot(DI, r(DI), 'Color', [0 0.447 0.741]); hold on
plot(daten(:, 1), daten(:, 2), 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('DI (ms)'); ylabel('APD (ms)'); legend('r(DI) = 220 - 180 exp(-DI/60)', 'S1-S2 data', 'Location', 'southeast');
