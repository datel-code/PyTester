' Arg 1:  Input1
' Arg 2:  Input2
' Result: Sum of inputs

Dim Input1
Dim Input2

Input1=CDbl(WScript.Arguments(0))
Input2=CDbl(WScript.Arguments(1))

WScript.Echo(Input1 + Input2)