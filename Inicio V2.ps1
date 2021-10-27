# Sobre o IIS
### Função instalar o IIS
Function instalacaoIIS {
    Write-Host "Instalando o IIS"
    $hostname = hostname
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    
    # Instalando as Funções
    Write-Host "Habilitando as Features do IIS"
    
    #Install-WindowsFeature -Name Web-App-Dev -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Net-Ext45 -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Asp-Net45 -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-ISAPI-Ext -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-ISAPI-Filter -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Http-Redirect -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Basic-Auth -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Client-Auth -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Windows-Auth -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Metabase -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name Web-Lgcy-Mgmt-Console -IncludeManagementTools -ComputerName $hostname
    #Install-WindowsFeature -Name NET-Framework-Features -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name NET-Framework-Core -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name NET-Framework-45-Core -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name NET-Framework-45-ASPNET -IncludeManagementTools -ComputerName $hostname
    Install-WindowsFeature -Name NET-WCF-HTTP-Activation45 -IncludeManagementTools -ComputerName $hostname
    }
### Chamando a função de instalar o IIS
    Write-Host "Atenção! este script deve ser executado no servidor onde deve ser instalado o IIS"
   $servidorIIS = Read-Host "Você está no servidor que dever ser instalado o IIS? Digite ""S"" para sim e ""N"" para não"
   if ($servidorIIS -eq "S") {
       instalacaoIIS
       }
       else
       {
       $ipdoiis = read-Host "Informe o IP onde deve ser instalado o IIS"
       $usuarioiis = read-Host "Informe o user do servidor do IIS e caso tenha Dominio, informe com o dominio"
       Enter-PSSession -ComputerName $ipdoiis -Credential $usuarioiis
       #instalacaoIIS
       }

#verificando pasta dos arquivos de instalação.
    do{
        $usuário = $env:username
        write-host $usuário
        $testepacote = Test-Path C:\Users\$usuário\Desktop\instalacao
        if($testepacote -eq "True"){
            Write-host "Pasta existe, com diretório em Ingles!" -ForegroundColor Green
            $caminhopacotecoletado = "C:\Users\$usuário\Desktop\instalacao"
        }
        else
        {
         Write-host "Pasta existe, com diretório em português!" -ForegroundColor Red
            $caminhopacotecoletado = "C:\Usuários\$usuário\Área de trabalho\instalacao"
        }
        }while($teste -eq "True")

# Sobre a instalação do CRM
function instalandoCRM {
    #Coletando o nome da Base CRM
    $basecrm = Read-Host "Informe o nome da Base Tactium"
    $ipdobd = Read-Host "Informe o IP do banco"
    
    $dir = Read-Host "Qual o diretorio C ou D?"
    if($dir -eq "C"){
      $caminhocrm = "C:\inetpub\wwwroot\CRM"
    }
    else {
      $caminhocrm = "D:\inetpub\wwwroot\CRM"        
    }

    
    Write-Host "Criando pools CRM"
    
    New-WebAppPool NewManager -force
    New-WebAppPool ManagerConsulta -force
    New-WebAppPool ManagerAdmin -force
    New-WebAppPool CRM -force

    #Pool Classic 
    Set-ItemProperty -Path "IIS:\AppPools\ManagerConsulta" -name "managedPipelineMode" -value 0  # 0 = Integrated  1 = Classic

    Write-Host "Criando as Pastas do CRM"
    
    #Duvida: Como pegar o resultado final desse caminho e salvar em uma variável?
    new-item -path "$caminhocrm" -name "NewManager" -itemtype directory -Force
    new-item -path "$caminhocrm" -name "ManagerConsulta" -itemtype directory -force
    new-item -path "$caminhocrm" -name "ManagerAdmin" -itemtype directory -force

    #criando os Sites.
    Write-Host "Criando os Sites CRM"

    New-WebApplication -name CRM -Site 'Default Web Site' -PhysicalPath "${caminhocrm}" -ApplicationPool CRM -force
    New-WebApplication -name Client -Site 'Default Web Site/CRM' -PhysicalPath "${caminhocrm}\NewManager" -ApplicationPool NewManager -force
    New-WebApplication -name Consulta -Site 'Default Web Site/CRM' -PhysicalPath "${caminhocrm}\ManagerConsulta" -ApplicationPool ManagerConsulta -force
    New-WebApplication -name Admin -Site 'Default Web Site/CRM' -PhysicalPath "${caminhocrm}\ManagerAdmin" -ApplicationPool ManagerAdmin -force

    #copiando os arquivos para os diretórios
    Write-Host "Copiando arquivos para as pastas CRM"
    
    Copy-Item -Path "$caminhopacotecoletado\CRM\Newmanager\*" -Destination "${caminhocrm}\NewManager\" -Recurse
    Copy-Item -Path "$caminhopacotecoletado\CRM\ManagerConsulta\*" -Destination "${caminhocrm}\ManagerConsulta\" -Recurse 
    Copy-Item -Path "$caminhopacotecoletado\CRM\ManagerAdmin\*" -Destination "${caminhocrm}\ManagerAdmin\" -Recurse

    #Copiando os configs
    Write-Host "Copiando os configs para as pastas"

    Copy-Item -Path "$caminhopacotecoletado\configs\Newmanager\*" -Destination "${caminhocrm}\NewManager\" -Recurse 
    Copy-Item -Path "$caminhopacotecoletado\configs\ManagerConsulta\*" -Destination "${caminhocrm}\ManagerConsulta\" -Recurse 
    Copy-Item -Path "$caminhopacotecoletado\configs\ManagerAdmin\*" -Destination "${caminhocrm}\ManagerAdmin\" -Recurse

    #Editando config da ManagerAdmin
    Write-Host "Editando o config do ManagerAdmin"
    
    Copy-Item -Path "$caminhopacotecoletado\configs\ManagerAdmin\*" -Destination "${caminhocrm}\ManagerAdmin\" -Recurse
        Set-Location ${caminhocrm}"\ManagerAdmin\"
        powershell -Command "(gc Bibliotecas.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Bibliotecas.config"
        powershell -Command "(gc Bibliotecas.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Bibliotecas.config"
		#powershell -Command "(gc Bibliotecas.config) -replace 'diretoriFoinsta', '$diretorioinsta' | Out-File -encoding ASCII Bibliotecas.config"
		powershell -Command "(gc Bibliotecas.config) -replace 'caminhocrm', '$caminhocrm' | Out-File -encoding ASCII Bibliotecas.config"

    #Editando config da ManagerConsulta
    Write-Host "Editando o config do ManagerConsulta"
    
    Copy-Item -Path "$caminhopacotecoletado\configs\ManagerConsulta\*" -Destination "${caminhocrm}\ManagerConsulta\" -Recurse
        Set-Location ${caminhocrm}"\ManagerConsulta\"
        powershell -Command "(gc Bibliotecas.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Bibliotecas.config"
        powershell -Command "(gc Bibliotecas.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Bibliotecas.config"
		#powershell -Command "(gc Bibliotecas.config) -replace 'diretorioinsta', '$diretorioinsta' | Out-File -encoding ASCII Bibliotecas.config"
		powershell -Command "(gc Bibliotecas.config) -replace 'caminhocrm', '$caminhocrm' | Out-File -encoding ASCII Bibliotecas.config"

    #Editando config da Newmanager
    Write-Host "Editando o config do Newmanager"
    
    Copy-Item -Path "$caminhopacotecoletado\configs\NewManager\*" -Destination "${caminhocrm}\NewManager\" -Recurse
        Set-Location ${caminhocrm}"\NewManager\"
        powershell -Command "(gc Bibliotecas.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Bibliotecas.config"
        powershell -Command "(gc Bibliotecas.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Bibliotecas.config"
		#powershell -Command "(gc Bibliotecas.config) -replace 'diretorioinsta', '$diretorioinsta' | Out-File -encoding ASCII Bibliotecas.config"
		powershell -Command "(gc Bibliotecas.config) -replace 'caminhocrm', '$caminhocrm' | Out-File -encoding ASCII Bibliotecas.config"
    }

# Sobre a instalação do Omni
function instalandoOmni {

    $basecrm = Read-Host "Informe o nome da Base Tactium"
    $ipdobd = Read-Host "Informe o IP do banco"
    
    $dir = Read-Host "Qual o diretorio C ou D?"
    if($dir -eq "C"){
      $caminhoomni = "C:\inetpub\wwwroot\OMNI"
    }
    else {
      $caminhoomni = "D:\inetpub\wwwroot\OMNI"        
    }
        #Write-Host "Instalando Omni na mesma maquina onde está o CRM" 
        Write-Host "Criando pools Omni"
    
        New-WebAppPool MonitorChatMail
        New-WebAppPool OmniPA
        New-WebAppPool WebChat
        New-WebAppPool Omni

        #Pool Classic 
        Set-ItemProperty -Path "IIS:\AppPools\OmniPA" -name "managedPipelineMode" -value 1  # 0 = Integrated  1 = Classic  
        Set-ItemProperty -Path "IIS:\AppPools\WebChat" -name "managedPipelineMode" -value 1  # 0 = Integrated  1 = Classic

        Write-Host "Criando as Pastas e Sites do OmniChanel"
        
        #Duvida: Como pegar o resultado final desse caminho e salvar em uma variável?
        new-item -path "$caminhoomni" -name "WebChat" -itemtype directory -Force
        new-item -path "$caminhoomni" -name "OmniPA" -itemtype directory -force
        new-item -path "$caminhoomni" -name "MonitorChatMail" -itemtype directory -force
   
        #criando os Sites.
          
        Write-Host "Criando os sites do OmniChanel"
        New-WebApplication -Name OMNI -Site 'Default Web Site' -PhysicalPath "${caminhoomni}" -ApplicationPool Omni -force
        New-WebApplication -name Monitor -Site 'Default Web Site/OMNI' -PhysicalPath "${caminhoomni}\MonitorChatMail" -ApplicationPool MonitorChatMail -force
        New-WebApplication -name Client -Site 'Default Web Site/OMNI' -PhysicalPath "${caminhoomni}\OmniPA" -ApplicationPool OmniPA -force
        New-WebApplication -name WebChat -Site 'Default Web Site/OMNI' -PhysicalPath "${caminhoomni}\WebChat" -ApplicationPool WebChat -force
  
        #copiando os arquivos para os diretórios
        Write-Host "Copiando arquivos para as pastas OmniChanel"
        
        Copy-Item -Path "$caminhopacotecoletado\Omni\OmniPA\*" -Destination "${caminhoomni}\OmniPA\" -Recurse
        Copy-Item -Path "$caminhopacotecoletado\Omni\MonitorOmniChannel\*" -Destination "${caminhoomni}\MonitorChatMail\" -Recurse 
        Copy-Item -Path "$caminhopacotecoletado\Omni\Webchat\*" -Destination "${caminhoomni}\WebChat\" -Recurse


        #Editando config da OmniPA
        Write-Host "Editando o config do OmniPA"
        
        Copy-Item -Path "$caminhopacotecoletado\configs\OmniPA\*" -Destination "${caminhoomni}\OmniPA\" -Recurse
            Set-Location ${caminhoomni}"\OmniPA\"
            powershell -Command "(gc Bibliotecas.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Bibliotecas.config"
            powershell -Command "(gc Bibliotecas.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Bibliotecas.config"
			#powershell -Command "(gc Bibliotecas.config) -replace 'diretorioinsta', '$diretorioinsta' | Out-File -encoding ASCII Bibliotecas.config"
			powershell -Command "(gc Bibliotecas.config) -replace 'caminhoomni', '$caminhoomni' | Out-File -encoding ASCII Bibliotecas.config"

        #Editando config da MonitorOmniChannel
        Write-Host "Editando o config do MonitorOmniChannel"
        
        Copy-Item -Path "$caminhopacotecoletado\configs\MonitorOmniChannel\*" -Destination "${caminhoomni}\MonitorChatMail\" -Recurse
            Set-Location ${caminhoomni}"\MonitorChatMail\"
            powershell -Command "(gc Bibliotecas.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Bibliotecas.config"
            powershell -Command "(gc Bibliotecas.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Bibliotecas.config" 
			#powershell -Command "(gc Bibliotecas.config) -replace 'diretorioinsta', '$diretorioinsta' | Out-File -encoding ASCII Bibliotecas.config"
			powershell -Command "(gc Bibliotecas.config) -replace 'caminhoomni', '$caminhoomni' | Out-File -encoding ASCII Bibliotecas.config"

        #Editando config da Webchat
        Write-Host "Editando o config do Webchat"
        
        Copy-Item -Path "$caminhopacotecoletado\configs\Webchat\*" -Destination "${caminhoomni}\Webchat\" -Recurse
        Set-Location ${caminhoomni}"\Webchat\"
        powershell -Command "(gc Bibliotecas.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Bibliotecas.config"
        powershell -Command "(gc Bibliotecas.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Bibliotecas.config"
		#powershell -Command "(gc Bibliotecas.config) -replace 'diretorioinsta', '$diretorioinsta' | Out-File -encoding ASCII Bibliotecas.config"
		powershell -Command "(gc Bibliotecas.config) -replace 'caminhoomni', '$caminhoomni' | Out-File -encoding ASCII Bibliotecas.config"
    }


$confCRM = Read-Host "Deseja instalar o pacote CRM? Digite S para sim e N para não"
if($confCRM -eq "S"){
    instalandoCRM
}

$confOmni = Read-Host "Deseja instalar o pacote Omni? Digite S para sim e N para não"
if($confOmni -eq "S"){
    instalandoOmni
}

$confChatServer = Read-Host "Deseja instalar o ChatMailServer? Digite S para sim e N para não"
if($confChatServer -eq "S"){
    Write-Host "Inicializando a instalação."
    $usuário = $env:username
    Start-Process "C:\Users\$usuário\Desktop\instalacao\ChatMailServer\Softium.TactiumChat.ChatServer.msi" /passive

    $instChat = Read-Host "Instalação finalizada? Deseja continuar para a configurações? Digite S para sim e N para não"
    if($instChat -eq "S") {
        
        $caminhopacotecoletado = "C:\Users\$usuário\Desktop\instalacao"

        #Coletando o nome da Base CRM
        $basecrm = Read-Host "Informe o nome da Base Tactium"
        $ipdobd = Read-Host "Informe o IP do banco"
        
        $caminhoChatServer = "C:\Program Files\Softium Informática\Softium.ChatServer"

        #Copiando os configs
        Write-Host "Copiando os configs para as pastas"

        Copy-Item -Path "$caminhopacotecoletado\configs\ChatMailServer\*" -Destination "${caminhoChatServer}\" -Recurse

        #Editando config ChatServer
        Write-Host "Editando o Config"
    
        Copy-Item -Path "$caminhopacotecoletado\configs\ChatMailServer\*" -Destination "${caminhoChatServer}\" -Recurse
        Set-Location ${caminhoChatServer}"\"
        
        #Editando config exe
        powershell -Command "(gc Softium.Tactium.ChatServer.Service.exe.config) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII Softium.Tactium.ChatServer.Service.exe.config"
        powershell -Command "(gc Softium.Tactium.ChatServer.Service.exe.config) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII Softium.Tactium.ChatServer.Service.exe.config"
        
        #Editando config ini
        powershell -Command "(gc TTChatMailServer.ini) -replace 'basecrm', '$basecrm' | Out-File -encoding ASCII TTChatMailServer.ini"
        powershell -Command "(gc TTChatMailServer.ini) -replace 'ipdobd', '$ipdobd' | Out-File -encoding ASCII TTChatMailServer.ini"

    }

    #Subindo o serviço
    Write-Host "Subindo o serviço."
    Start-Service ChatServer
    Get-Service ChatServer
}
