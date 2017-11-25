FROM acadon/timber
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY Custom /Custom/
RUN PowerShell .\Custom\BuildCustomImageFromFob.ps1