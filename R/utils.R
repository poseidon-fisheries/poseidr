make_java_map_key <- \(key) {
  try_java(
    rJava::.jnew("java/lang/String", key) |>
      rJava::.jcast()
  )
}
