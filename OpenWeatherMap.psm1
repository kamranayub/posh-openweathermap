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
Function Get-WeatherCity([string]$City, [string]$ApiKey) 
{
    return Invoke-WebRequest `
        -UseBasicParsing `
        -Uri "http://api.openweathermap.org/data/2.5/weather?q=$City&APPID=$ApiKey&units=imperial" | ConvertFrom-Json
}

<#
    .SYNOPSIS
        Returns the current temperature in the provided OpenWeatherMap city

    .PARAMETER WeatherCity
        The OpenWeatherMap raw city object
#>
Function Get-WeatherCityCurrentTemperature($WeatherCity) 
{
    return "$($WeatherCity.main.temp)°F"
}

<#
    .SYNOPSIS
        Returns the current weather status (clear, rainy, etc.) in the provided OpenWeatherMap city

    .PARAMETER WeatherCity
        The OpenWeatherMap raw city object
#>
Function Get-WeatherCityCurrentWeather($WeatherCity) 
{
    return $WeatherCity.weather[0].description
}