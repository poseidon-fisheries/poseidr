make_java_map_key <- \(key) {
  try_java(
    rJava::.jnew("java/lang/String", key) |>
      rJava::.jcast()
  )
}

simplify <- \(x) {
  if (rJava::is.jnull(x)) {
    NA
  } else {
    o <- rJava::.jsimplify(x)
    if (inherits(o, "jobjRef")) {
      rJava::.jcall(o, "S", "toString")
    } else {
      o
    }
  }
}

simplify_list <- \(xs, progress = TRUE) {
  xs |>
    as.list() |>
    purrr::map(simplify, .progress = progress) |>
    purrr::list_simplify()
}
