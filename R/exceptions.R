try_java <- \(expr) {
  try_fetch(
    expr,
    Exception = \(e) {
      abort(
        message = stack_trace(e$jobj),
        call = caller_env(),
        parent = NA,
        trace = trace_back(),
        java_exception = e$jobj
      )
    }
  )
}

stack_trace <- \(e) {
  t <- rJava::.jcast(e, "java/lang/Throwable")
  rJava::.jcall("uk/ac/ox/poseidon/r/Utils", "S", "getStackTrace", t)
}
