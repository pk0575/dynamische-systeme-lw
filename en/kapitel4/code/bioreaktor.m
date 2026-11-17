% Fig. 4.20: Biomass and nutrient in the bioreactor (book, Section 4.4, Eq. 4.17)
% db/dt = K(n) b - D b,  dn/dt = -nu K(n) b - D n + D n_in  with K(n) = kmax n/(k50 + n), D = 0.2, n_in = 10, nu = 2, kmax = 1, k50 = 0.5
% start with b(0) = 0.1 g/l and n(0) = n_in; dashed the steady state n* = D k50/(kmax - D), b* = (n_in - n*)/nu
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
D = 0.2; nin = 10; nu = 2; kmax = 1; k50 = 0.5;      % D in 1/h, concentrations in g/l
K = @(n) kmax * n ./ (k50 + n);                        % Monod growth rate
f = @(t, z) [K(z(2)) * z(1) - D * z(1); -nu * K(z(2)) * z(1) - D * z(2) + D * nin];
opt = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[t, z] = ode45(f, linspace(0, 20, 2001), [0.1; nin], opt);
b = z(:, 1); n = z(:, 2);
ns = D * k50 / (kmax - D); bs = (nin - ns) / nu;
fprintf('steady state: n* = %.4f g/l,  b* = %.4f g/l\n', ns, bs);
[bm, im] = max(b);
fprintf('b(20) = %.4f,  n(20) = %.4f;  largest biomass %.4f at t = %.2f h\n', b(end), n(end), bm, t(im));
subplot(1, 2, 1);
plot([0 20], [bs bs], 'k--'); hold on; plot(t, b, 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold off
xlabel('t (hours)'); ylabel('Biomass b (g/l)');
subplot(1, 2, 2);
plot([0 20], [ns ns], 'k--'); hold on; plot(t, n, 'Color', [0.64 0.08 0.18], 'LineWidth', 2); hold off
xlabel('t (hours)'); ylabel('Nutrient n (g/l)');
