# Abb. 2.12: stabile Altersverteilung im Leslie-Modell (Buch, Abschnitt 2.3, Gl. 2.17)
# L mit b_2 = 5: die Anteile der Klassen nähern sich dem Eigenvektor v_1 zum dominanten Eigenwert lambda_1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

L = np.array([[0, 5, 9],
              [0.1, 0, 0],
              [0, 0.6, 0]])
w, V = np.linalg.eig(L)
i1 = np.argmax(abs(w))
v1 = np.real(V[:, i1]); v1 = v1 / v1.sum()
print(f"dominanter Eigenwert lambda_1 = {np.real(w[i1]):.4f}")
print("stabile Altersverteilung v_1 = (%.3f, %.3f, %.3f)" % tuple(v1))

N = 30
X = np.zeros((N + 1, 3)); X[0] = [0, 0, 1000]
for n in range(N):
    X[n + 1] = L @ X[n]
P = X / X.sum(axis=1, keepdims=True)         # Anteile der Klassen
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for i, m in enumerate("osD"):
    plt.plot(np.arange(N + 1), P[:, i], "-", marker=m, color=farben[i], label=f"Klasse {i + 1}")
    plt.axhline(v1[i], color=farben[i], ls="--", lw=0.8)
plt.xlabel("n"); plt.ylabel("Anteil der Klasse"); plt.legend()
plt.show()
