Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$KhompAPIService = Get-Service -Name "Khomp API Server Fake"
$KhompKibsService = Get-Service -Name "Khomp Integrated Boot System Fake"
$KhompLogService = Get-Service -Name "Khomp Log Server Fake"
$KhompMediaService = Get-Service -Name "Khomp Media Server Fake"
$KhompMrcpService = Get-Service -Name "Khomp MRCP Client Fake"
$KhompQueryService = Get-Service -Name "Khomp Query Server Fake"
$BoardService = Get-Service -Name "TactiumIP Board Service Fake"
$IpService = Get-Service -Name "TactiumIP Service Fake"
$ReplicationService = Get-Service -Name "TactiumIP Replication Service Fake"

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = '582,400'
$Form.text = "Dependências TactiumIP"
$Form.MaximizeBox = $false           
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D 
   
$TextBox1 = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline = $true
$TextBox1.width = 565
$TextBox1.height = 330
$TextBox1.location = New-Object System.Drawing.Point(8,60)
$TextBox1.Font = 'Microsoft Sans Serif,10'
$TextBox1.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Center
$TextBox1.Enabled = $false

$btnCheckDependencies = New-Object system.Windows.Forms.Button
$btnCheckDependencies.text = "Verificar dependencias"
$btnCheckDependencies.width = 180
$btnCheckDependencies.height = 30
$btnCheckDependencies.location = New-Object System.Drawing.Point(8,15)
$btnCheckDependencies.Font = 'Microsoft Sans Serif,10'

$btnFixDependencies = New-Object system.Windows.Forms.Button
$btnFixDependencies.text = "Corrigir dependências"
$btnFixDependencies.width = 175
$btnFixDependencies.height = 30
$btnFixDependencies.location = New-Object System.Drawing.Point(205,15)
$btnFixDependencies.Font = 'Microsoft Sans Serif,10'

$btnRemoveDependencies = New-Object system.Windows.Forms.Button
$btnRemoveDependencies.text = "Remover dependências"
$btnRemoveDependencies.width = 176
$btnRemoveDependencies.height = 30
$btnRemoveDependencies.location = New-Object System.Drawing.Point(398,15)
$btnRemoveDependencies.Font = 'Microsoft Sans Serif,10'

function CheckDependencies{​
    $TextBox1.Text = " "  
    $KhompAPIService.Refresh()
    $KhompKibsService.Refresh()
    $KhompLogService.Refresh()
    $KhompMediaService.Refresh()
    $KhompMrcpService.Refresh()
    $KhompQueryService.Refresh()
    $BoardService.Refresh()
    $IpService.Refresh()
    $ReplicationService.Refresh()
    $ServicesOnDepencyError = [System.Collections.ArrayList]::new() 
    if(!($KhompAPIService.ServicesDependedOn.Where({​$_.Name -eq $KhompMediaService.Name}​) -ne $null)){​
        $ServicesOnDepencyError.Add($KhompAPIService) | Out-Null
    }​
    if(!($KhompMrcpService.ServicesDependedOn.Where({​$_.Name -eq $KhompAPIService.Name}​) -ne $null)){​
        $ServicesOnDepencyError.Add($KhompMrcpService) | Out-Null
    }​
    if(!($BoardService.ServicesDependedOn.Where({​$_.Name -eq $KhompAPIService.Name}​) -ne $null)){​
        $ServicesOnDepencyError.Add($BoardService) | Out-Null
    }​
    if(!($IpService.ServicesDependedOn.Where({​$_.Name -eq $BoardService.Name}​) -ne $null)){​
        $ServicesOnDepencyError.Add($IpService) | Out-Null
    }​
    if($ServicesOnDepencyError.Count -gt 0){​
        $TextBox1.Text += "Foram encontrados os seguintes serviços configurados incorretamente:" 
        $TextBox1.Text +=  [Environment]::NewLine
        $TextBox1.Text += "--------------------------------------------------------------------"  + [Environment]::NewLine
        $ServicesOnDepencyError | ForEach-Object{​ $TextBox1.Text += $_.DisplayName + [Environment]::NewLine}​
        $TextBox1.Text += "--------------------------------------------------------------------" 
    }​else{​
        $TextBox1.Text +="Todas as dependências dos serviços estão configuradas corretamente:"
    }​
}​
function FixDependencies{​
    $TextBox1.Text = " "  
    $TextBox1.Text +=  "----------------------------------------------------------------------------" + [Environment]::NewLine
    $TextBox1.Text +=  "Configurando as dependências dos serviços corretamente:" + [Environment]::NewLine
    $TextBox1.Text +=  "----------------------------------------------------------------------------" + [Environment]::NewLine
    sc.exe config $KhompAPIService.Name  depend= $KhompMediaService.Name
    sc.exe config $KhompMrcpService.Name depend= $KhompAPIService.Name 
    sc.exe config $BoardService.Name depend= $KhompAPIService.Name 
    sc.exe config $IpService.Name depend= $BoardService.Name 
    $TextBox1.Text +=   "----------------------------------------------------------------------------" + [Environment]::NewLine
    $TextBox1.Text +=   "Dependências dos serviços configuradas" + [Environment]::NewLine
    $TextBox1.Text +=   "----------------------------------------------------------------------------" + [Environment]::NewLine
}​
function RemoveDependencies{​
    $TextBox1.Text = " "  
    $TextBox1.Text +=   "----------------------------------------------------------------------------"  + [Environment]::NewLine
    $TextBox1.Text +=   "Removendo as dependências dos serviços:"  + [Environment]::NewLine
    $TextBox1.Text +=  "----------------------------------------------------------------------------" + [Environment]::NewLine
    sc.exe config $KhompAPIService.Name  depend= " "
    sc.exe config $KhompMrcpService.Name depend= " "
    sc.exe config $BoardService.Name depend= " "
    sc.exe config $IpService.Name depend= " "
    $TextBox1.Text +=   "----------------------------------------------------------------------------" + [Environment]::NewLine
    $TextBox1.Text +=  "Dependências dos serviços removidas" + [Environment]::NewLine
    $TextBox1.Text +=   "----------------------------------------------------------------------------"  + [Environment]::NewLine
}​
$btnCheckDependencies.Add_Click({​CheckDependencies}​)
$btnFixDependencies.Add_Click({​FixDependencies}​)
$btnRemoveDependencies.Add_Click({​RemoveDependencies}​)
$Form.controls.AddRange(@($TextBox1,$btnCheckDependencies,$btnFixDependencies,$btnRemoveDependencies))
$Form.ShowDialog()
    
    
  
  

