# Fig. 3.20: Euler's method follows the slope of the direction field (book, Section 3.4, Eq. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80, step size h = 20:  T_{n+1} = T_n + h · 0.03 (5 - T_n)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k <- 0.03; Tu <- 5; T0 <- 80; h <- 20
N <- 6
t <- h * (0:N)
T <- numeric(N + 1); T[1] <- T0
for (n in 1:N) T[n + 1] <- T[n] + h * k * (Tu - T[n])
tt <- seq(0, 120, length.out = 300)
plot(tt, Tu + (T0 - Tu) * exp(-k * tt), type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, xaxt = "n", xlab = "t (min)", ylab = "T (°C)")
axis(1, at = t)
lines(t, T, col = rgb(0.2, 0.6, 0.25), lwd = 2)
points(t, T, pch = 16, cex = 1.4, col = rgb(0.89, 0.44, 0.49))
for (n in 1:(N + 1)) cat(sprintf("t = %5.0f: T_n = %6.2f,  exact %6.2f\n", t[n], T[n], Tu + (T0 - Tu) * exp(-k * t[n])))
legend("topright", legend = c("exact solution T(t)", "Tangent segments", "Euler T_n, h = 20"),
       col = c(rgb(0.43, 0.04, 0.12), rgb(0.2, 0.6, 0.25), rgb(0.89, 0.44, 0.49)), lwd = c(2, 2, NA), pch = c(NA, NA, 16))
