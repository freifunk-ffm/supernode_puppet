define mailserver::sasl_user (
  $trocla_key,
  $username = $title,
) {
  include mailserver::params

  $db = $mailserver::params::generated_userdb
  $password = trocla_get($trocla_key, 'sha1')

  concat::fragment { "${db}+${username}":
    target  => $db,
    content => "${username}:${password}",
  }
}
