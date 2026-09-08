let
  # YubiKey key (sk-ssh-ed25519) is not supported by age for encryption.
  # Using standard SSH key instead.
  yannis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIFavtKrQR2LhGcnquFEtt72UOhoNw6zDquYt8hURSr yannismalgorn@gmail.com";
  # System host key (cat /etc/ssh/ssh_host_ed25519_key.pub)
  dellYannis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+U2JvoXefMFF+eSm814MPEK8fYlRmoRa1gaJJGvKdS root@dellYannis";

  system = dellYannis;
  allKeys = [yannis system];
in {
  "nextcloud-sync-drive.age".publicKeys = allKeys;
  "gitlab-token.age".publicKeys = allKeys;
  "gemini-api-key.age".publicKeys = allKeys;
}
