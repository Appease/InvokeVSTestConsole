# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'Stop'

function Invoke-CIStep(
[String[]]
[ValidateCount(1,[Int]::MaxValue)]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName = $true)]
$IncludeNupkgFilePath,

[String[]]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$ExcludeFileNameLike,

[switch]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$Recurse,

[String]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$SourceUrl = 'https://nuget.org/api/v2/',

[String]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$ApiKey){
    
    $NupkgFilePaths = gci -Path $IncludeNupkgFilePath -Filter '*.nupkg' -File -Exclude $ExcludeFileNameLike -Recurse:$Recurse | ?{!$_.PSIsContainer} | %{$_.FullName}
        
Write-Debug `
@"
`Located packages:
$($NupkgFilePaths | Out-String)
"@

    foreach($nupkgFilePath in $NupkgFilePaths)
    {
        $nugetExecutable = 'nuget'
        $nugetParameters = @('push',$nupkgFilePath,'-Source',$SourceUrl)

        if($ApiKey){
            $nugetParameters = $nugetParameters + @('-ApiKey',$ApiKey)
        }

Write-Debug `
@"
Invoking nuget:
$nugetExecutable $($nugetParameters|Out-String)
"@
        & $nugetExecutable $nugetParameters
        
        # handle errors
        if ($LastExitCode -ne 0) {
            throw $Error
        
        }

    }

}

Export-ModuleMember -Function Invoke-CIStep
