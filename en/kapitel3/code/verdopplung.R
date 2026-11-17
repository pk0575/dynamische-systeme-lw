# Fig. 3.10: Growth of E. coli with a doubling time of 20 minutes (book, Section 3.2, Eq. 3.18)
# x(t) = 1000 · 2^(t/20) = 1000 e^(r t) with r = ln(2)/20 per minute
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tV <- 20; x0 <- 1000
r <- log(2) / tV
t <- seq(0, 120, length.out = 300)
plot(t, x0 * exp(r * t), type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2.5, xaxt = "n", xlab = "t (min)", ylab = "cells")
axis(1, at = seq(0, 120, 20))
for (k in 1:6) { lines(c(tV * k, tV * k), c(0, x0 * 2^k), lty = 3, col = "grey50"); points(tV * k, x0 * 2^k, pch = 16) }
cat(sprintf("r = ln(2)/20 = %.5f per minute;  x(120) = %.0f cells\n", r, x0 * exp(r * 120)))
