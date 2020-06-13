NET USER ansible_user "Passw0rd" /ADD
NET LOCALGROUP "Administrators" "ansible_user" /ADD
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
netsh advfirewall firewall add rule name="WinRM" dir=in action=allow protocol=TCP localport=5985 remoteip=10.0.0.15

#################If some network related issue occurs######################
$networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}")) 
$connections = $networkListManager.GetNetworkConnections() 

# Set network location to Private for all networks 
$connections | % {$_.GetNetwork().SetCategory(1)}

###################COnnection Check#######################
winrm identify -u:ansible_user -p:Passw0rd -r:http://localhost:5985