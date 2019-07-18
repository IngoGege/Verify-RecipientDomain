# Verify-RecipientDomain
## Description

The purpose of the script is to check a recipient for SMTP address with domains, which are not configured as accepted domain. Non-existing domains will cause the migration to fail.

## Requirements
# Exchange PowerShell session

## Examples

# check failed MigrationUser piped from a batch
```
Get-MigrationUser -Status failed -BatchId MyFirstMigBatch | .\Verify-RecipientDomain.ps1 -Verbose
```

## Required Parameters

### -Recipient

The purpose of the script is to check a recipient for SMTP address with domains, which are not configured as accepted domain. Non-existing domains will cause the migration to fail.

## Links

https://ingogegenwarth.wordpress.com/2018/05/14/exo-notaccepteddomainexception/
