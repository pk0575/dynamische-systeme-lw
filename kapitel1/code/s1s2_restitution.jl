# Abb. 1.39: S1-S2-Protokoll und Restitutionskurve (Buch, Abschnitt 1.6, Gl. 1.48)
# links: nach periodischer Anregung (S1, PCL = 400 ms) folgt ein Reiz S2 nach kürzerem bzw. längerem Abstand
# rechts: gemessene Paare (DI, APD) und Restitutionskurve r(DI) = 220 - 180 exp(-DI/60)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13; vref = 0.1; dt = 0.01
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49)]
p1 = plot(xlabel = "t (ms)", ylabel = "v", xlims = (-40, 800))
for (p, tS2) in enumerate([300, 430])
    reize = [0, 400, 800, 800 + tS2]
    t = (0:159999) .* dt; v = zeros(length(t)); vv = 0.0; h = 1.0
    for i in 2:length(t)
        J = any(r -> r <= t[i] < r + 2, reize) ? 0.2 : 0.0
        dv = h * vv^2 * (1 - vv) / tin - vv / tout + J
        dh = vv < vgate ? (1 - h) / topen : -h / tclose
        vv += dt * dv; h += dt * dh; v[i] = vv
    end
    m = t .>= 760
    plot!(p1, t[m] .- 800, v[m], color = farben[p], label = "S2 bei $tS2 ms")
    kreuz = t[findall(diff(sign.(v .- vref)) .!= 0)] .- 800
    ende_s1 = kreuz[findfirst(k -> 50 < k < tS2, kreuz)]           # Ende des letzten S1-Aktionspotentials
    ende_s2 = kreuz[findfirst(k -> k > tS2 + 20, kreuz)]           # Ende des S2-Aktionspotentials
    @printf("S2 bei %d ms:  DI = %.1f ms,  APD = %.1f ms\n", tS2, tS2 - ende_s1, ende_s2 - tS2)
end
hline!(p1, [vref], ls = :dot, color = :gray, label = "")

r(DI) = 220 - 180 * exp(-DI / 60)
daten = [60 150; 80 178; 100 182; 120 190; 140 198; 160 204; 180 208;
         200 214; 220 214; 240 219; 260 212; 280 223]              # (DI, APD) in ms
DI = range(50, 300, length = 300)
p2 = plot(DI, r.(DI), color = RGB(0, 0.447, 0.741), lw = 2, label = "r(DI) = 220 - 180 exp(-DI/60)",
          xlabel = "DI (ms)", ylabel = "APD (ms)", legend = :bottomright)
scatter!(p2, daten[:, 1], daten[:, 2], color = :black, label = "S1-S2-Daten")
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
