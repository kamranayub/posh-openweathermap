# OpenWeatherMap PowerShell Module

This is a little module to help you get some weather in your Powershell prompt!

![Example](https://cloud.githubusercontent.com/assets/563819/17722041/ab4372a4-63f4-11e6-8b7f-bd8e4a60a4d3.png)

# Install

From the [PowerShell Gallery](https://www.powershellgallery.com):

    PS> Install-Module OpenWeatherMap

# Usage

You will need an account on [http://openweathermap.org](http://openweathermap.org) and the API key, it's free to create.

## Unicode Symbols

You may need to use a prompt that supports Unicode characters such as [ConEmu](https://conemu.github.io/) in order to see the weather
symbols.

## Example Profile

See **profile.example.ps1** for an example of a profile that writes the above output. 
See [How to customize your PowerShell profile](http://www.howtogeek.com/50236/customizing-your-powershell-profile/).

```powershell
# Import module from current folder
Import-Module .\OpenWeatherMap

# Import weather from global module path ($env:PSModulePath)
# Import-Module OpenWeatherMap

Function Write-LocalWeatherCurrent([switch]$Inline) {
    # Replace city and API key
    Write-WeatherCurrent -City Minneapolis -ApiKey xxx -Units imperial -Inline:$Inline
}

Function Write-LocalWeatherForecast($Days = 1) {
    # Replace city and API key
    Write-WeatherForecast -City Minneapolis -ApiKey xxx -Units imperial -Days $Days
}

# EXAMPLE: Write at startup
Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Write-LocalWeatherCurrent

# Type `weather` in the prompt to see current weather
Set-Alias weather Write-LocalWeatherCurrent
# Type `forecast` or `forecast -d 2` to get the current forecast
Set-Alias forecast Write-LocalWeatherForecast

# EXAMPLE: Override prompt and include inline weather
Function Prompt() {
    # Write current dir
    Write-Host ($PWD) -NoNewline -ForegroundColor Red
    # Write inline weather
    Write-LocalWeatherCurrent -Inline
    Write-Host "›" -NoNewline -ForegroundColor Gray

    return ' '
}
```

This adds a `weather` and `forecast` alias to your PowerShell profile with local weather. It also shows how to override the
built-in prompt to add an inline weather banner.

# Cmdlets

## Raw API Functions

These functions return the raw JSON objects from the OpenWeatherMap API

### `Get-WeatherCurrentRaw -City <name[,country code]> -ApiKey <appid> -Units <imperial|metric|kelvin> [-Proxy <uri>] [-ProxyCredential <PSCredential] [-ProxyUseDefaultCredentials]`

Returns the raw weather city object from the API for you to do whatever you want. 
Uses the [Current Weather API](http://openweathermap.org/current).

### `Get-WeatherForecastRaw -City <name[,country code]> -ApiKey <appid> -Units <imperial|metric|kelvin> [-Proxy <uri>] [-ProxyCredential <PSCredential] [-ProxyUseDefaultCredentials]`

Returns the raw weather city object from the API for you to do whatever you want. 
Uses the [Current Weather API](http://openweathermap.org/current).

## Work with API objects

### `Get-WeatherCityTemperature -City <WeatherCity> -Units <imperial|metric|kelvin>`

Gets the current temp in the provided weather city object (provided by `Get-WeatherCurrentRaw` or `Get-WeatherForecastRaw`)

### `Get-WeatherCityStatus -City <WeatherCity> [-Symbol]`

Gets the current weather status (clear, rainy, snowy) in the provided weather city object (provided by `Get-WeatherCity`).
Pass in `-Symbol` switch to retrieve the weather symbol for a city.

## Helpful utilities

### `Get-WeatherSymbol -Code <weather code>`

Gets a Unicode symbol for the given weather code. Only a limited set available in Windows 10.

### `Write-WeatherCurrent -City <name[,country code]> -ApiKey <appid> -Units <imperial|metric|kelvin> [-Inline]`

Displays a colorful banner in the console (useful for startup). The `-Inline` switch makes it compact for use in the prompt.

### `Write-WeatherForecast -City <name[,country code]> -Days <num> -ApiKey <appid> -Units <imperial|metric|kelvin>`

Displays a colorful weather forecast for given amount of days (including today). Defaults to including tomorrow (1 day).

### `Get-WeatherForecastSummaryForDay -Times <Hashtable[]>`

Summarizes a set of forecasts during a day to the closest one to midday

# Contribute

Run Pester tests:

```powershell
& .\Run-Tests.ps1
```

This will install Pester locally to `.modules` folder and run the tests.

# License

Open BSD 2-Clause

```
Copyright (c) 2016, Kamran Ayub
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list 
   of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this 
   list of conditions and the following disclaimer in the documentation and/or 
   other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
```
