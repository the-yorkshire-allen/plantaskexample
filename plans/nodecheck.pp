#
# @summary A new Plan
# @param targets Targets for plan
#
plan natwest::nodecheck (
  TargetSpec $targets,
) {
  run_plan('puppetdb_fact', 'targets' => $targets)

  $tally_targets = $targets
  $faillock_targets = $targets

  $tally_result = run_task(natwest::nodecheck, $tally_targets, '_catch_errors' => true)
  $tally_ok_targets = $tally_result.ok_set
  $tally_failed_targets = $tally_result.error_set.names
  $tally_locked = $tally_ok_targets.filter_set | $tally | { $tally['message'] == 'locked' }.targets

  run_task(natwest::nodecheck, $tally_locked, '_catch_errors' => true)

  $faillock_result = run_task(natwest::nodecheck, $faillock_targets, '_catch_errors' => true)
  $faillock_ok_targets = $faillock_result.ok_set
  $faillock_failed_targets = $faillock_result.error_set.names
  $faillock_locked = $faillock_ok_targets.filter_set | $faillock | { $faillock['message'] == 'locked' }.targets

  run_task(natwest::nodecheck, $faillock_locked, '_catch_errors' => true)

  $check_error_names = $tally_failed_targets + $faillock_failed_targets

  if $check_error_names {
    out::message("Unable to run check on accounts on targets [${check_error_names}]")
  }

  return ({
    'tally' => $tally_result,
    'faillock' => $faillock_result,
    'tally_locked' => $tally_locked,
    'faillock_locked' => $faillock_locked,
  })

}
