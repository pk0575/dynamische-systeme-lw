# Fig. 3.3: Family of solutions of a linear differential equation (book, Section 3.1, Eq. 3.6 and 3.7)
# dx/dt = a x + b with a = -0.5, b = 1; solutions x(t) = C e^(at) - b/a for different initial values, x* = -b/a = 2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
a, b = -0.5, 1
xs = -b / a                                              # constant solution
t = np.linspace(0, 8, 400)
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, x0 in enumerate([5, 3.5, 2.5, 1, 0]):
    C = x0 - xs
    plt.plot(t, C * np.exp(a * t) + xs, color=rot[i % 3], lw=2)
    print(f"x(0) = {x0}: C = {C:4.1f}, x(8) = {C * np.exp(8 * a) + xs:.4f}")
plt.axhline(xs, color="k", lw=1.5)
plt.xlabel("t"); plt.ylabel("x(t)"); plt.title("black: x* = -b/a = 2")
plt.show()
