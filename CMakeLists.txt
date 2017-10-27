project(pde_jacobi)
cmake_minimum_required(VERSION 3.5)
enable_language(Fortran)

# ---- Working standalone application

add_executable(pde_jacobi.exe jacobi_serial.f90 jacobi_utils.f90 )

# ---- Library to link with f2py code ----------------

add_library(jacobi_utils STATIC jacobi_utils.f90 )

# ----  position independent code to link with a shared object ----

set_property(TARGET jacobi_utils PROPERTY POSITION_INDEPENDENT_CODE ON)

add_custom_command(TARGET jacobi_utils POST_BUILD
       COMMAND f2py -m jacobi_utils -c ${PROJECT_SOURCE_DIR}/jacobi_utils.f90 -ljacobi_utils -L${CMAKE_BINARY_DIR}
)


