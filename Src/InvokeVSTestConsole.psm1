# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'continue'

function Invoke-CIStep(

[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$PoshCIProjectRootDirPath,

[String[]]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$IncludeDllPath = @(gci -Path $PoshCIProjectRootDirPath -File -Recurse -Filter '*test*.dll' | ?{$_.FullName -notmatch '.*[/\\]packages|obj[/\\].*'} | %{$_.FullName}),

[String[]]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$ExcludeDllNameLike,

[switch]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$Recurse,

[String]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$TestCaseFilter,

[String]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$PathToVSTestConsoleExe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe'){

   
   $DllPaths = @(gci -Path $IncludeDllPath -Filter '*.dll' -File -Exclude $ExcludeDllNameLike -Recurse:$Recurse | ?{!$_.PSIsContainer} | %{$_.FullName})
        
Write-Debug `
@"
`Located dll's:
$($DllPaths | Out-String)
"@

    $vsTestConsoleParameters = $DllPaths
    $vsTestConsoleParameters += '/InIsolation'

    if($TestCaseFilter){
            $vsTestConsoleParameters = $vsTestConsoleParameters + @('/TestCaseFilter',$TestCaseFilter)
        }

Write-Debug `
@"
Invoking VSTest.Console.exe:
$PathToVSTestConsoleExe $($vsTestConsoleParameters|Out-String)
"@
    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'continue'

    & $PathToVSTestConsoleExe $vsTestConsoleParameters

    $ErrorActionPreference = $previousErrorActionPreference
        
    # handle errors
    if ($LastExitCode -ne 0) {
        throw $Error
       
    }

}

Export-ModuleMember -Function Invoke-CIStep
