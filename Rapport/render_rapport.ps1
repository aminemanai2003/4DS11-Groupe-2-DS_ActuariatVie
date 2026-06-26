$ErrorActionPreference = "Stop"

$rscript = "C:\Program Files\R\R-4.5.2\bin\Rscript.exe"
$pandoc = "C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools"
$rapport = "Rapport_Projet_Actuariat_Vie_Sujet3_Groupe-2-DS.Rmd"

if (-not (Test-Path $rscript)) {
  throw "Rscript introuvable: $rscript"
}

if (-not $env:HMD_USERNAME -or -not $env:HMD_PASSWORD) {
  throw "Définir HMD_USERNAME et HMD_PASSWORD avant de générer le rapport."
}

$env:RSTUDIO_PANDOC = $pandoc

Push-Location $PSScriptRoot
try {
  & $rscript -e "rmarkdown::render('$rapport', output_format = 'html_document', encoding = 'UTF-8')"
  & $rscript -e "rmarkdown::render('$rapport', output_format = 'pdf_document', encoding = 'UTF-8')"
}
finally {
  Pop-Location
}
