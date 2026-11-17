# Fig. 3.18: Gene switch of the lac operon (book, Section 3.3, Eq. 3.23)
# dX/dt = (a + X^2)/(1 + X^2) - r X with a = 0.02; left import and degradation for r = 0.4, right X* as a function of r (hysteresis)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a <- 0.02
imp <- function(X) (a + X^2) / (1 + X^2)
par(mfrow = c(1, 2))
X <- seq(0, 3, length.out = 400); r <- 0.4
plot(X, imp(X), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, ylim = c(0, 1.25), xlab = "X", ylab = "")
lines(X, r * X, lty = 2, col = rgb(0.64, 0.08, 0.18), lwd = 2)
# steady state: (a + X^2) = r X (1 + X^2), i.e. -r X^3 + X^2 - r X + a = 0 (polyroot: coefficients in ascending order)
xs <- sort(Re(polyroot(c(a, -r, 1, -r))))
points(xs, r * xs, pch = 21, bg = c("black", "white", "black"), cex = 1.3)
cat("r = 0.4: X* =", sprintf("%.3f", xs), " (off, threshold, on)\n")
legend("topleft", legend = c("Import (a + X^2)/(1 + X^2)", "Degradation r X, r = 0.4"), col = c(rgb(0, 0.447, 0.741), rgb(0.64, 0.08, 0.18)), lty = 1:2, lwd = 2, cex = 0.8)
# bifurcation diagram: each X* belongs to r = Import(X*)/X*
Xs <- seq(0.005, 4, length.out = 4000); R <- imp(Xs) / Xs
i1 <- which.min(ifelse(Xs < 0.5, R, Inf))              # turning points of the curve: smallest r on the lower branch,
i2 <- which.max(ifelse(Xs > 0.5 & Xs < 2, R, 0))       # largest r on the middle branch
gruen <- rgb(0, 0.39, 0)
plot(R[1:i1], Xs[1:i1], type = "l", col = gruen, lwd = 3, xlim = c(0.1, 0.82), ylim = c(-0.1, 3.2), xlab = "Degradation rate r", ylab = "X*")
lines(R[i1:i2], Xs[i1:i2], lty = 2, col = gruen, lwd = 2)
lines(R[i2:length(R)], Xs[i2:length(R)], col = gruen, lwd = 3)
cat(sprintf("bistable for %.2f < r < %.2f\n", R[i1], R[i2]))
