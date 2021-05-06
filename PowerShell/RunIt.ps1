function Run-It {
    [cmdletbinding()]
    param(
        [string] $ConnectorFolder = (Get-Location),
        [switch] $StoreMissingBaselines,
	    [switch] $OverwriteBaselines,
	    [string[]] $Tests = @(),
        [string[]] $NotMatch = @(),
        [string] $ConnectorName = $null,
        [string] $StubUri = "http://localhost:90"
    )

    function Get-TargetFramework {
        param(
            [string] $ProjectPath
        )

        [string]$targetFramework = Select-Xml -Path $ProjectPath -XPath "/Project/PropertyGroup/TargetFramework" | select -ExpandProperty Node -First 1 | select -ExpandProperty InnerText
        if ([string]::IsNullOrEmpty($targetFramework)) {
            Write-Error "Couldn't find target framework in the $ProjectPath"
        }

        return $targetFramework
    }

    cd $ConnectorFolder

    Write-Host "Determining connector name"
    if ([string]::IsNullOrEmpty($ConnectorName)) {
        $ConnectorName = Get-ChildItem .\src -Filter "*.sln" | select -ExpandProperty Name -First 1 | % { [System.IO.Path]::GetFileNameWithoutExtension($_) }
    }
    Write-Host "`nConnector name: $ConnectorName"

    Write-Host "`nDetermining projects path"
    $projectFolderPath = ".\src\$ConnectorName"
    $projectPath = "$projectFolderPath\$ConnectorName.csproj"
    $itProjectFolderPath = ".\tests\$ConnectorName.IntegrationTests"
    $itProjectPath = "$itProjectFolderPath\$ConnectorName.IntegrationTests.csproj"
    if (!(Test-Path $projectPath) -or !(Test-Path $itProjectPath)) {
        Write-Error "Projects not found"
        return
    }
    Write-Host "`nProject path: $projectPath, IT project path: $itProjectPath"

    Write-Host "`nDetermining projects target framework"
    $projectFramework = Get-TargetFramework $projectPath
    $itFramework = Get-TargetFramework $itProjectPath
    Write-Host "`nProject framework: $projectFramework, IT project framework: $itFramework"

    Write-Host "`nRestoring packages..."
    dotnet restore $projectPath

    Write-Host "`nRestoring packages for IT..."
    dotnet restore $itProjectPath

    Write-Host "`nPublishing..."
    dotnet publish $projectPath -r win-x64 -c Release -o $projectFolderPath\bin\Release\$projectFramework\publish

    Write-Host "`nRemoving dev config..."
    rm $projectFolderPath\bin\Release\$projectFramework\publish\conf\90-NOT4PROD-DevSettings.json -Force

    Write-Host "`nChanging settings in TestsSettings.json..."
    Copy-Item "$itProjectFolderPath\TestsSettings.json" "$itProjectFolderPath\TestsSettingsBak.json" -Force
    $testSettingsContent = gc $itProjectFolderPath\TestsSettings.json
    $testSettings = $testSettingsContent | ConvertFrom-Json
    $testSettings.iapiStub.uri = $StubUri
    $testSettings.connector.executablePath = "..\..\..\..\.$projectFolderPath\bin\Release\$projectFramework\publish\$ConnectorName.exe"
    $testSettings.connector.executionTimeout = "00:05:00"
    $testSettings.testDataStorage.storeMissingBaselines = $StoreMissingBaselines.IsPresent
    $testSettings.testDataStorage.overwriteExistingBaselines = $OverwriteBaselines.IsPresent
    $testSettings | ConvertTo-Json -Depth 10 | Out-File $itProjectFolderPath\TestsSettings.json

    Write-Host "`nClearing TestData..."
    rm $itProjectFolderPath\bin\Debug\$itFramework\TestData -Force -Recurse

    Write-Host "`nRunning IT..."
    if ($Tests.Length -gt 0) {
        dotnet test $itProjectPath --logger:"console;verbosity=normal" --filter "$([string]::Join("|", $Tests))"
    }
    elseif ($NotMatch.Length -gt 0) {
        dotnet test $itProjectPath --logger:"console;verbosity=normal" --filter "$([string]::Join("&", ($NotMatch | % { "FullyQualifiedName!~$_" })))"
    }
    else {
        dotnet test $itProjectPath --logger:"console;verbosity=normal"
    }

    Write-Host "`nRestoring TestsSettings.json..."
    Copy-Item "$itProjectFolderPath\TestsSettingsBak.json" "$itProjectFolderPath\TestsSettings.json" -Force
}