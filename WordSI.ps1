Clear-Host

[System.Collections.ArrayList][string[]]$TrainData = Get-Content .\DataSet\Train_DataSet.txt
$TrainData = $TrainData.ToArray()

Write-Host "$($TrainData.Count) Words has been loaded."

function Get-Input {

    $NumOf_Input = 15
    $Inputs = 1..$NumOf_Input | ForEach-Object {
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
    [System.Collections.ArrayList][int[]]$Err = @()

    for ($i = 0; $i -lt $Inputs.Count; $i++) {
        [void]$Sum.Add(($Inputs.Characters[$i] * $Weight[$i]))
        $Sum[$i] = [math]::Round($Sum[$i], 2)
    }

    for ($i = 0; $i -lt $Inputs.Count; $i++) {
        [int[]]$Guess += switch ($Sum[$i]) {
            {$_ -ne $Inputs.Characters[$i]} {0}
            {$_ -eq $Inputs.Characters[$i]} {1}
        }

        [void]$Err.Add(1 - $Guess[$i])
    }

    $Result = 1..$Inputs.Count | ForEach-Object {
        [PSCustomObject]@{
            Sum = $Sum[$_]
            Guess = $Guess[$_]
            Words = $Inputs.Word[$_]
        }
    }

    $Result
}

$Inputs = Get-Input
[float[]]$Weight = (
    1..$Inputs.Count | ForEach-Object {[math]::Round((Get-Random -Max 1.0 -Min 0.1), 2)}
)

Guess $Inputs $Weight