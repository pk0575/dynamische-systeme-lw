# Fig. 1.34: Newton's method without convergence (book, Section 1.5, Eq. 1.44)
# g(x) = x^3 - 2x + 2 with x_0 = 0: the approximations jump between 0 and 1, the root at -1.769 is not found
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

g(x) = x^3 - 2x + 2
dg(x) = 3x^2 - 2

x = zeros(7)
for k in 1:6
    x[k + 1] = x[k] - g(x[k]) / dg(x[k])
end
println("x_0 ... x_6 = ", join([@sprintf("%g", v) for v in x], "  "))

xs = -1.0                                # with a better initial value it works
for k in 1:8
    global xs = xs - g(xs) / dg(xs)
end
@printf("start at -1: root x* = %.6f\n", xs)

xx = range(-2.2, 1.8, length = 400)
p = plot(xx, g.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, ylims = (-2.2, 4.5), xlabel = "x")
hline!(p, [0], color = :black)
zz = range(-0.6, 1.6, length = 10)
for a in (0, 1)                          # the two tangents
    plot!(p, zz, g(a) .+ dg(a) .* (zz .- a), color = :black)
end
scatter!(p, [0, 1], [0, 0], color = RGB(0.64, 0.08, 0.18))
scatter!(p, [xs], [0], color = :black)
display(p)
