# Abb. 2.11: Krankheitsverlauf mit stationärem Zustand (Buch, Abschnitt 2.3, Gl. 2.8)
# Der stationäre Zustand x* = A x* ist ein Eigenvektor zum Eigenwert 1, skaliert auf 100000 Personen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

A = np.array([[0.997, 0.6, 0],
              [0.003, 0, 0.35],
              [0, 0.4, 0.65]])
w, V = np.linalg.eig(A)
print("Eigenwerte:", "  ".join(f"{x:.4f}" for x in sorted(np.real(w))))
v = np.real(V[:, np.argmin(abs(w - 1))])     # Eigenvektor zum Eigenwert 1
xs = v / v.sum() * 100000
print("stationärer Zustand x* = (%.0f, %.0f, %.0f)" % tuple(xs))

N = 30
X = np.zeros((N + 1, 3)); X[0] = [100000, 0, 0]
for n in range(N):
    X[n + 1] = A @ X[n]
fig, axs = plt.subplots(3, 1, figsize=(8, 7), sharex=True)
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for i, (name, m) in enumerate(zip(["g_n", "l_n", "k_n"], "osD")):
    axs[i].plot(np.arange(N + 1), X[:, i], "--", marker=m, color=farben[i], label=name)
    axs[i].axhline(xs[i], color="k", ls="--", lw=0.8)
    axs[i].legend(loc="lower right")
axs[2].set_xlabel("n (Jahre)")
plt.show()
