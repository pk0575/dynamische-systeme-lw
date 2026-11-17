# Fig. 3.19: Michaelis-Menten kinetics, approximate solution with Euler's method (book, Section 3.4, Eq. 3.24 and 3.26)
# dS/dt = -kmax S/(k50 + S) with kmax = 0.5, k50 = 1, S(0) = 2; Euler's method S_{n+1} = S_n + h f(S_n) with h = 0.01
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
kmax, k50 = 0.5, 1
f = lambda S: -kmax * S / (k50 + S)
h, T = 0.01, 10
N = int(round(T / h))
t = h * np.arange(N + 1)
S = np.zeros(N + 1); S[0] = 2
for n in range(N):
    S[n + 1] = S[n] + h * f(S[n])                       # one Euler step
for tt in [2, 5, 10]:
    print(f"S({tt:2d}) ≈ {S[int(round(tt / h))]:.4f}")
plt.plot(t, S, color=(0.64, 0.08, 0.18), lw=2.5)
plt.xlabel("t"); plt.ylabel("S(t)"); plt.ylim(0, 2.1)
plt.show()
