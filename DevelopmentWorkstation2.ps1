#boxstarter http://boxstarter.org/downloads/Boxstarter.2.5.21.zip

Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Enable-RemoteDesktop

#optional
#cinst skype -y
#cinst vlc -y

cinst google-chrome-x64 -y
cinst notepadplusplus -y
cinst fiddler4 -y
cinst 7zip -y
cinst sysinternals -y
cinst resharper -y
cinst github  -y #GitHub sometimes needs some help

Install-ChocolateyVsixPackage SqlLiteToolbox https://visualstudiogallery.msdn.microsoft.com/0e313dfd-be80-4afb-b5e9-6e74d369f7a1/file/29445/76/SqlCeToolbox.4.3.0.2.vsix
 
#cinst dotnet3.5 -y #doesn't work?
#cinst IIS-WebServerRole -source windowsfeatures
#cinst IIS-HttpCompressionDynamic -source windowsfeatures
