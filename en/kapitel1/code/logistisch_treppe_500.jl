# Fig. 1.31: Staircase diagrams of the logistic model over 500 steps (book, Section 1.4)
# initial value 0.05; a = 2 (fixed point), 3.3 (2-cycle), 3.55 (8-cycle), 4 (aperiodic)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

N = 500
xx = range(0, 1, length = 400)
bilder = []
for a in (2, 3.3, 3.55, 4)
    f(y) = a * y * (1 - y)
    y = zeros(N + 1); y[1] = 0.05
    for k in 1:N
        y[k + 1] = f(y[k])
    end
    px = [y[1]]; py = [0.0]                                # staircase
    for k in 1:N
        append!(px, [y[k], y[k + 1]]); append!(py, [y[k + 1], y[k + 1]])
    end
    p = plot(xx, f.(xx), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1, xlims = (0, 1), ylims = (0, 1),
             xlabel = "x_n", ylabel = "f(x_n)", title = "a = $a")
    plot!(p, [0, 1], [0, 1], color = :black)
    plot!(p, px, py, color = RGB(0.64, 0.08, 0.18), lw = a < 4 ? 1.5 : 0.3)
    push!(bilder, p)
    werte = sort(unique(round.(y[end-15:end] .* 1e4) ./ 1e4))   # long-term behavior: distinct values at the end
    if length(werte) <= 8
        println(@sprintf("a = %g:  %d distinct values at the end: ", a, length(werte)), join([@sprintf("%.4f", w) for w in werte], "  "))
    else
        @printf("a = %g:  %d distinct values at the end: aperiodic\n", a, length(werte))
    end
end
display(plot(bilder..., layout = (2, 2), size = (850, 850)))
