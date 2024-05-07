$servers = @('list','of','hostnames')
$emailbody
$emailfrom = "from@email.com"
$emailto = "to@email.com"

for($i=0; $i -lt $servers.Length; $i++){
    $lastboottime = (Get-WMIObject -Class Win32_OperatingSystem -ComputerName $servers[$i] -ErrorAction SilentlyContinue).LastBootUpTime
    $sysuptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
    $uptime = "   UPTIME           :    $($sysuptime.days) Days, $($sysuptime.hours) Hours, $($sysuptime.minutes) Minutes, $($sysuptime.seconds) Seconds"
    $server=$servers[$i]
    $emailBody += "$server $uptime`n"
    $PingResult = (Test-NetConnection -ComputerName $servers[$i] -InformationLevel Detailed).PingSucceeded
    $emailbody += "Can Ping: $PingResult`n"
}

Write-Host $emailbody


#Email send setup
$hash = @{
	from       = "$emailfrom"
	to         = "$emailto"
	subject    = "Server Uptime"
	smtpserver = "smtpserver"
	port       = "25"
	body       = "$emailbody"
}

Send-MailMessage @hash -ea SilentlyContinue -ev err