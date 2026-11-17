# Fig. 2.9: Leslie model with three age classes (book, Section 2.2, Eq. 2.11)
# x_{n+1} = L x_n with birth rate 9 of class 3 and survival rates 0.1 and 0.6, x_0 = (0, 0, 1000)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

L = np.array([[0, 0, 9],
              [0.1, 0, 0],
              [0, 0.6, 0]])
N = 20
X = np.zeros((N + 1, 3))
X[0] = [0, 0, 1000]
for n in range(N):
    X[n + 1] = L @ X[n]
print("class 3 every three steps:", "  ".join(f"{x:.1f}" for x in X[0:N + 1:3, 2]))
print(f"factor per period: 9 * 0.1 * 0.6 = {9 * 0.1 * 0.6:g} < 1, the population dies out")

fig, axs = plt.subplots(3, 1, figsize=(8, 7), sharex=True)
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for i, m in enumerate("osD"):
    axs[i].plot(np.arange(N + 1), X[:, i], "--", marker=m, color=farben[i], label=f"Class {i + 1}")
    axs[i].legend(loc="upper right")
axs[2].set_xlabel("n")
plt.show()
