! yfanaj write this file similar to mod_mklake.F90 on 29-Oct-2024
! yfanaj extract data from USGS, see globdat/GWE
! yfanaj read gwp here from globdat/CLM45/surface/mksrf_gwp.nc
module mod_mkgwp
  use mod_realkinds
  use mod_intkinds
  use mod_constants
  use mod_dynparam
  use mod_grid
  use mod_rdldtr

  implicit none

  private

  public :: mkgwp

  character(len=16) , parameter :: varname = 'GWP_STS'

  contains

  subroutine mkgwp(gwpfile,mask,gwp)
    implicit none
    character(len=*) , intent(in) :: gwpfile
    real(rkx) , dimension(:,:) , intent(in) :: mask
    real(rkx) , dimension(:,:) , intent(out) :: gwp
    integer(ik4) :: i , j
    type(globalfile) :: gfile
    character(len=256) :: inpfile

    inpfile = trim(inpglob)//pthsep//'CLM45'// &
                             pthsep//'surface'//pthsep//gwpfile
    call gfopen(gfile,inpfile,xlat,xlon,ds*nsg,roidem,i_band)
    call gfread(gfile,varname,gwp,h_missing_value)
    call gfclose(gfile)
    call bestaround(gwp,h_missing_value)
    do i = 1 , iysg
      do j = 1 , jxsg
        if ( mask(j,i) < 0.5_rkx ) then
          gwp(j,i) = h_missing_value
        else
          gwp(j,i) = max(d_zero,gwp(j,i))
          gwp(j,i) = min(gwp(j,i),1.0_rkx)
        end if
      end do
    end do
  end subroutine mkgwp

end module mod_mkgwp
! vim: tabstop=8 expandtab shiftwidth=2 softtabstop=2
