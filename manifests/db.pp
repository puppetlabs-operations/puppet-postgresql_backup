# Sample Usage:
#
#   postgresql_backup { 'my application':
#     db_host     => 'postgres.example.com',
#     db_pass     => 'db pass',
#     db_user     => 'postgres',
#     db_name     => 'postgres',
#     backup_path => '/backups',
#   }
#
define postgresql_backup::db (
  $db_host,
  $db_pass,
  $db_user,
  $db_name,
  $backup_path,
  $group  = 'root',
  $owner  = 'root',
  $ensure = present,
) {
  file { "/usr/local/bin/${name}_backup":
    ensure => $ensure,
    group  => $group,
    owner  => $owner,
    mode   => '0755',
    source => template('postgresql_backup/postgresql_backup.erb')
  }

  file { "/etc/${name}_backup.conf":
    ensure  => present,
    group   => $group,
    owner   => $owner,
    mode    => '0600',
    content => template('postgresql_backup/postgresql_backup.conf.erb')
  }

  file { "$owner/.pgpass":
    ensure  => present,
    group   => $group,
    owner   => $owner,
    mode    => '0600',
    content => template('postgresql_backup/pgpass.erb')
  }
}
