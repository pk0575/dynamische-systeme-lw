# Fig. 2.12: Stable age distribution in the Leslie model (book, Section 2.3, Eq. 2.17)
# L with b_2 = 5: the fractions of the classes approach the eigenvector v_1 for the dominant eigenvalue lambda_1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

L = np.array([[0, 5, 9],
              [0.1, 0, 0],
              [0, 0.6, 0]])
w, V = np.linalg.eig(L)
i1 = np.argmax(abs(w))
v1 = np.real(V[:, i1]); v1 = v1 / v1.sum()
print(f"dominant eigenvalue lambda_1 = {np.real(w[i1]):.4f}")
print("stable age distribution v_1 = (%.3f, %.3f, %.3f)" % tuple(v1))

N = 30
X = np.zeros((N + 1, 3)); X[0] = [0, 0, 1000]
for n in range(N):
    X[n + 1] = L @ X[n]
P = X / X.sum(axis=1, keepdims=True)         # fractions of the classes
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for i, m in enumerate("osD"):
    plt.plot(np.arange(N + 1), P[:, i], "-", marker=m, color=farben[i], label=f"Class {i + 1}")
    plt.axhline(v1[i], color=farben[i], ls="--", lw=0.8)
plt.xlabel("n"); plt.ylabel("Fraction of class"); plt.legend()
plt.show()
