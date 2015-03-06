[PSCustomObject]@{
	Steps = [Ordered]@{
		CreatePoshCIPackage = [PSCustomObject]@{
			Name = [String]"CreatePoshCIPackage"; 
			PackageId = [String]"CreatePoshCIPackage"; 
			PackageVersion = [String]"0.0.2"
		}; 
		PushPoshCIPackage = [PSCustomObject]@{
			Name = [String]"PushPoshCIPackage"; 
			PackageId = [String]"PushPoshCIPackage"; 
			PackageVersion = [String]"0.0.15"; 
			Parameters = [Hashtable]@{
				IncludeNupkgFilePath = [String[]]@(
					[String]".\*"
				)
			}
		}
	}
}
