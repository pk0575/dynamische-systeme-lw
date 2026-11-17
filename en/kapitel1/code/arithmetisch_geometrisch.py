# Fig. 1.11: Arithmetic and geometric sequences (book, Section 1.2, Eq. 1.11 and 1.13)
# top: x_{n+1} = x_n + b with x_0 = 20;  bottom: x_{n+1} = a x_n with x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]   # shades of red for several sequences
fig, axs = plt.subplots(2, 1, figsize=(7, 7))

n = np.arange(11)
for b, c, m in zip([2, 1, -1], rot, "osD"):
    x = 20 + b * n                       # solution formula (1.12)
    axs[0].plot(n, x, "--", marker=m, color=c, label=f"b = {b}")
    print(f"b = {b}:  x_10 = {x[-1]}")
axs[0].set_xlabel("n"); axs[0].set_ylabel("x_n"); axs[0].legend()

n = np.arange(6)
for a, c, m in zip([1.2, 1.01, 0.5], rot, "osD"):
    x = a**n                             # solution formula (1.14) with x_0 = 1
    axs[1].plot(n, x, "--", marker=m, color=c, label=f"a = {a}")
    print(f"a = {a}:  x_5 = {x[-1]:.4f}")
axs[1].set_xlabel("n"); axs[1].set_ylabel("x_n"); axs[1].legend()
plt.tight_layout()
plt.show()
