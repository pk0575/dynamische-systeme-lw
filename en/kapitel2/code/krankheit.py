# Fig. 2.7: Disease progression as a linear system (book, Section 2.2, Eq. 2.8)
# x_{n+1} = A x_n with x = (healthy, mildly ill, severely ill), x_0 = (100000, 0, 0), one step = one year
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

A = np.array([[0.997, 0.6, 0],
              [0.003, 0, 0.35],
              [0, 0.4, 0.65]])
N = 20
X = np.zeros((N + 1, 3))
X[0] = [100000, 0, 0]
for n in range(N):
    X[n + 1] = A @ X[n]                 # matrix times vector
print("x_20 = (%.0f, %.0f, %.0f)" % tuple(X[N]))
print("column sums of A: %g %g %g" % tuple(A.sum(axis=0)), "-> the total number is conserved: %.0f" % X[N].sum())

fig, axs = plt.subplots(3, 1, figsize=(8, 7), sharex=True)
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for i, (name, m) in enumerate(zip(["healthy g_n", "mildly ill l_n", "severely ill k_n"], "osD")):
    axs[i].plot(np.arange(N + 1), X[:, i], "--", marker=m, color=farben[i], label=name)
    axs[i].legend(loc="lower right")
axs[2].set_xlabel("n (years)")
plt.show()
