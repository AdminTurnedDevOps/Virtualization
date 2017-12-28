Function Get-VMResources {
	
    [cmdletbinding()]
	param(
		[parameter(mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(1,5)]
        [string]$VMName,
        
        [string]$ErrorLog = 'C:\VMResourceErrorLog.txt',

        [switch]$LogError

	)

begin{}

process{
        Write-Verbose "Beginning the collection of VM resources"
        Write-Verbose "Seeing if VM is enabled for collect resources"

    TRY { $NoErrors = $true
		$YesOrNo = Read-Host "Would you like to enable resource metering? If so, select Y. If the VM has already been enabled, please select N"

			IF($YesOrNo -like 'y') 
				{ Enable-VMResourceMetering -VMName $VMName 
				  
				  Measure-VM $VMName

				  Get-VMIntegrationService -VMName $VMName | Where-Object {($_.Name -like "Heartbeat")} |
				  Select-Object Name,Enabled,
					@{Name='PrimaryStatus' ;expression={$_.PrimaryStatusDescription}},
					@{Name='SecondaryStatus' ;expression={$_.SecondaryStatusDescription}}
				}

            		ELSEIF ($YesOrNo -like 'n')
                		{ Measure-VM $VMName

				Get-VMIntegrationService -VMName $VMName | Where-Object {($_.Name -like "Heartbeat")} |
				Select-Object Name,Enabled,
					@{Name='PrimaryStatus' ;expression={$_.PrimaryStatusDescription}},
					@{Name='SecondaryStatus' ;expression={$_.SecondaryStatusDescription}}
                }
        }#TRY Closing Bracket

    CATCH {
            $NoErrors = $false
            Write-Warning "An error has occured. Please review the error log under C:\VMResourceErrorLog"
            IF($LogError) 
            { $Error | Out-File $ErrorLog }


          }#CATCH Closing Bracket
        
        }#Process Closing Bracket

    end{}
        
}#Function Closing Bracket
