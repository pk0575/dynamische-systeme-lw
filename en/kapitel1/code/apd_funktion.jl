# Fig. 1.40: Update function of the APD model (book, Section 1.6, Eq. 1.49 and 1.50)
# f(APD) = r(m PCL - APD) with m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Plots

DImin = 5
r(DI) = 220 - 180 * exp(-DI / 60)
f(APD, PCL) = r(ceil((APD + DImin) / PCL) * PCL - APD)   # ceil: after how many periods the next stimulus takes effect

APD = range(0, 800, length = 4001)
farben = [RGB(0, 0.447, 0.741), RGB(0.45, 0.70, 0.90)]
bilder = []
for PCLs in ([400], [400, 220])
    b = plot(xlabel = "APD (ms)", ylabel = "f(APD)", legend = :bottomleft)
    for (i, PCL) in enumerate(PCLs)
        y = f.(APD, PCL)
        y[[false; abs.(diff(y)) .> 20]] .= NaN    # do not connect the jumps
        plot!(b, APD, y, color = farben[i], lw = 2, label = "PCL = $PCL ms")
    end
    push!(bilder, b)
end
println("jumps at APD = k PCL - DI_min, e.g. 395 and 795 ms for PCL = 400 ms")
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
