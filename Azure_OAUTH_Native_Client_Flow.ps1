# Replace the Tutorial Sample App ID with your registered application ID. 
$clientId = "6731de76-14a6-49ae-97bc-6eba6914391e"

Start-Process "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=$clientId&scope=openid%20profile%20https://ads.microsoft.com/msads.manage%20offline_access&response_type=code&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient&state=ClientStateGoesHere&prompt=login"

$code = Read-Host "Grant consent in the browser, and then enter the response URI here:"
$code = $code -match 'code=(.*)\&'
$code = $Matches[1]

# Get the initial access and refresh tokens. 

$response = Invoke-WebRequest https://login.microsoftonline.com/common/oauth2/v2.0/token -ContentType application/x-www-form-urlencoded -Method POST -Body "client_id=$clientId&scope=https://ads.microsoft.com/msads.manage%20offline_access&code=$code&grant_type=authorization_code&redirect_uri=https%3A%2F%2Flogin.microsoftonline.com%2Fcommon%2Foauth2%2Fnativeclient"

$oauthTokens = ($response.Content | ConvertFrom-Json)  
Write-Output "Access token: " $oauthTokens.access_token  
Write-Output "Access token expires in: " $oauthTokens.expires_in  
Write-Output "Refresh token: " $oauthTokens.refresh_token 

# The access token will expire e.g., after one hour. 
# Use the refresh token to get new access and refresh tokens. 

$response = Invoke-WebRequest https://login.microsoftonline.com/common/oauth2/v2.0/token -ContentType application/x-www-form-urlencoded -Method POST -Body "client_id=$clientId&scope=https://ads.microsoft.com/msads.manage%20offline_access&code=$code&grant_type=refresh_token&refresh_token=$($oauthTokens.refresh_token)"

$oauthTokens = ($response.Content | ConvertFrom-Json)  
Write-Output "Access token: " $oauthTokens.access_token  
Write-Output "Access token expires in: " $oauthTokens.expires_in  
Write-Output "Refresh token: " $oauthTokens.refresh_token
