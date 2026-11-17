# Fig. 4.25: Mitchell-Schaeffer model with pacemaker current (book, Section 4.5, Eq. 4.20)
# constant inward current J0 > J_c: left periodic action potentials for J0 = 0.0022 and 0.003,
# right the limit cycle for J0 = 0.0022 with the nullclines (there is no steady state anymore)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # parameters in ms
hc = 4 * tin / tout

function simuliere(T; J0 = 0.0, reize = (), J = 0.2, dauer = 2.0, dt = 0.01)
    # Euler's method for the Mitchell-Schaeffer model with constant current J0 and stimuli of strength J
    N = round(Int, T / dt); t = dt .* (0:N)
    Jt = fill(J0, N + 1)
    for s in reize
        Jt[(t .>= s - 1e-9) .& (t .< s + dauer - 1e-9)] .+= J
    end
    v = zeros(N + 1); h = ones(N + 1)
    for n in 1:N
        dv = h[n] * v[n]^2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
        dh = v[n] < vgate ? (1 - h[n]) / topen : -h[n] / tclose
        v[n + 1] = v[n] + dt * dv; h[n + 1] = h[n] + dt * dh
    end
    return t, v, h
end

function nullklinen!(p, J0)
    v = range(0.003, 0.997, length = 2000)
    H = (v ./ tout .- J0) ./ (v .^ 2 .* (1 .- v) ./ tin)   # dv/dt = 0 solved for h
    m = (H .>= -0.05) .& (H .<= 1.1)
    plot!(p, H[m], v[m], color = BL, lw = 2.5, label = "dv/dt = 0")
    J0 == 0 && plot!(p, [-0.05, 1.1], [0, 0], color = BL, lw = 2.5, label = "")
    plot!(p, [1, 1], [-0.05, vgate], color = HB, lw = 2.5, label = "dh/dt = 0")
    plot!(p, [0, 0], [vgate, 1.05], color = HB, lw = 2.5, label = "")
end

function feld!(p, J0)
    hg = [h for h in range(0.05, 1.05, length = 12), v in range(0.05, 1.0, length = 11)][:]
    vg = [v for h in range(0.05, 1.05, length = 12), v in range(0.05, 1.0, length = 11)][:]
    dv = hg .* vg .^ 2 .* (1 .- vg) ./ tin .- vg ./ tout .+ J0
    dh = ifelse.(vg .< vgate, (1 .- hg) ./ topen, -hg ./ tclose)
    L = hypot.(dh, dv) ./ 0.052
    quiver!(p, hg, vg, quiver = (dh ./ L, dv ./ L), color = GR, label = "")
end

f(v) = v^2 * (1 - v) / tin - v / tout
Jc = -minimum(f.(range(0, 0.2, length = 200001)))
@printf("J_c = %.5f\n", Jc)
p1 = plot(xlims = (0, 2000), xlabel = "t (ms)", ylabel = "v(t)", legend = :topright)
p2 = plot(xlims = (-0.05, 1.1), ylims = (-0.05, 1.05), xlabel = "h", ylabel = "v", legend = :right)
for (J0, farbe) in [(0.0022, R1), (0.003, R3)]
    t, v, h = simuliere(3000, J0 = J0)
    hoch = t[2:end][(v[1:end - 1] .< 0.5) .& (v[2:end] .>= 0.5)]   # start of each action potential
    @printf("J0 = %g: period %.0f ms\n", J0, hoch[end] - hoch[end - 1])
    m = t .>= 400
    plot!(p1, t[m] .- 400, v[m], color = farbe, lw = 2, label = "J0 = $J0")
    if J0 == 0.0022
        m = t .>= 1500
        feld!(p2, J0); nullklinen!(p2, J0)
        plot!(p2, h[m], v[m], color = R2, lw = 2, label = "Limit cycle")
    end
end
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
