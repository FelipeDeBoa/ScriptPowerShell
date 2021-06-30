$KhompAPIService = Get-Service -Name "Khomp API Server Fake"
$KhompKibsService = Get-Service -Name "Khomp Integrated Boot System Fake"
$KhompLogService = Get-Service -Name "Khomp Log Server Fake"
$KhompMediaService = Get-Service -Name "Khomp Media Server Fake"
$KhompMrcpService = Get-Service -Name "Khomp MRCP Client Fake"
$KhompQueryService = Get-Service -Name "Khomp Query Server Fake"
$BoardService = Get-Service -Name "TactiumIP Board Service Fake"
$IpService = Get-Service -Name "TactiumIP Service Fake"
$ReplicationService = Get-Service -Name "TactiumIP Replication Service Fake"
function CheckDependencies{
    $KhompAPIService.Refresh()
    $KhompKibsService.Refresh()
    $KhompLogService.Refresh()
    $KhompMediaService.Refresh()
    $KhompMrcpService.Refresh()
    $KhompQueryService.Refresh()
    $BoardService.Refresh()
    $IpService.Refresh()
    $ReplicationService.Refresh()
  
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Information  "Verificando se as dependências dos serviços estão configuradas corretamente:" -InformationAction Continue
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Host  `n
    $ServicesOnDepencyError = [System.Collections.ArrayList]::new() 
    if(!($KhompAPIService.ServicesDependedOn.Where({$_.Name -eq $KhompMediaService.Name}) -ne $null)){
        $ServicesOnDepencyError.Add($KhompAPIService) | Out-Null
    }
    if(!($KhompMrcpService.ServicesDependedOn.Where({$_.Name -eq $KhompAPIService.Name}) -ne $null)){
        $ServicesOnDepencyError.Add($KhompMrcpService) | Out-Null
    }
    if(!($BoardService.ServicesDependedOn.Where({$_.Name -eq $KhompAPIService.Name}) -ne $null)){
        $ServicesOnDepencyError.Add($BoardService) | Out-Null
    }
    if(!($IpService.ServicesDependedOn.Where({$_.Name -eq $BoardService.Name}) -ne $null)){
        $ServicesOnDepencyError.Add($IpService) | Out-Null
    }

    if($ServicesOnDepencyError.Count -gt 0){
        Write-Host "Foram encontrados os seguintes serviços configurados incorretamente:" `n
        Write-Host "----------------------------------------------------------------------------" 
        $ServicesOnDepencyError | ForEach-Object{ Write-Host $_.DisplayName}
        Write-Host "----------------------------------------------------------------------------" 
    }else{
     Write-Host "Todas as dependências dos serviços estão configuradas corretamente:"
    }
}
    
function FixDependencies{
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Information  "Configurando as dependências dos serviços corretamente:" -InformationAction Continue
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Host  `n
    sc.exe config $KhompAPIService.Name  depend= $KhompMediaService.Name
    sc.exe config $KhompMrcpService.Name depend= $KhompAPIService.Name 
    sc.exe config $BoardService.Name depend= $KhompAPIService.Name 
    sc.exe config $IpService.Name depend= $BoardService.Name 
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Information  "Dependências dos serviços configuradas" -InformationAction Continue
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Host  `n
}
function RemoveDependencies{
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Information  "Removendo as dependências dos serviços:" -InformationAction Continue
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Host  `n
    sc.exe config $KhompAPIService.Name  depend= " "
    sc.exe config $KhompMrcpService.Name depend= " "
    sc.exe config $BoardService.Name depend= " "
    sc.exe config $IpService.Name depend= " "
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Information  "Dependências dos serviços removidas" -InformationAction Continue
    Write-Information  "----------------------------------------------------------------------------" -InformationAction Continue
    Write-Host  `n
}