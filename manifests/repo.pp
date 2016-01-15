# Class: npmo::repo
#
#
class npmo::repo {
  if $module_name != $caller_module_name {
    fail("Module ${name} is private.")
  }

  if $::npmo::manage_npmo_repo == true {
    case $::osfamily {
      'Debian': { include ::npmo::repo::apt }
      default:  { }
    }
  }

}
