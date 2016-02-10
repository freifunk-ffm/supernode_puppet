define postfix::sasl_user (
  $username,
  $trocla_key,
) {
  $password = trocla($trocla_key)
}
