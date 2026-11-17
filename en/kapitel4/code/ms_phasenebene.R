# Fig. 4.24: Phase plane of the Mitchell-Schaeffer model (book, Section 4.5, Eq. 4.20)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J0,  dh/dt = (1 - h)/topen for v < vgate, -h/tclose otherwise;  J0 = 0
# nullclines, direction field, resting state (1, 0), threshold, and the action potential after a stimulus at t = 1 ms
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

x <- simuliere(500, reize = 1)
vs <- (1 - sqrt(1 - hc)) / 2
cat(sprintf("resting state (h, v) = (1, 0),  threshold (1, %.4f),  peak of the action potential v = %.4f\n", vs, max(x$v)))
cat(sprintf("after 500 ms: (h, v) = (%.4f, %.4f)\n", x$h[length(x$h)], x$v[length(x$v)]))
plot(NULL, xlim = c(-0.05, 1.1), ylim = c(-0.05, 1.05), xlab = "h", ylab = "v")
feld(0); nullklinen(0)
lines(x$h, x$v, col = rgb(0.64, 0.08, 0.18), lwd = 2)
points(1, 0, pch = 16, cex = 1.3); points(1, vs, pch = 21, bg = "white", cex = 1.3)
legend("right", legend = c("dv/dt = 0", "dh/dt = 0", "Action potential"), col = c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90), rgb(0.64, 0.08, 0.18)), lwd = 2)
