# Windows logs files rotation powershell script #

## Description ##
This script is designed to package log files into a specific directory with data compression. This script provides parameters for source and output data (which files should not be affected during script execution (modification time of which is more than N days - they are not compressed and then deleted) and which packaged files (modification time of which is more than N days) should be deleted from the destination directory).

## Описание ##

Этот скрипт предназначен для упаковки файлов журнала в определенный каталог со сжатием данных. Этот скрипт предоставляет параметры для исходных и выходных данных (какие файлы не должны быть затронуты во время выполнения скрипта (время модификации которых составляет более N дней - они не сжимаются и затем не удаляются) и какие упакованные файлы (время модификации которых составляет более N дней) следует удалить из каталога назначения).

---

## How to use it: | Использование

```
.\lg.ps1 -targetDirectory "C:\logs" -destinationDirectory "C:\logarchives" -keepLogsDate 2 -deleteZipAfterDate 7
```


