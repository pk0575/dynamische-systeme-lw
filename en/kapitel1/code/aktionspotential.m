% Fig. 1.38: Action potentials under periodic stimulation (book, Section 1.6)
% Mitchell-Schaeffer model (two currents), Euler's method with dt = 0.01 ms, stimulus every PCL = 400 ms;
% measured is the time above the reference value 0.1 (action potential duration APD) and below it (diastolic interval DI)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;    % time constants in ms
PCL = 400; T = 2050; dt = 0.01; vref = 0.1;

t = 0:dt:T - dt;
v = zeros(size(t));
vv = 0; h = 1;
for i = 2:numel(t)
    if mod(t(i), PCL) < 2                % stimulus: 2 ms long
        J = 0.2;
    else
        J = 0;
    end
    dv = h * vv^2 * (1 - vv) / tin - vv / tout + J;
    if vv < vgate
        dh = (1 - h) / topen;
    else
        dh = -h / tclose;
    end
    vv = vv + dt * dv;
    h = h + dt * dh;
    v(i) = vv;
end

s = sign(v - vref);                      % crossings of the reference value
kreuz = t(find(diff(s) ~= 0));
auf = kreuz(1:2:end); ab = kreuz(2:2:end);
for k = 1:numel(ab)
    if k < numel(auf)
        fprintf('AP %d:  APD = %6.1f ms,  DI = %6.1f ms\n', k, ab(k) - auf(k), auf(k + 1) - ab(k));
    else
        fprintf('AP %d:  APD = %6.1f ms\n', k, ab(k) - auf(k));
    end
end

plot(t, v, 'Color', [0.64 0.08 0.18]); hold on
plot([0 T], [vref vref], ':', 'Color', [0.35 0.35 0.35]); hold off
xlabel('t (ms)'); ylabel('v (dimensionless)');
