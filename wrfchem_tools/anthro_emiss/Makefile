.SUFFIXES: .o .f90

F90    = $(FC)
LIBS   = -L$(NETCDF_DIR)/lib $(AR_LIBS)
INCLUDE_MODULES = -I$(NETCDF_DIR)/include

ifeq ($(FC),lf95)
  FFLAGS = --g
else
  FFLAGS = -g
endif

ifeq ($(FC),pgf90)
  FFLAGS += -Mnosave -Ktrap=fp
endif

ifeq ($(FC),gfortran)
  FFLAGS += -ffree-line-length-none -fallow-argument-mismatch -fallow-invalid-boz
endif

ifeq ($(FC),lf95)
  FFLAGS += --nap --chk --pca --nsav --trace --trap --wide
endif

ifeq ($(FC),ifort)
  FFLAGS += -fpe0 -ftrapuv
endif

EXEC = anthro_emis 

OBJS = misc_definitions_module.o constants_module.o mo_calendar.o anthro_types.o mapper_types.o area_mapper.o anthro_utils.o data_file_utils.o anthro_emis.o

##dependencies
#$(OBJECTS) : makefile

${EXEC} :       ${OBJS}
		${F90} -o $@ ${OBJS} ${LIBS} 

.f90.o:
		${F90} ${FFLAGS} -c ${INCLUDE_MODULES} $<

cleanup:
		rm -f ${OBJS} *.mod

clean:
		rm -f core ${EXEC} ${OBJS} *.mod
