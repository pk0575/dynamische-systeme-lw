# Fig. 5.3: Conduction velocity and coupling (book, Section 5.2, Eq. 5.5)
# simulation of the cable equation for five values of D and the formula c = sqrt(D/(2 tin)) (1 - 3 vs)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # parameters in ms
hc <- 4 * tin / tout
vs <- (1 - sqrt(1 - hc)) / 2                                         # threshold for h = 1
formel <- function(D) sqrt(D / (2 * tin)) * (1 - 3 * vs)

geschwindigkeit <- function(D, dx = 0.1, dt = 0.01, L = 60) {
  # fiber of length L, stimulus at the left end; c from the times at which v reaches 0.5 at 20 and 50 mm
  N <- round(L / dx) + 1; v <- numeric(N); h <- rep(1, N); reiz <- dx * (0:(N - 1)) <= 1; innen <- 2:(N - 1)
  i1 <- round(20 / dx) + 1; i2 <- round(50 / dx) + 1; t1 <- NA; t2 <- NA; n <- 0
  while (is.na(t2)) {
    lap <- c(v[2] - v[1], v[innen + 1] - 2 * v[innen] + v[innen - 1], v[N - 1] - v[N])
    dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
    if (n * dt < 2) dv[reiz] <- dv[reiz] + 0.2
    dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
    v <- v + dt * dv; h <- h + dt * dh; n <- n + 1
    if (is.na(t1) && v[i1] > 0.5) t1 <- n * dt
    if (is.na(t2) && v[i2] > 0.5) t2 <- n * dt
  }
  30 / (t2 - t1)
}

Ds <- c(0.025, 0.05, 0.1, 0.2, 0.4)
cs <- sapply(Ds, geschwindigkeit)
for (k in seq_along(Ds)) cat(sprintf("D = %5.3f:  simulation c = %.4f,  formula c = %.4f mm/ms\n", Ds[k], cs[k], formel(Ds[k])))
Dd <- seq(0, 0.45, length.out = 300)
plot(Dd, formel(Dd), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, ylim = c(0, 0.8), xlab = "D (mm²/ms)", ylab = "c (mm/ms)")
points(Ds, cs, pch = 19, col = rgb(0.64, 0.08, 0.18), cex = 1.5)
legend("bottomright", legend = c("formula", "simulation"), col = c(rgb(0, 0.447, 0.741), rgb(0.64, 0.08, 0.18)), lwd = c(2.5, NA), pch = c(NA, 19))
