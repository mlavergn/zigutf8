###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

###############################################

st:
	open -a SourceTree .

clean:
	rm -rf zig-build zig-cache