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
  $db_host     = undef,
  $db_pass     = undef,
  $db_user     = undef,
  $db_name     = undef,
  $backup_path = undef,
  $group       = 'root',
  $owner       = 'root',
  $ensure      = present,
  $pgpass      = '/root/.pgpass',
  $confdir     = '/etc/postgresql/9.3/main/backup'
) {

  if ! defined(File[$confdir]) {
    file { $confdir:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      before => File["/usr/local/bin/${title}_backup"]
    }
  }

  if ! defined(Concat[$pgpass]) {
    concat { $pgpass:
      owner  => $owner,
      group  => $group,
      mode   => '0600',
    }
  }

  file { "/usr/local/bin/${title}_backup":
    ensure  => $ensure,
    group   => $group,
    owner   => $owner,
    mode    => '0755',
    content => template('postgresql_backup/postgresql_backup.erb')
  } ->

  file { "/etc/postgresql/9.3/main/backup/${title}_backup.conf":
    ensure  => $ensure,
    group   => $group,
    owner   => $owner,
    mode    => '0600',
    content => template('postgresql_backup/postgresql_backup.conf.erb')
  }

# if ! defined(Concat::Fragment['postgresql_backup header']) {
#   concat::fragment { 'postgresql_backup header':
#     target  => $postgresql_backup::db::pgpass,
#     content => "\nPuppet managed postgresql_backups. Changes made to this file will not be saved\n\n",
#     order   => '1'
#   }
# }

  concat::fragment { $title:
    target  => $pgpass,
    content => "${db_host}:5432:${db_name}:${db_user}:${db_pass}\n",
    order   => '2'
  }
}
