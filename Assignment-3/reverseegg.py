import sys
import struct
egghunter=""
if (len(sys.argv) < 2):
	print "4 bytes string required in second param"
else:
	for i in range(0,4):
		egghunter += "\\x"+hex(ord(sys.argv[1][3-i])).replace('0x',"")

	print egghunter
