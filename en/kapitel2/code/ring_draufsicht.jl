# Fig. 2.22: The three scenarios of the ring model seen from above (book, Section 2.5, Eq. 2.34)
# horizontally the cells, vertically the time steps n, color = y1; each oblique track is a traveling wave
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

weissrot = cgrad([RGB(1, 1, 1), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18), RGB(0.43, 0.04, 0.12)])
bilder = []
for (name, n_stoer) in [("a", 37), ("b", 45), ("c", 41)]
    Y1 = ring(n_stoer)
    push!(bilder, heatmap(1:50, 0:201, Y1, color = weissrot, clims = (0, 4.2), xlabel = "Cell", ylabel = "n", title = "Scenario $name)"))
    zeiten = [n for n in 100:201 if Y1[n + 1, 1] > 1]
    @printf("Scenario %s): time steps with excited cell 1 from n = 100: [%s]\n", name, join(first(zeiten, 6), ", "))
end
display(plot(bilder..., layout = (1, 3), size = (1100, 420)))
