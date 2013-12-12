postgresql_backup { 'my application':
  db_host     => 'postgres.example.com',
  db_pass     => 'db pass',
  db_user     => 'postgres',
  db_name     => 'postgres',
  backup_path => '/backups',
}
