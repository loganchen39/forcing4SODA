#!/bin/bash
# #!/bin/tcsh

#PBS  -A UMCP0014   
#PBS  -l walltime=12:00:00              
# #PBS  -l walltime=12:00:00              
# #PBS  -l select=1:ncpus=8:mpiprocs=8
# #PBS  -l select=1:ncpus=36:mpiprocs=36
#PBS  -l select=1:ncpus=1:mpiprocs=1 
#PBS  -N soda
#PBS  -j oe
#PBS  -q main
# #PBS  -q preempt
#PBS -M lchen2@umd.edu

module load conda/latest
conda activate npl

module load cdo
module load nco

# python3 02.ERA5_addLastHourOfYear_Accu.py > soda_02.log
python3 05.ERA5_ChangeAttrTime.py > soda_05.log
 
exit 0
