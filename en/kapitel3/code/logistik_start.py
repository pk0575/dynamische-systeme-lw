# Fig. 3.15: Solutions of the logistic model for different initial values (book, Section 3.3)
# r = 0.55, K = 210; the steady-state solutions x = 0 and x = K are neither reached nor crossed by any other solution
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.55, 210
x = lambda t, x0: x0 * K / (x0 + (K - x0) * np.exp(-r * t))
t = np.linspace(0, 20, 300)
plt.plot(t, 0 * t, color=(0.43, 0.04, 0.12), lw=3, label="x0 = 0")
plt.plot(t, 0 * t + K, color=(0.43, 0.04, 0.12), lw=3, label="x0 = K")
plt.plot(t, x(t, 30), "--", color=(0.64, 0.08, 0.18), lw=2, label="x0 = 30")
plt.plot(t, x(t, 300), "--", color=(0.89, 0.44, 0.49), lw=2, label="x0 = 300")
for x0 in [30, 300]:
    print(f"x0 = {x0}: x(20) = {x(20, x0):.3f},  distance to K: {abs(x(20, x0) - K):.3f}")
plt.xlabel("t (h)"); plt.ylabel("x(t)"); plt.legend(loc="center right")
plt.show()
