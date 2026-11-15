# Abb. 4.16: volles System und quasistationäre Näherung (Buch, Abschnitt 4.3, Gl. 4.12 und 4.14)
# d[S]/dt = -kmax [S]/(k50 + [S]) mit kmax = k3 [E]tot; links [E]tot = 0.2 µM, rechts 0.02 µM
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
k1 <- 1; k2 <- 1e-4; k3 <- 0.1                 # Raten in 1/(µM s) bzw. 1/s
S0 <- 0.5                                      # µM
k50 <- (k2 + k3) / k1
# z = ([S], [E], [SE], [P]): Substrat, Enzym, Komplex, Produkt
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
  cat(sprintf("[E]tot = %g: größte Abweichung %.4f µM\n", E0, max(abs(voll - qss))))
  plot(t, voll, type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 0.5), xlab = "t (s)", ylab = "Substrat [S] (µM)",
       main = sprintf("[E]tot = %g µM", E0))
  lines(t, qss, col = rgb(0.89, 0.44, 0.49), lwd = 2)
  legend("topright", legend = c("volles System", "quasistationär"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
}
