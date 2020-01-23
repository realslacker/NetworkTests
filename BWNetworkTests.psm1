<#
.SYNOPSIS
    Helper function to test a TCP port.

.DESCRIPTION
    Helper function to test a TCP port.

.PARAMETER Destination
    DNS name or IP address of the host to test.

.PARAMETER Port
    Port number to probe.

.PARAMETER Timeout
    Timeout in milli-seconds.
#>
function Test-NetTcpPortOpen {
    
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(

        [parameter(ValueFromPipeline=$True, Mandatory=$True, Position=1)]
        [string[]]
        $Destination,

        [parameter(Mandatory=$True, Position=2)]
        [int]
        $Port,

        [int]
        $Timeout=500 ## Adjust the port test time-out in milli-seconds, here is 500ms
    
    )

    process {
    
        foreach ( $DestinationItem in $Destination ) {

            Write-Verbose "Testing connection to $DestinationItem on port $Port"
            
            $Socket= New-Object Net.Sockets.TcpClient
            $IAsyncResult= [IAsyncResult] $Socket.BeginConnect($DestinationItem,$Port,$null,$null)
            $IAsyncResult.AsyncWaitHandle.WaitOne($Timeout,$true) > $null
            $result = $Socket.Connected
            $Socket.close()

            if ( ! $result ) {

                Write-Error "Could not connect to $DestinationItem on port $Port" -ErrorAction Stop

            }

            $result
        
        }
    }
}

<#
.SYNOPSIS
    Helper function to test that a DNS name resolves.

.DESCRIPTION
    Helper function to test that a DNS name resolves.

.PARAMETER Domain
    DNS name to test.
#>
function Test-NetDomainNameResolution {

    param(

        [parameter(ValueFromPipeline=$True, Mandatory=$True, Position=1)]
        [string[]]
        $Domain

    )

    process {
        
        foreach ( $DomainItem in $Domain ) {

            try {

                [System.Net.Dns]::GetHostAddresses($Domain) > $null

                $true

            } catch {

                $false

            }
        
        }

    }
}


