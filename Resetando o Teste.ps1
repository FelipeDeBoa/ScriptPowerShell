Import-Module WebAdministration
Remove-WebAppPool WebChat
Remove-WebAppPool OmniPA
Remove-WebAppPool NewManager
Remove-WebAppPool ManagerADM
Remove-WebAppPool ManagerConsulta
Remove-WebAppPool OmniMonitor

Remove-WebSite -Name "WebChat"
Remove-WebSite -Name "OmniPA"
Remove-WebSite -Name "NewManager"
Remove-WebSite -Name "ManagerADM"
Remove-WebSite -Name "ManagerConsulta"
Remove-WebSite -Name "OmniMonitor"

Remove-Item -Path C:\inetpub\wwwroot\ManagerCRM -recurse