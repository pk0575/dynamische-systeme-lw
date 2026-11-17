# Fig. 1.30: Iterates f^2 and f^3 of the logistic model (book, Section 1.4, Eq. 1.38)
# left: f^2 with a = 3.1 (stable 2-cycle);  right: f^3 with a = 3.835 (stable 3-cycle)
# fixed points of f^k: filled black = stable (|(f^k)'| < 1), white = unstable
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

# root of g in the interval [lo, hi] by bisection (like fzero/brentq, without extra package)
function bisektion(g, lo, hi)
    for _ in 1:100
        m = (lo + hi) / 2
        sign(g(m)) == sign(g(lo)) ? (lo = m) : (hi = m)
    end
    return (lo + hi) / 2
end

x = range(0, 1, length = 2000)
bilder = []
for (a, k) in [(3.1, 2), (3.835, 3)]
    f(y) = a * y * (1 - y)
    fk = k == 2 ? (y -> f(f(y))) : (y -> f(f(f(y))))   # f^2 or f^3
    p = plot(x, fk.(x), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (0, 1), ylims = (0, 1), xlabel = "x", ylabel = "f^$k(x)", title = "a = $a")
    plot!(p, [0, 1], [0, 1], color = :black)
    # fixed points: look for sign changes of f^k(x) - x, then determine precisely
    xg = range(0, 1, length = 20001); g = fk.(xg) .- xg
    idx = findall(sign.(g[1:end-1]) .!= sign.(g[2:end]))
    pts = unique(round.([0.0; [bisektion(z -> fk(z) - z, xg[i], xg[i + 1]) for i in idx]], digits = 10))
    for q in pts
        e = 1e-7; ableitung = (fk(q + e) - fk(q - e)) / (2 * e)
        stabil = abs(ableitung) < 1
        scatter!(p, [q], [q], color = stabil ? :black : :white, msc = :black)
        @printf("a = %g, f^%d:  x = %.4f  %s  (derivative %.3f)\n", a, k, q, stabil ? "stable" : "unstable", ableitung)
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 450)))
