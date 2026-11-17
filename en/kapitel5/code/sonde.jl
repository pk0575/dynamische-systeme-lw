# Fig. 5.6: An arrhythmia in the model (book, Section 5.4, Eq. 5.6)
# as Fig. 5.5 up to t = 3000 ms; course of v at the point (25, 25) mm, intervals, durations, and diastolic intervals of the action potentials
# The computation takes about one minute.
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

function rechne()
    v = zeros(N, N); h = ones(N, N); vn = similar(v); i0 = floor(Int, 25 / dx) + 1
    K = round(Int, 3000 / dt); spur = zeros(K)
    for n in 0:K-1
        schritt!(v, h, vn, n * dt); v, vn = vn, v
        spur[n + 1] = v[i0, i0]
    end
    return spur
end

spur = rechne(); ts = dt .* collect(1:length(spur))         # as dt * k in the other languages
hoch(s) = [false; (spur[2:end] .> s) .& (spur[1:end-1] .<= s)]
akt = ts[hoch(0.5)]                                                  # v rises above 0.5
auf = ts[hoch(0.1)]; ab = ts[[false; (spur[2:end] .< 0.1) .& (spur[1:end-1] .>= 0.1)]]
m = min(length(auf), length(ab)); apd = ab[1:m] .- auf[1:m]; di = auf[2:end] .- ab[1:length(auf)-1]
abst = diff(akt)
@printf("Intervals between the action potentials (ms): [%s]\n", join([@sprintf("%.1f", d) for d in abst], " "))
@printf("from the 4th interval on: mean %.0f ms,  mean APD %.0f ms,  mean DI %.0f ms\n", mean(abst[4:end]), mean(apd[5:end]), mean(di[5:end]))
display(plot(ts, spur, color = RGB(0.64, 0.08, 0.18), lw = 1.5, legend = false, xlabel = "t (ms)", ylabel = "v at (25, 25) mm", size = (900, 400)))
