# Abb. 4.10: drei lineare Systeme dx/dt = A x mit x(0) = (1, 3) (Buch, Abschnitt 4.2, Gl. 4.8 und 4.10)
# oben stabiler Knoten A = (-2 1; 1 -2), Mitte stabile Spirale A = (-1 2; -2 -1), unten Zentrum A = (0 -2; 2 0)
# links Zeitverläufe (Lösungsformeln), rechts Phasenebene mit Richtungsfeld
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
namen <- c("stabiler Knoten", "stabile Spirale", "Zentrum")
As <- list(matrix(c(-2, 1, 1, -2), 2, byrow = TRUE), matrix(c(-1, 2, -2, -1), 2, byrow = TRUE), matrix(c(0, -2, 2, 0), 2, byrow = TRUE))
t <- seq(0, 6, length.out = 800)
X1 <- list(2 * exp(-t) - exp(-3 * t), exp(-t) * (cos(2 * t) + 3 * sin(2 * t)), cos(2 * t) - 3 * sin(2 * t))   # Lösungsformeln
X2 <- list(2 * exp(-t) + exp(-3 * t), exp(-t) * (3 * cos(2 * t) - sin(2 * t)), 3 * cos(2 * t) + sin(2 * t))
g <- expand.grid(x1 = seq(-3.6, 3.6, length.out = 15), x2 = seq(-3.6, 3.6, length.out = 15))
par(mfrow = c(3, 2), mar = c(4, 4, 2, 1))
for (z in 1:3) {
  A <- As[[z]]
  lam <- eigen(A)$values; lam <- lam[order(Im(lam), Re(lam))]   # nach Imaginär-, dann Realteil ordnen
  cat(namen[z], ": Eigenwerte ", paste(sprintf("%g%+gi", Re(lam), Im(lam)), collapse = "  "), "\n", sep = "")
  plot(t, X1[[z]], type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(-3.5, 3.5), xlab = "t", ylab = "", main = namen[z])
  lines(t, X2[[z]], col = rgb(0.89, 0.44, 0.49), lwd = 2); abline(h = 0)
  legend("topright", legend = c("x1(t)", "x2(t)"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2, cex = 0.8)
  U <- A[1, 1] * g$x1 + A[1, 2] * g$x2; V <- A[2, 1] * g$x1 + A[2, 2] * g$x2; L <- sqrt(U^2 + V^2) + 1e-12
  plot(NULL, xlim = c(-3.6, 3.6), ylim = c(-3.6, 3.6), asp = 1, xlab = "x1", ylab = "x2")
  arrows(g$x1, g$x2, g$x1 + 0.22 * U / L, g$x2 + 0.22 * V / L, length = 0.03, col = rgb(0.2, 0.6, 0.25))
  lines(X1[[z]], X2[[z]], col = rgb(0.64, 0.08, 0.18), lwd = 2)
  points(1, 3, pch = 16, col = rgb(0.64, 0.08, 0.18)); points(0, 0, pch = 16)
}
