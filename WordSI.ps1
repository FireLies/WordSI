Clear-Host

# Data set will be loaded only once for the sake of performance
if ($TrainData.Count -eq 0) {
    [System.Collections.ArrayList][string[]]$global:TrainData = Get-Content .\DataSet\Train_DataSet.txt
    "{0} Words has been loaded." -f $TrainData.Count 
}

function Get-Input {

    $NumOf_Input = 12
    $Inputs = foreach ($i in 1..$NumOf_Input) {
        $Randomize = ($TrainData | Get-Random).Replace(' ', '')
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

    $Counter = $Inputs.Count - 1
    foreach ($i in 0..$Counter) {
        [void]$Sum.Add($Inputs.Characters[$i] * $Weight[$i])

        # Activation
        [void]$(switch ($Sum[$i]) {
            {$_ -ne $Inputs.Characters[$i]} {$Guess.Add(0)}
            default {$Guess.Add(1)}
        })

        [void]$Err.Add(1 - $Guess[$i])
    }

    $Result = 0..$Counter | ForEach-Object {
        [PSCustomObject]@{
            Sum = '{0:n2}' -f $Sum[$_]
            Guess = '  {0}' -f $Guess[$_]
            Words = $Inputs.Word[$_]
        }
    }

    $Result
    "`nInput: {0}`nCorrect guess: {1}" -f $Inputs.Count, ($Guess | Select-String '1').Count
}

$Inputs = Get-Input
[float[]]$Weight = (
    1..$Inputs.Count | ForEach-Object {
        '{0:n2}' -f (Get-Random -Max 1.0 -Min 0.1)
    }
)

Guess $Inputs $Weight