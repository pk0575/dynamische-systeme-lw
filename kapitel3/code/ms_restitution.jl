# Abb. 3.25: Restitutionskurve des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.33)
# Formel r_MS(DI), simulierte S1-S2-Messung (drei S1-Reize im Abstand von 400 ms, dann S2 nach der Pause DI) und r(DI) aus Kapitel 1
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
he = h[findfirst(t .>= d[2])]                              # h am Ende des Aktionspotentials
Delta = apd - tclose * log(1 / hc)
r_ms(DI) = Delta + tclose * log((1 - (1 - he) * exp(-DI / topen)) / hc)
r_k1(DI) = 220 - 180 * exp(-DI / 60)
t, v, _ = simuliere(1250, [0, 400, 800])
ende = first(filter(s -> s > 805, durchgaenge(t, v)))     # Ende des dritten Aktionspotentials
DIs = [10, 20, 40, 60, 80, 100, 150, 200, 250, 300]
sim = map(DIs) do DI
    s2 = ende + DI
    t, v, _ = simuliere(s2 + 400, [0, 400, 800, s2])
    d = filter(s -> s > s2 - 1, durchgaenge(t, v))
    d[2] - d[1]
end
@printf("h_e = %.4f,  Delta = %.2f ms\n", he, Delta)
println("DI:         ", join([@sprintf("%5d", x) for x in DIs], "  "))
println("Simulation: ", join([@sprintf("%5.1f", x) for x in sim], "  "))
println("Formel:     ", join([@sprintf("%5.1f", r_ms(x)) for x in DIs], "  "))
DI = range(4.8, 300, length = 400)
p = plot(DI, r_ms.(DI), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "r_MS(DI)", ylims = (40, 235),
         xlabel = "DI (ms)", ylabel = "APD (ms)", legend = :bottomright)
plot!(p, DI, r_k1.(DI), color = RGB(0.45, 0.70, 0.90), lw = 2, label = "r(DI) aus Kapitel 1")
scatter!(p, DIs, sim, color = :black, label = "S1-S2-Simulation")
display(p)
