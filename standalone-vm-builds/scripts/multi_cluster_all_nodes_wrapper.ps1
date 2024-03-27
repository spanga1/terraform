$ClusterNames = @()

#foreach($ClusterName in $ClusterNames) {
$ClusterNames | ForEach-Object -ThrottleLimit 7 -Parallel {
    $ClusterName = $_

    $LogFileName = "${ClusterName}_DomainJoin_Log.txt"
    $LogFilePath = "${using:PSScriptRoot}\${LogFileName}"

    $TargetScript = "${using:PSScriptRoot}\${ClusterName}\all_nodes\all_nodes_wrapper.ps1"
    Write-output "Executing  script for ${ClusterName} to join VMs to Domain"
    & $TargetScript 3>&1 2>&1 >> $LogFilePath
}