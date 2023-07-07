#CMTraceLog formats logging in CMTrace style
function CMTraceLog {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		$Message,

		[Parameter(Mandatory = $false)]
		$ErrorMessage,

		[Parameter(Mandatory = $false)]
		$Component = 'HP BIOS Downloader',

		[Parameter(Mandatory = $false)]
		[int]$Type,

		[Parameter(Mandatory = $true)]
		$LogFile
	)

    # Type: 1 = Normal, 2 = Warning (yellow), 3 = Error (red)

	$Time = Get-Date -Format "HH:mm:ss.ffffff"
	$Date = Get-Date -Format "MM-dd-yyyy"

	if ($ErrorMessage -ne $null) { $Type = 3 }
	if ($Component -eq $null) { $Component = " " }
	if ($Type -eq $null) { $Type = 1 }

	$LogMessage = "<![LOG[$Message $ErrorMessage" + "]LOG]!><time=`"$Time`" date=`"$Date`" component=`"$Component`" context=`"`" type=`"$Type`" thread=`"`" file=`"`">"
	$LogMessage | Out-File -Append -Encoding UTF8 -FilePath $LogFile
}