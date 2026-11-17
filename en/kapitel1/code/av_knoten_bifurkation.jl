# Fig. 1.37: Parameter study and bifurcation diagram of the AV node model (book, Section 1.6, Eq. 1.47)
# V_{n+1} = f(V_n) with V_0 = 1.1, u = 1, V_g = 1, and different values of c
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

Vg = 1; u = 1; V0 = 1.1; N = 40
f(V, c) = c * V + u * (c * V <= Vg)      # c V, plus u if c V <= V_g
n = 0:N
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect]
bilder = []
for paar in ([1/3, 2/3], [0.5001, 0.6], [0.71, 0.9])
    b = plot(ylims = (0.6, 2.1), xlabel = "n", ylabel = "V_n", legend = :bottomright)
    for (i, c) in enumerate(paar)
        V = zeros(N + 1); V[1] = V0
        for k in 1:N
            V[k + 1] = f(V[k], c)
        end
        plot!(b, n, V, ls = :dash, marker = zeichen[i], ms = 3, color = farben[i], label = @sprintf("c = %.4g", c))
        println(@sprintf("c = %.4g:  V_35 ... V_40 = ", c), join([@sprintf("%.3f", v) for v in V[36:41]], "  "))
    end
    push!(bilder, b)
end

c = range(0.33, 0.999, length = 3000)    # bifurcation diagram
V = fill(V0, length(c))
for k in 1:10000
    global V = f.(V, c)
end
C = Float64[]; W = Float64[]
for k in 1:150
    global V = f.(V, c)
    append!(C, c); append!(W, V)
end
push!(bilder, scatter(C, W, ms = 0.5, msw = 0, color = RGB(0, 0.39, 0), legend = false, xlims = (0.3, 1),
                      xlabel = "c", ylabel = "V_n for n > 10000"))
display(plot(bilder..., layout = (2, 2), size = (900, 650)))
