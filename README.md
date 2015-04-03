![](https://ci.appveyor.com/api/projects/status/qcsvd9rs60tb3lpt?svg=true)

####What is it?
An [Appease](http://appease.io) task template that invokes [VSTest.Console.exe](https://msdn.microsoft.com/en-us/library/jj155796.aspx)

####How do I install it?
```PowerShell
Add-AppeaseTask `
    -DevOpName YOUR-DEVOP-NAME `
    -Name YOUR-TASK-NAME `
    -TemplateId InvokeVSTestConsole
```

####What parameters are required?
none

####What parameters are optional?

#####IncludeDllPath
description: a `string[]` representing included .dll file paths. Either literal or wildcard paths are supported.  
default: all .dlls within your project root dir @ any depth containing `test` in their name not within a `packages` or `bin` directory (case insensitive).

#####ExcludeDllNameLike
description: a `string[]` representing .dll file names to exclude. Either literal or wildcard names are supported.

#####Recurse
description: a `switch` representing whether to recursively search directories below $IncludeDllPath.

#####TestCaseFilter
description: a `string` representing the `/TestCaseFilter` option of VSTest.Console.exe.

#####Logger
description: a `string` representing the `/Logger` option of VSTest.Console.exe.

#####UseVsixExtensions
description: a `switch` representing whether to pass the `/UseVsixExtensions` option to VSTest.Console.exe.

#####PathToVSTestConsoleExe
description: a `string` representing the path to VSTest.Console.exe.  
default: 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe'