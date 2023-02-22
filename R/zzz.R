.onLoad <- \(libname, pkgname) {
  rJava::.jpackage(
    pkgname,
    lib.loc = libname,
    morePaths = list.files(system.file("java", package = pkgname), full.names = TRUE)
  )
}
