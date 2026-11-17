# Fig. 2.24: Spiral wave after a brief block (book, Section 2.5, Eq. 2.35)
# as Fig. 2.23, but in steps 50 to 52 the coupling d is zero in the region [28, 30] x [1, 50]: the wave breaks and rotates
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4
f1(y1, y2) = y1^2 * exp(y2 - y1) + k
y1r = 0.2; y2r = c / (1 - a)
for j in 1:180                                       # resting state of a single cell
    global y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c
end

function ebene(blockade, schritte; Z = 100)
    # Z x Z cells, no-flux boundary; left edge (i = 1) starts excited. List of the states y1 for n = 0, 1, 2, ...
    Y1 = fill(y1r, Z, Z); Y2 = fill(y2r, Z, Z); Y1[1, :] .= 0.3
    vor = [2:Z; Z]; zur = [1; 1:Z-1]                 # neighbor indices, at the boundary the cell itself
    zustaende = [copy(Y1)]
    for n in 1:schritte
        D = fill(d, Z, Z)
        blockade && 50 <= n <= 52 && (D[28:30, 1:50] .= 0)   # block in the region [28, 30] x [1, 50]
        F = f1.(Y1, Y2)
        Y1neu = (1 .- D) .* F .+ D ./ 4 .* (F[vor, :] .+ F[zur, :] .+ F[:, vor] .+ F[:, zur])
        Y2 = a .* Y2 .- b .* Y1 .+ c
        Y1 = Y1neu
        push!(zustaende, copy(Y1))
    end
    return zustaende
end
weissrot = cgrad([RGB(1, 1, 1), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18), RGB(0.43, 0.04, 0.12)])

Y = ebene(true, 301)
bilder = [heatmap(1:100, 1:100, Y[n + 1]', color = weissrot, clims = (0, 4), title = "n = $n", colorbar = false, aspect_ratio = 1)
          for n in 54:20:214]
erregt = [count(Y[n + 1] .> 1) for n in (100, 200, 300)]
@printf("number of excited cells at n = 100, 200, 300: [%s]  -> the excitation does not stop\n", join(erregt, ", "))
display(plot(bilder..., layout = (3, 3), size = (900, 900)))
