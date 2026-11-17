# Fig. 1.21: Update function and staircase diagram (book, Section 1.3, Eq. 1.30)
# f(y) = a y (1 - y) with a = 2.5, initial value y_0 = 0.1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, y0, N = 2.5, 0.1, 12
f = lambda y: a * y * (1 - y)

y = np.linspace(0, 1, 200)
plt.plot(y, f(y), label="f(y) = a y (1 - y)")
plt.plot([0, 1], [0, 1], "k", lw=0.8, label="y_{n+1} = y_n")

# staircase: vertically to the graph, horizontally to the diagonal
yn = y0
px, py = [yn], [0.0]
for k in range(N):
    yneu = f(yn)
    px += [yn, yneu]; py += [yneu, yneu]
    yn = yneu
plt.plot(px, py, "r-", lw=1)
print(f"y_{N} = {yn:.6f},  steady state 1 - 1/a = {1 - 1/a:.6f}")

plt.xlabel("y_n"); plt.ylabel("y_{n+1}"); plt.legend()
plt.show()
