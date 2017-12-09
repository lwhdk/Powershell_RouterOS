﻿
#https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt


## makes powershell use TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$blacklist = "https://rules.emergingthreats.net/blockrules/compromised-ips.txt"

$data = Invoke-WebRequest $blacklist -UserAgent "myemail@email[.]dk"
#Start-Sleep -Seconds 100

$RosFirewallAddresslist = "/ip firewall address-list"
$RosAddList = "add list=blacklist address="
$RosComment = " comment=emergingthreats_compromised"



$RosScriptOutput = "c:\temp\emergingthreats_compromised.rsc"

$RosFirewallAddresslist | out-file $RosScriptOutput -Encoding unicode -Force


## https://chrisjwarwick.wordpress.com/2012/09/16/more-regular-expressions-regex-for-ip-v4-addresses/
Function ExtractValidIPAddress($String){
    $IPregex=‘(?<Address>((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))’
    If ($String -Match $IPregex) {$Matches.Address}
}


foreach( $line in $data.RawContent.Split("") )
{

if ($line -and (ExtractValidIPAddress($line) )) {

$RosAddList + $line + $RosComment | out-file $RosScriptOutput -Encoding unicode -Append

}

}

Get-Content $RosScriptOutput