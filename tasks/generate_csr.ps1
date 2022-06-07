[CmdletBinding()]
Param(
 [Parameter(Mandatory = $True)]
 [String] $AuthCode
)

if ($AuthCode -eq $null -or $AuthCode -eq "") {
  'Authorisation Code is empty'
  Exit 1
} else {

  $inffile = '[Version]
Signature = "WindowsNT"

[NewRequest]
Subject = "'+$AuthCode+'"
Exportable = TRUE
KeyLength = 2048'
  $inffile | Out-File csrfile.inf
  $inffile
  # certreq
}


Exit 0
