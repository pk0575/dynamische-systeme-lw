% Fig. 2.22: The three scenarios of the ring model seen from above (book, Section 2.5, Eq. 2.34)
% horizontally the cells, vertically the time steps n, color = y1; each oblique track is a traveling wave
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4;
f1 = @(y1, y2) y1.^2 .* exp(y2 - y1) + k;

% resting state: compute a single cell for 180 steps starting from (0.2, c/(1 - a))
y1r = 0.2; y2r = c / (1 - a);
for j = 1:180
    y1neu = f1(y1r, y2r); y2r = a * y2r - b * y1r + c; y1r = y1neu;
end
Z = 50; schritte = 201;
rechts = [2:Z 1]; links = [Z 1:Z-1];                 % neighbors on the ring

namen = 'abc'; nstern = [37 45 41];
weissrot = [linspace(1, 0.43, 64)' linspace(1, 0.04, 64)' linspace(1, 0.12, 64)'];
for sp = 1:3
    n_stoer = nstern(sp);
    Y1 = y1r * ones(schritte + 1, Z); Y2 = y2r * ones(schritte + 1, Z);   % row n+1 = time step n
    Y1(1, 1) = 0.3;                                  % cell 1 starts excited
    for n = 0:schritte-1
        F = f1(Y1(n+1, :), Y2(n+1, :));
        Y1(n+2, :) = (1 - d) * F + d / 2 * (F(rechts) + F(links));
        Y2(n+2, :) = a * Y2(n+1, :) - b * Y1(n+1, :) + c;
        if n + 1 == n_stoer
            Y1(n+2, 36) = 0.3;                       % second stimulation of cell 36
        end
    end
    subplot(1, 3, sp);
    imagesc([1 50], [0 201], Y1, [0 4.2]); axis xy; colormap(weissrot);
    title(sprintf('Scenario %s)', namen(sp))); xlabel('Cell');
    if sp == 1, ylabel('n'); end
    t = find(Y1(101:202, 1) > 1)' + 99;              % time steps n >= 100 with excited cell 1
    s = sprintf('%d, ', t(1:min(6, end)));
    fprintf('Scenario %s): time steps with excited cell 1 from n = 100: [%s]\n', namen(sp), s(1:end-2));
end
colorbar;
