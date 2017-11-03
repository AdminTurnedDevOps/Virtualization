Function Get-VMInfo {

<#
.SYNOPSIS
This script is to pull information about the system state of all VM's in ESXi
.DESCRIPTION
Get-VMInfo will pull the state of the VM's that are listed in the ESXi host
.PARAMETER
The parameters are $Name for the computer names and $Error for any error logs
#>

[cmdletbinding()]
param(
    [parameter(mandatory=$true,
               ValueFromPipeline=$true)]
                   
    [int][validatecount(1,200)]
    [alias('hostname')]
    [string[]]$Name,

    [string]$VM,

    [string]$Error,

    [int]$ServerIP

)  

BEGIN{
        Write-Verbose "We will now begin retrieving the VM information"
}

PROCESS{
[string]$User = "Username"

        New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,('password' | ConvertTo-SecureString)
        connect-VIServer -Server $ServerIP -User $User -Password 'password'

        Get-VM -Name $Name | select Name,
            @{name='on or off?' ;expression={$_.PowerState}},
            @{name='Virtual CPUs Attached' ;expression={$_.NumCpu}},
            @{name='Memory in GB Attached' ;expression={$_.MemoryGB}}
   
        Write-Verbose "The collection of VM info is now complete"
    }

END{}

}
Get-VMInfo -Name Name -Verbose | Out-File \\Path\To\Folder\

Function Send-Mail {

[cmdletbinding()]
param(

    [parameter(Mandatory=$true)]
    [string]$Attachment = '\\Path\To\Folder',
    
    [parameter(Mandatory=$true)]
    [string]$From,
    
    [parameter(Mandatory=$true)]
    [string]$To,
    
    [parameter(Mandatory=$true)]
    [string]$cc,

    [parameter(Mandatory=$true)]
    [string]$Subject,
    
    [parameter(Mandatory=$true)]  
    [string]$SmtpServer

)

[string]$Object = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From,('Password' | ConvertTo-SecureString -AsPlainText -Force)

        Send-MailMessage -From $From -To $To -Cc $cc -Body "Attached is a health check of the VM's on your ESXi Server" -Attachments $Attachment -Subject $Subject -Credential $Object -SmtpServer $SmtpServer -UseSsl -Port 25
}

Send-Mail
