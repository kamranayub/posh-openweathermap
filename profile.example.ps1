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