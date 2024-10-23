# contrib/lt_tempfile/Makefile

MODULE_big = myfce
OBJS = myfce.o \
	uint8.o


EXTENSION = myfce
DATA = myfce--1.0.sql myfce--1.0--1.1.sql myfce--1.1--1.2.sql myfce--1.2--1.3.sql myfce--1.3--1.4.sql myfce--1.4--1.5.sql myfce--1.5--1.6.sql myfce--1.6--1.7.sql \
	myfce--1.6.1--1.7.sql \
	myfce--1.7--1.8.sql
PGFILEDESC = "myfce - For compatibility with Mysql"

REGRESS = find_in_set truncate group_concat if substr sysdate

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
