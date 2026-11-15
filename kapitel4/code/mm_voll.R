# Abb. 4.13: Michaelis-Menten-System mit allen vier Konzentrationen (Buch, Abschnitt 4.3, Gl. 4.12)
# k1 = 1, k2 = 1e-4, k3 = 0.1, [S]0 = 0.5 µM, [E]0 = 0.2 µM, [SE]0 = [P]0 = 0
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
k1 <- 1; k2 <- 1e-4; k3 <- 0.1                 # Raten in 1/(µM s) bzw. 1/s
S0 <- 0.5                                      # µM
k50 <- (k2 + k3) / k1
# z = ([S], [E], [SE], [P]): Substrat, Enzym, Komplex, Produkt
mm <- function(t, z) c(-k1 * z[1] * z[2] + k2 * z[3], -k1 * z[1] * z[2] + (k2 + k3) * z[3],
                       k1 * z[1] * z[2] - (k2 + k3) * z[3], k3 * z[3])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-14)

E0 <- 0.2
x <- loese(mm, c(S0, E0, 0, 0), seq(0, 60, length.out = 3001))   # Spalten: Zeit, [S], [E], [SE], [P]
cat("Erhaltung [E] + [SE] = E0 bis auf Rundungsfehler (< 1e-12):", if (max(abs(x[, 3] + x[, 4] - E0)) < 1e-12) "ja" else "nein", "\n")
for (tt in c(5, 20, 60)) {
  i <- which(x[, 1] >= tt - 1e-9)[1]
  cat(sprintf("t = %2d s: [S] = %.4f, [E] = %.4f, [SE] = %.4f, [P] = %.4f\n", tt, x[i, 2], x[i, 3], x[i, 4], x[i, 5]))
}
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49), rgb(0.95, 0.70, 0.73)); zeichen <- c(16, 15, 18, 17)
plot(NULL, xlim = c(0, 60), ylim = c(0, 0.55), xlab = "t (s)", ylab = "Konzentration (µM)")
for (j in 1:4) {
  lines(x[, 1], x[, j + 1], col = farben[j], lwd = 2)
  idx <- seq(1, nrow(x), 250); points(x[idx, 1], x[idx, j + 1], pch = zeichen[j], col = farben[j])
}
legend("right", legend = c("Substrat [S]", "Enzym [E]", "Komplex [SE]", "Produkt [P]"), col = farben, pch = zeichen, lwd = 2)
