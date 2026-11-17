# Fig. 3.21: Euler's method for cooling with different step sizes (book, Section 3.4, Eq. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80; Euler with h = 10 and h = 5 compared with the exact solution
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k <- 0.03; Tu <- 5; T0 <- 80
exakt <- function(t) Tu + (T0 - Tu) * exp(-k * t)
tt <- seq(0, 120, length.out = 300)
plot(tt, exakt(tt), type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, xlab = "t (min)", ylab = "T (°C)")
farben <- c(rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(15, 18)
hs <- c(10, 5)
for (i in 1:2) {
  h <- hs[i]; N <- 120 / h
  t <- h * (0:N); T <- numeric(N + 1); T[1] <- T0
  for (n in 1:N) T[n + 1] <- T[n] + h * k * (Tu - T[n])
  lines(t, T, type = "o", lty = 2, pch = zeichen[i], col = farben[i])
  cat(sprintf("h = %2d: T(60) ≈ %.3f,  error %.3f\n", h, T[60 / h + 1], abs(T[60 / h + 1] - exakt(60))))
}
legend("topright", legend = c("exact", sprintf("Euler, h = %d", hs)), col = c(rgb(0.43, 0.04, 0.12), farben), lty = c(1, 2, 2), pch = c(NA, zeichen))
