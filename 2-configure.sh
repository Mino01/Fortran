#!/bin/bash 

#Clean up 
rm -rf *.dat
rm -rf *.out 
rm -rf *.a
rm -rf *.so 
rm -rf *.conf
rm -rf *.mod
rm -rf cmake_install.cmake
rm -rf __pycache__
rm -rf Makefile
rm -rf CMakeFiles

#compile in working directory 
FC=/sw/easybuild/software/Core/GCCcore/6.3.0/bin/gfortran cmake .

#Build the project 

make 
