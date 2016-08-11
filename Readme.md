# OpenWeatherMap PowerShell Module

This is a little module to help you get some weather in your Powershell prompt!

![Example prompt](https://cloud.githubusercontent.com/assets/563819/17570839/a00433aa-5f13-11e6-88d6-b6b75d43dfd5.png)

# Install

From the [PowerShell Gallery](https://www.powershellgallery.com):

    PS> Install-Module OpenWeatherMap

# Usage

You will need an account on [http://openweathermap.org](http://openweathermap.org) and the API key, it's free to create.

## Example Profile

See **profile.example.ps1** for an example of a profile that write the above output.

```powershell
# Import weather
Import-Module OpenWeatherMap

# Replace city and API key
Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Write-WeatherBanner -City Minneapolis -ApiKey xxx

Set-Alias weather Write-WeatherBanner
```

# Cmdlets

## `Get-WeatherCity -City <name[,country code]> -ApiKey <appid> -Units <imperial|metric|kelvin>`

Returns the raw weather city object from the API for you to do whatever you want. 
Uses the [Current Weather API](http://openweathermap.org/current).

## `Get-WeatherCityCurrentTemperature -City <WeatherCity> -Units <imperial|metric|kelvin>`

Gets the current temp in the provided weather city object (provided by `Get-WeatherCity`)

## `Get-WeatherCityCurrentWeather -City <WeatherCity>`

Gets the current weather status (clear, rainy, snowy) in the provided weather city object (provided by `Get-WeatherCity`)

## `Get-WeatherSymbol -Code <weather code>`

Gets a Unicode symbol for the given weather code. Only a limited set available in Windows 10.

## `Write-WeatherBanner -City <name[,country code]> -ApiKey <appid> -Units <imperial|metric|kelvin>`

Displays a colorful banner in the console (useful for startup)

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