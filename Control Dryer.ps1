$ClientID="yourID"
$Secret="yourSecret"


#Auth 1
$URL="https://api.home-connect.com"
$Body = @{
    "client_id"  = "$ClientID"
    "scope"   = "IdentifyAppliance Monitor Control "
}

$AuthURL="https://api.home-connect.com/security/oauth/device_authorization"
$VerificationRepsonse=Invoke-RestMethod -Method POST -Uri $AuthURL -ContentType "application/x-www-form-urlencoded" -Body $Body

#Manual
$VerificationRepsonse.verification_uri_complete

#Build Token Header
$Body = @{
    "client_id"  = "$ClientID"
    "grant_type"   = "device_code"
    "client_secret" = "$Secret"
    "device_code" = "$($VerificationRepsonse.device_code)"
}

$AuthURL="https://api.home-connect.com/security/oauth/token"

$TokenRepsonse=Invoke-RestMethod -Method POST -Uri $AuthURL -ContentType "application/x-www-form-urlencoded" -Body $Body

$Header = @{
    "Authorization"  = "Bearer $($TokenRepsonse.access_token)"
}

#Get Devices
$Appliances=Invoke-RestMethod -Uri "https://api.home-connect.com/api/homeappliances" -Method GET -Headers $Header
$Appliances.data.homeappliances

#Get State
$State=Invoke-RestMethod -Uri "https://api.home-connect.com/api/homeappliances/$($AppliANCES.data.homeappliances.haId)/status" -Method GET -Headers $Header
$State.data.status

#Start a Program
#https://api-docs.home-connect.com/programs-and-options#dryer
$JsonBody = @"
{
    "data":{
        "key":"LaundryCare.Dryer.Program.Mix",
        "options":[
            {
                "key":"LaundryCare.Dryer.Option.DryingTarget",
                "value":"LaundryCare.Dryer.EnumType.DryingTarget.CupboardDry"
            }
        ]
    }
}
"@


Invoke-RestMethod -Uri "https://api.home-connect.com/api/homeappliances/$($AppliANCES.data.homeappliances.haId)/programs/active" -Method PUT -Headers $Header -Body $JsonBody -ContentType "application/vnd.bsh.sdk.v1+json"




$Program=Invoke-RestMethod -Uri "https://api.home-connect.com/api/homeappliances/$($AppliANCES.data.homeappliances.haId)/programs/active" -Method GET -Headers $Header
$Program.data.options


$Settings=Invoke-RestMethod -Uri "https://api.home-connect.com/api/homeappliances/$($AppliANCES.data.homeappliances.haId)/settings" -Method GET -Headers $Header
$Settings.data.options


$Events=Invoke-RestMethod -Uri "https://api.home-connect.com/api/homeappliances/$($AppliANCES.data.homeappliances.haId)/events" -Method GET -Headers $Header
$Events.data.options