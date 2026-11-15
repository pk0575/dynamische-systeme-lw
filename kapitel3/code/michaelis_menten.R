# Abb. 3.19: Michaelis-Menten-Kinetik, Näherungslösung mit dem Euler-Verfahren (Buch, Abschnitt 3.4, Gl. 3.24 und 3.26)
# dS/dt = -kmax S/(k50 + S) mit kmax = 0.5, k50 = 1, S(0) = 2; Euler-Verfahren S_{n+1} = S_n + h f(S_n) mit h = 0.01
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
kmax <- 0.5; k50 <- 1
f <- function(S) -kmax * S / (k50 + S)
h <- 0.01; T <- 10
N <- round(T / h)
t <- h * (0:N)
S <- numeric(N + 1); S[1] <- 2
for (n in 1:N) S[n + 1] <- S[n] + h * f(S[n])        # ein Euler-Schritt
for (tt in c(2, 5, 10)) cat(sprintf("S(%2d) ≈ %.4f\n", tt, S[round(tt / h) + 1]))
plot(t, S, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2.5, ylim = c(0, 2.1), xlab = "t", ylab = "S(t)")
