# Set the current directory as the working directory
Set-Location -Path $PWD

$command2 = "dart run serious_python:main package --asset app/desktop.zip ..\..\extension_server\src\"

$command3 = "dart run serious_python:main package --asset app/mobile.zip ..\..\extension_server\src\ --mobile"

# Execute the command
Invoke-Expression $command2
Invoke-Expression $command3
