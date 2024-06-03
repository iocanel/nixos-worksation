self: super: {
  # Override openjdk with temurin-bin-17 or set openjdk to null
  openjdk = null;
  jdk = self.temurin-bin-17;
  jre = self.temurin-bin-17;
}
