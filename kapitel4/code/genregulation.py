# Abb. 4.22: Genregulation mit Aktivator und Repressor (Buch, Abschnitt 4.4, Gl. 4.18)
# dA/dt = k A^2/(A^2 + 10 (1 + 5R)) - A + 0.4,  dR/dt = 0.3 A^2/(A^2 + 10 (1 + 5R)) - 0.2 R  mit A(0) = 3, R(0) = 0.2
# links k = 9.5: gedämpfte Schwingung; rechts k = 10.5: Grenzzyklus
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5), sharey=True)
t = np.linspace(0, 400, 4001)
for ax, k in zip(axs, [9.5, 10.5]):
    f = lambda t, z: [k * z[0]**2 / (z[0]**2 + 10 * (1 + 5 * z[1])) - z[0] + 0.4,
                      0.3 * z[0]**2 / (z[0]**2 + 10 * (1 + 5 * z[1])) - 0.2 * z[1]]
    A = solve_ivp(f, [0, 400], [3, 0.2], t_eval=t, rtol=1e-9, atol=1e-11).y[0]
    ax.plot(t, A, color=(0.64, 0.08, 0.18), lw=2); ax.set_title(f"k = {k}"); ax.set_xlabel("t (min)")
    spaet = t > 200                                       # Maxima nach dem Einschwingen
    i = np.where((A[1:-1] > A[:-2]) & (A[1:-1] > A[2:]) & spaet[1:-1])[0] + 1
    schwankung = A[spaet].max() - A[spaet].min()
    if schwankung > 0.01:
        print(f"k = {k}: Schwankung von A für t > 200: {schwankung:.3f}, Periode {np.mean(np.diff(t[i])):.1f} min")
    else:
        print(f"k = {k}: Schwankung von A für t > 200: {schwankung:.3f} (stationärer Zustand)")
axs[0].set_ylabel("Aktivator A")
plt.tight_layout()
plt.show()
