# Fig. 2.21: Second stimulation of cell 36 in the ring model (book, Section 2.5, Eq. 2.34)
# scenario a) n* = 37: signal dies out;  b) n* = 45: spreads in both directions;  c) n* = 41: circulates permanently
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4
f1(y1, y2) = y1^2 * exp(y2 - y1) + k

# resting state: compute a single cell for 180 steps starting from (0.2, c/(1 - a))
y1r = 0.2; y2r = c / (1 - a)
for j in 1:180
    global y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c
end

function ring(n_stoer = -1; Z = 50, schritte = 201)
    # ring of Z cells; cell 1 starts excited (0.3), optionally a second stimulation of cell 36 after n_stoer steps
    Y1 = fill(y1r, schritte + 1, Z); Y2 = fill(y2r, schritte + 1, Z)   # row n+1 = time step n
    Y1[1, 1] = 0.3
    rechts = [2:Z; 1]; links = [Z; 1:Z-1]                            # neighbors on the ring
    for n in 0:schritte-1
        F = f1.(Y1[n + 1, :], Y2[n + 1, :])
        Y1[n + 2, :] = (1 - d) .* F .+ d / 2 .* (F[rechts] .+ F[links])
        Y2[n + 2, :] = a .* Y2[n + 1, :] .- b .* Y1[n + 1, :] .+ c
        n + 1 == n_stoer && (Y1[n + 2, 36] = 0.3)                     # second stimulation of cell 36
    end
    return Y1
end
function stamm(werte, titel)               # bars above the cells of the ring (3D view)
    w = range(0, 2pi, length = 51)[1:50]; cx = cos.(w); cy = sin.(w)
    p = plot3d(cos.(range(0, 2pi, length = 100)), sin.(range(0, 2pi, length = 100)), zeros(100), color = :gray, legend = false,
               zlims = (0, 4.5), title = titel, ticks = false, grid = false)
    for i in 1:50
        plot3d!(p, [cx[i], cx[i]], [cy[i], cy[i]], [0, werte[i]], color = RGB(0.64, 0.08, 0.18))
    end
    scatter3d!(p, cx, cy, werte, color = RGB(0.64, 0.08, 0.18), ms = 2)
    return p
end

szenarien = [("a", 37, [37, 39, 41, 43]), ("b", 45, [45, 52, 72, 81]), ("c", 41, [41, 52, 75, 100])]
bilder = Matrix{Any}(undef, 4, 3)
for (sp, (name, n_stoer, zeiten)) in enumerate(szenarien)
    Y1 = ring(n_stoer)
    @printf("Scenario %s) n* = %d: excited cells after 200 steps: [%s]\n", name, n_stoer, join(findall(Y1[201, :] .> 1), ", "))
    for (z, n) in enumerate(zeiten)
        bilder[z, sp] = stamm(Y1[n + 1, :], "$name) n = $n")
    end
end
display(plot(permutedims(bilder)..., layout = (4, 3), size = (900, 1100)))
