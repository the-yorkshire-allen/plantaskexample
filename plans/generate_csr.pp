#
# @summary A new Plan
# @param targets Targets for plan
#
plan natwest::generate_csr (
  String $authorisation_code,
  TargetSpec $targets,
) {

    run_task('natwest::mkdir_p_file', $target,
      path    => 'c:/windows/temp/generate_csr.inf',
      content => @("HEREDOC"),
[Version]
Signature = "$WindowsNT$"

[NewRequest]
Subject = "CN=ca-win2016-9055b0-0.us-west1-c.c.emea-ps-lab.internal,OU=PuppetLabs"
Exportable = TRUE
KeyLength = 2048

[RequestAttributes]
CertificateTemplate=TestTemplate
Details=        [main]
        certname = ${target.peadm::certname()}
        | HEREDOC
    )

  $my_key = lookup('my_key')

  return ({
    'key' => $my_key,
  })

}
