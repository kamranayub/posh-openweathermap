$PesterVersion = '3.4.2'

# TODO save-module locally
Save-Module -Name Pester -Path '.modules\' -RequiredVersion $PesterVersion

# TODO copy custom assertions
Copy-Item -Path '.\Assertions\*.ps1' -Destination ".\.modules\Pester\$PesterVersion\Functions\Assertions"

# Import local Pester module so we can extend built-in assertions
Import-Module ".\.modules\Pester\$PesterVersion\Pester.psd1"

# Run tests
Invoke-Pester -Script ".\OpenWeatherMap.Tests.ps1"