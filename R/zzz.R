.onLoad <- \(libname, pkgname) {
  rJava::.jpackage(
    pkgname,
    lib.loc = libname,
    morePaths = list.files(system.file("java", package = pkgname), full.names = TRUE)
  )
  rJava::.jcall(
    "java/lang/System", "V", "setOut",
    rJava::.jnew(
      "java/io/PrintStream",
      rJava::.jcast(
        rJava::.jnew(
          "org/rosuda/JRI/RConsoleOutputStream",
          rJava::.jengine(start = TRUE),
          0L
        ),
        "java/io/OutputStream"
      )
    )
  )
}
