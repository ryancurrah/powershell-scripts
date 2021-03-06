# Bulk_PCInfo_Lookup
# Ryan Currah


###################### SET INITIAL VARIABLES ######################
# Load hostnames into memory
$hostnameFile = ".\hostname.txt"
$hostnameArray = @(Get-Content $hostnameFile)
$hostnameCount = $hostnameArray.count

# Result file if needed
$resultFile = "result.txt"
Clear-Content $resultFile

# Load File Names to Copy
#$fileNames = @("LON1_PACKAGES.bat", "LON2_PACKAGES.bat")
###################### END INITIAL VARIABLES ######################


############################ SET MENU #############################
# Give options
#Write-Host 'Please select the following...'
#Write-Host '1) To deploy file'
#Write-Host '2) To delete file'

# Ask for input
#$userSelection = Read-Host 'Please input 1 or 2'
############################ END MENU #############################


###################### START BUSINESS LOGIC #######################
Function check-even ($num) {[bool]!($num%2)}

for($i=0; $i -le ($hostnameCount - 1); $i++)
{
    $model = "NULL"
    $model = Get-WmiObject -ComputerName $hostnameArray[$i] -Class Win32_computersystem | select -ExpandProperty Model
    switch ($model) 
    {
        "5536A76" {$model = "5536"}
	"5536R99" {$model = "5536"}
        "3209A85" {$model = "3209"}
        "7220RY8" {$model = "7220"}
        "4518A12" {$model = "4518"}
        default {}
    }


    $serial = "NULL"
    $serial = Get-WmiObject -ComputerName $hostnameArray[$i] -Class Win32_bios | select -ExpandProperty SerialNumber

    $memoryQuery = "NULL"
    $memory = 0
    $memoryQuery = Get-WMIObject -ComputerName $hostnameArray[$i] -Class win32_physicalmemory | ForEach-Object {$_.Capacity/1MB}
    foreach($memBank in $memoryQuery)
    {
        $memory = $memory + $memBank
    }

    $result = $hostnameArray[$i] + ";" + $model + ";" + $serial + ";" + $memory
    Add-Content $resultFile $result
}

######################## END BUSINESS LOGIC ########################

####################### NOTIFY DONE
Write-host "SCRIPT DONE!"