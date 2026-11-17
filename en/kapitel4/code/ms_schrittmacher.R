# Fig. 4.25: Mitchell-Schaeffer model with pacemaker current (book, Section 4.5, Eq. 4.20)
# constant inward current J0 > J_c: left periodic action potentials for J0 = 0.0022 and 0.003,
# right the limit cycle for J0 = 0.0022 with the nullclines (there is no steady state anymore)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # parameters in ms
hc <- 4 * tin / tout

simuliere <- function(T, J0 = 0, reize = c(), J = 0.2, dauer = 2, dt = 0.01) {
  # Euler's method for the Mitchell-Schaeffer model with constant current J0 and stimuli of strength J
  N <- round(T / dt); t <- dt * (0:N)
  Jt <- rep(J0, N + 1)
  for (s in reize) Jt[t >= s - 1e-9 & t < s + dauer - 1e-9] <- J0 + J
  v <- numeric(N + 1); h <- rep(1, N + 1)
  for (n in 1:N) {
    dv <- h[n] * v[n]^2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
    dh <- if (v[n] < vgate) (1 - h[n]) / topen else -h[n] / tclose
    v[n + 1] <- v[n] + dt * dv; h[n + 1] <- h[n] + dt * dh
  }
  list(t = t, v = v, h = h)
}
nullklinen <- function(J0) {
  v <- seq(0.003, 0.997, length.out = 2000)
  H <- (v / tout - J0) / (v^2 * (1 - v) / tin)       # dv/dt = 0 solved for h
  m <- H >= -0.05 & H <= 1.1
  lines(H[m], v[m], col = rgb(0, 0.447, 0.741), lwd = 2.5)
  if (J0 == 0) lines(c(-0.05, 1.1), c(0, 0), col = rgb(0, 0.447, 0.741), lwd = 2.5)
  lines(c(1, 1), c(-0.05, vgate), col = rgb(0.45, 0.70, 0.90), lwd = 2.5); lines(c(0, 0), c(vgate, 1.05), col = rgb(0.45, 0.70, 0.90), lwd = 2.5)
}
feld <- function(J0) {
  g <- expand.grid(h = seq(0.05, 1.05, length.out = 12), v = seq(0.05, 1.0, length.out = 11))
  dv <- g$h * g$v^2 * (1 - g$v) / tin - g$v / tout + J0
  dh <- ifelse(g$v < vgate, (1 - g$h) / topen, -g$h / tclose)
  L <- sqrt(dh^2 + dv^2)
  arrows(g$h, g$v, g$h + dh / L * 0.045, g$v + dv / L * 0.045, length = 0.03, col = rgb(0.2, 0.6, 0.25))
}

vv <- seq(0, 0.2, length.out = 200001)
Jc <- -min(vv^2 * (1 - vv) / tin - vv / tout)
cat(sprintf("J_c = %.5f\n", Jc))
par(mfrow = c(1, 2))
plot(NULL, xlim = c(0, 2000), ylim = c(0, 1), xlab = "t (ms)", ylab = "v(t)")
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49))
J0s <- c(0.0022, 0.003)
for (j in 1:2) {
  x <- simuliere(3000, J0 = J0s[j])
  hoch <- x$t[which(x$v[-length(x$v)] < 0.5 & x$v[-1] >= 0.5) + 1]   # start of each action potential
  cat(sprintf("J0 = %g: period %.0f ms\n", J0s[j], hoch[length(hoch)] - hoch[length(hoch) - 1]))
  m <- x$t >= 400
  lines(x$t[m] - 400, x$v[m], col = farben[j], lwd = 2)
  if (j == 1) zyklus <- x
}
legend("topright", legend = sprintf("J0 = %g", J0s), col = farben, lwd = 2)
plot(NULL, xlim = c(-0.05, 1.1), ylim = c(-0.05, 1.05), xlab = "h", ylab = "v")
feld(0.0022); nullklinen(0.0022)
m <- zyklus$t >= 1500
lines(zyklus$h[m], zyklus$v[m], col = rgb(0.64, 0.08, 0.18), lwd = 2)
