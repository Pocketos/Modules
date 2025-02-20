Function greeting {
$Hour = (Get-Date).Hour
If ($Hour -lt 12) {"Good Morning $Env:UserName"}
ElseIf ($Hour -gt 16) {"Good Evening $Env:UserName"}
Else {"Good Afternoon $Env:UserName"}
}