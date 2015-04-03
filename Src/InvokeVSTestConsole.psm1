# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'stop'

function Invoke(

[String]
[ValidateNotNullOrEmpty()]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName=$true)]
$AppeaseProjectRootDirPath,

[String[]]
[ValidateCount(1,[Int]::MaxValue)]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$IncludeDllPath = @(gci -Path $AppeaseProjectRootDirPath -File -Recurse -Filter '*test*.dll' | ?{$_.FullName -notmatch '.*[/\\]packages|obj[/\\].*'}|%{$_.FullName}),

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

    $VSTestConsoleParameters += $DllPaths
    $VSTestConsoleParameters += '/InIsolation'

    if($TestCaseFilter){
            $VSTestConsoleParameters += @("/TestCaseFilter:$TestCaseFilter")
    }

    if($Logger){
        $VSTestConsoleParameters += @("/Logger:$Logger")
    }

    if($UseVsixExtensions.IsPresent){
        $VSTestConsoleParameters += @('/UseVsixExtensions:true')
    }

Write-Debug `
@"
Invoking VSTest.Console.exe:
$PathToVSTestConsoleExe $($VSTestConsoleParameters|Out-String)
"@
    $OriginalErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'continue'

    & $PathToVSTestConsoleExe $VSTestConsoleParameters

    $ErrorActionPreference = $OriginalErrorActionPreference
        
    # handle errors
    if ($LastExitCode -ne 0) {
        throw $Error
       
    }

}

Export-ModuleMember -Function Invoke
