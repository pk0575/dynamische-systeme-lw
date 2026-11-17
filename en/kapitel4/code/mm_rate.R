# Fig. 4.14: Michaelis-Menten rate (book, Section 4.3, Eq. 4.14)
# K([S]) = kmax [S]/(k50 + [S]) with kmax = k3 [E]tot = 0.02 µM/s and k50 = (k2 + k3)/k1 ≈ 0.1 µM
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k1 <- 1; k2 <- 1e-4; k3 <- 0.1; Etot <- 0.2
kmax <- k3 * Etot; k50 <- (k2 + k3) / k1
cat(sprintf("kmax = %g µM/s,  k50 = %.4f µM\n", kmax, k50))
S <- seq(0, 1, length.out = 400)
plot(S, kmax * S / (k50 + S), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, ylim = c(0, 0.024), xlab = "Substrate [S] (µM)", ylab = "Rate (µM/s)")
abline(h = kmax, lty = 2); lines(c(k50, k50, 0), c(0, kmax / 2, kmax / 2), lty = 3)
legend("bottomright", legend = "K([S]) = kmax [S]/(k50 + [S])", col = rgb(0, 0.447, 0.741), lwd = 2.5)
