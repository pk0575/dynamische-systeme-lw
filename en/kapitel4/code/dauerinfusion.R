# Fig. 4.12: Continuous infusion (book, Section 4.2, Eq. 4.11)
# dm/dt = -ka m,  db/dt = ka m - ke b + u  with u = 1 mg per hour, m(0) = b(0) = 0:  b(t) = (u/ke)(1 - e^(-ke t)), b* = u/ke = 5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
ke <- 0.2; u <- 1
t <- seq(0, 30, length.out = 600)
b <- u / ke * (1 - exp(-ke * t))
for (tt in c(5, 10, 20, 30)) cat(sprintf("t = %2d h: b = %.3f mg\n", tt, u / ke * (1 - exp(-ke * tt))))
plot(t, b, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2.5, ylim = c(0, 6), xlab = "t (hours)", ylab = "Drug (mg)")
abline(h = u / ke, lty = 2)
legend("bottomright", legend = c("b* = u/k_e", "Blood b(t)"), col = c("black", rgb(0.64, 0.08, 0.18)), lty = c(2, 1), lwd = c(1, 2.5))
