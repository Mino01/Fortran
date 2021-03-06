
module Jacobi_utils
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------

!-----------------------------------------------

    contains 
    
!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|
	  subroutine Init_field( nx, ny, u0, interior_value )

!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent( in ) :: nx
    integer, intent( in ) :: ny
    double precision, intent( in ) :: interior_value
    double precision, dimension( :, : ), intent ( in out ):: u0
!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------

!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------
    integer :: lx, ly
    integer :: x1, x2, x3, x4, y1, y2, y3, y4
!**********************************************************************
!  1) SET THE BOUNDARY CONDITIONS FOR THE JACOBI BOUNDARY PROBLEM.
! 
!  2) SET THE INTERIOR ISLAND VALUE OF THE JACOBI PROBLEM ARRAY.  
!
!   INPUT
!     NX             : THE X-DIMENSION OF THE JACOBI PROBLEM ARRAY. 
!     NY             : THE Y-DIMENSION OF THE JACOBI PROBLEM ARRAY. 
!     U0             : THE JACOBI ARRAY.
!     INTERIOR_VALUE : THE INTERIOR ISLAND VALUE OF THE JACOBI ARRARY. 
!   OUTPUT
!     U0             : THE JACOBI ARRAY.
!
!**********************************************************************

    !debug dimensions of u(x,y) 
    print*, "DEBUG: DIMENSIONS OF U(X,Y) IN init_field"
    print*, "SIZE OF U0: ", shape( u0 ) 
      
    !-- Window points ----

    x1 = nint( 0.25*nx )
    y1 = ( ny+2 )

    x2 = nint(0.75*nx)
    y2 = ( ny+2 )

    x3 = ( nx+2 )
    y3 = nint( 0.25*ny )

    x4 = ( nx+2 )
    y4 = nint( 0.75*ny ) 

    lx= nint( dble( nx )/10 )
    ly= nint( dble( ny )/10 )

!
! Set interior grid region to interior_value
!

    u0( 2:nx+1, 2:ny+1 ) = interior_value

!
! Set windows points. Shift by lx and ly respectively.                   
!

    u0( x1-lx/2:x1+lx/2, y1 ) = 100.0
    u0( x2-lx/2:x2+lx/2,y2 ) = 100.0
    u0( x3,y3-ly/2:y3+ly/2 ) = 100.0
    u0( x4,y4-ly/2:y4+ly/2 ) = 100.0

	end subroutine 

!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

    subroutine Read_binary_inputfile( nx, ny, u0, filename )

!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent( in ):: nx
    integer, intent( in ):: ny
    character( len=* ), intent( in ) :: filename
    !OBS NOT DIMENSION(:,:) FOR U0 IN READ BINARY ROUTINE
    !CORRECT DIMENSIONS (NX+2,NY+2) 
    double precision, dimension( nx+2, ny+2 ), intent( out ) :: u0
!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------
    integer, parameter :: iw = 17
!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------
    integer :: dnx, dny
!**********************************************************************
!  1) READS BINARY INPUT ARRAY IN NUMPY 'D' FLOATING POINT PRECISION. 
!  2) WORKAROUND FOR WRONG FLOATING POINT PYTHON DATATYPE...
!  3) FILENAME (INSTRUCTIONS): JACOBI.DAT
!   INPUT
!     NX             : THE X-DIMENSION OF THE JACOBI PROBLEM ARRAY. 
!     NY             : THE Y-DIMENSION OF THE JACOBI PROBLEM ARRAY. 
!     U0             : THE JACOBI ARRAY.
!     FILENAME       : THE FILENAME OF THE 
!   OUTPUT
!     U0             : THE JACOBI ARRAY.
!**********************************************************************
    open ( iw, file = filename, status = 'unknown', form = 'unformatted', action = 'read')
   		read( iw ) dnx
   		read( iw ) dny
   		read( iw ) u0        
    close( iw )
   
    !debug: read binary file  
    !write(*,'(a)') "DEBUG: Read binary file."   
    !write(*,'(f6.2)') u0
        
    !debug dimensions 
    !print*, "DEBUG: DIMENSIONS OF U(X,Y); Read_binary_inputfile" 
    !write(*,'(a,i4)') "Size of u0 is: ", shape(u0) 
  
    end subroutine Read_binary_inputfile

!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

    subroutine Write_binary_inputfile( nx, ny, u0, filename )
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------
!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent( in ) :: nx
    integer, intent( in ) :: ny
    !Dimension(:,:) for u0 in write binary routine
    double precision, dimension( :, : ), intent( in ) :: u0
    character( len=* ), intent( in ) :: filename
!-----------------------------------------------
!   L o c a l   P a r a m e t e r s

    integer, parameter :: iw = 11
!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------    

!**********************************************************************
!  1) WRITES BINARY INPUT ARRAY IN NUMPY 'D' DOUBLE FLOATING POINT 
!     PRECISION BYTE SIZE. 
!   INPUT
!     NX             : THE X-DIMENSION OF THE JACOBI PROBLEM ARRAY. 
!     NY             : THE Y-DIMENSION OF THE JACOBI PROBLEM ARRAY. 
!     U0             : THE JACOBI ARRAY.
!     FILENAME       : THE FILENAME OF THE 
!   OUTPUT
!     U0             : THE JACOBI ARRAY.
!
!**********************************************************************  

    open( iw, file = filename, status = 'unknown', form = 'unformatted', action= 'write' )
        write( iw ) nx
        write( iw ) ny
        write( iw ) u0
    close( iw ) 

    print*, "DEBUG: write binary file"
    print*, "DEBUG: Write binary file."   
    write(*,'( a, i4 )') "nx:", nx  
    write(*,'( a, i4 )') "ny:", ny 

    ! debug dimensions 
    print*, "DEBUG DIMENSIONS" 
    write( *, '( a )') "DEBUG: dimensions of u(x,y); Write_binary_inputfile" 
    write( *, * ) "SIZE OF U0 IS: ", shape( u0 ) 

    end subroutine 

!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

     subroutine Read_params( nx, ny, cx, cy, num_iters )
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------

!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent( out ) :: nx
    integer, intent( out ) :: ny
    double precision, intent( out ) :: cx
    double precision, intent( out ) :: cy
    integer, intent( out ) :: num_iters

!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------

!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------   

!**********************************************************************
!  1) READS GLOBAL JACOBI PROBLEM PARAMETERS  
!     FROM FILE PARAMS.CONF
!   INPUT
!     NX         : THE X-DIMENSION OF THE JACOBI ARRAY. 
!     NY         : THE Y-DIMENSION OF THE JACOBI ARRAY. 
!     CX         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DX.
!     CY         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DY.
!     NUM_ITERS   : THE NUMBER OF ITERATIONS OF THE JACOBI PROBLEM.
!   OUTPUT
!
!**********************************************************************  
               open( unit=99, file = 'params.conf' , form = 'formatted' ) 
                         read( 99, '( i4, 5x )') nx 
                         read( 99, '( i4, 5x )') ny
                         read( 99, '( f6.2, 5x )') cx
                         read( 99, '( f6.2, 5x )') cy
                         read( 99, '( i4, 5x )') num_iters
               close(99)

     end subroutine

!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

    subroutine Write_params( nx, ny, cx, cy, num_iters)
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------

!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!----------------------------------------------- 
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent( in ) :: nx
    integer, intent( in ) :: ny
    double precision, intent( in ) :: cx
    double precision, intent( in ) :: cy
    integer, intent( in ) :: num_iters
    
!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------

!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!----------------------------------------------- 

!**********************************************************************
!  1) WRITES THE GLOBAL JACOBI PROBLEM PARAMETERS  
!     TO FILE PARAMS.CONF
!   INPUT
!     NX         : THE X-DIMENSION OF THE JACOBI ARRAY. 
!     NY         : THE Y-DIMENSION OF THE JACOBI ARRAY. 
!     CX         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DX.
!     CY         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DY.
!     NUM_ITERS  : THE NUMBER OF ITERATIONS OF THE JACOBI PROBLEM.
!   OUTPUT
!
!**********************************************************************  
                          
    open( unit = 80, file = 'params.conf', form = 'formatted' )
        write( 80, '( i4, 5x )') nx
        write( 80, '( i4, 5x )') ny
        write( 80, '( f6.2, 5x )') cx
        write( 80, '( f6.2, 5x )') cy
        write( 80, '( i4, 5x )') num_iters
    close(80)
    
    end subroutine 

!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

     subroutine Jacobi_step( nx, ny, cx, cy, u0 )
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------

!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent( in ) :: nx
    integer, intent( in ) :: ny
    double precision, intent(in) :: cx
    double precision, intent(in) :: cy
    ! change of dimesion nx+2 -> :
    double precision, dimension( :, : ), intent( in out ) :: u0
!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------
    double precision, dimension( :, : ), allocatable :: u1

!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------  
    integer :: i, j
!**********************************************************************
!  1) PDE JACOBI SOLVER FOR JACOBI GRID.
!
!   INPUT
!     NX         : THE X-DIMENSION OF THE JACOBI ARRAY. 
!     NY         : THE Y-DIMENSION OF THE JACOBI ARRAY. 
!     CX         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DX.
!     CY         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DY.
!     NUM_ITERS  : THE NUMBER OF ITERATIONS OF THE JACOBI PROBLEM.
!     U0         : THE JACOBI GRID.
!   OUTPUT
!     U0         : THE JACOBI ARRAY AS SOLVED.
!**********************************************************************               

    allocate( u1( nx+2, ny+2 ) )
    
        do j= 2, ny+1                         
            do i= 2, nx+1                 

                  u1( i, j ) = ( ( 1+0.5*cx)*u0( i+1, j ) &
                          + ( 1-0.5*cx)*u0( i-1, j ) &
                          + ( 1+0.5*cy )*u0( i, j+1 ) &
                          + ( 1-0.5*cy )*u0( i, j-1) )/4

            end do
        end do

        ! keep boundary values of grid
        ! update all interior u values
			  
			  u0( 2:nx+1, 2:ny+1 ) = u1( 2:nx+1, 2:ny+1 )
             
    end subroutine 
      
!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

    subroutine Jacobi_step_parallel( nx_local, ny_local, cx, cy, u0_part )
!-----------------------------------------------
!   M o d u l e s
!-----------------------------------------------

!-----------------------------------------------
!   I n t e r f a c e   B l o c k s
!-----------------------------------------------
    implicit none
!-----------------------------------------------
!   D u m m y   A r g u m e n t s
!-----------------------------------------------
    integer, intent(in) :: nx_local
    integer, intent(in) :: ny_local
    double precision, intent(in) :: cx
    double precision, intent(in) :: cy
    ! change of dimesion nx+2 --> :
    double precision, dimension( :, : ), intent( in out ) :: u0_part  
!-----------------------------------------------
!   L o c a l   P a r a m e t e r s
!-----------------------------------------------
    double precision, dimension( :, : ), allocatable :: u1_part	   

!-----------------------------------------------
!   L o c a l   V a r i a b l e s
!-----------------------------------------------   
    integer :: i, j   
    
!**********************************************************************
!  1) PARALLEL PDE JACOBI SOLVER FOR JACOBI GRID.
!
!   INPUT
!     NX         : THE X-DIMENSION OF THE JACOBI ARRAY. 
!     NY         : THE Y-DIMENSION OF THE JACOBI ARRAY. 
!     CX         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DX.
!     CY         : THE PREFACTOR FOR FIRST PARTIAL DERIVATIVE DY.
!     NUM_ITERS  : THE NUMBER OF ITERATIONS OF THE JACOBI PROBLEM.
!     U0_PART    : THE JACOBI GRID.
!     U1_PART    : THE UPDATED NEW JACOBI GRID.
!   OUTPUT
!     U0_PART    : THE JACOBI GRID AS SOLVED.
!**********************************************************************           

    allocate( u1_part( nx_local, ny_local ) )

    do j = 1, ny_local                    
        do i = 1, nx_local                 


            u1_part( i, j ) = ( ( 1+0.5*cx)*u0_part( i+1, j ) &
                          + ( 1-0.5*cx)*u0_part( i-1, j ) &
                          + ( 1+0.5*cy )*u0_part( i, j+1 ) &
                          + ( 1-0.5*cy )*u0_part( i, j-1 ) )/4

        end do
    end do

    ! update all interior u values
    u0_part( 1:nx_local+1, 1:ny_local+1) = u1_part( 1:nx_local+1, 1:ny_local+1 )       
			  
    return 
			    
    end subroutine 
    
!***|****1****|****2****|****3****|****4****|****5****|****6****|****7****|****8****|

end module 


