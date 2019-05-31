################################################################################
################# - MAKEFILE STATIC VARIABLES - ################################
################################################################################

sfunction-sources := ${sources} ${sfunction-source-file}

sfunction-objects       := $(filter %.o,$(subst   .c,.o,$(sfunction-sources)))
sfunction-objects       += $(filter %.o,$(subst  .cc,.o,$(sfunction-sources)))
sfunction-objects       += $(filter %.o,$(subst .cpp,.o,$(sfunction-sources)))
sfunction-dependencies  := $(subst .o,.d,$(sfunction-objects))

ifeq ($(parallelize),true)
# parallel compilation variables
   libtarget     := $(libdir)/lib$(packagename).a
   exetarget     := $(bindir)/$(packagename)
   pkgconfigfile := $(packagename).pc
else
   libtarget     := $(libdir)/lib$(packagename).a
   exetarget     := $(bindir)/$(packagename)
   pkgconfigfile := $(packagename).pc
endif

ARCH 		:= $(shell getconf LONG_BIT)

mexsuffix 	:= $(mex$(ARCH)suffix)

sfunctiontarget	 := $(sfunctiondir)/$(packagename).$(mexsuffix)

automakefile := make.auto
