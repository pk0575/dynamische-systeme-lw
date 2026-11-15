% Abb. 1.41: Parameterstudie und Bifurkationsdiagramm zum APD-Modell (Buch, Abschnitt 1.6, Gl. 1.49)
% APD_{n+1} = f(APD_n) mit APD_0 = 150 ms, DI_min = 5 ms und verschiedenen Reizperioden PCL
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
DImin = 5; APD0 = 150; N = 120;
r = @(DI) 220 - 180 * exp(-DI / 60);
f = @(APD, PCL) r(ceil((APD + DImin) ./ PCL) .* PCL - APD);

n = 0:N;
farben = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'osd';
PCLliste = {[400 220 180], 110, 100};
for p = 1:3
    subplot(2, 2, p); hold on
    PCLs = PCLliste{p};
    for i = 1:numel(PCLs)
        A = zeros(1, N + 1); A(1) = APD0;
        for k = 1:N
            A(k + 1) = f(A(k), PCLs(i));
        end
        plot(n, A, ['--' marker(i)], 'Color', farben(i, :), 'MarkerSize', 3, 'DisplayName', sprintf('PCL = %d', PCLs(i)));
        fprintf('PCL = %d ms:  APD_117 ... APD_120 = ', PCLs(i)); fprintf('%.1f  ', A(118:121)); fprintf('\n');
    end
    hold off; xlabel('n'); ylabel('APD_n (ms)'); legend('show', 'Location', 'southeast');
end

PCL = linspace(50, 250, 4000);           % Bifurkationsdiagramm bzgl. PCL
A = APD0 * ones(size(PCL));
for k = 1:10000
    A = f(A, PCL);
end
P = []; W = [];
for k = 1:150
    A = f(A, PCL);
    P = [P PCL]; W = [W A];
end
subplot(2, 2, 4);
plot(P, W, '.', 'Color', [0 0.39 0], 'MarkerSize', 1);
xlabel('PCL (ms)'); ylabel('APD_n (ms) für n > 10000');
