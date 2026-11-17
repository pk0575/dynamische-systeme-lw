# Fig. 1.34: Newton's method without convergence (book, Section 1.5, Eq. 1.44)
# g(x) = x^3 - 2x + 2 with x_0 = 0: the approximations jump between 0 and 1, the root at -1.769 is not found
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

g = lambda x: x**3 - 2 * x + 2
dg = lambda x: 3 * x**2 - 2

x = [0.0]
for n in range(6):
    x.append(x[-1] - g(x[-1]) / dg(x[-1]))
print("x_0 ... x_6 =", "  ".join(f"{v:g}" for v in x))

xs = -1.0                                # with a better initial value it works
for n in range(8):
    xs = xs - g(xs) / dg(xs)
print(f"start at -1: root x* = {xs:.6f}")

xx = np.linspace(-2.2, 1.8, 400)
plt.plot(xx, g(xx), color=(0, 0.447, 0.741), label="g(x) = x^3 - 2x + 2")
plt.axhline(0, color="k", lw=0.8)
zz = np.linspace(-0.6, 1.6, 10)
for a in (0, 1):                         # the two tangents
    plt.plot(zz, g(a) + dg(a) * (zz - a), "k", lw=1)
plt.plot([0, 1], [0, 0], "o", color=(0.64, 0.08, 0.18))
plt.plot(xs, 0, "ko")
plt.ylim(-2.2, 4.5); plt.xlabel("x"); plt.legend(loc="upper left")
plt.show()
