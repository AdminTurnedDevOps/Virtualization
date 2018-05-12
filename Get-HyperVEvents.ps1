Function Get-HyperVEvents {
    [Cmdletbinding(DefaultParameterSetName = 'HyperVEvents', ConfirmImpact = 'low', SupportsShouldProcess = $true)]
    Param (
        [Parameter(Position = 0,
            ParameterSetName = 'HyperVEvents',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Hostname')]
        [string[]]$ComputerName
    )
    Begin {
        $Events = @("System", "Security", "Application")
        Write-Output "The following event logs will be scanned;";
        $Events

        $systemEvents = Get-EventLog -ComputerName $ComputerName -LogName $Events[0] | Select-Object -First 20
        $securityEvents = Get-EventLog -ComputerName $ComputerName -LogName $Events[1] | Select-Object -First 20
        $applicationEvents = Get-EventLog -ComputerName $ComputerName -LogName $Events[2] | Select-Object -First 20
    }

    Process {
        Try {
            Foreach ($Event0 in $systemEvents) {
                $systemEventsOBJECT = [pscustomobject] @{
                    'Time'         = $Event0.TimeGenerated
                    'Source'       = $Event0.Source
                    'InstanceID'   = $Event0.InstanceID
                    'ErrorMessage' = $Event0.Message
                }
                $systemEventsOBJECT
            }#Foreach1
            Write-Output 'The following errors were found for system events;'
            Pause
        }
        Catch {
            Write-Warning "An error has occured with pulling log: $Event0"
            $PSItem
            Throw
        }

        Try {
            Foreach ($Event1 in $securityEvents) {
                $securityEventsOBJECT = [pscustomobject] @{
                    'Time'         = $Event1.TimeGenerated
                    'Source'       = $Event1.Source
                    'InstanceID'   = $Event1.InstanceID
                    'ErrorMessage' = $Event1.Message
                }
                $securityEventsOBJECT
            }#Foreach2
            Write-Output 'The following errors were found for security events;'
            Pause
        }
        Catch {
            Write-Warning "An error has occured with pulling log: $Event1"
            $PSItem
            Throw
        }

        Try {
            Foreach ($Event2 in $applicationEvents) {
                $securityEventsOBJECT = [pscustomobject] @{
                    'Time'         = $Event2.TimeGenerated
                    'Source'       = $Event2.Source
                    'InstanceID'   = $Event2.InstanceID
                    'ErrorMessage' = $Event2.Message
                }
                $securityEventsOBJECT
            }#Foreach2
            Write-Output 'The following errors were found for application events;'
        }
        Catch {
            Write-Warning "An error has occured with pulling log: $Event2"
            $PSItem
            Throw
        }
    }#Process
    End {}
}#Function
