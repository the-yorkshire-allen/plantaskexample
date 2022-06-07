[CmdletBinding()]
Param(
 [Parameter(Mandatory = $True)]
 [String] $authorisation_code
)

if ($authorisation_code -eq $null -or $authorisation_code -eq "") {
  'Authorisation Code is empty'
  Exit 1
} else {

  $inffile = '[Version]
Signature = "WindowsNT"

[NewRequest]
Subject = "'+$authorisation_code+'"
Exportable = TRUE
KeyLength = 2048'
  $inffile | Out-File csrfile.inf
  $inffile
  # certreq
}


Exit 0
