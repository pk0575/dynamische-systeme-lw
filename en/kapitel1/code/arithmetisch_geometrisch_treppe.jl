# Fig. 1.12: Update functions and staircase diagrams (book, Section 1.2)
# left: arithmetic sequence f(x) = x + 2 with x_0 = 20;  right: geometric sequence f(x) = a x with a = 1.2 and 0.5, x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

blau = RGB(0, 0.447, 0.741); hellblau = RGB(0.45, 0.70, 0.90)
rot = RGB(0.64, 0.08, 0.18); hellrot = RGB(0.89, 0.44, 0.49)
function treppe(x)                       # points of the staircase: vertically to the graph, horizontally to the diagonal
    px = [x[1]]; py = [0.0]
    for k in 1:length(x) - 1
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    return px, py
end

p1 = plot([18, 33], [20, 35], color = blau, lw = 2, label = "f(x) = x + 2", xlims = (18, 33), ylims = (18, 33),
          xlabel = "x", ylabel = "f(x)", legend = :bottomright)
plot!(p1, [18, 33], [18, 33], color = :black, label = "y = x")
x = zeros(7); x[1] = 20
for k in 1:6
    x[k + 1] = x[k] + 2
end
plot!(p1, treppe(x)..., ls = :dash, color = rot, label = "")
println("arithmetic: ", join([@sprintf("%g", v) for v in x], "  "))

p2 = plot([0, 2.6], [0, 2.6], color = :black, legend = false, xlims = (0, 2.6), ylims = (0, 2.6), xlabel = "x", ylabel = "f(x)")
for (a, N, cF, cT) in [(1.2, 5, blau, rot), (0.5, 4, hellblau, hellrot)]
    plot!(p2, [0, 2.6], [0, a * 2.6], color = cF, lw = 2)
    x = zeros(N + 1); x[1] = 1
    for k in 1:N
        x[k + 1] = a * x[k]
    end
    plot!(p2, treppe(x)..., ls = :dash, color = cT)
    println(@sprintf("geometric a = %g: ", a), join([@sprintf("%.4f", v) for v in x], "  "))
end
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
