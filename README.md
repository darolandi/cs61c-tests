Proj2: MIPS Simulator
===========

Download (copy, symlink, pull, etc.) proj2/daniel.s and proj2/daniel.trace<br />
(Namings are such that they do not conflict with your existing tests.)

Put those files into your proj2/mipscode/ directory.

Open your Makefile:<br/>
Find a line that says: "ASM_TESTS := simple insts rt3 rt13 rt25" and append " daniel"<br />
Find a line that says: "runtest: mips insts_test rt3_test rt13_test rt25_test" and append " daniel_test"

Run "make runtest"

If your simulator hasn't passed my test, run "./mips mipscode/daniel"<br />
It will tell you which test# your simulator failed on (open daniel.s to see what the tests are)

This test uses the insts.s as template.