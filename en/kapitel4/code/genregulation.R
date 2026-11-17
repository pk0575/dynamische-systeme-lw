# Fig. 4.22: Gene regulation with activator and repressor (book, Section 4.4, Eq. 4.18)
# dA/dt = k A^2/(A^2 + 10 (1 + 5R)) - A + 0.4,  dR/dt = 0.3 A^2/(A^2 + 10 (1 + 5R)) - 0.2 R  with A(0) = 3, R(0) = 0.2
# left k = 9.5: damped oscillation; right k = 10.5: limit cycle
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
library(deSolve)                         # package deSolve: install.packages("deSolve")
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

t <- seq(0, 400, length.out = 4001)
par(mfrow = c(1, 2))
for (k in c(9.5, 10.5)) {
  f <- function(t, z) c(k * z[1]^2 / (z[1]^2 + 10 * (1 + 5 * z[2])) - z[1] + 0.4,
                        0.3 * z[1]^2 / (z[1]^2 + 10 * (1 + 5 * z[2])) - 0.2 * z[2])
  A <- loese(f, c(3, 0.2), t)[, 2]
  plot(t, A, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, ylim = c(0, 4.8), xlab = "t (min)", ylab = "Activator A", main = sprintf("k = %g", k))
  spaet <- t > 200                       # maxima after the transient
  i <- which(A[2:4000] > A[1:3999] & A[2:4000] > A[3:4001] & spaet[2:4000]) + 1
  schwankung <- max(A[spaet]) - min(A[spaet])
  if (schwankung > 0.01) {
    cat(sprintf("k = %g: variation of A for t > 200: %.3f, period %.1f min\n", k, schwankung, mean(diff(t[i]))))
  } else {
    cat(sprintf("k = %g: variation of A for t > 200: %.3f (steady state)\n", k, schwankung))
  }
}
