# Fig. 3.8: Exponential growth and decay (book, Section 3.2, Eq. 3.15 and 3.16)
# x(t) = e^(0.5 t) and x(t) = e^(-0.5 t); left linear, right logarithmic axis (where both become straight lines)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

t = range(0, 6, length = 300)
bilder = []
for (achse, titel) in [(:identity, "linear axis"), (:log10, "logarithmic axis: straight lines")]
    p = plot(t, exp.(0.5 .* t), yscale = achse, color = RGB(0.43, 0.04, 0.12), lw = 2, label = "e^(0.5t) (growth)", title = titel, xlabel = "t")
    plot!(p, t, exp.(-0.5 .* t), ls = :dash, color = RGB(0.89, 0.44, 0.49), lw = 2, label = "e^(-0.5t) (decay)")
    push!(bilder, p)
end
@printf("doubling time ln(2)/0.5 = %.4f,  half-life = %.4f\n", log(2) / 0.5, log(2) / 0.5)
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
