# Abb. 1.41: Parameterstudie und Bifurkationsdiagramm zum APD-Modell (Buch, Abschnitt 1.6, Gl. 1.49)
# APD_{n+1} = f(APD_n) mit APD_0 = 150 ms, DI_min = 5 ms und verschiedenen Reizperioden PCL
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

DImin = 5; APD0 = 150.0; N = 120
r(DI) = 220 - 180 * exp(-DI / 60)
f(APD, PCL) = r(ceil((APD + DImin) / PCL) * PCL - APD)

n = 0:N
farben = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :diamond]
bilder = []
for PCLs in ([400, 220, 180], [110], [100])
    b = plot(xlabel = "n", ylabel = "APD_n (ms)", legend = :bottomright)
    for (i, PCL) in enumerate(PCLs)
        A = zeros(N + 1); A[1] = APD0
        for k in 1:N
            A[k + 1] = f(A[k], PCL)
        end
        plot!(b, n, A, ls = :dash, marker = zeichen[i], ms = 2, color = farben[i], label = "PCL = $PCL")
        println(@sprintf("PCL = %d ms:  APD_117 ... APD_120 = ", PCL), join([@sprintf("%.1f", a) for a in A[118:121]], "  "))
    end
    push!(bilder, b)
end

PCL = range(50, 250, length = 4000)      # Bifurkationsdiagramm bzgl. PCL
A = fill(APD0, length(PCL))
for k in 1:10000
    global A = f.(A, PCL)
end
P = Float64[]; W = Float64[]
for k in 1:150
    global A = f.(A, PCL)
    append!(P, PCL); append!(W, A)
end
push!(bilder, scatter(P, W, ms = 0.5, msw = 0, color = RGB(0, 0.39, 0), legend = false,
                      xlabel = "PCL (ms)", ylabel = "APD_n (ms) für n > 10000"))
display(plot(bilder..., layout = (2, 2), size = (900, 650)))
