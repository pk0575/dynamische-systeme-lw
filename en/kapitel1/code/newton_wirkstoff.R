# Fig. 1.35: When does the drug level fall below 1 mg/l? (book, Section 1.5, Eq. 1.44)
# c(t) = 5 (exp(-0.2 t) - exp(-t)); Newton's method for g(t) = c(t) - 1 with initial value t_0 = 10 h
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
konz <- function(t) 5 * (exp(-0.2 * t) - exp(-t))   # c(t); in R the name c() is already taken
dc <- function(t) 5 * (-0.2 * exp(-0.2 * t) + exp(-t))

t <- numeric(6); t[1] <- 10
for (k in 1:5) t[k + 1] <- t[k] - (konz(t[k]) - 1) / dc(t[k])
for (k in 1:6) cat(sprintf("t_%d = %.6f h\n", k - 1, t[k]))

tt <- seq(0, 24, length.out = 500)
plot(tt, konz(tt), type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlim = c(0, 24), ylim = c(0, 3),
     xlab = "Time t (h)", ylab = "c(t) (mg/l)")
abline(h = 1); points(t[6], 1, pch = 16)
text(t[6] + 0.5, 1.15, sprintf("t* = %.2f h", t[6]), adj = 0)
