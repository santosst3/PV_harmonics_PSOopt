import numpy as np
import pyswarms as ps
from pyswarms.utils.plotters import plot_cost_history
import matplotlib.pyplot as plt
import subprocess
import multiprocessing as mp


def call_matlab(x):
    # writing matlab command with function syntax
    m_comm = 'matlab -nodisplay -nojvm -batch "run_simulink(' \
            + repr(x[0]) + ',' + repr(x[1]) + ',' + repr(x[2]) \
            + ',' + repr(x[3]) + ')"'
    # Run MATLAB script
    subprocess.run(m_comm, shell=True, check=True)
    # Reading file outputs.csv is outside the for loop


def sphere_mod_simulink(x):
    """Sphere objective function.

    Has a global minimum at :code:`0` and with a search domain of
        :code:`[-inf, inf]`

    Parameters
    ----------
    x : numpy.ndarray
        set of inputs of shape :code:`(n_particles, dimensions)`

    Returns
    -------
    numpy.ndarray
        computed cost of size :code:`(n_particles, )`
    """

    # Initialize j
    j = np.ndarray(shape=(len(x), 1), dtype=float)

    # Remove old outputs.csv and create a fresh one
    subprocess.run('rm outputs.csv', shell=True, check=True)
    subprocess.run('touch outputs.csv', shell=True, check=True)

    # Adding index as the last column of x
    x = np.append(x, np.arange(len(x)).reshape(x.shape[0], 1), axis=1)

    # Changing x from ndarray to a list of tuples for map function
    x_mod = list(map(tuple, x))

    # Parallel tasks with Pool
    with mp.Pool(processes=3) as pool:
        pool.map(call_matlab, x_mod, chunksize=10)

    # Read file outputs.csv generated by MATLAB script
    thd_str = np.genfromtxt('outputs.csv', delimiter=',')

    # Sort thd_str and remove index in column 1
    thd_str = thd_str[thd_str[:, 0].argsort()]
    temp1 = thd_str[:, 1:]

    # Compute cost
    j = (temp1 ** 2.0).sum(axis=1)

    return j


# Preconfigure Simulink to stop retaining data
subprocess.run(
    'matlab -nodisplay -nojvm -batch "func_confdatainsp(false,true,0)"',
    shell=True, check=True)

# Set-up optimizer
options = {'c1': 0.5, 'c2': 0.3, 'w': 0.9}  # , 'k': 10, 'p': 2}
max_bound = np.ones(3)
min_bound = np.ones(3)
min_bound[0] = 0.01
max_bound[0] = 100
min_bound[1] = 0.01
max_bound[1] = 1
min_bound[2] = 0.01
max_bound[2] = 1
bounds = (min_bound, max_bound)
optimizer = ps.single.GlobalBestPSO(n_particles=60, dimensions=3,  # 40 60
                                    options=options, bounds=bounds)
optimizer.optimize(sphere_mod_simulink, iters=17)  # 25 17

# Reconfigure Simulink to save data as before
subprocess.run(
    'matlab -nodisplay -nojvm -batch "func_confdatainsp(true,true,20)"',
    shell=True, check=True)

# Plot the cost
plot_cost_history(optimizer.cost_history)
plt.show()
