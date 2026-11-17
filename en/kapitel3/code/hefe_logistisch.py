# Fig. 3.12: Logistic growth of yeast (book, Section 3.2, Eq. 3.19 and 3.20)
# dx/dt = r (1 - x/K) x with r = 0.55 per hour, K = 210 (million cells per ml); solution x(t) = x0 K / (x0 + (K - x0) e^(-rt))
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.55, 210
x = lambda t, x0: x0 * K / (x0 + (K - x0) * np.exp(-r * t))
t = np.linspace(0, 20, 300)
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, x0 in enumerate([5, 50, 300]):
    plt.plot(t, x(t, x0), ["-", "--", "-."][i], color=rot[i], lw=2, label=f"x0 = {x0}")
    print(f"x0 = {x0:3d}: x(5) = {x(5, x0):6.2f},  x(20) = {x(20, x0):6.2f}")
plt.axhline(K, color="k", ls="--", lw=1)
plt.xlabel("t (h)"); plt.ylabel("x(t)"); plt.legend()
plt.show()
