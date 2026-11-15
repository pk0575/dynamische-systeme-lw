# Abb. 2.7: Krankheitsverlauf als lineares System (Buch, Abschnitt 2.2, Gl. 2.8)
# x_{n+1} = A x_n mit x = (gesund, leicht erkrankt, schwer erkrankt), x_0 = (100000, 0, 0), ein Schritt = ein Jahr
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

A = np.array([[0.997, 0.6, 0],
              [0.003, 0, 0.35],
              [0, 0.4, 0.65]])
N = 20
X = np.zeros((N + 1, 3))
X[0] = [100000, 0, 0]
for n in range(N):
    X[n + 1] = A @ X[n]                 # Matrix mal Vektor
print("x_20 = (%.0f, %.0f, %.0f)" % tuple(X[N]))
print("Spaltensummen von A: %g %g %g" % tuple(A.sum(axis=0)), "-> die Gesamtzahl bleibt erhalten: %.0f" % X[N].sum())

fig, axs = plt.subplots(3, 1, figsize=(8, 7), sharex=True)
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for i, (name, m) in enumerate(zip(["gesund g_n", "leicht erkrankt l_n", "schwer erkrankt k_n"], "osD")):
    axs[i].plot(np.arange(N + 1), X[:, i], "--", marker=m, color=farben[i], label=name)
    axs[i].legend(loc="lower right")
axs[2].set_xlabel("n (Jahre)")
plt.show()
