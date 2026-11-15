# Abb. 2.16: Szenario B des SIR-Modells in der Phasenebene (Buch, Abschnitt 2.4, Gl. 2.21)
# Zustände (S_n, I_n), hell: früh, dunkel: spät; Kreuz: stationärer Zustand x_b* = (N/R_0, alpha (N - S*)/(gamma + alpha))
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N <- 100000; alpha <- 0.1; gamma <- 0.1
beta <- 7.6e-6
M <- 80
S <- numeric(M + 1); I <- numeric(M + 1)
S[1] <- 99999; I[1] <- 1
for (k in 1:M) {
  S[k + 1] <- S[k] - beta * S[k] * I[k] + alpha * (N - S[k])
  I[k + 1] <- I[k] + beta * S[k] * I[k] - (gamma + alpha) * I[k]
}
R0 <- beta * N / (gamma + alpha)
Ss <- N / R0; Is <- alpha * (N - Ss) / (gamma + alpha)
cat(sprintf("R_0 = %.1f,  stationärer Zustand x_b*: S* = %.0f, I* = %.0f\n", R0, Ss, Is))
cat(sprintf("(S_80, I_80) = (%.0f, %.0f)\n", S[M + 1], I[M + 1]))

hell_dunkel <- colorRampPalette(c(rgb(1, 0.85, 0.85), rgb(0.43, 0.04, 0.12)))(M + 1)   # hell: früh, dunkel: spät
plot(S, I, type = "l", col = "grey75", xlab = "S_n", ylab = "I_n")
points(S, I, pch = 16, col = hell_dunkel)
points(Ss, Is, pch = 4, cex = 2, lwd = 2)
points(N, 0, pch = 21, bg = "white")     # x_a* = (N, 0): krankheitsfrei
