# Abb. 3.23: schnelle Dynamik des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.31)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) mit festem h = 1; links f(v) mit Ruhe, Schwelle und erregtem Zustand,
# rechts Antwort auf einen Reiz der Dauer 2 ms unter (J = 0.02) und über (J = 0.04) der Schwelle
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # Parameter in ms
hc = 4 * tin / tout

function simuliere(T, reize; J = 0.2, dauer = 2.0, dt = 0.01, h_fest = false)
    # Euler-Verfahren für das Mitchell-Schaeffer-Modell; Reizstrom J für 'dauer' ms ab jedem Zeitpunkt in 'reize'
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
durchgaenge(t, v; schwelle = 0.1) = t[findall(diff(sign.(v .- schwelle)) .!= 0)]   # Beginn und Ende der Aktionspotentiale

f(v) = v^2 * (1 - v) / tin - v / tout
w = sqrt(1 - hc); vs = (1 - w) / 2; ve = (1 + w) / 2   # Schwelle und erregter Zustand
@printf("h_c = %.2f,  Schwelle v_s* = %.4f,  erregt v_e* = %.4f\n", hc, vs, ve)
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
