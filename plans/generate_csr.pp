#
# @summary A new Plan
# @param targets Targets for plan
#
plan natwest::generate_csr (
  String $authorisation_code,
  TargetSpec $targets,
) {

  $csr_result = run_task(natwest::generate_csr, $targets, 'AuthCode' => $authorisation_code, '_catch_errors' => true)

  return ({
    'csr' => $csr_result.ok_set(),
  })

}
