% Fig. 5.3: Conduction velocity and coupling (book, Section 5.2, Eq. 5.5)
% simulation of the cable equation for five values of D and the formula c = sqrt(D/(2 tin)) (1 - 3 vs)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % parameters in ms
hc = 4 * tin / tout;
vs = (1 - sqrt(1 - hc)) / 2;                                    % threshold for h = 1
formel = @(D) sqrt(D / (2 * tin)) * (1 - 3 * vs);
dx = 0.1; dt = 0.01; L = 60;
Ds = [0.025 0.05 0.1 0.2 0.4]; cs = zeros(size(Ds));
for k = 1:numel(Ds)
    D = Ds(k);                                                  % fiber of length L, stimulus at the left end
    N = round(L / dx) + 1; v = zeros(1, N); h = ones(1, N); reiz = dx * (0:N-1) <= 1;
    i1 = round(20 / dx) + 1; i2 = round(50 / dx) + 1; t1 = NaN; t2 = NaN; n = 0;
    while isnan(t2)
        lap = [v(2) - v(1), v(3:end) - 2 * v(2:end-1) + v(1:end-2), v(end-1) - v(end)];
        dv = h .* v.^2 .* (1 - v) / tin - v / tout + D * lap / dx^2;
        if n * dt < 2, dv(reiz) = dv(reiz) + 0.2; end
        dh = (v < vgate) .* (1 - h) / topen - (v >= vgate) .* h / tclose;
        v = v + dt * dv; h = h + dt * dh; n = n + 1;
        if isnan(t1) && v(i1) > 0.5, t1 = n * dt; end
        if isnan(t2) && v(i2) > 0.5, t2 = n * dt; end
    end
    cs(k) = 30 / (t2 - t1);                                     % c from the times at 20 and 50 mm
    fprintf('D = %5.3f:  simulation c = %.4f,  formula c = %.4f mm/ms\n', D, cs(k), formel(D));
end
Dd = linspace(0, 0.45, 300);
plot(Dd, formel(Dd), 'Color', [0 0.447 0.741], 'LineWidth', 2.5); hold on
plot(Ds, cs, 'o', 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18], 'MarkerSize', 8); hold off
xlabel('D (mm^2/ms)'); ylabel('c (mm/ms)'); legend('formula', 'simulation', 'Location', 'southeast');
