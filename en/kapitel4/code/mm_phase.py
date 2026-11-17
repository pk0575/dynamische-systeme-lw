# Fig. 4.15: Michaelis-Menten system in the ([S], [SE]) plane (book, Section 4.3, Eq. 4.13)
# solution with time marks and the curve d[SE]/dt = 0, i.e. [SE] = [E]tot [S]/([S] + k50); left [E]tot = 0.2 µM, right 0.02 µM
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
k1, k2, k3 = 1.0, 1e-4, 0.1                # rates in 1/(µM s) and 1/s
S0 = 0.5                                   # µM
k50 = (k2 + k3) / k1
def mm(t, z):
    S, E, C, P = z                         # substrate, enzyme, complex SE, product
    r1, r2, r3 = k1 * S * E, k2 * C, k3 * C
    return [-r1 + r2, -r1 + r2 + r3, r1 - r2 - r3, r3]

fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for ax, E0, T, marken in [(axs[0], 0.2, 60, [2, 10, 30]), (axs[1], 0.02, 600, [5, 100, 300])]:
    t = np.linspace(0, T, 4001)
    s = solve_ivp(mm, [0, T], [S0, E0, 0, 0], t_eval=t, method="LSODA", rtol=1e-10, atol=1e-14)
    S, C = s.y[0], s.y[2]
    Sg = np.linspace(0, 0.52, 300)
    ax.plot(Sg, E0 * Sg / (Sg + k50), color=(0, 0.447, 0.741), lw=2, label="d[SE]/dt = 0")
    ax.plot(S, C, color=(0.64, 0.08, 0.18), lw=2, label="Solution")
    for tm in marken:
        i = np.searchsorted(t, tm)
        ax.plot(S[i], C[i], "ko"); ax.text(S[i] + 0.01, C[i], f"{tm} s")
        print(f"[E]tot = {E0:g}: t = {tm:3d} s: [S] = {S[i]:.4f}, [SE] = {C[i]:.5f}")
    ax.set_xlabel("[S] (µM)"); ax.set_ylabel("[SE] (µM)"); ax.set_ylim(0, E0); ax.set_title(f"[E]tot = {E0:g} µM"); ax.legend(loc="upper left")
plt.tight_layout()
plt.show()
