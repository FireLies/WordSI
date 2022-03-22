Clear-Host

if ($TrainData.Count -eq 0) {
    [System.Collections.ArrayList][string[]]$TrainData = Get-Content .\DataSet\Train_DataSet.txt
    $TrainData = $TrainData.ToArray()

    '{0} Words has been loaded.' -f $TrainData.Count 
}

function Get-Input {

    $NumOf_Input = 10
    $Inputs = foreach ($i in 1..$NumOf_Input) {
        $Randomize = ($TrainData | Get-Random).replace(' ', '')
        [PSCustomObject]@{
            Word = $Randomize
            Characters = $Randomize.Length # Characters in a word
        }
    }

    return $Inputs
}

function Guess ($Inputs, $Weight) {

    [System.Collections.ArrayList][float[]]$Sum = @()
    [System.Collections.ArrayList][int[]]$Guess = @()
    [System.Collections.ArrayList][int[]]$Err = @()

    foreach ($i in 1..$Inputs.Count) {
        [void]$Sum.Add($Inputs.Characters[$i-1] * $Weight[$i-1])
        [void]$(switch ($Sum[$i-1]) {
            {$_ -ne $Inputs.Characters[$i-1]} {$Guess.Add(0)}
            default {$Guess.Add(1)}
        })

        [void]$Err.Add(1 - $Guess[$i-1])
    }

    $Result = 1..$Inputs.Count | ForEach-Object {
        [PSCustomObject]@{
            Sum = '{0:n2}' -f $Sum[$_-1]
            Guess = '  {0}' -f $Guess[$_-1]
            Words = $Inputs.Word[$_-1]
        }
    }

    $Result

    ""; 'Correct guess: {0}' -f ($Guess | Select-String '1').Count
}

$Inputs = Get-Input
[float[]]$Weight = (
    1..$Inputs.Count | ForEach-Object {
        '{0:n2}' -f (Get-Random -Max 1.0 -Min 0.1)
    }
)

Guess $Inputs $Weight