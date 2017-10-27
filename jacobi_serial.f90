    program Jacobi_serial
!------------------------------------------------------------------------------------
!   AUTHOR: MARTIN A. OLSSON 
!   LAST MODIFIED:  25 JULY 2017
!   DESCRIPTION:
! 
!   Solves the PDE d2u/dx2 + d2u/dy2 + cx*du/dx + cy*du/dy = 0 
!   using Jacobi iteration on a grid.
!
!   For boundary conditions, see subroutine init_field in module jacobi_utils.
!------------------------------------------------------------------------------------
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------
    use Jacobi_utils, only : Read_params, Read_binary_inputfile, Write_params, Write_binary_inputfile, Jacobi_step 
!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------

!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------

!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------
    integer :: nx, ny, iterations, num_iters
    double precision, dimension ( : , : ) , allocatable :: u0, u1  
    double precision :: cx, cy 
    double precision :: interior_value 
    double precision :: start_time, stop_time

!----------------------------------------------- 

    call cpu_time( start_time )
    call Read_params( nx, ny, cx, cy, num_iters )
    
    allocate( u1( nx+2, ny+2 ) )
	allocate( u0( nx+2, ny+2 ) ) 
  
    !debug parameters 
	write( *, * ) "PARAMETERS ARE:"
	write( *, * ) "NX:", nx
	write( *, * ) "NY:", ny
	write( *, * ) "CX:", cx
	write( *, * ) "CY:", cy
	write( *, * ) "NUMITERS:", num_iters

    call Read_binary_inputfile( nx, ny, u0, 'binary.dat' )

    write( *,'( a )' ) "DEBUG: u0 after binary.dat read" 
    write( *,'( f6.2 )' ) u0

    !debug dimensions of u(x,y) 
    write( *, '( a )' ) "DEBUG: dimensions of u(x,y); before jacobi step"
    write( *, * ) "Size of u0 is: ", shape( u0 )  
 
!
! START JACOBI ALGORITM           
!

     do iterations = 1, num_iters

          call Jacobi_step( nx, ny, cx, cy, u0 )

     end do
!
! END JACOBI ALGORITHM
!     
     
!
! debug u(x,y) after jacobi step
!    
    write( *, '( a )' ) "DEBUG: u(x,y) after jacobi step"
    write(*,'( f6.2 )' ) u0

!
! debug dimensions of u(x,y)
!

    print*, "DEBUG: dimensions of u(x,y); after jacobi step"
    write( *, * ) "Size of u0 is: ", shape( u0 ) 
      
    call Write_binary_inputfile( nx, ny, u0, 'jacobi.dat' )

    call cpu_time( stop_time )

    write( *, '( a10, f10.4, a8 )' ) "timing:", stop_time - start_time, "seconds"

end program 






