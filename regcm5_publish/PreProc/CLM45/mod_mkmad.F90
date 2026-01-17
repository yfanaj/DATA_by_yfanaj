! yfanaj write this file similar to mod_mkmad.F90 on 27-Dec-2024
! yfanaj extract data from previous h0 irr, see globdat/GWE
! yfanaj read mad here from globdat/CLM45/surface/mksrf_mad.nc
module mod_mkmad
  use mod_realkinds
  use mod_intkinds
  use mod_constants
  use mod_dynparam
  use mod_grid
  use mod_rdldtr

  implicit none

  private

  public :: mkmad

  character(len=16) , parameter :: varname = 'MAD_2d'

  contains

  subroutine mkmad(madfile,mask,mad)
    implicit none
    character(len=*) , intent(in) :: madfile
    real(rkx) , dimension(:,:) , intent(in) :: mask
    real(rkx) , dimension(:,:) , intent(out) :: mad
    integer(ik4) :: i , j
    type(globalfile) :: gfile
    character(len=256) :: inpfile

    inpfile = trim(inpglob)//pthsep//'CLM45'// &
                             pthsep//'surface'//pthsep//madfile
    call gfopen(gfile,inpfile,xlat,xlon,ds*nsg,roidem,i_band)
    call gfread(gfile,varname,mad,h_missing_value)
    call gfclose(gfile)
    call bestaround(mad,h_missing_value)
    do i = 1 , iysg
      do j = 1 , jxsg
        if ( mask(j,i) < 0.5_rkx ) then
          mad(j,i) = h_missing_value
        else
          mad(j,i) = max(d_zero,mad(j,i))
          mad(j,i) = min(mad(j,i),1.0_rkx)
        end if
      end do
    end do
  end subroutine mkmad

end module mod_mkmad
! vim: tabstop=8 expandtab shiftwidth=2 softtabstop=2
