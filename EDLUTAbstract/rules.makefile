################################################################################
################################ - MAKEFILE RULES - ############################
################################################################################

compiler	:= g++
mex		:= $(matlabrootdir)/bin/mex
CXX 		:= ${compiler}

.PHONY		: sfunction
sfunction	: $(sfunctiontarget) 
	@echo
	@echo ------------------ making sfunction file $(sfunctiontarget)
	@echo

$(sfunctiontarget)	: $(sfunction-objects)
	@echo compiler path = ${mex}
	@echo
	@echo ------------------ making sfunction file
	@echo
	@mkdir -p $(sfunctiondir)
	$(mex) $(MEXFLAGS) $^ $(LDFLAGS) -o $@

.PHONY : tags
tags   :
	@echo
	@echo ------------------ creating tag entries
	@echo
	@etags $(includedir)/*.h $(includedir)/*.h $(srcdir)/*.cpp $(srcdir)/*.cc $(srcdir)/*.c

.PHONY : dox
dox    : Doxyfile
	@echo
	@echo ------------------ creating documentation
	@echo
	@doxygen Doxyfile

.PHONY   : doxclean
doxclean :
	@echo
	@echo ------------------ removing documentation
	@echo
	@rm -rf doc

.PHONY : distclean
distclean  :
	@echo
	@echo ------------------ cleaning everything
	@echo
	@rm -f $(pkgconfigfile) $(libtarget) $(packagename) $(objects) ${exetarget}.exe ${exe-objects} $(dependencies) ${exe-dependencies} ${mextarget} ${mex-objects} {mex-dependencies} ${sfunctiontarget} ${sfunction-objects} {sfunction-dependencies} TAGS gmon.out

.PHONY : clean
clean  :
	@echo
	@echo ------------------ cleaning *.o exe lib
	@echo
	@rm -f $(objects) ${exe-objects} ${libtarget} ${exetarget}.exe ${mextarget} ${mex-objects} ${sfunctiontarget} ${sfunction-objects} TAGS gmon.out

.PHONY : clear
clear :
	@rm -rf \#* ${dependencies}

ifneq "$(MAKECMDGOALS)" "clean"
  include $(dependencies)
endif

%.d : %.cc
	@echo
	@echo ------------------ creating dependencies for $@
	@echo
	$(compiler) $(CXXFLAGS) $(TARGET_ARCH) -MM $< | \
	sed 's,\($(notdir $*)\.o\) *:,$(dir $@)\1 $@: ,' > $@.tmp
	mv -f $@.tmp $@
	@echo

%.d : %.cpp
	@echo
	@echo ------------------ creating dependencies for $@
	@echo
	$(compiler) $(CXXFLAGS) $(TARGET_ARCH) -MM $< | \
	sed 's,\($(notdir $*)\.o\) *:,$(dir $@)\1 $@: ,' > $@.tmp
	mv -f $@.tmp $@
	@echo


