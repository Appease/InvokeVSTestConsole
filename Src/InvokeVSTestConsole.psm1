# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'stop'

function Invoke-CIStep(

[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$PoshCIProjectRootDirPath,

[String[]]
[ValidateCount(1,[Int]::MaxValue)]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$IncludeDllPath = @(gci -Path $PoshCIProjectRootDirPath -File -Recurse -Filter '*test*.dll' | ?{$_.FullName -notmatch '.*[/\\]packages|obj[/\\].*'}|%{$_.FullName}),

[String[]]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$ExcludeDllNameLike,

[Switch]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$Recurse,

[String]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$TestCaseFilter,

[String]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$Logger,

[Switch]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$UseVsixExtensions ,

[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$PathToVSTestConsoleExe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe'){

   
   $DllPaths = @(gci -Path $IncludeDllPath -Filter '*.dll' -File -Exclude $ExcludeDllNameLike -Recurse:$Recurse | %{$_.FullName})
        
Write-Debug `
@"
`Located dll's:
$($DllPaths | Out-String)
"@

    $vsTestConsoleParameters = @($DllPaths, '/InIsolation')

    if($TestCaseFilter){
            $vsTestConsoleParameters += @("/TestCaseFilter:$TestCaseFilter")
    }

    if($Logger){
        $vsTestConsoleParameters += @("/Logger:$Logger")
    }

    if($UseVsixExtensions.IsPresent){
        $vsTestConsoleParameters += @('/UseVsixExtensions:true')
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
