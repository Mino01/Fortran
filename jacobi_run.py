#!/user/bin/python 

#from numpy import 
from os import system
import subprocess 

class Batchfile:

    def __init__(self,name,numNodes,tasksPerNode,walltime,executable,batchscript): 
         #self.jac = jac 
         self.name = name 
         self.numNodes = numNodes
         self.tasksPerNode = tasksPerNode 
         self.wallTime = walltime 
         self.executable = executable 
         self.batchScript = batchscript 

    def writeScript(self): 
         self.slurmTemplate ="""#!/bin/bash
#SBATCH  -N %(numNodes)d
#SBATCH  --tasks-per-node=%(tasksPerNode)d
#SBATCH  --exclusive
#SBATCH  -t %(wallTime)s
#SBATCH  -J %(name)s
#SBATCH  -o %(name)s_%%j.out
#SBATCH  -e %(name)s_%%j.out

cat $0

mpirun -bind-to core %(executable)s"""


         scriptFile = open(self.batchScript , "w")
         scriptFile.write(self.slurmTemplate % self.__dict__)
         scriptFile.close()


    def submit(self): 
        #Replacing pde_jacobi.MPI with serial pde_jacobi in build directory.  
        #system("sbatch %s " %self.batchScript) 
        subprocess.call(['pde_jacobi.exe'])


#if __name__ == '__main__':
#
#     job = Batchfile(name="jacobi", numNodes=1, tasksPerNode=4, walltime='00:30:00', executable="jacobisolver", batchscript="subjob.sh")
#    #job.writeScript() 
#     job.submit() 

