Function PesterBeDate($Value, $Expected) {
    $Expected = [System.DateTime]::Parse($Expected)

    $Value.Year   | Should Be $Expected.Year
    $Value.Month  | Should Be $Expected.Month
    $Value.Day    | Should Be $Expected.Day

    $Value.Hour   | Should Be $Expected.Hour
    $Value.Minute | Should Be $Expected.Minute
    $Value.Second | Should Be $Expected.Second
}

Function PesterBeDateFailureMessage($Value, $Expected) {
    if (-not (($expected -is [string]) -and ($value -is [System.DateTime])))
    {
        return "Expected: {$expected}`nBut was:  {$value}"
    }
    
    return "Expected: $Expected\nBut was: $($Value.ToString('MM/dd/YYYY h:mm:ss'))"
}

Function NotPesterBeDateFailureMessage($Value, $Expected) {
    return PesterBeDateFailureMessage -Value $Value -Expected $Expected
}