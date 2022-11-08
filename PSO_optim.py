import numpy as np
import pyswarms as ps
from pyswarms.utils.plotters import plot_cost_history  # ,\
#    plot_contour, plot_surface
import matplotlib.pyplot as plt
import subprocess


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

    # For each particle in x
    for k in range(0, len(x), 1):
        # writing particle x to file smc_param.m
        with open('smc_param.m', 'w', encoding='utf-8') as f:
            f.write('tr_L=' + repr(x[k, 0]) + ';\ntr_H='
                    + repr(x[k, 1]) + ';\nksmc='
                    + repr(x[k, 2]) + ';\n')
        # Run MATLAB script
        subprocess.run(
            'matlab -nodisplay -nojvm -batch "run_simulink"',
            shell=True, check=True)
        # Reading file outputs.csv is outside the for loop

    # Read file outputs.csv generated by MATLAB script
    thd_str = np.genfromtxt('outputs.csv', delimiter=',')
    # Compute cost
    j = (thd_str ** 2.0).sum(axis=1)

    return j


# Preconfigure Simulink to stop retaining data
subprocess.run(
    'matlab -nodisplay -nojvm -batch "func_confdatainsp(false,true,0)"',
    shell=True, check=True)

# Set-up optimizer
options = {'c1': 2.5, 'c2': 1.5, 'w': 2}
max_bound = 500 * np.ones(3)
min_bound = 0.01 * np.ones(3)
min_bound[2] = 0.1
max_bound[2] = 2
bounds = (min_bound, max_bound)
optimizer = ps.single.GlobalBestPSO(n_particles=40, dimensions=3,
                                    options=options, bounds=bounds)
optimizer.optimize(sphere_mod_simulink, iters=25)

# Reconfigure Simulink to save data as before
subprocess.run(
    'matlab -nodisplay -nojvm -batch "func_confdatainsp(true,true,20)"',
    shell=True, check=True)

# Plot the cost
plot_cost_history(optimizer.cost_history)
plt.show()
