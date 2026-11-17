# Abb. 5.5: Entstehung einer Spiralwelle (Buch, Abschnitt 5.4, Gl. 5.6)
# Quadrat 100 mm x 100 mm, Reiz S1 am linken Rand bei t = 0, Reiz S2 in der unteren Hälfte bei t = 380 ms
# Die Rechnung dauert etwa eine halbe Minute.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, Statistics
const tin = 0.3; const tout = 6.0; const topen = 100.0; const tclose = 115.0; const vgate = 0.13   # Parameter in ms
const D = 0.1; const dx = 0.25; const dt = 0.05; const Lq = 100.0         # mm^2/ms, mm, ms, Seitenlänge in mm
const N = round(Int, Lq / dx); const xs = dx .* ((1:N) .- 0.5)       # Gitterpunkte; erster Index x, zweiter Index y

function schritt!(v, h, vn, t)
    # ein Euler-Schritt; Rand ohne Fluss (fehlender Nachbar = Zelle selbst); Reize S1 (linker Rand) und S2 (untere Hälfte)
    for j in 1:N, i in 1:N
        vi = v[i, j]
        lap = v[min(i + 1, N), j] + v[max(i - 1, 1), j] + v[i, min(j + 1, N)] + v[i, max(j - 1, 1)] - 4vi
        J = (t < 2.0 && xs[i] <= 1.0) || (380.0 <= t < 382.0 && xs[j] <= Lq / 2) ? 0.2 : 0.0
        vn[i, j] = vi + dt * (h[i, j] * vi^2 * (1 - vi) / tin - vi / tout + D * lap / dx^2 + J)
        h[i, j] += dt * (vi < vgate ? (1 - h[i, j]) / topen : -h[i, j] / tclose)
    end
end

function rechne(zeiten)
    v = zeros(N, N); h = ones(N, N); vn = similar(v); bilder = Dict{Int, Matrix{Float64}}()
    for n in 0:round(Int, 1200 / dt)
        t = n * dt
        for z in zeiten
            abs(t - z) < 1e-6 && (bilder[z] = copy(v))
        end
        schritt!(v, h, vn, t); v, vn = vn, v
    end
    return bilder
end

zeiten = [100, 300, 390, 450, 550, 650, 800, 1000, 1200]
bilder = rechne(zeiten)
for z in zeiten
    @printf("t = %4d ms: Anteil erregt (v > 0.5) = %.3f\n", z, mean(bilder[z] .> 0.5))
end
p = [heatmap(xs, xs, bilder[z]', color = :reds, clims = (0, 1), title = "t = $z ms", colorbar = false, aspect_ratio = 1) for z in zeiten]
display(plot(p..., layout = (3, 3), size = (900, 900)))
