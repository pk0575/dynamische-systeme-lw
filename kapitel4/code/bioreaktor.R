# Abb. 4.20: Biomasse und Nährstoff im Bioreaktor (Buch, Abschnitt 4.4, Gl. 4.17)
# db/dt = K(n) b - D b,  dn/dt = -nu K(n) b - D n + D n_in  mit K(n) = kmax n/(k50 + n), D = 0.2, n_in = 10, nu = 2, kmax = 1, k50 = 0.5
# Start mit b(0) = 0.1 g/l und n(0) = n_in; gestrichelt der stationäre Zustand n* = D k50/(kmax - D), b* = (n_in - n*)/nu
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
D <- 0.2; nin <- 10; nu <- 2; kmax <- 1; k50 <- 0.5    # D in 1/h, Konzentrationen in g/l
K <- function(n) kmax * n / (k50 + n)                  # Wachstumsrate nach Monod
f <- function(t, z) c(K(z[2]) * z[1] - D * z[1], -nu * K(z[2]) * z[1] - D * z[2] + D * nin)
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

x <- loese(f, c(0.1, nin), seq(0, 20, length.out = 2001))
b <- x[, 2]; n <- x[, 3]
ns <- D * k50 / (kmax - D); bs <- (nin - ns) / nu
cat(sprintf("stationär: n* = %.4f g/l,  b* = %.4f g/l\n", ns, bs))
cat(sprintf("b(20) = %.4f,  n(20) = %.4f;  größte Biomasse %.4f bei t = %.2f h\n", b[length(b)], n[length(n)], max(b), x[which.max(b), 1]))
par(mfrow = c(1, 2))
plot(x[, 1], b, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlab = "t (Stunden)", ylab = "Biomasse b (g/l)"); abline(h = bs, lty = 2)
plot(x[, 1], n, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlab = "t (Stunden)", ylab = "Nährstoff n (g/l)"); abline(h = ns, lty = 2)
