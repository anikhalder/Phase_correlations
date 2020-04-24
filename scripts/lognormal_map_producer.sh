#!/bin/bash

echo "Please provide the same logshift parameter for delta field as you've entered in the field_info.dat (in the data folder) file:"
read logshift_delta

mkdir -p ./simulations_output/lognormal_maps/logshift_$logshift_delta

maps_count=2

start=0

counter=$((1+start))

rndseed=$((401+start))

while [ $counter -le $maps_count ]
do
    flask flask_lognormal.config RNDSEED $rndseed
    mv ./simulations_output/lognormal_maps/map-f1z1.fits ./simulations_output/lognormal_maps/logshift_$logshift_delta/lognormal_map_$counter.fits 
    mv ./simulations_output/lognormal_maps/recov-alm.dat ./simulations_output/lognormal_maps/logshift_$logshift_delta/recov_alm_$counter.dat
    mv ./simulations_output/lognormal_maps/recovCls.dat ./simulations_output/lognormal_maps/logshift_$logshift_delta/recovCls_$counter.dat

    if [ $counter -eq 1 ]
    then
        mv ./simulations_output/lognormal_maps/Xi-f1z1f1z1.dat ./simulations_output/lognormal_maps/logshift_$logshift_delta/Xi_flask.dat
        mv ./simulations_output/lognormal_maps/regCl-f1z1f1z1.dat ./simulations_output/lognormal_maps/logshift_$logshift_delta/regCl.dat
    else
        rm ./simulations_output/lognormal_maps/Xi-f1z1f1z1.dat
        rm ./simulations_output/lognormal_maps/regCl-f1z1f1z1.dat
    fi

    ((counter++))
    ((rndseed++))
done

echo $maps_count lognormal maps created!
