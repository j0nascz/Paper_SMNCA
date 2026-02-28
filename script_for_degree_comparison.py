import pandas as pd
import matplotlib.pyplot as plt

deg_bac = pd.read_csv("degrees_bac.csv").iloc[:,0].tolist()
deg_vir = pd.read_csv("degrees_vir.csv").iloc[:,0].tolist()

plt.figure()
plt.hist(deg_bac, bins=50, alpha=0.6, label="Bac")
plt.hist(deg_vir, bins=50, alpha=0.6, label="Vir")
plt.xlabel("Degree")
plt.ylabel("Frequency")
plt.title("Degree Distribution: Bac vs Vir")
plt.legend()
plt.show()