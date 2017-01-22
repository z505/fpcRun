# fpcRun
FPC Run, will run a program after compiling it. 

Avoiding the need to compile and then run (two commands at a terminal, or two steps)

Just one step with fpr.exe (windows) or fpr (unix) 

### Where to place fpr.exe or fpr executable?

On windows, place fpr.exe in the same directory as your fpc.exe executable. Then it will be in your path and you can use it at the command line just like using fpc

Unix: currently testing this out to see if ExecuteProcess works okay if fpr is in same directory as fpc. If not, fpr will have to be changed to use TProcess instead

### Usage

Just type in
    `fpr sourcefile`
the same way you would use fpc.exe or fpc. It runs the program after compiling.

Extra options:
    `fpr =v sourcefile`
The "=v" option specifes fpr to run in verbose mode giving more detailed notices.

### More detailed info below:

Runs program after compiling. Initially it was going to be fpcrun.exe but shortened to "fpr" for easy usage at command line (fpr.exe on windows).

Potential issues: if the -o option is used to specify a different exe and this -o option exists inside an fpc.cfg file, this program fpr knows nothing about it.  This fpr program will try to run the program as the source file program name or an -o option sent to the compiler at the command line. So if the -o option is used at the command line it works fine as fpr detects this.

### License 
You may use this code under MIT or BSD license (most open that can be) 
