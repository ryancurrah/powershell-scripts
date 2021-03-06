﻿# HOSTNAME LOOKUP TOOL
# Ryan Currah
# Created: 5/20/2013
# Last Edited: 5/20/2013
# USAGE:
#       Place hostnames in the dns.txt file; each on a new line
#       Edit the domain name below; be sure start with a period ".example.com"
#       Run this script
#       Output will placed in the result.txt; hostname and IP will appear side by side
#       Copy and paste into excel using excels delimiter function to separate hostname from IP into a new column
#       For instructions on delimiter: http://www.makeuseof.com/tag/how-to-convert-delimited-text-files-into-excel-spreadsheets/
#
# NOTE: For failed hostname lookups powershell will throw an exception as follows...
#       ...Exception calling "GetHostAddresses" with "1" argument(s): "No such host is known"
#       This will be noted in the result.txt file

$domainName = ".acme.com"

$dnsLookupFile = ".\dns.txt"
$dnsLookupArray = Get-Content $dnsLookupFile
$dnsLookupCount = $dnsLookupArray.count
$resultFile = ".\result.txt"


Clear-Content $resultFile

for($i=0; $i -le ($dnsLookupCount - 1); $i++)
{
    $ip = [System.Net.Dns]::GetHostAddresses($dnsLookupArray[$i] + $domainName) | Select -ExpandProperty IPAddressToString
    # Add if statement: if a hostname cannot be resolved the ip will be the same as the last loop; make sure that no duplicate IP's
    if ($oldIP -ne $ip)
    {
        $a = $dnsLookupArray[$i] + ";" + $ip
        Add-Content $resultFile $a
    }
    else
    {
        $a = $dnsLookupArray[$i] + ";No such host is known"
        Add-Content $resultFile $a
    }
    $oldIP = $ip
} 
