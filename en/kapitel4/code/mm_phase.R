# Fig. 4.15: Michaelis-Menten system in the ([S], [SE]) plane (book, Section 4.3, Eq. 4.13)
# solution with time marks and the curve d[SE]/dt = 0, i.e. [SE] = [E]tot [S]/([S] + k50); left [E]tot = 0.2 µM, right 0.02 µM
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
library(deSolve)                         # package deSolve: install.packages("deSolve")
k1 <- 1; k2 <- 1e-4; k3 <- 0.1                 # rates in 1/(µM s) and 1/s
S0 <- 0.5                                      # µM
k50 <- (k2 + k3) / k1
# z = ([S], [E], [SE], [P]): substrate, enzyme, complex, product
mm <- function(t, z) c(-k1 * z[1] * z[2] + k2 * z[3], -k1 * z[1] * z[2] + (k2 + k3) * z[3],
                       k1 * z[1] * z[2] - (k2 + k3) * z[3], k3 * z[3])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-14)

par(mfrow = c(1, 2))
for (fall in list(list(0.2, 60, c(2, 10, 30)), list(0.02, 600, c(5, 100, 300)))) {
  E0 <- fall[[1]]; T <- fall[[2]]
  x <- loese(mm, c(S0, E0, 0, 0), seq(0, T, length.out = 4001))
  Sg <- seq(0, 0.52, length.out = 300)
  plot(Sg, E0 * Sg / (Sg + k50), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, ylim = c(0, E0),
       xlab = "[S] (µM)", ylab = "[SE] (µM)", main = sprintf("[E]tot = %g µM", E0))
  lines(x[, 2], x[, 4], col = rgb(0.64, 0.08, 0.18), lwd = 2)
  for (tm in fall[[3]]) {
    i <- which(x[, 1] >= tm - 1e-9)[1]
    points(x[i, 2], x[i, 4], pch = 16); text(x[i, 2] + 0.01, x[i, 4], sprintf("%d s", tm), adj = 0)
    cat(sprintf("[E]tot = %g: t = %3d s: [S] = %.4f, [SE] = %.5f\n", E0, tm, x[i, 2], x[i, 4]))
  }
  legend("topleft", legend = c("d[SE]/dt = 0", "Solution"), col = c(rgb(0, 0.447, 0.741), rgb(0.64, 0.08, 0.18)), lwd = 2)
}
