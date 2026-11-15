# Abb. 4.16: volles System und quasistationäre Näherung (Buch, Abschnitt 4.3, Gl. 4.12 und 4.14)
# d[S]/dt = -kmax [S]/(k50 + [S]) mit kmax = k3 [E]tot; links [E]tot = 0.2 µM, rechts 0.02 µM
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
k1, k2, k3 = 1.0, 1e-4, 0.1                # Raten in 1/(µM s) bzw. 1/s
S0 = 0.5                                   # µM
k50 = (k2 + k3) / k1
def mm(t, z):
    S, E, C, P = z                         # Substrat, Enzym, Komplex SE, Produkt
    r1, r2, r3 = k1 * S * E, k2 * C, k3 * C
    return [-r1 + r2, -r1 + r2 + r3, r1 - r2 - r3, r3]

fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for ax, E0, T in [(axs[0], 0.2, 60), (axs[1], 0.02, 600)]:
    t = np.linspace(0, T, 4001)
    voll = solve_ivp(mm, [0, T], [S0, E0, 0, 0], t_eval=t, method="LSODA", rtol=1e-10, atol=1e-14).y[0]
    kmax = k3 * E0
    qss = solve_ivp(lambda t, S: -kmax * S / (k50 + S), [0, T], [S0], t_eval=t, rtol=1e-10, atol=1e-13).y[0]
    print(f"[E]tot = {E0:g}: größte Abweichung {np.max(abs(voll - qss)):.4f} µM")
    ax.plot(t, voll, color=(0.43, 0.04, 0.12), lw=2, label="volles System")
    ax.plot(t, qss, color=(0.89, 0.44, 0.49), lw=2, label="quasistationär")
    ax.set_xlabel("t (s)"); ax.set_ylabel("Substrat [S] (µM)"); ax.set_title(f"[E]tot = {E0:g} µM"); ax.legend()
plt.tight_layout()
plt.show()
