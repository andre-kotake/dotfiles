# shellcheck shell=sh
cleanup() {
  :
}

on_success() {
  log_ok "Done!"
}

on_failure() {
  log_error "Failed (exit code $status)"
}

on_exit() {
  status=$?

  cleanup

  if [ "$status" -eq 0 ]; then
    on_success
  else
    on_failure
  fi

  exit "$status"
}

on_signal() {
  signal=$1

  log_warn "Received $signal"
  cleanup
  exit 1
}

trap on_exit 0
trap 'on_signal INT' INT
trap 'on_signal TERM' TERM
