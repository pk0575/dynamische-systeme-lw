# Abb. 5.3: Leitungsgeschwindigkeit und Kopplung (Buch, Abschnitt 5.2, Gl. 5.5)
# Simulation der Kabelgleichung für fünf Werte von D und die Formel c = sqrt(D/(2 tin)) (1 - 3 vs)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
tin = 0.3; tout = 6.0; topen = 100.0; tclose = 115.0; vgate = 0.13   # Parameter in ms
hc = 4 * tin / tout
vs = (1 - sqrt(1 - hc)) / 2                                          # Schwelle für h = 1
formel(D) = sqrt(D / (2 * tin)) * (1 - 3 * vs)

function geschwindigkeit(D; dx = 0.1, dt = 0.01, L = 60.0)
    # Faser der Länge L, Reiz am linken Ende; c aus den Zeitpunkten, an denen v bei 20 und 50 mm den Wert 0.5 erreicht
    N = round(Int, L / dx) + 1; v = zeros(N); h = ones(N); reiz = dx .* (0:N-1) .<= 1.0
    i1 = round(Int, 20 / dx) + 1; i2 = round(Int, 50 / dx) + 1; t1 = NaN; t2 = NaN; n = 0; lap = zeros(N)
    while isnan(t2)
        lap[2:end-1] .= v[3:end] .- 2 .* v[2:end-1] .+ v[1:end-2]; lap[1] = v[2] - v[1]; lap[end] = v[end-1] - v[end]
        dv = h .* v.^2 .* (1 .- v) ./ tin .- v ./ tout .+ D .* lap ./ dx^2
        n * dt < 2.0 && (dv[reiz] .+= 0.2)
        dh = ifelse.(v .< vgate, (1 .- h) ./ topen, -h ./ tclose)
        v = v .+ dt .* dv; h = h .+ dt .* dh; n += 1
        isnan(t1) && v[i1] > 0.5 && (t1 = n * dt)
        isnan(t2) && v[i2] > 0.5 && (t2 = n * dt)
    end
    return 30.0 / (t2 - t1)
end

Ds = [0.025, 0.05, 0.1, 0.2, 0.4]
cs = [geschwindigkeit(D) for D in Ds]
for (D, c) in zip(Ds, cs)
    @printf("D = %5.3f:  Simulation c = %.4f,  Formel c = %.4f mm/ms\n", D, c, formel(D))
end
Dd = range(0, 0.45, length = 300)
plot(Dd, formel.(Dd), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "Formel", xlabel = "D (mm²/ms)", ylabel = "c (mm/ms)", legend = :bottomright)
display(scatter!(Ds, cs, color = RGB(0.64, 0.08, 0.18), ms = 6, label = "Simulation"))
