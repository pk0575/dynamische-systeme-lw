# Fig. 3.15: Solutions of the logistic model for different initial values (book, Section 3.3)
# r = 0.55, K = 210; the steady-state solutions x = 0 and x = K are neither reached nor crossed by any other solution
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r <- 0.55; K <- 210
x <- function(t, x0) x0 * K / (x0 + (K - x0) * exp(-r * t))
t <- seq(0, 20, length.out = 300)
plot(t, 0 * t, type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 3, ylim = c(-10, 320), xlab = "t (h)", ylab = "x(t)")
lines(t, 0 * t + K, col = rgb(0.43, 0.04, 0.12), lwd = 3)
lines(t, x(t, 30), lty = 2, col = rgb(0.64, 0.08, 0.18), lwd = 2)
lines(t, x(t, 300), lty = 2, col = rgb(0.89, 0.44, 0.49), lwd = 2)
for (x0 in c(30, 300)) cat(sprintf("x0 = %d: x(20) = %.3f,  distance to K: %.3f\n", x0, x(20, x0), abs(x(20, x0) - K)))
legend("right", legend = c("x0 = 0 or K", "x0 = 30", "x0 = 300"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)),
       lty = c(1, 2, 2), lwd = c(3, 2, 2))
