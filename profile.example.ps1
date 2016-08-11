# Import module from current folder
Import-Module .\OpenWeatherMap

# Import weather from global module path ($env:PSModulePath)
# Import-Module OpenWeatherMap

Function Get-CurrentWeather() {
    # Replace city and API key
    Write-WeatherBanner -City Minneapolis -ApiKey xxx
}

# (optional) Write at startup
Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Get-CurrentWeather

# Type `weather` in the prompt to see current weather
Set-Alias weather Get-CurrentWeather