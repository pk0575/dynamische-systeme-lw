# Abb. 1.20: Simulation des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.26)
# x_{n+1} = x_n + r (1 - x_n/K) x_n mit K = 5, x_0 = 0.1 und drei Wachstumsraten r; 20 (links) bzw. 50 (rechts) Schritte
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
K <- 5; x0 <- 0.1
raten <- c(0.5, 0.25, 0.1)
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15, 18)
par(mfrow = c(1, 2))
for (N in c(20, 50)) {
  n <- 0:N
  plot(NULL, xlim = c(0, N), ylim = c(0, 5.3), xlab = "n", ylab = "x_n")
  abline(h = K)
  for (i in 1:3) {
    r <- raten[i]
    x <- numeric(N + 1)
    x[1] <- x0                           # R zählt ab 1: x[1] ist x_0
    for (k in 1:N) x[k + 1] <- x[k] + r * (1 - x[k] / K) * x[k]
    lines(n, x, type = "o", lty = 2, pch = zeichen[i], cex = 0.6, col = rot[i])
    cat(sprintf("N = %d, r = %g:  x_N = %.4f\n", N, r, x[N + 1]))
  }
  legend("bottomright", legend = sprintf("r = %g", raten), col = rot, pch = zeichen, lty = 2)
}
