# Comando úteis

## Limpa a tela para não encher a paciencia
Clear-Host

##------------------------------------------------------------------------------------------------
## Checagen de dirertórios e arquivos
if (Test-Path C:\Users\David\Desktop\COMPARE\) {
    Write-Host "Diretório existente"
} else {
    Write-Host "Diretório não existente"
}

if (Test-Path c:) {
    Write-Host "O dico local c:\ existe"
} else {
    Write-Host "O dico local não c:\ existe"
}

if (Test-Path C:\Users\David\Desktop\COMPARE\IPServer1.txt) {
    Write-Host "O arquivo existe"
} else {
    Write-Host "O arquivo não existe"
}

##------------------------------------------------------------------------------------------------
## Comparação de objetos
$strReference = Get-Content "C:\Users\David\Desktop\COMPARE\MonitorServices Nosso.txt"
$strDifference = Get-Content "C:\Users\David\Desktop\COMPARE\MonitorServices.txt"
Compare-Object $strReference $strDifference

##------------------------------------------------------------------------------------------------
Clear-host
## Validando IP
$ip = Read-host "Digite o ip"
$pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
if($ip -match $pattern){
        Write-host "O ip é válido"
} else {
        Write-host "O IP não é válido"
}

## Validando IP com repetição
Clear-host
$pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"

do{
    $ip = Read-host "Digite o ip"
    $teste = $ip -match $pattern
    
    if($teste -ne "False"){
    Write-host "O ip é inválido"
}else{
    Write-host "O ip é válido"
}

}while($teste -ne "False")

##------------------------------------------------------------------------------------------------
## Alerta de pop-up
powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Mensagem de alerta','Alerta')}"

##------------------------------------------------------------------------------------------------
## Alerta de balão
[reflection.assembly]::loadwithpartialname('System.Windows.Forms')
[reflection.assembly]::loadwithpartialname('System.Drawing')
$notify = new-object system.windows.forms.notifyicon
$notify.icon = [System.Drawing.SystemIcons]::Information
$notify.visible = $true
$notify.showballoontip(10,'Alerta','balão de alerta',[system.windows.forms.tooltipicon]::None)


##------------------------------------------------------------------------------------------------
## Criando um arquivo
New-Item C:\Users\David\Desktop\COMPARE\test.config
## Criando um arquivo na pasta raiz
New-Item -Path .\Teste.txt

##------------------------------------------------------------------------------------------------
## Criando um novo config setando os IP's automáticos
$ip = Read-host "Indique o IP do Servidor"

Set-Content C:\Users\David\Desktop\COMPARE\test.config '<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <configSections>
    <section name="tactiumIP" type="Softium.TactiumIP.Settings, Softium.TactiumIP"/>
    <section name="log4net" type="System.Configuration.IgnoreSectionHandler" />
  </configSections>

  <tactiumIP>
    <config>
      <properties>
          <property name="useBuiltinAcd" value="true" />
	  <property name="queueDevice" value="7779" />
      </properties>
    </config>
    <modules>
      <essentials>
        <module name="Softium.TactiumIP.Core" type="Core">
	<!-- ENDERECO DA MAQUINA DO REPLICATION EM SERVICEINFOURL-->
          <properties>
            <property name="adminEnable" value="true" />
            <property name="adminPort" value="3308" />
			<property name="bindAddress" value="ipdocliente" />
            <property name="supervEnable" value="true" />
            <property name="supervPort" value="3309" />
            <property name="serviceInfoUrl" value="tcp://192.168.70.242:37025/ServiceInfo" />
	        <property name="snapshotInterval" value="300" />'



(Get-Content C:\Users\David\Desktop\COMPARE\test.config) |
    ForEach-Object {$_ -Replace 'ipdocliente', $ip} |
        Set-Content C:\Users\David\Desktop\COMPARE\test.config
Get-Content C:\Users\David\Desktop\COMPARE\test.config




