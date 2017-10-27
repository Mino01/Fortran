#!/bin/env python 

# -*- coding: utf-8 -*-

import sys
sys.path.append("Build")

from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5 import uic
from PyQt5.QtGui import * 
import numpy as np
import matplotlib.pyplot as plt
from PyQt5.QtGui import QPixmap # --- Required for QPixmap
from jacobi_input import * 
from jacobi_run import *  
from jacobi_utils import *
from os import system
import subprocess

#---clean from output files---------
system("rm -rf *.dat")
system("rm -rf *.out")
#------------------------------------


class JacobiApp:

    def __init__(self, app, jac, job):
        """Class constructor"""
        self.app = app
        self.jac = jac
        self.job = job
        self.jac.bypass()
        self.ui = uic.loadUi('jacobi.ui')
        self.nx=jac.getNx()
        self.ny=jac.getNy() 
        self.cx=jac.getCx()
        self.cy=jac.getCy()
        self.filename=jac.getFilename()
        self.intValue=jac.getIntValue()
        self.numIters=jac.getNumIters()
        self.u = jac.getlattice()
        self.ui.setWindowTitle('Jacobi PDE parameters')
        self.plotInit()
        self.jac.printall() 

        #-- Assign labels ---------------------------------------
        self.ui.iterations_label.setText("Iterations")
        self.ui.iterations_label.setAlignment(Qt.AlignCenter)

        self.ui.nx_label.setText("nx")
        self.ui.nx_label.setAlignment(Qt.AlignCenter)

        self.ui.ny_label.setText("nx")
        self.ui.ny_label.setAlignment(Qt.AlignCenter)

        self.ui.cx_label.setText("cx")
        self.ui.cx_label.setAlignment(Qt.AlignCenter)

        self.ui.cy_label.setText("cy")
        self.ui.cy_label.setAlignment(Qt.AlignCenter)

        self.ui.interiorvalue_label.setText("Interior value")
        self.ui.interiorvalue_label.setAlignment(Qt.AlignCenter)

        #---- connect actions to gui objects --------------------

        self.ui.iterations.setText("100")
        self.ui.iterations.textChanged.connect(self.onTextChanged1)
        
        self.ui.nx.setText("38")
        self.ui.nx.textChanged.connect(self.onTextChanged2)   

        self.ui.ny.setText("38")
        self.ui.ny.textChanged.connect(self.onTextChanged3)

        self.ui.cx.setText("0.4")
        self.ui.cx.setValidator(QDoubleValidator(0.0,1.0,2))
        self.ui.cx.textChanged.connect(self.onTextChanged4)

        self.ui.cy.setText("0.4")
        self.ui.cy.setValidator(QDoubleValidator(0.0,1.0,2))
        self.ui.cy.textChanged.connect(self.onTextChanged5)

        self.ui.interiorvalue.setText("0.4")
        self.ui.interiorvalue.setValidator(QDoubleValidator(0.0,1.0,2))
        self.ui.interiorvalue.textChanged.connect(self.onTextChanged6)

        self.ui.jobname.setText("jacobi")  
        self.ui.jobname.textChanged.connect(self.onTextChanged7)

        #Assign QPushButton           
        self.ui.submitbutton.resize(100,50)
        self.ui.submitbutton.clicked.connect(self.onSubmitButtonClicked)
        
        self.ui.show() 
        self.ui.raise_()

    def onTextChanged1(self, text):
        self.iterations = int(text)
        print(self.iterations)
        jac.updateNumIters(self.numIters)
         
    def onTextChanged2(self, text): 
        self.nx = int(text)  
        print(self.nx)
        jac.updateNx(self.nx)

    def onTextChanged3(self, text):
        self.ny = int(text)
        print(self.ny)
        jac.updateNy(self.ny)

    def onTextChanged4(self, text):
        self.cx = float(text)
        print(self.cx)
        jac.updateCx(self.cx)

    def onTextChanged5(self, text):
        self.cy = float(text)
        print(self.cy)
        jac.updateCy(self.cy)

    def onTextChanged6(self, text):
        self.intValue = float(text) 
        print(self.intValue)
        jac.updateIntValue(self.intValue)
         
    def onTextChanged7(self, text):
        self.filename = text
        print(self.filename)
        jac.updateFilename(self.filename)

    def onSubmitButtonClicked(self):
        """Respond to button click. Implements jacobi_run.py"""
        self.updateProblem() 
        self.tmpSubmit() 
        QMessageBox.information(self.ui,"JacobiPDE", "Submitted job. Wait...!")
        self.plotSolution()        

    def show(self):
            self.ui.show()
            self.ui.raise_()

    def getNumIters(self): 
        return self.numIters

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

    def updateUi(self): 
           self.ui.iterations.setText(str(self.jac.getNumIters())) 
           self.ui.nx.setText(str(self.jac.getNx()))
           self.ui.ny.setText(str(self.jac.getNy()))
           self.ui.cx.setText(str(self.jac.getCx()))
           self.ui.cy.setText(str(self.jac.getCy())) 
           self.ui.jobname.setText(str(self.jac.getFilename()))
           self.ui.interiorvalue.setText(str(self.jac.getIntValue()))

    def updateProblem(self): 
           self.jac.printall()
           self.jac.write()

    def tmpSubmit(self):
           subprocess.call(['pde_jacobi.exe'])

     #----Plotting---------------------------------------------

    def plotInit(self):
        self.u=jacobi_utils.read_binary_inputfile(self.nx,self.ny,'binary.dat')
        plt.figure()
        plt.imshow(self.u)
        plt.title('Initialized grid for u(x,y)')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.savefig('init.png')
        image = QPixmap("init.png")
        self.ui.imagepix.setPixmap(image)
        #---- external --- plt.show()

    def plotSolution(self):
        self.u=jacobi_utils.read_binary_inputfile(self.nx,self.ny,'jacobi.dat')
        plt.figure()
        plt.imshow(self.u)
        plt.title(' Full PDE solution u(x,y)')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.savefig('full_pde_solution.png')
        image = QPixmap("full_pde_solution.png")
        self.ui.imagepix.setPixmap(image)
        #---external --- plt.show()

         
if __name__ == '__main__':

    jac = JacobiProblem(nx=128,
                        ny=128,
                        cx=0.4,
                        cy=0.4,
                        numProcs=4,
                        numIters=2000,
                        intValue=0.0,
                        filename='binary.dat', 
                        paramFilename = 'params.conf') 

    jac.setup()
    jac.write()

    job = Batchfile(name='jacobi',
                    numNodes=1,
                    tasksPerNode=4,
                    walltime='00:30:00',
                    executable="pde_jacobi.exe",
                    batchscript="subjob.sh")

    app = QApplication(sys.argv)
    window = JacobiApp(app,jac,job)
    sys.exit(app.exec_())

