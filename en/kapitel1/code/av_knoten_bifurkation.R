# Fig. 1.37: Parameter study and bifurcation diagram of the AV node model (book, Section 1.6, Eq. 1.47)
# V_{n+1} = f(V_n) with V_0 = 1.1, u = 1, V_g = 1, and different values of c
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
Vg <- 1; u <- 1; V0 <- 1.1; N <- 40
f <- function(V, c) c * V + u * (c * V <= Vg)   # c V, plus u if c V <= V_g
n <- 0:N
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15)
paare <- rbind(c(1/3, 2/3), c(0.5001, 0.6), c(0.71, 0.9))
par(mfrow = c(2, 2))
for (p in 1:3) {
  plot(NULL, xlim = c(0, N), ylim = c(0.6, 2.1), xlab = "n", ylab = "V_n")
  for (i in 1:2) {
    c <- paare[p, i]
    V <- numeric(N + 1); V[1] <- V0
    for (k in 1:N) V[k + 1] <- f(V[k], c)
    lines(n, V, type = "o", lty = 2, pch = zeichen[i], cex = 0.6, col = farben[i])
    cat(sprintf("c = %.4g:  V_35 ... V_40 =", c), sprintf("%.3f", V[36:41]), "\n")
  }
  legend("bottomright", legend = sprintf("c = %.4g", paare[p, ]), col = farben, pch = zeichen, lty = 2, cex = 0.8)
}

c <- seq(0.33, 0.999, length.out = 3000)   # bifurcation diagram
V <- rep(V0, length(c))
for (k in 1:10000) V <- f(V, c)
C <- c(); W <- c()
for (k in 1:150) { V <- f(V, c); C <- c(C, c); W <- c(W, V) }
plot(C, W, pch = ".", col = rgb(0, 0.39, 0), xlim = c(0.3, 1), xlab = "c", ylab = "V_n for n > 10000")
