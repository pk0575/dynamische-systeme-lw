# Fig. 4.14: Michaelis-Menten rate (book, Section 4.3, Eq. 4.14)
# K([S]) = kmax [S]/(k50 + [S]) with kmax = k3 [E]tot = 0.02 µM/s and k50 = (k2 + k3)/k1 ≈ 0.1 µM
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k1, k2, k3, Etot = 1.0, 1e-4, 0.1, 0.2
kmax, k50 = k3 * Etot, (k2 + k3) / k1
print(f"kmax = {kmax:g} µM/s,  k50 = {k50:.4f} µM")
S = np.linspace(0, 1, 400)
plt.plot(S, kmax * S / (k50 + S), color=(0, 0.447, 0.741), lw=2.5, label="K([S]) = kmax [S]/(k50 + [S])")
plt.axhline(kmax, color="k", ls="--", lw=1)
plt.plot([k50, k50, 0], [0, kmax / 2, kmax / 2], "k:")
plt.xlabel("Substrate [S] (µM)"); plt.ylabel("Rate (µM/s)"); plt.ylim(0, 0.024); plt.legend(loc="lower right")
plt.show()
