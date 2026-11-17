# Fig. 3.1: From discrete-time to continuous growth (book, Section 3.1, Eq. 3.1 and 3.2)
# x(t + dt) = (1 + r dt) x(t) with r = 0.5, x(0) = 1 for dt = 1, 0.5, 0.1; for dt -> 0 one obtains x(t) = e^(r t)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r = 0.5
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, dt in enumerate([1, 0.5, 0.1]):
    n = np.arange(int(round(4 / dt)) + 1)
    x = (1 + r * dt)**n                                  # solution of the difference equation
    plt.plot(n * dt, x, "os^"[i], color=rot[i], ms=[9, 7, 5][i], label=f"Δt = {dt}")
    print(f"dt = {dt}: x(4) = {x[-1]:.4f}")
t = np.linspace(0, 4, 300)
plt.plot(t, np.exp(r * t), color=rot[0], lw=2, label="x(t) = e^(rt)")
print(f"e^(0.5*4) = {np.exp(2):.4f}")
plt.xlabel("t"); plt.ylabel("x"); plt.legend()
plt.show()
