####What is it?

A [PoshCI](https://github.com/PoshCI/PoshCI) step that invokes [VSTest.Console.exe](https://msdn.microsoft.com/en-us/library/jj155796.aspx)

####How do I install it?

```PowerShell
Add-CIStep -Name "YOUR-CISTEP-NAME" -PackageId "InvokeVSTestConsole"
```

####What parameters are available?

#####IncludeDllPath
A String[] representing included .dll file paths. Either literal or wildcard paths are supported; default is all .dlls 
within your project root dir @ any depth containing `test` in their name not within a `packages` directory (case insensitive)
```PowerShell
[String[]]
[ValidateCount(1,[Int]::MaxValue)]
[Parameter(
    Mandatory=$true,
    ValueFromPipelineByPropertyName = $true)]
$IncludeDllPath
```

#####ExcludeDllNameLike
A String[] representing .dll file names to exclude. Either literal or wildcard names are supported.
```PowerShell
[String[]]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$ExcludeDllNameLike
```

#####Recurse
A Switch representing whether to recursively search directories below $IncludeDllPath.
```PowerShell
[Switch]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$Recurse
```

#####TestCaseFilter
A String representing the `/TestCaseFilter` option of VSTest.Console.exe
```PowerShell
[String]
[Parameter(
    ValueFromPipelineByPropertyName = $true)]
$TestCaseFilter
```

#####PathToVSTestConsoleExe
A String representing the path to VSTest.Console.exe
```PowerShell
[String]
[Parameter(
    ValueFromPipelineByPropertyName=$true)]
$PathToVSTestConsoleExe = 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe'
```

####What's the build status?
![](https://ci.appveyor.com/api/projects/status/rcevsilgkskrk9wi?svg=true)

