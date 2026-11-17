# Fig. 1.23: Bifurcation diagram of the logistic growth model (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n): for each value of a, the long-term behavior after n_* = 10000 steps is plotted
# top: 2.8 <= a <= 4;  bottom: detail 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (the pattern recurs)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

def bifurkation(a, behalten, fenster=(0, 1)):
    y = np.full_like(a, 0.9)                 # all parameter values at once (vector)
    for _ in range(10000):                   # transient
        y = a * y * (1 - y)
    A, Y = [], []
    for _ in range(behalten):                # collect long-term behavior
        y = a * y * (1 - y)
        m = (y > fenster[0]) & (y < fenster[1])
        A.append(a[m]); Y.append(y[m])
    return np.concatenate(A), np.concatenate(Y)

fig, axs = plt.subplots(2, 1, figsize=(8, 8))
A, Y = bifurkation(np.linspace(2.8, 4.0, 2401), 200)
axs[0].plot(A, Y, ",", color=(0, 0.39, 0))
axs[0].set_xlabel("a"); axs[0].set_ylabel("y_n for n > 10000")

A, Y = bifurkation(np.linspace(3.8538, 3.8541, 1501), 6000, fenster=(0.494, 0.506))
axs[1].plot(A, Y, ",", color=(0, 0.39, 0))
axs[1].set_xlabel("a"); axs[1].set_ylabel("y_n for n > 10000")
axs[1].ticklabel_format(useOffset=False)
plt.tight_layout()

a = np.array([3.2]); y = np.array([0.9])         # example a = 3.2: two values alternate (2-cycle)
for _ in range(10000):
    y = a * y * (1 - y)
print(f"a = 3.2:  2-cycle {y[0]:.4f} <-> {a[0] * y[0] * (1 - y[0]):.4f}")
plt.show()
