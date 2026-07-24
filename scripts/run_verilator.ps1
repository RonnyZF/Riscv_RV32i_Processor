[CmdletBinding()]
param(
    [ValidateSet("all", "tb_fetch", "tb_branch", "tb_pipeline_flush", "tb_hazards")]
    [string]$Test = "all",

    [string]$BashPath = $(if ($env:MSYS2_BASH) { $env:MSYS2_BASH } else { "C:\msys64\usr\bin\bash.exe" }),
    [string]$VerilatorRoot = $env:VERILATOR_ROOT,
    [string]$VerilatorPath = $env:VERILATOR
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$bash = $BashPath

if (-not $VerilatorRoot -and -not $VerilatorPath) {
    throw "Verilator was not configured. Set VERILATOR_ROOT (install root) or VERILATOR (full path to the verilator executable), or pass -VerilatorRoot / -VerilatorPath."
}

$verilatorRoot = if ($VerilatorRoot) { $VerilatorRoot } else { Split-Path (Split-Path $VerilatorPath -Parent) -Parent }
$verilator = if ($VerilatorPath) { $VerilatorPath } else { Join-Path $verilatorRoot "bin\verilator" }

if (-not (Test-Path $bash)) {
    throw "MSYS2 bash was not found at $bash. Pass -BashPath or set MSYS2_BASH."
}
if (-not (Test-Path $verilator)) {
    throw "The Verilator executable was not found at $verilator."
}

function ConvertTo-MsysPath {
    param([string]$Path)

    $resolvedPath = (Resolve-Path $Path).Path -replace "\\", "/"
    if ($resolvedPath -notmatch "^([A-Za-z]):/(.*)$") {
        throw "Cannot convert '$resolvedPath' to an MSYS2 path."
    }

    return "/$($Matches[1].ToLower())/$($Matches[2])"
}

$sourceFiles = @{
    tb_fetch = @(
        "rtl\fetch.sv",
        "rtl\instructionmem.sv",
        "verif\tb_fetch.sv"
    )
    tb_branch = @(
        "rtl\deco.sv",
        "rtl\control_unit.sv",
        "rtl\banco_registros.sv",
        "rtl\ext_signo.sv",
        "rtl\exe.sv",
        "rtl\alu_final.sv",
        "rtl\alu.sv",
        "rtl\alu_ctrl.sv",
        "rtl\shifter.v",
        "verif\tb_branch.sv"
    )
    tb_pipeline_flush = @(
        "rtl\if_id_pipeline.sv",
        "rtl\id_exe_pipeline.sv",
        "verif\tb_pipeline_flush.sv"
    )
    tb_hazards = @(
        "rtl\exe.sv",
        "rtl\hazard_unit.sv",
        "rtl\alu_final.sv",
        "rtl\alu.sv",
        "rtl\alu_ctrl.sv",
        "rtl\shifter.v",
        "verif\tb_hazards.sv"
    )
}

$tests = if ($Test -eq "all") { $sourceFiles.Keys | Sort-Object } else { @($Test) }
$repoRootMsys = ConvertTo-MsysPath $repoRoot
$verilatorRootMsys = ConvertTo-MsysPath $verilatorRoot
$verilatorMsys = ConvertTo-MsysPath $verilator
$buildRootMsys = "$repoRootMsys/build/verilator"
foreach ($testName in $tests) {
    $sources = $sourceFiles[$testName] | ForEach-Object {
        "'$(ConvertTo-MsysPath (Join-Path $repoRoot $_))'"
    }
    $sourceArguments = $sources -join " "
    $buildDirectory = "$buildRootMsys/$testName"
    $command = @"
set -e
cd '$repoRootMsys'
mkdir -p '$buildDirectory'
VERILATOR_ROOT='$verilatorRootMsys' '$verilatorMsys' --binary --timing -Wno-fatal -Wno-PINMISSING --no-fourstate --Mdir '$buildDirectory' --top-module '$testName' $sourceArguments
'$buildDirectory/V$testName'
"@

    Write-Host "Running $testName with Verilator..."
    & $bash -lc $command
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
