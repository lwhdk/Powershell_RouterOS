

## Mikrotik Rsc script format...
#/ip firewall address-list
#add list=blacklist address=1.4.0.0/17 comment=SpamHaus
#add list=blacklist address=1.10.16.0/20 comment=SpamHaus
#add list=blacklist address=1.116.0.0/14 comment=SpamHaus


## senderbase.org / talsos
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$blacklist = "https://talosintelligence.com/documents/ip-blacklist"

$data = Invoke-WebRequest $blacklist
$RosFirewallAddresslist = "/ip firewall address-list"
$RosAddList = "add list=blacklist address="
$RosComment = " comment=Talos"

$RosScriptOutput = "c:\temp\Talos.rsc"

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