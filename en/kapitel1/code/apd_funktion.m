% Fig. 1.40: Update function of the APD model (book, Section 1.6, Eq. 1.49 and 1.50)
% f(APD) = r(m PCL - APD) with m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
DImin = 5;
r = @(DI) 220 - 180 * exp(-DI / 60);
f = @(APD, PCL) r(ceil((APD + DImin) / PCL) * PCL - APD);   % ceil: after how many periods the next stimulus takes effect

APD = linspace(0, 800, 4001);
farben = [0 0.447 0.741; 0.45 0.70 0.90];
PCLliste = {400, [400 220]};
for p = 1:2
    subplot(1, 2, p); hold on
    PCLs = PCLliste{p};
    for i = 1:numel(PCLs)
        y = f(APD, PCLs(i));
        y([false abs(diff(y)) > 20]) = NaN;          % do not connect the jumps
        plot(APD, y, 'Color', farben(i, :), 'DisplayName', sprintf('PCL = %d ms', PCLs(i)));
    end
    hold off; xlabel('APD (ms)'); ylabel('f(APD)'); legend('show', 'Location', 'southwest');
end
disp('jumps at APD = k PCL - DI_min, e.g. 395 and 795 ms for PCL = 400 ms');
