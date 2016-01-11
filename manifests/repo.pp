# Class: npmo::repo
#
#
class npmo::repo {

  if $::npmo::manage_npmo_repo == true {
    case $::osfamily {
      'Debian': { include ::npmo::repo::apt }
      default:  { }
    }
  }

}
