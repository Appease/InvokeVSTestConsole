[PSCustomObject]@{
	Steps = [Ordered]@{
		CreatePoshDevOpsPackage = [PSCustomObject]@{
			Name = [String]"CreatePoshDevOpsPackage"; 
			PackageId = [String]"CreatePoshDevOpsPackage"; 
			PackageVersion = [String]"0.0.2"
		}; 
		PushPoshDevOpsPackage = [PSCustomObject]@{
			Name = [String]"PushPoshDevOpsPackage"; 
			PackageId = [String]"PushPoshDevOpsPackage"; 
			PackageVersion = [String]"0.0.15"; 
			Parameters = [Hashtable]@{
				IncludeNupkgFilePath = [String[]]@(
					[String]".\*"
				)
			}
		}
	}
}
