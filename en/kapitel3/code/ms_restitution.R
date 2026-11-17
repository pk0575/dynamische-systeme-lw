# Fig. 3.25: Restitution curve of the Mitchell-Schaeffer model (book, Section 3.5, Eq. 3.33)
# formula r_MS(DI), simulated S1-S2 measurement (three S1 stimuli 400 ms apart, then S2 after the pause DI), and r(DI) from Chapter 1
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

x <- simuliere(500, 0)
d <- durchgaenge(x$t, x$v); apd <- d[2] - d[1]
he <- x$h[which(x$t >= d[2])[1]]                          # h at the end of the action potential
Delta <- apd - tclose * log(1 / hc)
r_ms <- function(DI) Delta + tclose * log((1 - (1 - he) * exp(-DI / topen)) / hc)
r_k1 <- function(DI) 220 - 180 * exp(-DI / 60)
x <- simuliere(1250, c(0, 400, 800))
d <- durchgaenge(x$t, x$v)
ende <- d[d > 805][1]                                     # end of the third action potential
DIs <- c(10, 20, 40, 60, 80, 100, 150, 200, 250, 300)
sim <- sapply(DIs, function(DI) {
  s2 <- ende + DI
  x <- simuliere(s2 + 400, c(0, 400, 800, s2))
  d <- durchgaenge(x$t, x$v); d <- d[d > s2 - 1]
  d[2] - d[1]
})
cat(sprintf("h_e = %.4f,  Delta = %.2f ms\n", he, Delta))
cat("DI:        ", sprintf("%5d", DIs), "\n")
cat("simulation:", sprintf("%5.1f", sim), "\n")
cat("formula:    ", sprintf("%5.1f", r_ms(DIs)), "\n")
DI <- seq(4.8, 300, length.out = 400)
plot(DI, r_ms(DI), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, ylim = c(40, 235), xlab = "DI (ms)", ylab = "APD (ms)")
lines(DI, r_k1(DI), col = rgb(0.45, 0.70, 0.90), lwd = 2)
points(DIs, sim, pch = 16)
legend("bottomright", legend = c("r_MS(DI)", "r(DI) from Chapter 1", "S1-S2 simulation"),
       col = c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90), "black"), lwd = c(2.5, 2, NA), pch = c(NA, NA, 16))
