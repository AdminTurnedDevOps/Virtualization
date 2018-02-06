Function Get-VMStatus {

    [cmdletbinding()]
    param(
        
        [ValidateCount(1, 100)]
        [string]$HYPERVHOST = 'YourHost',
                            
        [string]$StatusLog = "C:\HyperVLogs\VMStatus.txt"

    )
    
        #Create a list of all VM's in your environment
        $VMs = @(
                "VM1"
                "VM2"
                "etc
                )

            #Set up your parameters
            $VM_Params = @{
                            'ComputerName'=$HYPERVHOST
                            'Name'=$VMs
                          }
            
            #Call only the VM's with a status outside of operating normally or if the VM is off
            $GetVMs = Get-VM @VM_Params | 
                      Where-Object {$_.Status -notlike 'Operating normally' -or $_.State -like 'Off'}
                
            #Create your custom table with PowerShell parameters
            $NewObject = [PSCustomObject] @{
                                            'Name'=$GetVMs.Name
                                            'VMStatus'=$GetVMs.Status
                                            'VMState'=$GetVMs.State
                                           }
            Write-Output $NewObject
            $NewObject | Out-file $StatusLog -NoClobber

                    $From = 'smtp@yourdomain.com'
                    $To = 'youremail@yourdomain.com'
                    $Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From('YourSMTPPassword' | ConvertTo-SecureString -AsPlainText -Force)
                    $SMTPServer = 'yoursmtp.yourdomain.com'
                    $Port = 'yourport'

                        $Mail_MessageParams = @{
                                                 'From'=$From
                                                 'To'=$To
                                                 'Subject'=Hyper-V VM Status
                                                 'Body'='Log file attached'
                                                 'Attachment'='C:\HyperVLogs\VMStatus.txt'
                                                 'Credential'=$Creds
                                                 'SmtpServer'=$SMTPServer
                                                 'Port'=$Port
                                                 'UseSsl'=$true
                                               }

                        Send-MailMessage @Mail_MessageParams

}# Function
Get-VMStatus
