#$ScopeName example:  192.168.108.0
#$DomainName example:  vsphere.local
#$DataPath example:  C:\VCF_SC.csv

$ScopeName = read-host -Prompt "Type in DHCP Scope Name"  
$DomainName = read-host -Prompt "Type in DNS Zone Name" 
$DataPath = read-host -prompt "Type in CSV file path"
$DhcpScope = Get-DhcpServerv4Scope | where-object{ $_.name.tolower() -eq $ScopeName.ToLower() } 
$ESXiHosts = import-csv -Path $dataPath -Delimiter "," 
 
foreach( $r in $ESXiHosts ) 
{ 
    if ( $r.'MAC' -eq $null ) { continue } 
    $m = ($r.'MAC').replace( ":", "-") 
    Add-DnsServerResourceRecordA -ZoneName $DomainName -Name $r.'FQDN' -IPv4Address $r.'IP' -CreatePtr
    Add-DhcpServerv4Reservation -ScopeId $ScopeName -IPAddress $r.'IP' -Name $r.'FQDN' -ClientId $m -Type Dhcp 
   
} 