# Fig. 4.23: Membrane potential in the Noble model (book, Section 4.4, Eq. 4.19)
# Cm dV/dt = -(400 m^3 h + 0.14)(V - 40) - (1.2 e^((-V-90)/50) + 0.015 e^((V+90)/60) + 1.2 n^4)(V + 100) - gL (V - VL) + I(t), Cm = 12
# left pacemaker cell (gL = 0.075, VL = -60), right excitable cell (gL = 0.3, VL = -85) with stimuli every 700 ms; time in ms
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))

function noble(gL, VL, reiz)
    function f(t, z)
        V, m, h, n = z
        am = 0.1 * (-V - 48) / (exp((-V - 48) / 15) - 1); bm = 0.12 * (V + 8) / (exp((V + 8) / 5) - 1)
        ah = 0.17 * exp((-V - 90) / 20); bh = 1 / (1 + exp((-V - 42) / 10))
        an = 0.0001 * (-V - 50) / (exp((-V - 50) / 10) - 1); bn = 0.002 * exp((-V - 90) / 80)
        iNa = (400 * m^3 * h + 0.14) * (V - 40)
        iK = (1.2 * exp((-V - 90) / 50) + 0.015 * exp((V + 90) / 60) + 1.2 * n^4) * (V + 100)
        I = reiz && t - 700 * floor(t / 700) < 2 ? 300.0 : 0.0     # stimulus: 2 ms long every 700 ms
        return [(-(iNa + iK + gL * (V - VL)) + I) / 12, am * (1 - m) - bm * m, ah * (1 - h) - bh * h, an * (1 - n) - bn * n]
    end
    return f
end
bilder = []
for (name, gL, VL, reiz, T0) in [("pacemaker", 0.075, -60, false, 2000), ("stimulated", 0.3, -85, true, 0)]
    T = T0 + 2100
    t = 0:0.1:T
    z = loese(noble(gL, VL, reiz), [-80, 0.02, 0.8, 0.05], t, alg = Rodas5P(), dtmax = 0.25, reltol = 1e-8, abstol = 1e-10)
    i = t .>= T0; tt = (t[i] .- T0) ./ 1000; V = z[1, i]
    hoch = tt[2:end][(V[1:end - 1] .< 0) .& (V[2:end] .>= 0)]   # times at which V reaches 0 mV from below
    @printf("%s: V between %.0f and %.0f mV, %d action potentials in 2.1 s", name, minimum(V), maximum(V), length(hoch))
    length(hoch) > 1 && @printf(", period %.2f s", sum(diff(hoch)) / (length(hoch) - 1))
    println()
    push!(bilder, plot(tt, V, color = RGB(0.64, 0.08, 0.18), lw = 2, legend = false, title = name, xlabel = "t (s)",
                       ylabel = name == "stimulated" ? "" : "Membrane potential V (mV)"))
end
display(plot(bilder..., layout = (1, 2), link = :y, size = (900, 420)))
