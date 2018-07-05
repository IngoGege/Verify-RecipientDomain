<#

.SYNOPSIS

Created by: https://ingogegenwarth.wordpress.com/
Version:    42 ("What do you get if you multiply six by nine?")
Changed:    04.07.2018

.LINK
https://ingogegenwarth.wordpress.com/

.DESCRIPTION

The purpose of the script is to check a recipient for SMTP address with domains, which are not configured as accepted domain. Non-existing domains will cause the migration to fail.

.PARAMETER Recipient

The recipient, which will be checked for non-existing domain

.EXAMPLE

# check failed MigrationUser piped from a batch
Get-MigrationUser -Status failed -BatchId MyFirstMigBatch | .\Verify-RecipientDomain -Verbose

.NOTES
#>

[CmdletBinding()]
param
(
    [parameter(
        ValueFromPipelineByPropertyName=$true,
        Mandatory=$true,
        Position=0)]
    [Alias('PrimarySmtpAddress','Identifier')]
    [System.String[]]$Recipient
)
Begin
{
    #get accepted domains
    $AcceptedDomain = @()
    $AcceptedDomain = Get-AcceptedDomain | Select-Object -ExpandProperty DomainName
    #create variable for output
    $objcol = @()
}
Process
{
    ForEach ($Rec in $Recipient)
    {
        Write-Verbose "Verifying $($Rec)"
        #create object for output
        $data = New-Object -TypeName PSObject
        $data | add-member -type NoteProperty -Name Recipient -Value $Rec
        #create 
        [System.Boolean]$BadDomainExists = $false
        #get EmailAddresses from recipient
        $RecAddresses = @()
        $RecAddresses = Get-Recipient $Rec | Select-Object -ExpandProperty EmailAddresses
        $BadDomains = @()
        #check SMTP address domain
        ForEach ($Address in $RecAddresses)
        {
            If ($Address.StartsWith("smtp") )
            {
                If ($AcceptedDomain -notcontains $($Address.Split('@')[1]))
                {
                    Write-Verbose "Missing domain found:$($Address.Split('@')[1])"
                    $BadDomainExists = $true
                    $BadDomains += $Address.Split('@')[1]
                }
            }
        }
        If ($BadDomainExists)
        {
            Write-Verbose "Adding missing domains to object"
            $data | add-member -type NoteProperty -Name MissingDomain -Value $(($BadDomains | Select-Object -Unique) -join ",")
            $objcol += $data
        }
    }
}
End
{
    If ($objcol.Count -ge 1)
    {
        $objcol
    }
}
