# Fig. 4.16: Full system and quasi-steady-state approximation (book, Section 4.3, Eq. 4.12 and 4.14)
# d[S]/dt = -kmax [S]/(k50 + [S]) with kmax = k3 [E]tot; left [E]tot = 0.2 µM, right 0.02 µM
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
for (fall in list(c(0.2, 60), c(0.02, 600))) {
  E0 <- fall[1]; T <- fall[2]
  t <- seq(0, T, length.out = 4001)
  voll <- loese(mm, c(S0, E0, 0, 0), t)[, 2]
  kmax <- k3 * E0
  qss <- ode(S0, t, function(t, S, p) list(-kmax * S / (k50 + S)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-13)[, 2]
  cat(sprintf("[E]tot = %g: largest deviation %.4f µM\n", E0, max(abs(voll - qss))))
  plot(t, voll, type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 0.5), xlab = "t (s)", ylab = "Substrate [S] (µM)",
       main = sprintf("[E]tot = %g µM", E0))
  lines(t, qss, col = rgb(0.89, 0.44, 0.49), lwd = 2)
  legend("topright", legend = c("full system", "quasi-steady state"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
}
