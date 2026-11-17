# Fig. 1.27: Steady states of x_{n+1} = sqrt(x_n) (book, Section 1.4, Eq. 1.31)
# left: start at 0.01 near the unstable state 0;  right: start at 1.01 near the stable state 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

function treppe(x, unten = 0.0)          # points of the staircase: vertically to the graph, horizontally to the diagonal
    px = [x[1]]; py = [unten]
    for k in 1:length(x) - 1
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    return px, py
end
N = 4
bilder = []
for (x0, lo, hi) in [(0.01, 0.0, 1.5), (1.01, 0.99, 1.01)]
    x = zeros(N + 1); x[1] = x0
    for k in 1:N
        x[k + 1] = sqrt(x[k])
    end
    println(@sprintf("x_0 = %g: ", x0), join([@sprintf("%.5f", v) for v in x], "  "))
    xx = range(lo, hi, length = 300)
    p = plot(xx, sqrt.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (lo, hi), ylims = (lo, hi), xlabel = "x", ylabel = "f(x)")
    plot!(p, [lo, hi], [lo, hi], color = :black)
    plot!(p, treppe(x, lo)..., color = RGB(0.64, 0.08, 0.18))
    push!(bilder, p)
end
println("f'(x) = 1/(2 sqrt(x)):  f'(1) = 0.5 < 1 (stable), f'(x) -> infinity for x -> 0 (unstable)")
display(plot(bilder..., layout = (1, 2), size = (900, 450)))
