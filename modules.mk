mod_openqm.la: mod_openqm.slo
	$(SH_LINK) -rpath $(libexecdir) -module -avoid-version  mod_openqm.lo
DISTCLEAN_TARGETS = modules.mk
shared =  mod_openqm.la
