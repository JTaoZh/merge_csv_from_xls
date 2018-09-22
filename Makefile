main: csv_merge.c
	i686-w64-mingw32-gcc csv_merge.c -o csv_merge -static -DWIN

clean: 
	rm -f csv_merge{,.exe}