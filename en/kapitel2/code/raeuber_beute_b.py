# Fig. 2.5: Predator-prey model, the predators die out (book, Section 2.1, Eq. 2.3)
# u_{n+1} = (1 + r) u_n - r u_n^2 - gamma u_n v_n,  v_{n+1} = gamma u_n v_n  with r = 2.5, gamma = 1.1, u_0 = 0.5, v_0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

r, gamma, N = 2.5, 1.1, 40
u = np.zeros(N + 1); v = np.zeros(N + 1)
u[0], v[0] = 0.5, 0.2
for n in range(N):
    u[n + 1] = (1 + r) * u[n] - r * u[n]**2 - gamma * u[n] * v[n]
    v[n + 1] = gamma * u[n] * v[n]
print("v_0, v_10, v_20, v_40 =", "  ".join(f"{v[k]:.4f}" for k in (0, 10, 20, 40)), " -> the predators die out")
print("u_36 ... u_40 =", "  ".join(f"{x:.3f}" for x in u[36:]))

fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
n = np.arange(N + 1)
axs[0].plot(n, u, "o--", color=(0.43, 0.04, 0.12), label="Prey u_n")
axs[0].plot(n, v, "s--", color=(0.89, 0.44, 0.49), label="Predators v_n")
axs[0].set_xlabel("n"); axs[0].legend()
axs[1].scatter(u, v, c=n, cmap="Reds", vmin=-15)          # light: early, dark: late
axs[1].plot(u[0], v[0], "ko")
axs[1].set_xlabel("Prey u_n"); axs[1].set_ylabel("Predators v_n")
plt.tight_layout()
plt.show()
