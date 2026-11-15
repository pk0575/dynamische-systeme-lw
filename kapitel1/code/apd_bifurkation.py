# Abb. 1.41: Parameterstudie und Bifurkationsdiagramm zum APD-Modell (Buch, Abschnitt 1.6, Gl. 1.49)
# APD_{n+1} = f(APD_n) mit APD_0 = 150 ms, DI_min = 5 ms und verschiedenen Reizperioden PCL
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

DImin, APD0, N = 5.0, 150.0, 120
r = lambda DI: 220 - 180 * np.exp(-DI / 60)
f = lambda APD, PCL: r(np.ceil((APD + DImin) / PCL) * PCL - APD)

def folge(PCL):
    A = np.zeros(N + 1)
    A[0] = APD0
    for n in range(N):
        A[n + 1] = f(A[n], PCL)
    return A

n = np.arange(N + 1)
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
fig, axs = plt.subplots(2, 2, figsize=(11, 7))
for ax, PCLs in zip(axs.flat, [(400, 220, 180), (110,), (100,)]):
    for PCL, farbe, m in zip(PCLs, rot, "osD"):
        A = folge(PCL)
        ax.plot(n, A, "--", marker=m, ms=3, lw=0.6, color=farbe, label=f"PCL = {PCL}")
        print(f"PCL = {PCL} ms:  APD_117 ... APD_120 =", "  ".join(f"{v:.1f}" for v in A[117:]))
    ax.set_xlabel("n"); ax.set_ylabel("APD_n (ms)"); ax.legend(loc="lower right", ncol=len(PCLs))

ax = axs[1, 1]                                   # Bifurkationsdiagramm bzgl. PCL
PCL = np.linspace(50, 250, 4000)
A = np.full_like(PCL, APD0)
for _ in range(10000):
    A = f(A, PCL)
for _ in range(150):
    A = f(A, PCL)
    ax.plot(PCL, A, ",", color=(0, 0.39, 0))
ax.set_xlabel("PCL (ms)"); ax.set_ylabel("APD_n (ms) für n > 10000")
plt.tight_layout()
plt.show()
