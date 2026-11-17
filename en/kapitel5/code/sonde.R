# Fig. 5.6: An arrhythmia in the model (book, Section 5.4, Eq. 5.6)
# as Fig. 5.5 up to t = 3000 ms; course of v at the point (25, 25) mm, intervals, durations, and diastolic intervals of the action potentials
# The computation takes about ten minutes.
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # parameters in ms
D <- 0.1; dx <- 0.25; dt <- 0.05; Lq <- 100                         # mm^2/ms, mm, ms, side length in mm
N <- round(Lq / dx); xs <- dx * ((1:N) - 0.5)
X <- matrix(xs, N, N); Y <- t(X)
S1 <- X <= 1; S2 <- Y <= Lq / 2
i0 <- floor(25 / dx) + 1                                             # grid point at (25, 25) mm
v <- matrix(0, N, N); h <- matrix(1, N, N)
vor <- c(2:N, N); zur <- c(1, 1:(N - 1))
K <- round(3000 / dt); spur <- numeric(K)
for (n in 0:(K - 1)) {
  t <- n * dt
  lap <- v[vor, ] + v[zur, ] + v[, vor] + v[, zur] - 4 * v
  dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
  if (t < 2) dv[S1] <- dv[S1] + 0.2
  if (t >= 380 && t < 382) dv[S2] <- dv[S2] + 0.2
  dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
  v <- v + dt * dv; h <- h + dt * dh
  spur[n + 1] <- v[i0, i0]
}
ts <- dt * (1:K)
hoch <- function(s) c(FALSE, spur[-1] > s & spur[-K] <= s)
akt <- ts[hoch(0.5)]                                                 # v rises above 0.5
auf <- ts[hoch(0.1)]; ab <- ts[c(FALSE, spur[-1] < 0.1 & spur[-K] >= 0.1)]
m <- min(length(auf), length(ab)); apd <- ab[1:m] - auf[1:m]; di <- auf[-1] - ab[1:(length(auf) - 1)]
abst <- diff(akt)
cat(sprintf("Intervals between the action potentials (ms): [%s]\n", paste(sprintf("%.1f", abst), collapse = " ")))
cat(sprintf("from the 4th interval on: mean %.0f ms,  mean APD %.0f ms,  mean DI %.0f ms\n", mean(abst[-(1:3)]), mean(apd[-(1:4)]), mean(di[-(1:4)])))
plot(ts, spur, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 1.5, xlab = "t (ms)", ylab = "v at (25, 25) mm")
