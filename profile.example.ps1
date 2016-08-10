# Import module from current folder
Import-Module .\OpenWeatherMap

# Import weather from global module path ($env:PSModulePath)
# Import-Module OpenWeatherMap

# Utility function to write friendly weather
# Replace city & API key with your own
Function Write-Weather() {
    $City = "Minneapolis"
    $WC = Get-WeatherCity -City $City -ApiKey "XXX"
    $Temp = Get-WeatherCityCurrentTemperature -WeatherCity $WC
    $Weather = Get-WeatherCityCurrentWeather -WeatherCity $WC
    
    Write-Host "It's " -NoNewline
    Write-Host $Temp -NoNewline -ForegroundColor Green
    Write-Host " ($Weather)" -NoNewline -ForegroundColor Yellow
    Write-Host " in $City"   
}

# Type `weather` in the prompt to see current weather
Set-Alias weather Write-Weather

# (optional) Write at startup
Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Write-Weather
Write-Host ""