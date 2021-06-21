 #FelipeDeBoa_Technology
 # Pré-requisito: Os pacotes devem estar na pasta C:\temp\Pacotes\ de acordo com o nome dos sites.
 # NewManager - ManagerADM - ManagerConsulta - OmniPA - WebChat - OmniMonitor
 
 ##BACKUP 
 #copy-item C:\inetpub\wwwroot\ManagerCRM -destination C:\temp\#Backup -recurse -Force
 
 
 Import-Module WebAdministration
 #Instalando Aplicação

 #Site
  $test = "C:\inetpub\wwwroot\ManagerCRM"
  If(!(test-path $test)) 
{
  New-Item IIS:\Sites\ManagerCRM -bindings @{protocol=”http”;bindingInformation=”:80:ManagerCRM”}-physicalPath C:\inetpub\wwwroot\ManagerCRM 
  
  #Criando a Estrutura (Pastas)
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\TactiumOmniWebhook -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\TactiumOmniWebhook\AplicacaoGupShup -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\NewManager -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\ManagerADM -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\ManagerConsulta -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\OmniPA -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\WebChat -ItemType directory
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\OmniMonitor -ItemType directory 
  New-Item -Path C:\inetpub\wwwroot\ManagerCRM\ManagerWS -ItemType directory 
     
  
 #Criando os Aplicativos
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\TactiumOmniWebhook\AplicacaoGupShup" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\TactiumOmniWebhook\AplicacaoGupShup"    
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\NewManager" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\NewManager" 
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\ManagerADM" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\ManagerADM" 
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\ManagerConsulta" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\ManagerConsulta" 
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\OmniPA" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\OmniPA" 
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\WebChat" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\WebChat" 
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\OmniMonitor" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\OmniMonitor" 
  New-Item -Type Application -Path "IIS:\Sites\ManagerCRM\ManagerWS" -physicalPath "C:\inetpub\wwwroot\ManagerCRM\ManagerWS" 

  # Criando os Pool's
  New-WebAppPool AplicacaoGupShup
  New-WebAppPool ManagerCRM
  New-WebAppPool NewManager
  New-WebAppPool ManagerADM
  New-WebAppPool ManagerConsulta
  New-WebAppPool OmniMonitor
  New-WebAppPool OmniPA
  New-WebAppPool WebChat
  New-WebAppPool ManagerWS
#Pool Classic   
  Set-ItemProperty -Path "IIS:\AppPools\OmniPA" -name "managedPipelineMode" -value 1  # 0 = Integrated  1 = Classic  
  Set-ItemProperty -Path "IIS:\AppPools\WebChat" -name "managedPipelineMode" -value 1  # 0 = Integrated  1 = Classic  
  Set-ItemProperty -Path "IIS:\AppPools\ManagerWS" -name "managedPipelineMode" -value 1  # 0 = Integrated  1 = Classic
  Set-ItemProperty -Path "IIS:\AppPools\ManagerConsulta" -name "managedPipelineMode" -value 1  # 0 = Integrated  1 = Classic
#Pool 32 Bits  
  Set-ItemProperty -Path "IIS:\AppPools\ManagerConsulta" -name "enable32BitAppOnWin64" -value $true # 32bits true/false
  
 
 #Atribuindo Pool's  aos Aplicativos
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM" -name "applicationPool" -value "ManagerCRM"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\TactiumOmniWebhook\AplicacaoGupShup" -name "applicationPool" -value "AplicacaoGupShup"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\NewManager" -name "applicationPool" -value "NewManager"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\ManagerADM" -name "applicationPool" -value "ManagerADM"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\ManagerConsulta" -name "applicationPool" -value "ManagerConsulta"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\OmniPA" -name "applicationPool" -value "OmniPA"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\WebChat" -name "applicationPool" -value "WebChat"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\OmniMonitor" -name "applicationPool" -value "OmniMonitor"
  Set-ItemProperty -Path "IIS:\Sites\ManagerCRM\ManagerWS" -name "applicationPool" -value "ManagerWS"
 
 #Instalando o Serviço do ChatMailServer
 #$Instalando = Start-Process "C:\Temp\Pacotes\ChatMailServer\Softium.TactiumChat.ChatServer.msi" /passive

 
#DELETANDO O SERVIÇO 
#Remove-Service -Name "ChatServer"
#sc.exe delete "ChatServer"


 #Transferência de Pacotes  
   #1 Newmanager
      copy-item C:\temp\Pacotes\NewManager\ -destination C:\inetpub\wwwroot\ManagerCRM -recurse -Force    
   #2 ManagerADM
      copy-item C:\temp\Pacotes\ManagerADM\ -destination C:\inetpub\wwwroot\ManagerCRM -recurse -Force    
   #3 ManagerConsulta
      copy-item C:\temp\Pacotes\ManagerConsulta\ -destination C:\inetpub\wwwroot\ManagerCRM -recurse -Force    
   #4 OmniPA
      copy-item C:\temp\Pacotes\OmniPA\ -destination C:\inetpub\wwwroot\ManagerCRM -recurse -Force    
   #5 WebChat
      copy-item C:\temp\Pacotes\WebChat\ -destination C:\inetpub\wwwroot\ManagerCRM -recurse -Force     
   #6 OmniMonitor
      copy-item C:\temp\Pacotes\OmniMonitor\ -destination C:\inetpub\wwwroot\ManagerCRM -recurse -Force
   #7 applicationPool
      copy-item C:\temp\Pacotes\applicationPool\ -destination C:\inetpub\wwwroot\ManagerCRM\TactiumOmniWebhook\applicationPool -recurse -Force
   #8 ManagerWS
      copy-item C:\temp\Pacotes\ManagerWS\ -destination C:\inetpub\wwwroot\ManagerCRM\ManagerWS -recurse -Force
 
}
 Else
 {
   clear
   write-host "Site ManagerCRM já existe!" -ForegroundColor Red
 }
