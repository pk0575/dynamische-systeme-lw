# Fig. 2.19: Action potentials in the Chialvo model (book, Section 2.5, Eq. 2.33)
# y1_{n+1} = y1_n^2 exp(y2_n - y1_n) + k,  y2_{n+1} = a y2_n - b y1_n + c  with a = 0.89, c = 0.28, k = 0.03
# left b = 0.26 (regular), right b = 0.18 (chaotic, early afterdepolarizations); top y1, bottom y2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, c, k, N = 0.89, 0.28, 0.03, 150
fig, axs = plt.subplots(2, 2, figsize=(11, 6), sharex=True)
for spalte, b in enumerate([0.26, 0.18]):
    y1, y2 = np.zeros(N + 1), np.zeros(N + 1)
    y1[0], y2[0] = 0.2, c / (1 - a)
    for n in range(N):
        y1[n + 1] = y1[n]**2 * np.exp(y2[n] - y1[n]) + k
        y2[n + 1] = a * y2[n] - b * y1[n] + c
    ap = np.sum((y1[1:] > 1) & (y1[:-1] <= 1))          # number of excursions above 1
    print(f"b = {b}: {ap} action potentials in {N} steps, max y1 = {y1.max():.2f}")
    axs[0, spalte].plot(y1, "o--", ms=2, lw=0.6, color=(0.64, 0.08, 0.18))
    axs[1, spalte].plot(y2, "o--", ms=2, lw=0.6, color=(0.89, 0.44, 0.49))
    axs[0, spalte].set_title(f"b = {b}"); axs[1, spalte].set_xlabel("n")
axs[0, 0].set_ylabel("y_1,n"); axs[1, 0].set_ylabel("y_2,n")
plt.tight_layout()
plt.show()
