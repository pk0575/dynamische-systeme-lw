# Fig. 1.28: Staircase diagrams with stable and unstable steady states (book, Section 1.4, Eq. 1.34)
# top: f(x) = x - 2x(0.5 - x)(1 - x) with fixed points 0 and 1 (stable) and 0.5 (unstable)
# bottom: f(x) = exp(-2x) (spiral approach) and f(x) = exp(-5x) (spiral divergence), each with x_0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

function treppe(x, unten = 0.0)          # points of the staircase: vertically to the graph, horizontally to the diagonal
    px = [x[1]]; py = [unten]
    for k in 1:length(x) - 1
        append!(px, [x[k], x[k + 1]]); append!(py, [x[k + 1], x[k + 1]])
    end
    return px, py
end
g(x) = x - 2 * x * (0.5 - x) * (1 - x)
faelle = [(g, "f(x) = x - 2x(0.5-x)(1-x)", [0.6], 20, 0.5, 1.0),
          (g, "f(x) = x - 2x(0.5-x)(1-x)", [0.4, 0.6], 20, 0.0, 1.0),
          (x -> exp(-2x), "f(x) = exp(-2x)", [0.2], 20, 0.0, 1.0),
          (x -> exp(-5x), "f(x) = exp(-5x)", [0.2], 7, 0.0, 1.0)]
bilder = []
for (f, name, starts, N, lo, hi) in faelle
    xx = range(lo, hi, length = 400)
    p = plot(xx, f.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (lo, hi), ylims = (lo, hi), xlabel = "x_n", ylabel = "f(x_n)", title = name, titlefontsize = 9)
    plot!(p, [lo, hi], [lo, hi], color = :black)
    for x0 in starts
        x = zeros(N + 1); x[1] = x0
        for k in 1:N
            x[k + 1] = f(x[k])
        end
        plot!(p, treppe(x, lo)..., color = RGB(0.64, 0.08, 0.18))
        @printf("%s, x_0 = %g:  x_%d = %.4f\n", name, x0, N, x[end])
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (2, 2), size = (850, 850)))

# stability criterion |f'(x*)| < 1 at the fixed points
for c in (2, 5)
    xs = 0.5
    for k in 1:100                       # fixed point with Newton's method
        xs = xs - (exp(-c * xs) - xs) / (-c * exp(-c * xs) - 1)
    end
    @printf("f(x) = exp(-%dx):  x* = %.4f,  f'(x*) = %.4f\n", c, xs, -c * exp(-c * xs))
end
