# Abb. 3.19: Michaelis-Menten-Kinetik, Näherungslösung mit dem Euler-Verfahren (Buch, Abschnitt 3.4, Gl. 3.24 und 3.26)
# dS/dt = -kmax S/(k50 + S) mit kmax = 0.5, k50 = 1, S(0) = 2; Euler-Verfahren S_{n+1} = S_n + h f(S_n) mit h = 0.01
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
kmax, k50 = 0.5, 1
f = lambda S: -kmax * S / (k50 + S)
h, T = 0.01, 10
N = int(round(T / h))
t = h * np.arange(N + 1)
S = np.zeros(N + 1); S[0] = 2
for n in range(N):
    S[n + 1] = S[n] + h * f(S[n])                       # ein Euler-Schritt
for tt in [2, 5, 10]:
    print(f"S({tt:2d}) ≈ {S[int(round(tt / h))]:.4f}")
plt.plot(t, S, color=(0.64, 0.08, 0.18), lw=2.5)
plt.xlabel("t"); plt.ylabel("S(t)"); plt.ylim(0, 2.1)
plt.show()
