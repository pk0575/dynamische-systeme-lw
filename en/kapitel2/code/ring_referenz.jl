# Fig. 2.20: Propagation of the action potential on a ring (book, Section 2.5, Eq. 2.34)
# N = 50 cells, a = 0.89, b = 0.6, c = 0.28, k = 0.02, d = 0.4; at the start cell 1 is stimulated
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

Y1 = ring()
println("excited cells (y1 > 1):")
bilder = []
for n in (0, 4, 10, 20, 31, 35)
    push!(bilder, stamm(Y1[n + 1, :], "n = $n"))
    @printf("  n = %2d: [%s]\n", n, join(findall(Y1[n + 1, :] .> 1), ", "))
end
display(plot(bilder..., layout = (2, 3), size = (1000, 650)))
