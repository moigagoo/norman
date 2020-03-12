import os


const ## Model structure
  mdlFile* = "models.nim"
  mdlDir* = "models"

const ## Migration structure
  mgrDir* = "migrations"
  binDir* = "bin"
  mgrFile* = "migration.nim"

const ## Templates
  tmplDir* = "templates"
  mdlTmpl* = staticRead(tmplDir/"models.nim.tmpl")
  cfgTmpl* = staticRead(tmplDir/"config.nims.tmpl")
  mgrTmpl* = staticRead(tmplDir/"migration.nim.tmpl")

const ## Migration compilation
  cmplCmdTmpl* = "nim c --verbosity:0 --hints:off --nimcache:$# --out:$#"
  mgrFlag* = "--define:migrate"
  undoFlag* = "--define:undo"
  verboseFlag* = "--define:verbose"
  mgrPfx* = "apply_"
  undoPfx* = "rollback_"
  cacheSfx* = "_cache"

const
  cfgFile* = "config.nims"
  lstFile* = ".last"
