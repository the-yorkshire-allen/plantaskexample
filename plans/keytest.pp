#
# @summary A new Plan
# @param targets Targets for plan
#
plan natwest::keytest (
  TargetSpec $targets,
) {

  $my_key = lookup('my_key')

  return ({
    'key' => $my_key,
  })

}
