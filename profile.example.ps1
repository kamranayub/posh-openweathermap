# Import module from current folder
Import-Module .\OpenWeatherMap

# Import weather from global module path ($env:PSModulePath)
# Import-Module OpenWeatherMap

Function Write-LocalWeatherCurrent() {
    # Replace city and API key
    Write-WeatherCurrent -City Minneapolis -ApiKey xxx
}

Function Write-LocalWeatherForecast($Days = 1) {
    # Replace city and API key
    Write-WeatherForecast -City Minneapolis -ApiKey xxx -Days $Days
}

# (optional) Write at startup
Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Write-LocalWeatherCurrent

# Type `weather` in the prompt to see current weather
Set-Alias weather Write-LocalWeatherCurrent
# Type `forecast` or `forecast -d 2` to get the current forecast
Set-Alias forecast Write-LocalWeatherForecast