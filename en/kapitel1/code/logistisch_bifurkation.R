# Fig. 1.23: Bifurcation diagram of the logistic growth model (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n): for each value of a, the long-term behavior after n_* = 10000 steps is plotted
# top: 2.8 <= a <= 4;  bottom: detail 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (the pattern recurs)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
gruen <- rgb(0, 0.39, 0)
bereiche <- list(seq(2.8, 4.0, length.out = 2401), seq(3.8538, 3.8541, length.out = 1501))
behalten <- c(200, 6000)
fenster <- rbind(c(0, 1), c(0.494, 0.506))
par(mfrow = c(2, 1))
for (p in 1:2) {
  a <- bereiche[[p]]
  y <- rep(0.9, length(a))               # all parameter values at once (vector)
  for (k in 1:10000) y <- a * y * (1 - y)          # transient
  A <- c(); Y <- c()
  for (k in 1:behalten[p]) {             # collect long-term behavior
    y <- a * y * (1 - y)
    m <- y > fenster[p, 1] & y < fenster[p, 2]
    A <- c(A, a[m]); Y <- c(Y, y[m])
  }
  plot(A, Y, pch = ".", col = gruen, xlab = "a", ylab = "y_n for n > 10000")
}

a <- 3.2; y <- 0.9                       # example a = 3.2: two values alternate (2-cycle)
for (k in 1:10000) y <- a * y * (1 - y)
cat(sprintf("a = 3.2:  2-cycle %.4f <-> %.4f\n", y, a * y * (1 - y)))
