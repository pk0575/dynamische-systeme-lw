% Abb. 5.5: Entstehung einer Spiralwelle (Buch, Abschnitt 5.4, Gl. 5.6)
% Quadrat 100 mm x 100 mm, Reiz S1 am linken Rand bei t = 0, Reiz S2 in der unteren Hälfte bei t = 380 ms
% Die Rechnung dauert etwa vier Minuten.
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
D = 0.1; dx = 0.25; dt = 0.05; Lq = 100;                        % mm^2/ms, mm, ms, Seitenlänge in mm
N = round(Lq / dx); xs = dx * ((1:N) - 0.5);
[X, Y] = ndgrid(xs, xs);                                        % erster Index: x, zweiter Index: y
S1 = X <= 1; S2 = Y <= Lq / 2;
v = zeros(N); h = ones(N); r = [1 1:N N];                       % r: Indizes mit gespiegeltem Rand (kein Fluss)
zeiten = [100 300 390 450 550 650 800 1000 1200]; bilder = zeros(N, N, 9);
for n = 0:round(1200 / dt)
    t = n * dt;
    j = find(abs(zeiten - t) < 1e-6); if ~isempty(j), bilder(:, :, j) = v; end
    vp = v(r, r);
    lap = vp(3:end, 2:end-1) + vp(1:end-2, 2:end-1) + vp(2:end-1, 3:end) + vp(2:end-1, 1:end-2) - 4 * v;
    dv = h .* v.^2 .* (1 - v) / tin - v / tout + D * lap / dx^2;
    if t < 2, dv(S1) = dv(S1) + 0.2; end                        % Reiz S1
    if t >= 380 && t < 382, dv(S2) = dv(S2) + 0.2; end          % Reiz S2
    dh = (v < vgate) .* (1 - h) / topen - (v >= vgate) .* h / tclose;
    v = v + dt * dv; h = h + dt * dh;
end
for j = 1:9
    B = bilder(:, :, j);
    fprintf('t = %4d ms: Anteil erregt (v > 0.5) = %.3f\n', zeiten(j), mean(B(:) > 0.5));
    subplot(3, 3, j); imagesc(xs, xs, B', [0 1]); axis xy equal tight; title(sprintf('t = %d ms', zeiten(j)));
end
colormap(flipud(hot));
