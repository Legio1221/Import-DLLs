<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: September 16, 2019
    Organization: Jimenez & Associates
    File Name: Import-DLLs.psm1
    Version: 0.0.1-alpha
    ======================================================

    .SYNOPSIS
    ======================================================
    Tests for the Import-DLLs function.
    ======================================================
#>
# Import directly from source.
Import-Module "$PSScriptRoot/../source/Import-DLLs/Import-DLLs.psd1" -Force # Forcing module import to account for possibility of module in $PSModulePath

# List of Assemblies in the 'DLLs' folder
$dllAssemblyNames = @(
    "Microsoft.Extensions.Configuration.Abstractions",
    "Microsoft.Extensions.Configuration",
    "Microsoft.Extensions.Configuration.EnvironmentVariables",
    "Microsoft.Extensions.Configuration.FileExtensions",
    "Microsoft.Extensions.Configuration.Json",
    "Microsoft.Extensions.FileProviders.Abstractions",
    "Microsoft.Extensions.FileProviders.Physical",
    "Microsoft.Extensions.FileProviders.FileSystemGlobbing",
    "Microsoft.Extensions.FileProviders.Primitives",
    "Newtonsoft.Json",
    "scriptsettings",
    "System.Buffers",
    "System.Management.Automation",
    "System.Memory",
    "System.Numerics.Vectors",
    "System.Runtime.CompilerServices.Unsafe"
)

$locationBeforeTests = $pwd

Describe 'Import-DLLs' {
    Context "Integration Tests (black-box testing)" {
        It "Loads all the DLLs in the 'DLLs' folder" {
            $dllFolder = "$PSScriptRoot/DLLs"

            Import-DLLs -directory $dllFolder

            foreach($assemblyName in $dllAssemblyNames)
            {
                # Check if Assembly is loaded. Modified  but taken from: https://stackoverflow.com/questions/43647107/powershell-check-if-net-class-exists
                $assembly = [System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object { $_.GetName() | Where-Object { $_.Name -like "$assemblyName"}} | Select-Object -ExpandProperty Name

                Write-Debug "======================================================"
                Write-Debug "Current Iteration of Assembly List: $assemblyName"
                Write-Debug "Actual value of search: $assembly"
                Write-Debug "======================================================"
                Write-Debug "$([Environment]::NewLine)"
            }
        }

        It "Loads DLLs in the current directory" {
            $dllFolder = "$PSScriptRoot/DLLs"
            Set-Location -Path $dllFolder

            Write-Debug "Current path: $pwd"

            Import-DLLs

            foreach($assemblyName in $dllAssemblyNames)
            {
                # Check if Assembly is loaded. Modified  but taken from: https://stackoverflow.com/questions/43647107/powershell-check-if-net-class-exists
                $assembly = [System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object { $_.GetName() | Where-Object { $_.Name -like "$assemblyName"}} | Select-Object -ExpandProperty Name

                Write-Debug "======================================================"
                Write-Debug "Current Iteration of Assembly List: $assemblyName"
                Write-Debug "Actual value of search: $assembly"
                Write-Debug "======================================================"
                Write-Debug "$([Environment]::NewLine)"
            }
        }

        It "Attempts to import DLLs from an empty folder" {
            $dllFolder = "$PSScriptRoot/Purposefully-Empty-Folder"

            { Import-DLLs -directory $dllFolder -ErrorAction Stop } | Should -Throw
        }

        It "Attempts to import DLLs from directory without DLLs" {
            $dllFolder = "$PSScriptRoot/Folder-Without-DLLs"

            { Import-DLLs -directory $dllFolder -ErrorAction Stop } | Should -Throw
        }
    }
}

Set-Location -Path $locationBeforeTests