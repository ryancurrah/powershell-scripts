# FullName AD LOOKUP TOOL
# Ryan Currah
# Created: 6/12/2013
# Last Edited: 6/12/2013
# Required to Run: Remote Server Administration Tools for Windows 7 with Service Pack 1 (SP1) _
# http://www.microsoft.com/en-us/download/details.aspx?id=7887 (x64 or x32)

# Import AD cmdlets
import-module ActiveDirectory

$acf2LookupFile = ".\acf2.txt"
$acf2LookupArray = Get-Content $acf2LookupFile
$acf2LookupCount = $acf2LookupArray.count
$resultFile = ".\result.txt"

Clear-Content $resultFile

for($i=0; $i -le ($acf2LookupCount - 1); $i++)
{
    $newValue = Get-ADUser $acf2LookupArray[$i] | Select -ExpandProperty Name
    # Add if statement: if a hostname cannot be resolved the ip will be the same as the last loop; make sure that no duplicate IP's
    if ($oldValue -ne $newValue)
    {
        $a = $acf2LookupArray[$i] + ";" + $newValue
        Add-Content $resultFile $a
    }
    else
    {
        $a = $acf2LookupArray[$i] + ";No such user is known"
        Add-Content $resultFile $a
    }
    $oldValue = $newValue
} 