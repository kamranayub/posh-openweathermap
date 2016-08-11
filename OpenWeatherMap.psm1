# Copyright (c) 2016, Kamran Ayub
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this list 
#    of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, this 
#    list of conditions and the following disclaimer in the documentation and/or 
#    other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.

<#
    .SYNOPSIS
        Gets the raw city object from OpenWeatherMap
    
    .PARAMETER City
        The name of the city or name and country code (e.g. "Minneapolis" or "Minneapolis,US")

    .PARAMETER ApiKey
        Your app ID (API key) from OpenWeatherMap
#>
Function Get-WeatherCity([string]$City, [string]$ApiKey, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') 
{
    return Invoke-WebRequest `
        -UseBasicParsing `
        -Uri "http://api.openweathermap.org/data/2.5/weather?q=$City&APPID=$ApiKey&units=$Units" | ConvertFrom-Json
}

<#
    .SYNOPSIS
        Returns the current temperature in the provided OpenWeatherMap city

    .PARAMETER WeatherCity
        The OpenWeatherMap raw city object
#>
Function Get-WeatherCityCurrentTemperature($WeatherCity, [string][ValidateSet("imperial","metric")]$Units = 'imperial') 
{
    
    switch ($Units) {
        'metric' { $Unit = '°C' }
        'imperial' { $Unit = '°F' }
        default { $Unit = 'K' }
    }
    return "$($WeatherCity.main.temp)$Unit"
}

<#
    .SYNOPSIS
        Returns the current weather status (clear, rainy, etc.) in the provided OpenWeatherMap city

    .PARAMETER WeatherCity
        The OpenWeatherMap raw city object
#>
Function Get-WeatherCityCurrentWeather($WeatherCity, [switch]$Symbol) 
{
    if (-not $Symbol) {
        return $WeatherCity.weather[0].description
    }

    return Get-WeatherSymbol -Code $WeatherCity.weather[0].id
}

<#
    .SYNOPSIS
        Gets an emoji/Unicode symbol for the given weather condition code
    .DESCRIPTION
        Not all emojis are supported in Windows command prompt, these
        tested fine on Windows 10.
#>
Function Get-WeatherSymbol($Code) {

    switch -Wildcard ($Code) {
        900 { return '🌪' } # Tornado
        901 { return '🌩' } # Tropical storm
        902 { return '🌀' } # Hurricane
        903 { return '❄' } # Cold
        904 { return '🔥' } # Hot
        905 { return '🎐' } # Windy
        9?? { return '☠' } # Extreme
        800 { return '☀' } # Clear
        8?? { return '☁' } # Cloudy        
        7?? { return '🌫' } # Atmosphere
        6?? { return '☃' } # Snow
        5?? { return '🌧' } # Rain
        3?? { return '☂' } # Drizzle
        2?? { return '🌩' } # Thunderstorm
        default { return '' }
    }
}

<#
    .SYNOPSIS
        Writes out a colorful weather banner w/temp and symbol. Great for profile.ps1!
#>
Function Write-WeatherBanner($City, $ApiKey, [string][ValidateSet("imperial","metric")]$Units = 'imperial') {

    $WC = Get-WeatherCity -City $City -ApiKey $ApiKey -Units $Units
    $Temp = Get-WeatherCityCurrentTemperature -WeatherCity $WC -Units $Units
    $Weather = Get-WeatherCityCurrentWeather -WeatherCity $WC
    $Symbol = Get-WeatherCityCurrentWeather -WeatherCity $WC -Symbol

    Write-Host $Temp -NoNewline -ForegroundColor Green
    Write-Host " ($Symbol $Weather)" -NoNewline -ForegroundColor Yellow
    Write-Host " in " -NoNewline
    Write-Host $City -ForegroundColor Cyan
    Write-Host ""

}