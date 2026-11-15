# Abb. 2.4: Räuber-Beute-Modell, Räuber und Beute überleben (Buch, Abschnitt 2.1, Gl. 2.3)
# u_{n+1} = (1 + r) u_n - r u_n^2 - gamma u_n v_n,  v_{n+1} = gamma u_n v_n  mit r = 3.1, gamma = 2.1, u_0 = 0.5, v_0 = 0.2
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r <- 3.1; gamma <- 2.1
N <- 40
u <- numeric(N + 1); v <- numeric(N + 1)
u[1] <- 0.5; v[1] <- 0.2                 # R zählt ab 1: u[1] ist u_0
for (k in 1:N) {
  u[k + 1] <- (1 + r) * u[k] - r * u[k]^2 - gamma * u[k] * v[k]
  v[k + 1] <- gamma * u[k] * v[k]
}
cat(sprintf("stationärer Zustand (1/gamma, r(1 - 1/gamma)/gamma) = (%.4f, %.4f)\n", 1/gamma, r * (1 - 1/gamma) / gamma))
cat("u_36 ... u_40 =", sprintf("%.3f", u[37:41]), "\n")

n <- 0:N
par(mfrow = c(1, 2))
plot(n, u, type = "o", lty = 2, pch = 16, col = rgb(0.43, 0.04, 0.12), ylim = range(c(u, v)), xlab = "n", ylab = "")
lines(n, v, type = "o", lty = 2, pch = 15, col = rgb(0.89, 0.44, 0.49))
legend("topright", legend = c("Beute u_n", "Räuber v_n"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), pch = c(16, 15), lty = 2)
hell_dunkel <- colorRampPalette(c(rgb(1, 0.85, 0.85), rgb(0.43, 0.04, 0.12)))(N + 1)   # hell: früh, dunkel: spät
plot(u, v, pch = 16, col = hell_dunkel, xlab = "Beute u_n", ylab = "Räuber v_n")
points(u[1], v[1], pch = 16, cex = 1.5)
