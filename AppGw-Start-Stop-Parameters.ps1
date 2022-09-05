<#
.SYNOPSIS  
	 Wrapper script for start and stop one specified Application Gateways
.DESCRIPTION  
	 This runbook is intended to start/stop Application Gateway
		
	 This runbook requires the Azure Automation Run-As (Service Principle) account, which must be added when creating the Azure Automation account.
.EXAMPLE  
	.\AppGw-Start-Stop-Parameters -Action "Value1" -WhatIf "False"

.PARAMETER  
    Parameters are read in from Azure Automation variables.  
    Variables (editable):

#>
Param(
[Parameter(Mandatory=$true,HelpMessage="Enter the value for Action. Values can be either stop or start")][String]$Action
)

	



$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "

    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName

    "Logging in to Azure..."
    $connectionResult =  Connect-AzAccount -Tenant $servicePrincipalConnection.TenantID `
                             -ApplicationId $servicePrincipalConnection.ApplicationID   `
                             -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
                             -ServicePrincipal
    "Logged in."

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
# Get Azure Application Gateway
$appgw=Get-AzApplicationGateway -Name Casazero-AppGw -ResourceGroupName AppGW-rg
 
# Stop the Azure Application Gateway
#Stop-AzApplicationGateway -ApplicationGateway $appgw


if($Action.ToLower() -eq 'start')
{
		Start-AzApplicationGateway -ApplicationGateway $appgw
}
elseif($Action.ToLower() -eq 'stop')
{
		Stop-AzApplicationGateway -ApplicationGateway $appgw
}



