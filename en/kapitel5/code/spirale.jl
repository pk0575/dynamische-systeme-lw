# Fig. 5.5: Formation of a spiral wave (book, Section 5.4, Eq. 5.6)
# square 100 mm x 100 mm, stimulus S1 at the left edge at t = 0, stimulus S2 in the lower half at t = 380 ms
# The computation takes about half a minute.
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, Statistics
const tin = 0.3; const tout = 6.0; const topen = 100.0; const tclose = 115.0; const vgate = 0.13   # parameters in ms
const D = 0.1; const dx = 0.25; const dt = 0.05; const Lq = 100.0         # mm^2/ms, mm, ms, side length in mm
const N = round(Int, Lq / dx); const xs = dx .* ((1:N) .- 0.5)       # grid points; first index x, second index y

function schritt!(v, h, vn, t)
    # one Euler step; no flux across the boundary (missing neighbor = the cell itself); stimuli S1 (left edge) and S2 (lower half)
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
    @printf("t = %4d ms: fraction excited (v > 0.5) = %.3f\n", z, mean(bilder[z] .> 0.5))
end
p = [heatmap(xs, xs, bilder[z]', color = :reds, clims = (0, 1), title = "t = $z ms", colorbar = false, aspect_ratio = 1) for z in zeiten]
display(plot(p..., layout = (3, 3), size = (900, 900)))
