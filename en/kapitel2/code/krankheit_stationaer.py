# Fig. 2.11: Disease progression with steady state (book, Section 2.3, Eq. 2.8)
# The steady state x* = A x* is an eigenvector for the eigenvalue 1, scaled to 100000 persons
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

A = np.array([[0.997, 0.6, 0],
              [0.003, 0, 0.35],
              [0, 0.4, 0.65]])
w, V = np.linalg.eig(A)
print("eigenvalues:", "  ".join(f"{x:.4f}" for x in sorted(np.real(w))))
v = np.real(V[:, np.argmin(abs(w - 1))])     # eigenvector for the eigenvalue 1
xs = v / v.sum() * 100000
print("steady state x* = (%.0f, %.0f, %.0f)" % tuple(xs))

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
axs[2].set_xlabel("n (years)")
plt.show()
