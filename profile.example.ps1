# Import module from current folder
Import-Module .\OpenWeatherMap

# Import weather from global module path ($env:PSModulePath)
# Import-Module OpenWeatherMap

# Type `weather` in the prompt to see current weather
Set-Alias weather Write-Weather

# (optional) Write at startup
Write-Host "Weather: " -NoNewline -ForegroundColor Yellow
Write-WeatherBanner -City Minneapolis -ApiKey xxx