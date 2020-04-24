#!/bin/bash

mkdir -p ./simulations_output/gaussian_maps/

maps_count=2

start=0

counter=$((1+start))

rndseed=$((401+start))

while [ $counter -le $maps_count ]
do
    flask flask_gaussian.config RNDSEED $rndseed
    mv ./simulations_output/gaussian_maps/map-f1z1.fits ./simulations_output/gaussian_maps/gaussian_map_$counter.fits 
    mv ./simulations_output/gaussian_maps/recov-alm.dat ./simulations_output/gaussian_maps/recov_alm_$counter.dat
    mv ./simulations_output/gaussian_maps/recovCls.dat ./simulations_output/gaussian_maps/recovCls_$counter.dat

    if [ $counter -eq 1 ]
    then
        mv ./simulations_output/gaussian_maps/Xi-f1z1f1z1.dat ./simulations_output/gaussian_maps/Xi_flask.dat
        mv ./simulations_output/gaussian_maps/regCl-f1z1f1z1.dat ./simulations_output/gaussian_maps/regCl.dat
    else
        rm ./simulations_output/gaussian_maps/Xi-f1z1f1z1.dat
        rm ./simulations_output/gaussian_maps/regCl-f1z1f1z1.dat
    fi

    ((counter++))
    ((rndseed++))
done

echo $maps_count gaussian maps created!
