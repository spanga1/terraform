$ClusterNames = @()

$ClusterNames | ForEach-Object -ThrottleLimit 7 -Parallel {
#foreach($ClusterName in $ClusterNames) {
    $ClusterName = $_

    $LogFileName = "${ClusterName}_FCI_Log.txt"
    $LogFilePath = "${using:PSScriptRoot}\${LogFileName}"

    $TargetScript = "${using:PSScriptRoot}\${ClusterName}\first_node\create_cluster_without_disks.ps1"
    Write-output "Executing  script for FCI Cluster ${ClusterName}"
    & $TargetScript 3>&1 2>&1 >> $LogFilePath
}