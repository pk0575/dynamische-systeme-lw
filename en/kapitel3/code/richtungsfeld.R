# Fig. 3.5: Direction field of cooling with some solutions (book, Section 3.1, Eq. 3.3)
# At each point (t, T) a short dash shows the slope dT/dt = 0.03 (5 - T); the solutions follow these slopes
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k <- 0.03; Tu <- 5
g <- expand.grid(t = seq(5, 175, length.out = 18), T = seq(2, 88, length.out = 12))
S <- k * (Tu - g$T)                      # slope dT/dt at each point
dt <- 4 / sqrt(1 + (S * 180 / 90)^2)     # dashes of equal length in the plot
plot(NULL, xlim = c(0, 184), ylim = c(-3, 92), xlab = "t (min)", ylab = "T (°C)")
segments(g$t - dt, g$T - S * dt, g$t + dt, g$T + S * dt, col = rgb(0.2, 0.6, 0.25))
tt <- seq(0, 180, length.out = 300)
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49))
T0s <- c(80, 40, 0)
for (i in 1:3) {
  lines(tt, Tu + (T0s[i] - Tu) * exp(-k * tt), col = rot[i], lwd = 2)
  cat(sprintf("T(0) = %2d: T(60) = %.2f\n", T0s[i], Tu + (T0s[i] - Tu) * exp(-60 * k)))
}
abline(h = Tu, lty = 2)
