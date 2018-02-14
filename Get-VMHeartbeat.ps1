Function Get-VMHeartbeat {
	
    [cmdletbinding()]
	param(
		[parameter(mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(1,50)]
		[string]$VMName

	)

begin{}

process{
        Write-Verbose "Beginning the collection of VM resources"
        Write-Verbose "Seeing if VM is enabled for collect resources"

		$YesOrNo = Read-Host "Would you like to enable resource metering? If so, select Y. If the VM has already been enabled, please select N"

			IF($YesOrNo -like 'y') 
				{ Enable-VMResourceMetering -VMName $VMName 
				  
                  Measure-VM $VMName
                  
                  $VMIntegration_Params = @{
                                            'VMName'=$VMName
                                           }

                    $VMIntegration = Get-VMIntegrationService @VMIntegration_Params | Where-Object {($_.Name -like "Heartbeat")}
                        $IntegrationObjects1 = [PSCustomObject] @{
                                                                  'Name'           = $VMIntegration.Name
                                                                  'Enabled?'       = $VMIntegration.Enabled
                                                                  'PrimaryStats'   = $VMIntegration.PrimaryStatusDescription
                                                                  'SecondaryStats' = $VMIntegration.SecondaryStatusDescription
                                                                 }
                                           
				}

            ELSEIF ($YesOrNo -like 'n')
                { Measure-VM $VMName

                    $VMIntegration_Params = @{
                        'VMName'=$VMName
                                             }

                         $VMIntegration = Get-VMIntegrationService @VMIntegration_Params | Where-Object {($_.Name -like "Heartbeat")}
                            $IntegrationObjects1 = [PSCustomObject] @{
                                                                      'Name'           = $VMIntegration.Name
                                                                      'Enabled?'       = $VMIntegration.Enabled
                                                                      'PrimaryStats'   = $VMIntegration.PrimaryStatusDescription
                                                                      'SecondaryStats' = $VMIntegration.SecondaryStatusDescription
                                                                     }
                }
      
        }#Process Closing Bracket

    end{}
        
}#Function Closing Bracket
