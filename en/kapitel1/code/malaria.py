# Fig. 1.3: Malaria parasites after n days (book, Section 1.1, Eq. 1.2 and 1.3)
# recursion rule x_{n+1} = 8 x_n, x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N = 4                           # number of days
x = np.zeros(N + 1)
x[0] = 1                        # initial value: one parasite
for n in range(N):
    x[n + 1] = 8 * x[n]         # recursion rule

n = np.arange(N + 1)
print(x.astype(int))            # [1 8 64 512 4096]
print((8**n * x[0]).astype(int))  # solution formula x_n = 8^n x_0 gives the same

plt.plot(n, x, "o--", color=(0.64, 0.08, 0.18))
for k in n:
    plt.text(k, x[k] + 100, f"{x[k]:.0f}", ha="center", color=(0.64, 0.08, 0.18))
plt.xlabel("n (days)")
plt.ylabel("Number of parasites $x_n$")
plt.xticks(n)
plt.show()
