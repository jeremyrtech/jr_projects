# Get-PSDrive C | Select-Object Used {}

#$diskRemaining = Get-Volume -DriveLetter C | ForEach-Object {[math]::Truncate($_.SizeRemaining / 1GB)}
$Subject = "Low Available Disk Volume Alert: "
$Subject += $env:COMPUTERNAME
$Body = $env:COMPUTERNAME
$Body += " -  Disk utilization is at" + $percentTotal + "%"
$diskQuery = Get-Volume C | Select-Object SizeRemaining,Size
$uri = ""
 $bodyjson = @{
    "title"= $Subject
    "text" = $Body

}
$messageBody = ConvertTo-Json $bodyjson -Depth 100
function TeamsMessageSend{
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -uri $uri -Method Post -body $messageBody -ContentType 'application/json'
}

foreach ($disk in $diskQuery){
    $total = [math]::Truncate($disk.Size/1GB)
    write-host $total
    $used = ($total - [math]::Truncate($disk.SizeRemaining/1GB))
    write-host $used
    $percentTotal = [math]::Truncate($used/$total*100)
    Write-Output $percentTotal
} 

if ($percentTotal -gt 85) {
    TeamsMessageSend
    exit
}
else {
Write-Host "Disk space normal, exiting."
exit
}

Invoke-RestMethod -uri $uri -Method Post -body $messageBody -ContentType 'application/json'



