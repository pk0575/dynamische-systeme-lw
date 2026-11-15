# Abb. 1.30: Iterierte f^2 und f^3 des logistischen Modells (Buch, Abschnitt 1.4, Gl. 1.38)
# links: f^2 mit a = 3.1 (stabiler 2-Zyklus);  rechts: f^3 mit a = 3.835 (stabiler 3-Zyklus)
# Fixpunkte von f^k: schwarz gefüllt = stabil (|(f^k)'| < 1), weiß = instabil
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

# Nullstelle von g im Intervall [lo, hi] mit Bisektion (wie fzero/brentq, ohne Zusatzpaket)
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
    fk = k == 2 ? (y -> f(f(y))) : (y -> f(f(f(y))))   # f^2 bzw. f^3
    p = plot(x, fk.(x), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, aspect_ratio = 1,
             xlims = (0, 1), ylims = (0, 1), xlabel = "x", ylabel = "f^$k(x)", title = "a = $a")
    plot!(p, [0, 1], [0, 1], color = :black)
    # Fixpunkte: Vorzeichenwechsel von f^k(x) - x suchen, dann genau bestimmen
    xg = range(0, 1, length = 20001); g = fk.(xg) .- xg
    idx = findall(sign.(g[1:end-1]) .!= sign.(g[2:end]))
    pts = unique(round.([0.0; [bisektion(z -> fk(z) - z, xg[i], xg[i + 1]) for i in idx]], digits = 10))
    for q in pts
        e = 1e-7; ableitung = (fk(q + e) - fk(q - e)) / (2 * e)
        stabil = abs(ableitung) < 1
        scatter!(p, [q], [q], color = stabil ? :black : :white, msc = :black)
        @printf("a = %g, f^%d:  x = %.4f  %s  (Ableitung %.3f)\n", a, k, q, stabil ? "stabil" : "instabil", ableitung)
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 450)))
