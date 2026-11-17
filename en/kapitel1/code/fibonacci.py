# Fig. 1.4: Fibonacci sequence (book, Section 1.1, Eq. 1.5 and 1.6)
# x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N = 10                          # number of months
x = np.zeros(N + 1)
x[0], x[1] = 1, 1               # two initial values (second-order difference equation)
for n in range(1, N):
    x[n + 1] = x[n] + x[n - 1]  # recursion rule

n = np.arange(N + 1)
phi, psi = (1 + np.sqrt(5)) / 2, (1 - np.sqrt(5)) / 2
formel = (phi**(n + 1) - psi**(n + 1)) / np.sqrt(5)   # solution formula (Eq. 1.6)
print(x.astype(int))            # [1 1 2 3 5 8 13 21 34 55 89]
print(np.round(formel).astype(int))  # the solution formula gives the same numbers

plt.plot(n, x, "o--", color=(0.64, 0.08, 0.18))
for k in n:
    plt.text(k, x[k] + 3, f"{x[k]:.0f}", ha="center", color=(0.64, 0.08, 0.18))
plt.xlabel("n (months)")
plt.ylabel("Rabbit pairs $x_n$")
plt.xticks(n)
plt.show()
