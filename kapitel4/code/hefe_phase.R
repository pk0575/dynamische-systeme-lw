# Abb. 4.18: Konkurrenzmodell in der Phasenebene (Buch, Abschnitt 4.4, Gl. 4.4)
# Nullklinen y = (1 - x/K1)/g1 und y = K2 (1 - g2 x), stationäre Zustände (gefüllt: stabil, offen: instabil) und die Lösung aus Abb. 4.5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
r1 <- 0.0607; K1 <- 5.8; g1 <- 0.0757      # S. kephir
r2 <- 0.2183; K2 <- 13; g2 <- 0.2423       # S. cerevisiae
f <- function(t, z) c(r1 * (1 - z[1] / K1 - g1 * z[2]) * z[1], r2 * (1 - z[2] / K2 - g2 * z[1]) * z[2])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

xs <- seq(0, 6.5, length.out = 50)
plot(xs, (1 - xs / K1) / g1, type = "l", col = rgb(0, 0.447, 0.741), lwd = 3, xlim = c(0, 6.5), ylim = c(0, 15),
     xlab = "S. kephir x", ylab = "S. cerevisiae y")
lines(xs, K2 * (1 - g2 * xs), col = rgb(0.45, 0.70, 0.90), lwd = 3)
x <- loese(f, c(0.5, 0.5), seq(0, 400, length.out = 4001))
lines(x[, 2], x[, 3], col = rgb(0.64, 0.08, 0.18), lwd = 2); points(0.5, 0.5, pch = 16, col = rgb(0.64, 0.08, 0.18))
for (p in list(c(0, 0), c(0, K2), c(K1, 0))) {
  xx <- p[1]; yy <- p[2]
  J <- matrix(c(r1 * (1 - 2 * xx / K1 - g1 * yy), -r1 * g1 * xx, -r2 * g2 * yy, r2 * (1 - 2 * yy / K2 - g2 * xx)), 2, byrow = TRUE)
  lam <- sort(Re(eigen(J)$values)); stabil <- max(lam) < 0
  points(xx, yy, pch = 21, bg = if (stabil) "black" else "white", cex = 1.3, xpd = TRUE)
  cat(sprintf("(%g, %g): Eigenwerte %.4f  %.4f -> %s\n", xx, yy, lam[1], lam[2], if (stabil) "stabil" else "instabil"))
}
legend("topright", legend = c("dx/dt = 0", "dy/dt = 0"), col = c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90)), lwd = 3)
