
CC=gcc -O3 -Wall -Winline -march=pentium2 
RC=windres -O coff

yadif.dll: yadif.o yadif.res
	${CC} -shared yadif.o yadif.res avisynth.lib -o yadif.dll
	strip yadif.dll

yadif.o: yadif.c
	${CC} -c yadif.c

yadif.res: yadif.rc
	${RC} -i yadif.rc -o yadif.res

