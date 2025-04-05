resource "kubernetes_config_map" "pg_config" {
  metadata {
    name = "pg-config"
  }
  data = {
    "postgresql.conf" = <<EOF
      listen_addresses = '*'
      wal_level = replica
      max_wal_senders = 10
      wal_keep_segments = 64
      archive_mode = on
      archive_command = 'cp %p /mnt/archive/%f'
      ssl = off
    EOF

    "pg_hba.conf" = <<EOF
      # allow connection without SSL for 10.0.191.0/24
      hostnossl all all 10.0.2.0/24 md5
      
      # allow connection without SSL for 10.0.2.0/24
      hostnossl all all 10.0.1.0/24 md5
    EOF
  }
}
