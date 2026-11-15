# Abb. 1.35: Wann fällt der Wirkstoffspiegel unter 1 mg/l? (Buch, Abschnitt 1.5, Gl. 1.44)
# c(t) = 5 (exp(-0.2 t) - exp(-t)); Newton-Verfahren für g(t) = c(t) - 1 mit Startwert t_0 = 10 h
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
konz <- function(t) 5 * (exp(-0.2 * t) - exp(-t))   # c(t); in R ist c() schon vergeben
dc <- function(t) 5 * (-0.2 * exp(-0.2 * t) + exp(-t))

t <- numeric(6); t[1] <- 10
for (k in 1:5) t[k + 1] <- t[k] - (konz(t[k]) - 1) / dc(t[k])
for (k in 1:6) cat(sprintf("t_%d = %.6f h\n", k - 1, t[k]))

tt <- seq(0, 24, length.out = 500)
plot(tt, konz(tt), type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlim = c(0, 24), ylim = c(0, 3),
     xlab = "Zeit t (h)", ylab = "c(t) (mg/l)")
abline(h = 1); points(t[6], 1, pch = 16)
text(t[6] + 0.5, 1.15, sprintf("t* = %.2f h", t[6]), adj = 0)
