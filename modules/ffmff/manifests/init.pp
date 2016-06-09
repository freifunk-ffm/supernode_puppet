class ffmff (
  $puppetmaster = false,
) {
  validate_bool($puppetmaster)

  include ::ffmff::apt
  class { '::ffmff::puppet':
    master => $puppetmaster,
  }
  include ::screen
  include ::rsyslog
  include ::sshd
  include ::postfix
  include ::firewall
  include ::ffmff::ntp
  include ::ffmff::admintools
  include ::ffmff::locales
  include ::ffmff::timezone

  ssh_authorized_key { 'freifunk@t-8ch.de':
    user => 'root',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCuGRPkEjqUhjvnpif8bjOFXujxgM7lbwL3ojisDAF/5WQ8SbAByIZaiOcGgpbYG/kF+fNXpOgKqxR3mf9dqggQDv0/jBAbUTK2027TqTFwCiksivKYX3Ciu9WM6crBfO09jLuP8VMyUD8vGjG/ewiXr1EQ508N43mwJLiFzeZvTW0it1MKuWu66BYRNz0V/Vm/FnO4ptJ3g69cVRuuL2Zbp5Vz5BSm9MNTbq3Og/gjI7lfuvjFh57GlXmiEvKfzHrrrr9OCnPP8ROfMmPpiCcmVDKIRDUfq5rVra4QLitEtkiIZ6VHSVMvmsIIP65Yj3eNkCpRXEwXsALp7D02/duB',
  }
}
