param ($targetDirectory, $destinationDirectory, [int] $keepLogsDate, [int] $deleteZipAfterDate)

Write-Output "$targetDirectory $destinationDirectory $keepLogsDate $deleteZipAfterDate"

# Укажите путь к директории, в которой требуется выполнить поиск файлов
# $targetDirectory = "C:\logs"

# Укажите путь, по которому будут храниться сжатые лог файлы
# $destinationDirectory = "C:\logarchives"

# Файлы, старше N дней подлежат обработке и последующему удалению
# $keepLogsDate = 1

# Файлы созданных архивов, время создания которых больше N дней подлежат удалению
# $deleteZipAfterDate = 7

# # Функция для создания zip-архива
function Compress-FilesToZip ($files, $zipFile) {
    $shellApplication = New-Object -com shell.application
    $zipPackage = $shellApplication.NameSpace($zipFile)
    $files | ForEach-Object {
        $zipPackage.CopyHere($_.FullName)
    }
}

# # Поиск файлов с расширением .log и их компрессия в zip-архивы
$logFiles = Get-ChildItem $targetDirectory -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$keepLogsDate) }

foreach ($logFile in $logFiles) {
    $zipFileName = $logFile.Name -replace ".log", ".zip"

    $sourceFileName = Join-Path -Path $logFile.Directory.FullName -ChildPath $logFile
    $zipFilePath = Join-Path -Path $destinationDirectory -ChildPath $zipFileName

    if (-not (Test-Path $zipFilePath)) {
        $compress = @{
            Path = $sourceFileName
            CompressionLevel = "Optimal"
            DestinationPath = $zipFilePath
        }
        Compress-Archive @compress
        if (Test-Path -Path $zipFilePath) {
            Write-Output "File  $sourceFileName  has been compressed into  $zipFilePath"
            try {
                Remove-Item -Path $sourceFileName -Force
                Write-Output "$sourceFileName has been removed"
            }
            catch {
                Write-Output "Error during file $sourceFileName deletion"
            }
        }
    }
}

$zippedFiles = Get-ChildItem $destinationDirectory -Filter *.zip | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$deleteZipAfterDate) }

foreach ($zippedFile in $zippedFiles) {
    $zipFilePath =  Join-Path -Path $zippedFile.Directory.FullName -ChildPath $zippedFile
    try {
        Remove-Item -Path $zipFilePath -Force
        Write-Output "$zipFilePath has been deleted"
    }
    catch {
        Write-Output "error during $zipFilePath deletion"
    }
}
