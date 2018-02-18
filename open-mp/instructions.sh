# INSTALL TAU
module load gcc/6.1.0
module load papi/5.4.3
module load openmpi/1.8.1
cd tau-2.26
./configure -prefix=/home/master/ppM/ppM-1-10/my_TAU -openmp -opari
./configure -prefix=/home/master/ppM/ppM-1-10/my_TAU -openmp -opari -papi=/soft/papi-5.4.3
./configure ­-prefix=/home/master/ppM/ppM-1-10/my_TAU –mpi -openmpi

# USE TAU
module load gcc/6.1.0
module load papi/5.4.3
module load openmpi/1.8.1
# export PATH=/home/master/ppM/ppM-1-10/my_TAU/x86_64/bin:$PATH

# STEP 2
export TAU_MAKEFILE=/home/master/ppM/ppM-1-10/my_TAU/x86_64/lib/Makefile.tau-openmp-opari
export TAU_OPTIONS=-optCompInst
# tau_cc.sh -lm -o openmp.test_Np lapFusionN.c
tau_cc.sh -lm -o openmp.test2 lapFusion2.c
./openmp.test_2p 512 500
tau_cc.sh -lm -o openmp.test4 lapFusion4.c
./openmp.test_4p 512 500
tau_cc.sh -lm -o openmp.test8 lapFusion8.c
./openmp.test_8p 512 500

# STEP 3
export TAU_TRACE=1
# tau_cc.sh -lm -o openmp.test_Np_trace lapFusionN.c
tau_cc.sh -lm -o openmp.test_2p_trace lapFusion2.c
./openmp.test_2p_trace 512 500
tau_cc.sh -lm -o openmp.test_4p_trace lapFusion4.c
./openmp.test_4p_trace 512 500
tau_cc.sh -lm -o openmp.test_8p_trace lapFusion8.c
./openmp.test_8p_trace 512 500

tau_treemerge.pl
tau2slog2 tau.trc tau.edf -o tau.slog2
jumpshot
