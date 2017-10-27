
from os import system
import sys 
sys.path.append("Build")

from numpy import *
from jacobi_utils import *
from os import system
import subprocess

#---clean from output files---------
system("rm -rf *.dat")
system("rm -rf *.out")
system("rm -rf *.png")
system("rm -rf *.conf")
#------------------------------------

# documentation of wrapped fortran routines 

print(jacobi_utils.init_field.__doc__)
print(jacobi_utils.write_binary_inputfile.__doc__)
 
nx = 100
ny = 100

class JacobiProblem:
    
	def __init__(self,nx,ny,cx,cy,numProcs,numIters,intValue,filename,paramFilename):
		self.filename=filename
		self.nx=nx
		self.ny=ny
		self.intValue=intValue
		self.cx=cx
		self.cy=cy
		self.numIters=numIters
		self.numProcs=numProcs
		self.u=[]
		self.paramFilename=paramFilename

	def setup(self):

                # Below the python 'd' double precision type is required for
                # correct reading of the correct byte types to avoid End-of-file errors. 
                # i.e. float64 is wrong. 

		self.u = zeros((self.nx+2, self.ny+2), 'd', order='F')  
		print(self.u) 
		jacobi_utils.init_field(self.nx,self.ny,self.u,self.intValue) 

                # Buggy wrapper reordering, check __doc__ ! 

		jacobi_utils.write_binary_inputfile(self.nx,self.ny,self.u,'binary.dat')
		print(self.u) 


	def write(self):      
		jacobi_utils.write_params(self.nx,self.ny,self.cx,self.cy,self.numIters)


	def printall(self): 
		print("Jac filename: %s " % self.filename)
		print("Jac nx: %d " % self.nx)
		print("Jac ny: %d " % self.ny)
		print("Jac intValue: %f" % self.intValue)
		print("Jac cx: %f " % self.cx)
		print("Jac cy: %f " % self.cy)
		print("Jac numIters: %d " % self.numIters)
		print("Jac numProcs: %d " % self.numProcs)

	def bypass(self): 
	        pass 
  	        #system("./bypass_python_init.exe")

	def getNx(self):
		return self.nx

	def getNy(self):
		return self.ny

	def getCx(self):
		return self.cx

	def getCy(self):
		return self.cy

	def getFilename(self):
		return self.filename

	def getIntValue(self):
		return self.intValue

	def getNumIters(self):
		return self.numIters

	def updateNumIters(self,input): 
		self.numIters = input 

	def updateNx(self, input):
		self.nx = input 

	def updateNy(self, input): 
		self.ny = input 

	def updateCx(self, input): 
		self.cx = input 

	def updateCy(self, input): 
		self.cy = input 
    
	def updateFilename(self, input): 
		self.filename = input 

	def updateIntValue(self, input): 
		self.intValue = input

	def getlattice(self):
		return self.u
               
if __name__ == '__main__':

	jac = JacobiProblem(nx=40,
                            ny=40,
                            cx=0.4,
                            cy=0.4,
                            numProcs=4,
                            numIters=2000,
                            intValue=0.0,
                            filename='binary.dat', 
                            paramFilename = 'params.conf')   

	jac.setup()
	jac.write()
        
