
import pandas as pd
import numpy as np

time_rows = pd.DataFrame(columns = ["Cython", "eucdist", "dotprod"],
                         index = [100, 500, 1000, 1500], dtype=np.float64)
time_rows['Cython'] = [55.364, 55.48, 40.413, 56.729]
time_rows['eucdist'] = np.ones(4)
time_rows["dotprod"] = [0.625, 0.614, 0.468, 0.617]
base_time = [3.045, 75.231, 315.346, 982.838]