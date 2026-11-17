# Fig. 1.17: Geometric growth with growth rate r (book, Section 1.3, Eq. 1.24)
# x_{n+1} = (1 + r) x_n with x_0 = 100; left x_n, right ln(x_n)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

x0, N = 100.0, 30
n = np.arange(N + 1)
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]

fig, axs = plt.subplots(1, 2, figsize=(10, 4.5))
for r, c, m in zip([1, 0.1, -0.5], rot, "osD"):
    x = x0 * (1 + r)**n
    axs[0].plot(n[:5], x[:5], "--", marker=m, color=c, label=f"r = {r}")
    axs[1].plot(n, np.log(x), "--", marker=m, color=c, label=f"r = {r}")
    print(f"r = {r}:  slope of ln(x_n) = ln(1 + r) = {np.log(1 + r):.4f}")
axs[0].set_xlabel("n"); axs[0].set_ylabel("x_n"); axs[0].legend()
axs[1].set_xlabel("n"); axs[1].set_ylabel("ln(x_n)"); axs[1].legend()
plt.tight_layout()
plt.show()
