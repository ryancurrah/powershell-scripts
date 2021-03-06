# Run instructions:
# This script needs to be ran in the admin context
# To do this:
# 1. Create a shortcut to the script
# 2. Right click and go to the properties on the new shortcut
# 3. Prepend "powershell -f" to the target path
# 4. Click "Advanced" select "Run As Administrator"


$global:staticIP = ""
$global:broadcastIP = ""
$global:gatewayIP = ""
$global:dnsIP = ""

$global:lanAdapterName = "L1C"

$global:select = ""

function IPFunctions
{
    switch ($select)
    {
        1
        {
            # Get IP Adapter Info
            Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE
            Read-Host "Press Enter to Continue..."
            cls
            MainMenu
        }
        
        2
        {
            # Set DHCP Enabled
            $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE | Where {$_.ServiceName-eq $global:lanAdapterName}
            Foreach($NIC in $NICs)
            {
                $NIC.EnableDHCP()
                $NIC.SetDNSServerSearchOrder()
            }
            Write-Host "IP Address set to DHCP..."
            Read-Host "Press Enter to Continue..."
            cls
            MainMenu
        }
        
        3
        {
            # Set Static IP
            Write-Host "Warning: This will not work if your ethernet is not plugged or wireless adapter is not connected"
            $global:staticIP = Read-Host "IP Address?"
            $global:broadcastIP =  Read-Host "Broadcast Address?"
            $global:gatewayIP  =  Read-Host "Gateway IP Address?"
            $global:dnsIP = Read-Host "DNS IP Address?"
            
            $NICs = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE | Where {$_.ServiceName-eq $global:lanAdapterName}
            Foreach($NIC in $NICs)
            {
                $NIC.EnableStatic($global:staticIP, $global:broadcastIP)
                $NIC.SetGateways($global:gatewayIP)
                $NIC.SetDNSServerSearchOrder($global:dnsIP)
            }
            Write-Host "IP Address set to Static..."
            Read-Host "Press Enter to Continue..."
            cls
            MainMenu
        }
        
        4
        {
            exit
        }
    }
}

function MainMenu
{
    # GUI
    Write-Host "IP CHANGER"
    Write-Host "=========="
    Write-Host ""
    Write-Host "1) List Current IP Addresses"
    Write-Host "2) Set LAN to DHCP"
    Write-Host "3) Set LAN to Static"
    Write-Host "4) Quit"
    Write-Host ""
    $global:select = ""
    $global:select = Read-Host "Enter selection"
    IPfunctions
}

# init script menu
MainMenu









