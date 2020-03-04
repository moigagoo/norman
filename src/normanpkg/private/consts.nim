import os


const ## Model structure
  mdlDir* = "models"
  mdlFile* = "models.nim"

const ## Migration structure
  mgrDir* = "migrations"
  binDir* = "bin"
  mgrFile* = "migration.nim"

const ## Template structure
  tmplDir* = "templates"
  mdlTmpl* = staticRead(tmplDir/"models.nim.tmpl")
  cfgTmpl* = staticRead(tmplDir/"config.nims.tmpl")
  mgrTmpl* = staticRead(tmplDir/"migration.nim.tmpl")

const
  cmplCmd* = "nim c --verbosity:0 --hints:off --outdir:" & (mgrDir/binDir)
  cfgFile* = "config.nims"
