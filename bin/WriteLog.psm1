function Write-Log {
  <#
  .SYNOPSIS
  Logging + Log-Rotation
  
  .EXAMPLE
  Write-Log INFO "Test"
  
   .PARAMETER LogFile
   Type: String, Parameter points to the log file
  
  .PARAMETER Level
   Type: String, Parameter indicates log level
   Possible values: INFO,WARN,ERROR

  .PARAMETER Message
   Type: String, Parameter contains log message

  #>
  [CmdletBinding()]
  Param
  (
    [Parameter(Position = 0,Mandatory = $false)] 
    [ValidateSet("ERROR", "WARN", "INFO", IgnoreCase = $false)] 
    [string]$Level = "INFO",

    [Parameter(Position = 1, Mandatory = $true, 
    ValueFromPipelineByPropertyName = $true)] 
    [ValidateNotNullOrEmpty()]
    [string]$Message,
	
	[Parameter(Position = 2, Mandatory = $false)]
	[string]$LogFile = "MDTDriverImport.log"
  )
 
  Begin {

	# Check for existance
	if (!(Test-Path variable:log_size)) {$log_size = 20971520}
	if (!(Test-Path variable:log_file)) {$log_file = $LogFile}
	
    if ($log_size) {
      # Get filesize of logfile
      if (Test-Path $log_file) { $Filesize_Log = (Get-Item $log_file).length }
      
      # Compare filesize to maximum
      if ($Filesize_Log -ge $log_size) {
        # Remove oldest log file
        if (Test-Path "$log_file.04") { Remove-Item "$log_file.04" -Force }
        # LogRotation
        if (Test-Path "$log_file.03") { Rename-Item -Path "$log_file.03" -NewName "$log_file.04" -Force }
        if (Test-Path "$log_file.02") { Rename-Item -Path "$log_file.02" -NewName "$log_file.03" -Force }
        if (Test-Path "$log_file.01") { Rename-Item -Path "$log_file.01" -NewName "$log_file.02" -Force }
        Rename-Item -Path "$log_file" -NewName "$log_file.01" -Force 
      }
    }
  } 
  Process {
    $LevelText = $Level + ":"
    $FormattedDate = Get-Date -Format "dd-MM-yyyy-HH:mm:ss" 
    "$FormattedDate - $LevelText $Message" | Out-File -FilePath $log_file -Append
  }
}