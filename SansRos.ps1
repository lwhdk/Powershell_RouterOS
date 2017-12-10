


## makes powershell use TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$blacklist = "https://isc.sans.edu/api/threatlist/shodan?json"

$Webdata = Invoke-WebRequest $blacklist -UserAgent "sysmail@mxbox.dk"

$data = $Webdata | ConvertFrom-Json 


$data.ipv4.Count
#Start-Sleep -Seconds 100

$RosFirewallAddresslist = "/ip firewall address-list"
$RosAddList = "add list=blacklist address="
$RosComment = " comment=Sans_shodan"



$RosScriptOutput = "c:\temp\Sans_shodan.rsc"

$RosFirewallAddresslist | out-file $RosScriptOutput -Encoding unicode -Force


## https://chrisjwarwick.wordpress.com/2012/09/16/more-regular-expressions-regex-for-ip-v4-addresses/
Function ExtractValidIPAddress($String){
    $IPregex=‘(?<Address>((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))’
    If ($String -Match $IPregex) {$Matches.Address}
}


foreach( $line in $data.ipv4 )
{

if ($line -and (ExtractValidIPAddress($line) )) {

$RosAddList + $line + $RosComment | out-file $RosScriptOutput -Encoding unicode -Append

}

}

Get-Content $RosScriptOutput