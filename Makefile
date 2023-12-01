# contrib/lt_tempfile/Makefile

MODULES = myfce

EXTENSION = myfce
DATA = myfce--1.0.sql myfce--1.0--1.1.sql myfce--1.1--1.2.sql
PGFILEDESC = "myfce - For compatibility with Mysql"

REGRESS = find_in_set truncate group_concat if

REGRESS_OPTS = --schedule=parallel_schedule --encoding=utf8


ifdef USE_PGXS
PG_CONFIG = lt_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/myfce
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif
