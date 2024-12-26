#Title: Windows Service Restart
#Description: Restarts whichever service is provided as the first argument
#WIP
Param (
[Parameter(Mandatory=$true)] [String]$ServiceName
)
[System.Collections.ArrayList]$ServicesToRestart = @()
#Logging
$logFile="E:\Scripts\Logs\$ServiceName.RestartLog.log"
function Log-Write{
   Param ([string]$logstring)
   Add-content $LogFile -value "$(Get-Date)    $logstring"
}
function Custom-GetDependServices ($ServiceInput)
{
	Log-Write "Name of `$ServiceInput: $($ServiceInput.Name)"
	Log-Write "Number of dependents: $($ServiceInput.DependentServices.Count)"
	If ($ServiceInput.DependentServices.Count -gt 0)
	{
		ForEach ($DepService in $ServiceInput.DependentServices)
		{
			Log-Write "Dependent of $($ServiceInput.Name): $($Service.Name)"
			If ($DepService.Status -eq "Running")
			{
				Log-Write "$($DepService.Name) is running."
				$CurrentService = Get-Service -Name $DepService.Name
				
                # get dependancies of running service
				Custom-GetDependServices $CurrentService                
			}
			Else
			{
				Log-Write "$($DepService.Name) is stopped. No Need to stop or start or check dependancies."
			}
			
		}
	}
    Log-Write "Service to restart $($ServiceInput.Name)"
    if ($ServicesToRestart.Contains($ServiceInput.Name) -eq $false)
    {
        Log-Write "Adding service to restart $($ServiceInput.Name)"
        $ServicesToRestart.Add($ServiceInput.Name)
    }
}
# Get the main service
$Service = Get-Service -Name $ServiceName
# Get dependancies and stop order
Custom-GetDependServices -ServiceInput $Service
Log-Write "-------------------------------------------"
Log-Write "Stopping Services"
Log-Write "-------------------------------------------"
foreach($ServiceToStop in $ServicesToRestart)
{
    Log-Write "Stop Service $ServiceToStop"
    Stop-Service $ServiceToStop -Verbose #-Force
}
Log-Write "-------------------------------------------"
Log-Write "Starting Services"
Log-Write "-------------------------------------------"
# Reverse stop order to get start order
$ServicesToRestart.Reverse()
foreach($ServiceToStart in $ServicesToRestart)
{
    Log-Write "Start Service $ServiceToStart"
    Start-Service $ServiceToStart -Verbose
}
Log-Write "-------------------------------------------"
Log-Write "Restart of services completed"
Log-Write "-------------------------------------------"
#Collect and send log file via email
#$logContent=[IO.File]::ReadAllText($logFile)
#send-mailmessage -from notifications@yourdomain.com -to you@oyourdomain.com -subject "$ServiceName restarted" -body "$logContent" -Attachments $logFile -smtpserver smtp.yourdomain.com