# Class: npmo::repo
#
#
class npmo::repo {

  case $::osfamily {
    'Debian': { include ::npmo::repo::apt }
    default:  { }
  }

}
