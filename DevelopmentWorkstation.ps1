$scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

function Install-NeededFor {
param(
   [string] $packageName = ''
  ,[bool] $defaultAnswer = $true
)
  if ($packageName -eq '') {return $false}

  $yes = '6'
  $no = '7'
  $msgBoxTimeout='-1'
  $defaultAnswerDisplay = 'Yes'
  $buttonType = 0x4;
  if (!$defaultAnswer) { $defaultAnswerDisplay = 'No'; $buttonType= 0x104;}

  $answer = $msgBoxTimeout
  try {
    $timeout = 10
    $question = "Do you need to install $($packageName)? Defaults to `'$defaultAnswerDisplay`' after $timeout seconds"
    $msgBox = New-Object -ComObject WScript.Shell
    $answer = $msgBox.Popup($question, $timeout, "Install $packageName", $buttonType)
  }
  catch {
  }

  if ($answer -eq $yes -or ($answer -eq $msgBoxTimeout -and $defaultAnswer -eq $true)) {
    write-host "Installing $packageName"
    return $true
  }

  write-host "Not installing $packageName"
  return $false
}

function InstallDotNet35
{
    Write-Host 'Enabling/Installing DotNet 3.5'
    Install-WindowsFeature NET-Framework-Core -Source 'C:\Temp\sources\Sxs\'
}

#################################################################
#Run List

#Ask False Stuff First
$installChoco = Install-NeededFor -PackageName 'Chocolatey' -DefaultAnswer $false
$installSSDB = Install-NeededFor -PackageName 'Sql Server Database' -DefaultAnswer $false

#Now Ask True Stuff
$installIIS=Install-NeededFor -PackageName 'IIS' -DefaultAnswer $true
$installVS2013 = Install-NeededFor -PackageName 'VS2013' -DefaultAnswer $true

if($installSSDB -eq $false){
    $installSSMS = Install-NeededFor -PackageName 'Sql Server Management Studio' -DefaultAnswer $true
}

#################################################################


#install chocolatey
if ($installChoco) {
  iex ((new-object net.webclient).DownloadString("http://chocolatey.org/install.ps1")) 
}

#Core Windows Features
Install-WindowsFeature NET-Framework-45-Core

#install common stuff
cinst google-chrome-x64
cinst notepadplusplus
cinst webpicmd
cinst githubforwindows

#Sql Management Studio and Sql Server
if ($installSSDB -or $installSSMS) {
    InstallDotNet35
}


if ($installVS2013) {
    
}

if ($installIIS) {

    Install-WindowsFeature Web-Asp-Net45
    Install-WindowsFeature Web-Net-Ext45
    Install-WindowsFeature Web-Mgmt-Console
    Install-WindowsFeature Web-WebSockets
    Install-WindowsFeature Web-Dyn-Compression
    Install-WindowsFeature Web-Basic-Auth
    Install-WindowsFeature Web-IP-Security
}



<#

Help:

Get List of webpi packages (https://github.com/chocolatey/chocolatey/wiki/CommandsWebPI)
clist -source webpi

#>