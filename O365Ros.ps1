#﻿
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$o365Ips = "https://support.content.office.net/en-us/static/O365IPAddresses.xml"

$output = "$PSScriptRoot\O365IPAddresses.xml"

$RosFirewallAddresslist = "/ip firewall address-list"
$RosAddList = "add list=Whitelist_O365 address="
$RosComment = " comment=O365_"

$RosScriptOutput = "c:\temp\o365Ros.rsc"

$RosFirewallAddresslist | out-file $RosScriptOutput -Encoding unicode -Force

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($o365Ips, $output)

[xml]$o365Data = Get-Content $output
$o365 = @() 

foreach($product in $o365Data.products.product)
{
    write-host $product.name
    
    foreach ($address in $product.addresslist)
    {

        if ($address.type -eq "IPv4")
        {

            if ($address.address)
            {
                $ourObject = New-Object -TypeName psobject 
                $ourObject | Add-Member -MemberType NoteProperty -Name Product -Value $product.name
                $ourObject | Add-Member -MemberType NoteProperty -Name AddressesType -Value $address.type
                $ourObject | Add-Member -MemberType NoteProperty -Name IPaddresses -Value $address.address
            }
                   
        }
        elseif($address.type -eq "IPv6")
        {
            #       Write-host $address.address
        }
        elseif($address.type -eq "URL")
        {
            #   Write-host $address.address
        }

    }
    $o365 += $ourObject
    $ourObject = $null

}
$o365

$o365 | foreach { $Prod = $_.Product  ; $ips = $_.IPaddresses ; $Prod + " : " + $ips.Count ; `
foreach ($ip in $ips){ $RosAddList + $ip + $RosComment +  $Prod | out-file $RosScriptOutput -Encoding unicode -Append }; `
` }
#Write-host "test "
#get-content $RosScriptOutput
