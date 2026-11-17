% Fig. 5.4: Circulating excitation on a ring (book, Section 5.3, Eq. 5.2)
% Initial state: piece of length L behind the front of a fiber stimulated at its end; L = 100 mm circulates, L = 65 mm dies out
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % parameters in ms
D = 0.1; dx = 0.2; dt = 0.02;                                   % mm^2/ms, mm, ms
% stimulate a long fiber (250 mm) at the left until the front (v > 0.5) is at 200 mm
N = round(250 / dx) + 1; x = dx * (0:N-1); vF = zeros(1, N); hF = ones(1, N); n = 0;
while ~any(vF > 0.5) || max(x(vF > 0.5)) < 200
    lap = [vF(2) - vF(1), vF(3:end) - 2 * vF(2:end-1) + vF(1:end-2), vF(end-1) - vF(end)];
    dv = hF .* vF.^2 .* (1 - vF) / tin - vF / tout + D * lap / dx^2;
    dh = (vF < vgate) .* (1 - hF) / topen - (vF >= vgate) .* hF / tclose;
    vF = vF + dt * dv; hF = hF + dt * dh;
    if n * dt < 2, vF(x <= 1) = vF(x <= 1) + dt * 0.2; end       % stimulus J = 0.2 for 2 ms
    n = n + 1;
end
iF = find(vF > 0.5, 1, 'last');
% rings: length, computing time, picture yes/no
faelle = [100 1500 1; 65 1500 1; 66 800 0; 67 800 0; 68 800 0; 69 800 0; 70 800 0];
for f = 1:size(faelle, 1)
    L = faelle(f, 1); T = faelle(f, 2); M = round(L / dx);
    v = vF(iF-M+1:iF); h = hF(iF-M+1:iF);
    K = round(T / dt); bild = zeros(K / 10, M); akt = []; oben = false; mitte = floor(M / 2) + 1;
    for k = 0:K-1
        if faelle(f, 3) && mod(k, 10) == 0, bild(k / 10 + 1, :) = v; end
        lap = [v(end), v(1:end-1)] - 2 * v + [v(2:end), v(1)];   % ring: neighbors cyclic
        dv = h .* v.^2 .* (1 - v) / tin - v / tout + D * lap / dx^2;
        dh = (v < vgate) .* (1 - h) / topen - (v >= vgate) .* h / tclose;
        v = v + dt * dv; h = h + dt * dh;
        if v(mitte) > 0.5 && ~oben, akt(end + 1) = (k + 1) * dt; oben = true; end
        if v(mitte) < 0.1, oben = false; end
    end
    if max(v) > 0.5, txt = 'circulates'; else, txt = 'dies out'; end
    if faelle(f, 3)
        fprintf('L = %d mm: round-trip times [%s] ms, the excitation %s\n', L, strtrim(sprintf(' %.1f', diff(akt))), txt);
        subplot(1, 2, f);
        imagesc([0 L], [0 T], bild); axis xy; colormap(flipud(hot)); caxis([0 1]);
        title(sprintf('L = %d mm', L)); xlabel('position on the ring (mm)'); ylabel('t (ms)');
    else
        fprintf('L = %d mm: %s\n', L, txt);
    end
end
