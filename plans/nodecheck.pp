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

  $tally_result = run_task(natwest::nodecheck, $tally_targets)
  $faillock_result = run_task(natwest::nodecheck, $faillock_targets)

  $tally_ok_targets = $tally_result.ok_set
  $tally_locked = $tally_ok_targets.filter_set | $tally | { $tally['message'] == 'locked' }.targets

  $faillock_ok_targets = $faillock_result.ok_set
  $faillock_locked = $faillock_ok_targets.filter_set | $faillock | { $faillock['message'] == 'locked' }.targets

  run_task(natwest::nodecheck, $tally_locked)
  run_task(natwest::nodecheck, $faillock_locked)

  return ({
    'tally' => $tally_result,
    'faillock' => $faillock_result,
    'tally_locked' => $tally_locked,
    'faillock_locked' => $faillock_locked,
  })

}
