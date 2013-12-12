class postgresql_backup {

  concat { $postgresql_backup::db::pgpass:
    owner => $postgresql_backup::db::owner,
    group => $postgresql_backup::db::group,
    mode  => '0600'
  }

  concat::fragment { 'postgresql_backup header':
    target  => $postgresql_backup::db::pgpass,
    content => "\nPuppet managed postgresql_backups. Changes made to this file will not be saved\n\n",
    order   => '01'
  }
}
