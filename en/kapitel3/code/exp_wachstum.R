# Fig. 3.8: Exponential growth and decay (book, Section 3.2, Eq. 3.15 and 3.16)
# x(t) = e^(0.5 t) and x(t) = e^(-0.5 t); left linear, right logarithmic axis (where both become straight lines)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
t <- seq(0, 6, length.out = 300)
par(mfrow = c(1, 2))
for (achse in c("", "y")) {
  plot(t, exp(0.5 * t), type = "l", log = achse, col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0.04, 21), xlab = "t", ylab = "",
       main = if (achse == "") "linear axis" else "logarithmic axis: straight lines")
  lines(t, exp(-0.5 * t), lty = 2, col = rgb(0.89, 0.44, 0.49), lwd = 2)
  if (achse == "") legend("topleft", legend = c("e^(0.5t) (growth)", "e^(-0.5t) (decay)"),
                          col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lty = c(1, 2), lwd = 2)
}
cat(sprintf("doubling time ln(2)/0.5 = %.4f,  half-life = %.4f\n", log(2) / 0.5, log(2) / 0.5))
