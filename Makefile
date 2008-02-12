CC	= gcc
CFLAGS	= -g -O2 -fPIC -Wall
LIBDIR	= /usr/lib
LIBX86	= libx86
VERSION	= 1

CFILES	= $(wildcard *.c)
OBJS	= $(CFILES:.c=.o)

LIB_SO	= $(LIBX86).so.$(VERSION)

%.o: %.c
	$(CC) -c $(CFLAGS) $<

all: shared

shared: $(LIB_SO)

install: shared
	install -D $(LIB_SO) $(DESTDIR)$(LIBDIR)/$(LIB_SO)
	ln -snf $(LIB_SO) $(DESTDIR)$(LIBDIR)/$(LIBX86).so
	install -D include/libx86.h $(DESTDIR)/usr/include/libx86.h

$(LIB_SO): .depend $(OBJS)
	$(CC) -shared -Wl,-soname,$(LIB_SO) $(OBJS) -o $(LIB_SO)

clean:
	rm -f *.o *~ include/*~ *.so.* .depend


ifneq "$(MAKECMDGOALS)" "clean"
.depend: $(CFILES)
	@$(CC) -MG -MM $(CFLAGS) $(CFILES) >$@
-include .depend
endif
