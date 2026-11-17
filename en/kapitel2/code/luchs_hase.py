# Fig. 2.2: Lynx and snowshoe hares (book, Section 2.1)
# number of pelts purchased by the Hudson's Bay Company (in thousands), 1900-1920, after Odum (1953)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

jahr = np.arange(1900, 1921)
hasen = [30, 47.2, 70.2, 77.4, 36.3, 20.6, 18.1, 21.4, 22, 25.4, 27.1, 40.3, 57, 76.6, 52.3, 19.5, 11.2, 7.6, 14.6, 16.2, 24.7]
luchse = [4, 6.1, 9.8, 35.2, 59.4, 41.7, 19, 13, 8.3, 9.1, 7.4, 8, 12.3, 19.5, 45.7, 51.1, 29.7, 15.8, 9.7, 10.1, 8.6]

for von, bis in [(1900, 1909), (1910, 1920)]:              # maxima per decade: the lynx follow the hares
    m = (jahr >= von) & (jahr <= bis)
    print(f"{von}-{bis}: most hares {jahr[m][np.argmax(np.array(hasen)[m])]}, most lynx {jahr[m][np.argmax(np.array(luchse)[m])]}")

plt.plot(jahr, hasen, "o--", color=(0.43, 0.04, 0.12), label="Snowshoe hares")
plt.plot(jahr, luchse, "s--", color=(0.89, 0.44, 0.49), label="Lynx")
plt.xlabel("Year"); plt.ylabel("Pelts (thousands)"); plt.legend()
plt.show()
