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
        Gets the raw current weather city object from OpenWeatherMap
    
    .PARAMETER City
        The name of the city or name and ISO country code (e.g. "Minneapolis" or "Minneapolis,US")

    .PARAMETER ApiKey
        Your app ID (API key) from OpenWeatherMap

    .PARAMETER Units
        The measurement system for units desired in the response
#>
Function Get-WeatherCurrentRaw([string]$City, [string]$ApiKey, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') 
{
    return Invoke-WebRequest `
        -UseBasicParsing `
        -Uri "http://api.openweathermap.org/data/2.5/weather?q=$City&APPID=$ApiKey&units=$Units" | ConvertFrom-Json
}

<#
    .SYNOPSIS
        Gets raw weather forecast (3 hour increments/5 day) for given city

    .PARAMETER ApiKey
        Your app ID (API key) from OpenWeatherMap

    .PARAMETER Units
        The measurement system for units desired in the response
#>
Function Get-WeatherForecastRaw([string]$City, [string]$ApiKey, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') {
    return Invoke-WebRequest `
        -UseBasicParsing `
        -Uri "http://api.openweathermap.org/data/2.5/forecast?q=$City&APPID=$ApiKey&units=$Units" | ConvertFrom-Json
}

<#
    .SYNOPSIS
        Gets the weather forecast as list of objects with the following properties: Time, Temperature, Weather, WeatherCode, WeatherSymbol
    
    .PARAMETER Forecast
        The raw Forecast object returned from Get-WeatherForecastRaw
    
    .PARAMETER Units
        The measurement system for units desired in the response
#>
Function Get-WeatherForecast($Forecast, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') {
    $Days = New-Object System.Collections.ArrayList

    ForEach ($_Day in $Forecast.list) 
    {
        $DayForecast = Get-WeatherForecastItem -ForecastObject $_Day -Units $Units

        $Days.Add($DayForecast) | Out-Null
    }

    return $Days
}

Function Get-WeatherForecastItem($ForecastObject, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') {
    $MinTemp = (Get-WeatherCityTemperature $ForecastObject -Type Min -Units None)
    $MaxTemp = (Get-WeatherCityTemperature $ForecastObject -Type Max -Units None)
    $AvgTemp = (($MaxTemp - $MinTemp)/2) + $MinTemp
    $UnitMeasure = Get-WeatherUnitMeasurement -Units $Units

    $Forecast = $ForecastObject | Select-Object -Property `
    @{ Label = "Time"; Expression = {(Get-DateTimeUtcFromUnix -UnixTimestamp $_.dt)}},
    @{ Label = "Temperature"; Expression = {"$AvgTemp$UnitMeasure"}},
    @{ Label = "Weather"; Expression = {$_.weather[0].description}},
    @{ Label = "WeatherCode"; Expression = {$_.weather[0].id}},
    @{ Label = "WeatherSymbol"; Expression = {Get-WeatherSymbol -Code $_.weather[0].id}}

    return $Forecast
}

<#
    .SYNOPSIS
        Gets a System.DateTime from a Unix timestamp

    .PARAMETER UnixTimestamp
        The Unix timestamp (seconds from Epoch) in UTC
#>
Function Get-DateTimeUtcFromUnix([int]$UnixTimestamp) {

    # Unix epoch
    $Date = New-Object System.DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0, ([System.DateTimeKind]::Utc)

    # Add ms since epoch
    return ($Date.AddSeconds($UnixTimestamp)).ToLocalTime()
}

<#
    .SYNOPSIS
        Returns the temperature in the provided OpenWeatherMap city

    .PARAMETER WeatherCity
        The OpenWeatherMap raw city object

    .PARAMETER Type
        The type of temperature to retrieve: Current, Min, Max
#>
Function Get-WeatherCityTemperature($WeatherCity, [string][ValidateSet('Current', 'Min', 'Max')]$Type = 'Current', [string][ValidateSet("imperial","metric","kelvin","none")]$Units = 'imperial') 
{        
    switch ($Type) {
        'Current' { $Temp = $WeatherCity.main.temp }
        'Min' { $Temp = $WeatherCity.main.temp_min }
        'Max' { $Temp = $WeatherCity.main.temp_max }
    }

    if ($Units -eq 'none') { 
        return $Temp
    } else { 
        $Unit = Get-WeatherUnitMeasurement -Units $Units
        return "$Temp$Unit" 
    }
}

<#
    .SYNOPSIS
        Gets the unit of measure for a given unit type (e.g. degrees Fahrenheit or Celsius)

    .PARAMETER Units
        The measurement system for units desired in the response
#>
Function Get-WeatherUnitMeasurement([string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') {
    switch ($Units) {
        'metric' { $Unit = '°C' }
        'imperial' { $Unit = '°F' }
        default { $Unit = 'K' }
    }
    return $Unit
}

<#
    .SYNOPSIS
        Returns the current weather status (clear, rainy, etc.) in the provided OpenWeatherMap city

    .PARAMETER WeatherCity
        The OpenWeatherMap raw city object

    .PARAMETER Symbol
        Whether or not to return the Unicode symbol for a weather code
#>
Function Get-WeatherCityStatus($WeatherCity, [switch]$Symbol) 
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

    .PARAMETER Code
        The API code for the weather condition
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
        4?? { return '🌧' } # Rain
        3?? { return '☂' } # Drizzle
        2?? { return '🌩' } # Thunderstorm
        default { return '' }
    }
}

<#
    .SYNOPSIS
        Writes out a colorful weather banner w/temp and symbol. Great for profile.ps1!

    .PARAMETER City
        The name of the city or name and ISO country code (e.g. "Minneapolis" or "Minneapolis,US")

    .PARAMETER ApiKey
        Your app ID (API key) from OpenWeatherMap

    .PARAMETER Units
        The measurement system for units desired in the response
#>
Function Write-WeatherCurrent($City, $ApiKey, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') {

    $WC = Get-WeatherCurrentRaw -City $City -ApiKey $ApiKey -Units $Units
    $Temp = Get-WeatherCityTemperature -WeatherCity $WC -Units $Units
    $Weather = Get-WeatherCityStatus -WeatherCity $WC
    $Symbol = Get-WeatherCityStatus -WeatherCity $WC -Symbol

    Write-Host $Temp -NoNewline -ForegroundColor Green
    Write-Host " ($Symbol $Weather)" -NoNewline -ForegroundColor Yellow
    Write-Host " in " -NoNewline
    Write-Host $City -ForegroundColor Cyan
    Write-Host ""

}

<#
    .SYNOPSIS
        Writes out a friendly forecast for the provided number of days (including today)

    .PARAMETER City
        The name of the city or name and ISO country code (e.g. "Minneapolis" or "Minneapolis,US")

    .PARAMETER Days
        The number of days to include in the forecast (up to 5) in addition to today. Defaults to 1 day.

    .PARAMETER ApiKey
        Your app ID (API key) from OpenWeatherMap

    .PARAMETER Units
        The measurement system for units desired in the response        
#>
Function Write-WeatherForecast($City, $Days = 1, $ApiKey, [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial') {

    $Forecast = Get-WeatherForecastRaw -City $City -ApiKey $ApiKey -Units $Units
    $ForecastTimes = Get-WeatherForecast $Forecast -Units $Units
    $Days = [System.Math]::Min(5, $Days)
    
    # Group by day
    $GroupedForecast = $ForecastTimes | Group-Object -Property @{ Expression = { $_.Time.Day }} -AsHashTable
    $GroupedForecast = $GroupedForecast.GetEnumerator() | Sort-Object -Property Name | Select-Object -First ($Days + 1)

    # Get summary of requested days
    $PluralDays = if ($Days -eq 1) { "day" } else { "days" }
    Write-Host "Forecast for " -NoNewLine
    Write-Host $City -ForegroundColor Cyan -NoNewLine
    Write-Host " next $Days $($PluralDays):"

    ForEach ($GroupedDay in $GroupedForecast) {
        $DaySummary = Get-WeatherForecastSummaryForDay -Times $GroupedDay.Value
                
        Write-Host "$($DaySummary.Time.ToString('MMM d'))" -NoNewLine -ForegroundColor Magenta
        Write-Host ": " -NoNewLine
        Write-Host $DaySummary.Temperature -NoNewline -ForegroundColor Green
        Write-Host " ($($DaySummary.WeatherSymbol) $($DaySummary.Weather))" -ForegroundColor Yellow                     
    }
    Write-Host ""
}

<#
    .SYNOPSIS
        Consolidates a set of same-day forecasts into the one closest to midday
#>
Function Get-WeatherForecastSummaryForDay([System.Collections.ArrayList]$Times) {
    if ($Times.Count -eq 1) {
        return $Times
    }

    # Find time closest to midday
    # Sort by absolute time closest to noon
    $SortedTimes = $Times | Sort-Object -Property @{ 
        Expression = {
            if ($_.Time.Hour -le 12) { 
                12 - $_.Time.Hour 
            } else {
                $_.Time.Hour - 12
            }
        }
    }

    return $SortedTimes[0]
}