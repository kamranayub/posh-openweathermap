Import-Module OpenWeatherMap -Force

######## Test Values ##########
$TestUnixTimestamp = 1471017423

# TODO Replace with raw JSON from file
$RawWeatherMain = @{
    temp = 60;
    temp_min = 50;
    temp_max = 70
}
$RawWeatherConditions = @(@{
    id = 500;
    description = 'light rain';    
})
$RawWeather = @{
    main = $RawWeatherMain
    weather = $RawWeatherConditions
}
$RawForecast = @{
    dt = $TestUnixTimestamp;
    main = $RawWeatherMain;
    weather = $RawWeatherConditions 
}
###################################

Describe 'Get-WeatherForecastItem' {

    It 'should return a hashtable with a forecast' {
        $Unit = Get-WeatherUnitMeasurement -Units imperial
        $Symbol = Get-WeatherSymbol -Code 500
        $Result = Get-WeatherForecastItem $RawForecast -Units imperial

        $Result.Time | Should BeDate '8/12/2016 10:57:03'
        $Result.Temperature | Should Be "60$Unit"
        $Result.Weather | Should Be 'light rain'
        $Result.WeatherCode | Should Be 500
        $Result.WeatherSymbol | Should Be $Symbol
    }

}

Describe 'Get-WeatherCityTemperature' {
    
    
    Context 'with units' {
        $Unit = Get-WeatherUnitMeasurement -Units imperial
        
        It 'should support current temperature by default' {
            Get-WeatherCityTemperature $RawWeather -Units imperial |
            Should Be "60$Unit"
        }

        It 'should support current temperature' {
            Get-WeatherCityTemperature $RawWeather -Type Current -Units imperial |
            Should Be "60$Unit"
        }

        It 'should support min temperature' {
            Get-WeatherCityTemperature $RawWeather -Type Min -Units imperial |
            Should Be "50$Unit"
        }

        It 'should support max temperature' {
            Get-WeatherCityTemperature $RawWeather -Type Max -Units imperial |
            Should Be "70$Unit"
        }
    }

    Context 'without units' {
        It 'should support current temperature by default' {
            Get-WeatherCityTemperature $RawWeather -Units none |
            Should Be 60
        }

        It 'should support current temperature' {
            Get-WeatherCityTemperature $RawWeather -Type Current -Units none |
            Should Be 60
        }

        It 'should support min temperature' {
            Get-WeatherCityTemperature $RawWeather -Type Min -Units none |
            Should Be 50
        }

        It 'should support max temperature' {
            Get-WeatherCityTemperature $RawWeather -Type Max -Units none |
            Should Be 70
        }
    }
}

Describe 'Get-WeatherCityStatus' {

    It 'should return weather condition' {
        $Result = Get-WeatherCityStatus -WeatherCity $RawWeather

        $Result | Should Be 'light rain'
    }

    It 'should return weather condition symbol' {
        $Result = Get-WeatherCityStatus -WeatherCity $RawWeather -Symbol

        $Result | Should Be '🌧'
    }
}

Describe 'Get-DateTimeUtcFromUnix' {
    It 'supports UTC Unix timestamp' {
        $Result = Get-DateTimeUtcFromUnix $TestUnixTimestamp

        $Result | Should BeDate '8/12/2016 10:57:03'
    }
}

Describe 'Get-WeatherUnitMeasurement' {

    It 'returns °F by default' {
        Get-WeatherUnitMeasurement | Should Be '°F'
    }

    It 'returns °F for imperial units' {
        Get-WeatherUnitMeasurement -Units imperial | Should Be '°F'
    }

    It 'returns °C for metric units' {
        Get-WeatherUnitMeasurement -Units metric | Should Be '°C'
    }

    It 'returns K for kelvin units' {
        Get-WeatherUnitMeasurement -Units kelvin | Should Be 'K'
    }
}

Describe 'Get-WeatherForecastSummaryForDay' {

    It 'should return forecast time closest to 12pm' {
        $Times = @(
            @{ Time = (Get-Date -Hour 8) },
            @{ Time = (Get-Date -Hour 10) },
            @{ Time = (Get-Date -Hour 13) }
        )

        (Get-WeatherForecastSummaryForDay -Times $Times).Time.Hour | Should Be 13
    }

}

Describe 'Get-WeatherSymbol' {

    It 'should return symbol for Tornado' {
        Get-WeatherSymbol 900 | Should Be '🌪'
    }
    It 'should return symbol for Tropical storm' {
        Get-WeatherSymbol 901 | Should Be '🌩'
    }
    It 'should return symbol for Hurricane' {
        Get-WeatherSymbol 902 | Should Be '🌀'
    }
    It 'should return symbol for Cold' {
        Get-WeatherSymbol 903 | Should Be '❄'
    }
    It 'should return symbol for Hot' {
        Get-WeatherSymbol 904 | Should Be '🔥'
    }
    It 'should return symbol for Windy' {
        Get-WeatherSymbol 905 | Should Be '🎐'
    }
    It 'should return symbol for Extreme' {
        Get-WeatherSymbol 906 | Should Be '☠'
        Get-WeatherSymbol 999 | Should Be '☠'
    }
    It 'should return symbol for Clear' {
        Get-WeatherSymbol 800 | Should Be '☀'
    }
    It 'should return symbol for Cloudy' {
        Get-WeatherSymbol 801 | Should Be '☁'
    }
    It 'should return symbol for Atmosphere' {
        Get-WeatherSymbol 700 | Should Be '🌫'
    }
    It 'should return symbol for Snow' {
        Get-WeatherSymbol 600 | Should Be '☃'
    }
    It 'should return symbol for Rain' {
        Get-WeatherSymbol 500 | Should Be '🌧'
        Get-WeatherSymbol 400 | Should Be '🌧'
    }
    It 'should return symbol for Drizzle' {
        Get-WeatherSymbol 300 | Should Be '☂'
    }
    It 'should return symbol for Thunderstorm' {
        Get-WeatherSymbol 200 | Should Be '🌩'
    }
    It 'should fallback to empty string when not matched' {
        Get-WeatherSymbol 100 | Should Be ''
    }
}