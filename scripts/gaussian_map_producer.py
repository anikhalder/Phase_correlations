import time
start = time.time()

import numpy as np
import healpy as hp
import os

def createFolder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print ('Error: Creating directory. ' +  directory)

# as l=0 and l=1 (and corresponding cl values of 0) are missing due to requirement of flask, we append them
# we also take only till l=8192 (before index 8191) for flask simulation
# therefore, we finally take l values from l=0 to l=8192 (and corresponding cl)

def read_cl():
    cell_file = './../data/buzzard_data/Cell_data-f1z1f1z1.dat'
    l = np.loadtxt(cell_file, usecols=(0))
    l = np.append(np.array([0.0,1.0]), l[:8191])
    cl = np.loadtxt(cell_file, usecols=(1))
    cl = np.append(np.array([0.0,0.0]), cl[:8191])
    return l, cl

l , cl = read_cl()

## HEALPY

maps_count = 2
NSIDE = 2048
rndseed = 401
lmax = 3*NSIDE-1

map_type = 'gaussian'

createFolder('./simulations_output/'+map_type+'_maps/')

for j in range(maps_count):    
    print('Gaussian Map # ',str(j+1))
    np.random.seed(rndseed+j)
    density_field = hp.synfast(cl, NSIDE)
    hp.write_map('./simulations_output/'+map_type+'_maps/'+map_type+'_map_'+str(j+1)+'.fits', density_field, overwrite='true')

    recov_alm = hp.sphtfunc.map2alm(density_field, lmax=lmax)
    recovCls = hp.sphtfunc.anafast(density_field, lmax=lmax)

    np.savetxt('./simulations_output/'+map_type+'_maps/recov_alm_'+str(j+1)+'.dat', recov_alm.T)
    np.savetxt('./simulations_output/'+map_type+'_maps/recovCls_'+str(j+1)+'.dat', recovCls.T)

end = time.time()
print('\nTime taken for execution (seconds): ', end - start)
