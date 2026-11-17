# Fig. 3.23: Fast dynamics of the Mitchell-Schaeffer model (book, Section 3.5, Eq. 3.29 and 3.31)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) with fixed h = 1; left f(v) with rest, threshold, and excited state,
# right response to a 2 ms stimulus below (J = 0.02) and above (J = 0.04) the threshold
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # parameters in ms
hc <- 4 * tin / tout

simuliere <- function(T, reize, J = 0.2, dauer = 2, dt = 0.01, h_fest = FALSE) {
  # Euler's method for the Mitchell-Schaeffer model; stimulus current J for 'dauer' ms from each time in 'reize'
  N <- round(T / dt); t <- dt * (0:N)
  Jt <- numeric(N + 1)
  for (s in reize) Jt[t >= s - 1e-9 & t < s + dauer - 1e-9] <- J
  v <- numeric(N + 1); h <- rep(1, N + 1)
  for (n in 1:N) {
    dv <- h[n] * v[n]^2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
    dh <- if (h_fest) 0 else if (v[n] < vgate) (1 - h[n]) / topen else -h[n] / tclose
    v[n + 1] <- v[n] + dt * dv; h[n + 1] <- h[n] + dt * dh
  }
  list(t = t, v = v, h = h)
}
durchgaenge <- function(t, v, schwelle = 0.1) t[which(diff(sign(v - schwelle)) != 0)]   # start and end of the action potentials

f <- function(v) v^2 * (1 - v) / tin - v / tout
w <- sqrt(1 - hc); vs <- (1 - w) / 2; ve <- (1 + w) / 2   # threshold and excited state
cat(sprintf("h_c = %.2f,  threshold v_s* = %.4f,  excited v_e* = %.4f\n", hc, vs, ve))
par(mfrow = c(1, 2))
v <- seq(-0.05, 1.05, length.out = 500)
plot(v, f(v), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, xlab = "v", ylab = "")
abline(h = 0); points(c(0, ve), c(0, 0), pch = 16); points(vs, 0, pch = 21, bg = "white")
legend("topleft", legend = "f(v), h = 1", col = rgb(0, 0.447, 0.741), lwd = 2.5)
plot(NULL, xlim = c(0, 15), ylim = c(0, 1), xlab = "t (ms)", ylab = "v(t)")
rect(1, -1, 3, 2, col = "grey88", border = NA)
Js <- c(0.02, 0.04); farben <- c(rgb(0.89, 0.44, 0.49), rgb(0.43, 0.04, 0.12))
for (i in 1:2) {
  x <- simuliere(15, 1, J = Js[i], h_fest = TRUE)
  lines(x$t, x$v, col = farben[i], lwd = 2)
  cat(sprintf("J = %g: v(15) = %.3f\n", Js[i], x$v[length(x$v)]))
}
abline(h = vs, lty = 3)
legend("right", legend = sprintf("J = %g", Js), col = farben, lwd = 2)
