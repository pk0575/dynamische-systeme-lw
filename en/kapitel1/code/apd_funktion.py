# Fig. 1.40: Update function of the APD model (book, Section 1.6, Eq. 1.49 and 1.50)
# f(APD) = r(m PCL - APD) with m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

DImin = 5.0
r = lambda DI: 220 - 180 * np.exp(-DI / 60)
def f(APD, PCL):
    m = np.ceil((APD + DImin) / PCL)          # after how many periods the next stimulus takes effect
    return r(m * PCL - APD)

APD = np.linspace(0, 800, 4001)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for ax, PCLs in zip(axs, [(400,), (400, 220)]):
    for PCL, farbe in zip(PCLs, [(0, 0.447, 0.741), (0.45, 0.70, 0.90)]):
        y = f(APD, PCL)
        y[np.abs(np.diff(y, prepend=y[0])) > 20] = np.nan       # do not connect the jumps
        ax.plot(APD, y, color=farbe, label=f"PCL = {PCL} ms")
    ax.set_xlabel("APD (ms)"); ax.set_ylabel("f(APD)"); ax.legend(loc="lower left")
print("jumps at APD = k PCL - DI_min, e.g. 395 and 795 ms for PCL = 400 ms")
plt.tight_layout()
plt.show()
