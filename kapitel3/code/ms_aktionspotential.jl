# Abb. 3.24: Aktionspotential des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.30)
# Reiz bei t = 0; links v(t) und h(t), rechts stationäre Zustände von v in Abhängigkeit von h und der Weg des Aktionspotentials
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

t, v, h = simuliere(500, [0.0])
d = durchgaenge(t, v); apd = d[2] - d[1]
tf = tclose * log(1 / hc)
@printf("APD = %.1f ms,  h = h_c nach tclose ln(1/h_c) = %.1f ms\n", apd, tf)
p1 = plot(t, v, color = RGB(0.43, 0.04, 0.12), lw = 2, label = "v(t)", xlabel = "t (ms)")
plot!(p1, t, h, color = RGB(0.89, 0.44, 0.49), lw = 2, label = "h(t)")
hline!(p1, [hc], ls = :dot, color = :gray, label = ""); vline!(p1, [tf], ls = :dashdot, color = :gray, label = "")
gruen = RGB(0, 0.39, 0)
H = range(hc, 1.05, length = 400); W = sqrt.(1 .- hc ./ H)
p2 = plot(H, (1 .+ W) ./ 2, color = gruen, lw = 2.5, label = "stabil", xlabel = "h", ylabel = "v*", legend = :right)
plot!(p2, H, (1 .- W) ./ 2, ls = :dash, color = gruen, lw = 2.5, label = "instabil")
plot!(p2, [0, 1.05], [0, 0], color = gruen, lw = 2.5, label = "")
plot!(p2, h, v, color = RGB(0.64, 0.08, 0.18), lw = 1.5, label = "Aktionspotential")
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
