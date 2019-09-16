<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: September 15, 2019
    Organization: Jimenez & Associates
    File Name: Import-DLLs.psm1
    Version: 0.0.1-alpha
    ======================================================

    .SYNOPSIS
    ======================================================
    This script looks through the current directory and 'Add-Type's files with the extension DLL.
    An optional directory parameter is available. This parameter takes priority!
    ======================================================
#>

function Import-DLLs
{
    param(
        [Parameter(Mandatory = $false)]
        [string]$directory
    )

    # Function Variables
    # ======================================================
    $directoryContents = $null
    $dllArray = @() # Declare empty array to add to it later.


    # Function Logic
    # ======================================================
    if(-not $directory)
    {
        $directoryContents = Get-ChildItem -Path $PWD
    }
    else
    {
        $directoryContents = Get-ChildItem -Path $directory
    }

    if($directoryContents.Count -le 0)
    {
        Write-Error -Message "No DLLs found! Directory - $($directoryContents.DirectoryName)"
        break
    }

    foreach( $file in $directoryContents)
    {
        if( $file.Name -match '*.dll')
        {
            $dllArray += $file.FullName
        }
    }

    if( $dllArray.Count -le 0)
    {
        Write-Error -Message "No DLLs found! Directory - $($directoryContents.DirectoryName)"
        break
    }

    foreach( $dll in $dllArray)
    {
        Add-Type -Path $dll
    }
}

Export-ModuleMember -Function "Import-DLLs"