# Fig. 3.23: Fast dynamics of the Mitchell-Schaeffer model (book, Section 3.5, Eq. 3.29 and 3.31)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) with fixed h = 1; left f(v) with rest, threshold, and excited state,
# right response to a 2 ms stimulus below (J = 0.02) and above (J = 0.04) the threshold
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # parameters in ms
hc = 4 * tin / tout

function simuliere(T, reize; J = 0.2, dauer = 2.0, dt = 0.01, h_fest = false)
    # Euler's method for the Mitchell-Schaeffer model; stimulus current J for 'dauer' ms from each time in 'reize'
    N = round(Int, T / dt); t = dt .* (0:N)
    Jt = zeros(N + 1)
    for s in reize
        Jt[(t .>= s - 1e-9) .& (t .< s + dauer - 1e-9)] .= J
    end
    v = zeros(N + 1); h = ones(N + 1)
    for n in 1:N
        dv = h[n] * v[n]^2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
        dh = h_fest ? 0.0 : (v[n] < vgate ? (1 - h[n]) / topen : -h[n] / tclose)
        v[n + 1] = v[n] + dt * dv; h[n + 1] = h[n] + dt * dh
    end
    return t, v, h
end
durchgaenge(t, v; schwelle = 0.1) = t[findall(diff(sign.(v .- schwelle)) .!= 0)]   # start and end of the action potentials

f(v) = v^2 * (1 - v) / tin - v / tout
w = sqrt(1 - hc); vs = (1 - w) / 2; ve = (1 + w) / 2   # threshold and excited state
@printf("h_c = %.2f,  threshold v_s* = %.4f,  excited v_e* = %.4f\n", hc, vs, ve)
v = range(-0.05, 1.05, length = 500)
p1 = plot(v, f.(v), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "f(v), h = 1", legend = :topleft, xlabel = "v")
hline!(p1, [0], color = :black, label = ""); scatter!(p1, [0, ve], [0, 0], color = :black, label = "")
scatter!(p1, [vs], [0], color = :white, msc = :black, label = "")
p2 = plot(xlabel = "t (ms)", ylabel = "v(t)", legend = :right)
vspan!(p2, [1, 3], color = :gray90, label = "")
for (J, farbe) in [(0.02, RGB(0.89, 0.44, 0.49)), (0.04, RGB(0.43, 0.04, 0.12))]
    t, v, _ = simuliere(15, [1.0], J = J, h_fest = true)
    plot!(p2, t, v, color = farbe, lw = 2, label = "J = $J")
    @printf("J = %g: v(15) = %.3f\n", J, v[end])
end
hline!(p2, [vs], ls = :dot, color = :gray, label = "")
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
