# fpcRun
FPC Run, will run a program after compiling it. 

Avoiding the need to compile and then run (two commands at a terminal, or two steps)

Just one step with fpr.exe (windows) or fpr (unix) 

More detailed info below:

Runs program after compiling. Initially was going to be fpcrun.exe but shortened to fpr.exe or fpr on unix for easy usage at command line fpr special option: use =v for verbose output

Potential issues: if the -o option is used to specify a different exe and this -o option exists inside an fpc.cfg file, this program fpr knows nothing about it.  This fpr program will try to run the program as the source file program name.

If the -o option is used at the command line it works fine as fpr detects this.

License: you may use this code under MIT or BSD license (most open that can be) 
