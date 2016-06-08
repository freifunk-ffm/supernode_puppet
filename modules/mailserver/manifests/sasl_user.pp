define mailserver::sasl_user (
  $trocla_key,
  $username = $title,
) {
  include mailserver::params

  $db = $mailserver::params::generated_userdb
  $password = base64('encode', trocla_get($trocla_key))

  concat::fragment { "${db}+${username}":
    target  => $db,
    content => strip("${username}:{PLAIN}${password}"),
  }
}
