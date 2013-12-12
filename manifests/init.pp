class postgresql_backup {

  concat { $postgresql_backup::db::pgpass:
    owner => $postgresql_backup::db::owner,
    group => $postgresql_backup::db::group,
    mode  => '0600'
  }
}
