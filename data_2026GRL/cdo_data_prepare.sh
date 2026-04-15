source /home/yfanaj/env_conda.sh
EXPS=(EC-Earth3_historical_CTL EC-Earth3_historical_fixed EC-Earth3_historical EC-Earth3_ssp585_ctl2095-99 EC-Earth3_ssp585_fixed EC-Earth3_ssp585)
NAMS=(RFD_HIST DEF_HIST WAT_HIST RFD_SSP5 DEF_SSP5 WAT_SSP5)

for i in ${!EXPS[@]} ; do 
    EXP=${EXPS[i]}
    echo ${EXP}

    DIR2="/home/yfanaj/myScripts/draw_gw4_heat/"
    if [[ ${EXP} == *"fixed"* ]]; then
        DIR="/disk/v184.a/hshenam/WRF_NCP/wrf451_onlw/run"
    else
        DIR="/disk/v184.a/hshenam/WRF_NCP/wrf451_snow/run"
    fi

    if [[ ${EXP} == *"ssp"* ]]; then
        YEAR="2090-2099"
    else
        YEAR="2005-2014"
    fi

    cdo -O -chname,IRVOL,IRR -fldmean -selindexbox,35,69,64,95 -selvar,T2,Q2,IRVOL ${DIR}_${EXP}/wrf${EXP}_monmean_${YEAR}.nc tmp_${EXP}_monmean.nc

    cdo -O -chname,SWmeanMEAN,SW -chname,TWmeanMEAN,TW -fldmean -selindexbox,35,69,64,95 -selvar,SWmeanMEAN,TWmeanMEAN,RH ${DIR2}/wrf${EXP}_extremeheat_monmean.nc tmp_${EXP}_heatmonmean.nc

    cdo -O -merge tmp_${EXP}_monmean.nc tmp_${EXP}_heatmonmean.nc wrf_${NAMS[i]}_monmean.nc

    cdo -O -fldmean -selvar,T2,Q2,RH,SWBGT,TW ${DIR2}/wrf${EXP}_extremeheat_dayJJA.nc wrf_${NAMS[i]}_dayJJA.nc
    cdo -O -selvar,SWmax95,TWmax95 ${DIR2}/wrf${EXP}_extremeheat_timmean.nc wrf_${NAMS[i]}_timmean.nc

done

rm -f tmp_*.nc