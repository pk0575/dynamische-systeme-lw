# Fig. 1.33: The first steps of Newton's method (book, Section 1.5, Eq. 1.44)
# x_{n+1} = x_n - g(x_n)/g'(x_n) for g(x) = exp(-5x) - x with x_0 = 0.05
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

g(x) = exp(-5x) - x
dg(x) = -5exp(-5x) - 1

x = zeros(7); x[1] = 0.05
for k in 1:6
    x[k + 1] = x[k] - g(x[k]) / dg(x[k])
end
for k in 1:7
    @printf("x_%d = %.12f\n", k - 1, x[k])   # the number of correct digits roughly doubles per step
end

xx = range(0, 0.35, length = 300)
bilder = []
for p in 1:2
    b = plot(xx, g.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, xlims = (0, 0.35), ylims = (-0.35, 1), xlabel = "x")
    hline!(b, [0], color = :black)
    for j in 1:p                         # tangent at x_{j-1}, its root is x_j
        plot!(b, xx, g(x[j]) .+ dg(x[j]) .* (xx .- x[j]), color = :black)
        plot!(b, [x[j], x[j]], [0, g(x[j])], ls = :dot, color = :black)
    end
    scatter!(b, x[1:p + 1], zeros(p + 1), color = RGB(0.64, 0.08, 0.18))
    push!(bilder, b)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
