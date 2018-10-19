workflow Shutdown-ARM-VMs-Parallel
{

	$SubscriptionId         = "ae8ab787-c66f-4733-aed2-228ab3e8523b"
    $TenantID               = "b41b72d0-4e9f-4c26-8a69-f949f367c91d"
    $CredentialAssetName    = "kristianCredential"
   


	"CredentialAssetName: $CredentialAssetName"
	#Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName;
    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account
	$Account = Login-AzureRmAccount -Credential $Cred -TenantId $TenantID -ServicePrincipal 
    
    $subscription = Get-AzureRmSubscription | Where-Object {$_.Id -eq $SubscriptionId} | Set-AzureRmContext

	$vms = Get-AzureRmVM
	
	Foreach -Parallel ($vm in $vms){
	    Write-Output "Stopping $($vm.Name)";		
	    Stop-AzureRmVm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force;
	}
}