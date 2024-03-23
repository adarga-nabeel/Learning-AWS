provider "aws" {
  region = "us-east-1"

  # private ~/.aws/config profile
  # Alternative to fixed long term credentials is using a SAML/LDAP (e.g. AZURE user management)
  profile = "personal"
}
