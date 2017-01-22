{ Copyright Lars Olson 2017

 Runs program after compiling. Initially was going to be fpcrun.exe but
 shortened to fpr.exe or fpr on unix for easy usage at command line
 fpr special option: use =v for verbose output

 Potential issues: if the -o option is used to specify a different exe and this
 -o option exists inside an fpc.cfg file, this program fpr knows nothing about
 it.  This fpr program will try to run the program as the source file program
 name.

 If the -o option is used at the command line it works fine as fpr detects this.
 License: you may use this code under MIT or BSD license (most open that can be) }

program fpr;

{$mode objfpc}{$H+}

uses
  sysutils, strutils;

const
  FpcExe = {$IFDEF WINDOWS}'fpc.exe'{$ELSE}'fpc'{$ENDIF};

type
  TStringArray = array of string;

var
  VerboseOpt: boolean = false;

procedure VerboseMsg(s: string);
begin
  if VerboseOpt then writeln('VERBOSE: '+s);
end;

// gets all parameters sent in to command: paramstr(), and returns as array
function GetParams(out params: TStringArray): boolean;
var
  i: integer;
  count: integer;
  curParam: string;
begin
  result := false;
  count := ParamCount();
  if count < 1 then exit;
  SetLength(params, count);
  for i := 0 to count-1 do begin
    curParam := ParamStr(i+1);
    // copy all paramaters to array except "verbose" special FPR option
    if curParam <> '=v' then begin
      params[i] := curParam;
    end;
  end;
  if length(params) > 0 then result := true;
end;

// Runs fpc compiler. Returns false if couldn't run fpc
function RunFpc(out exitcode: integer): boolean;
var
  got: boolean;
  params: TStringArray;

begin
  result := false;
  got := GetParams(params);
  if got then begin
    exitcode := ExecuteProcess(FpcExe, params, []);;
    VerboseMsg('exit code: '+ IntToStr(exitCode));
    result := true;
  end else begin
    writeln('FPR simply runs fpc and then runs the compiled program after.');
    writeln('You typed fpr, there are no paramaters specified to pass to fpc.');
    writeln('Type fpc for help on fpc arguments.');
  end;
end;

function GetProgramName: string;
var
  i: integer;
  count: integer;
  param: string;
  outputExeOptFound: boolean;
begin
  result := '';
  outputExeOptFound := false;
  count := ParamCount();

  for i := 1 to count do begin
    param := ParamStr(i);
    // try to find -o as a compiler option, which specifies a different output exe
    if (param[1] = '-') and (param[2] = 'o') then begin
      //-oOutputExeName compiler option found...
      result := MidStr(param, 3, length(param)-2);
      outputExeOptFound := true;
    end;
  end;

  if outputExeOptFound then exit;

  // else find program name by its source file if no -o option found
  for i := 1 to count do begin
    param := ParamStr(i);
    // return program name if it isn't a compiler option starting with dash
    if param[1] <> '-' then begin
      result := param;
      // strip source file extension, i.e. .pp or .pas
      result := ChangeFileExt(result, '');
      {$ifdef windows}
       result := result + '.exe';  // generally executables have exe extension on windows
      {$endif}
    end;
  end;

end;

procedure RunCompiledProg;
var
  exitCode: integer;
  prog: string;
begin
  prog := GetProgramName;
  if prog = '' then begin
    writeln('Program name not found in command line arguments of FPR');
  end;
  writeln('-------- Program Output Below --------');
  exitCode := ExecuteProcess(prog, '', []);;
  VerboseMsg('exit code of compiled program: '+ IntToStr(exitCode));
end;

// if special =v option is sent to fpr exe, more verbose information is displayed
procedure CheckVerbose;
var
  i: integer;
  count: integer;
  param: string;
begin
  count := ParamCount();
  for i := 1 to count do begin
    param := ParamStr(i);
    if param = '=v' then begin
      VerboseOpt := true;
      break;
    end;
  end;
end;

var
  exitcode: integer;
  ran: boolean;
begin
  CheckVerbose;
  ran := RunFpc(exitcode);
  if ran then begin
    // if exit code is not zero then compilation aborted. Only run program if compilation was successful
    if exitcode = 0 then RunCompiledProg;
  end;
end.

