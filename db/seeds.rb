def ensure_user!(email:, role:, username:, password: nil)
  user = User.find_or_initialize_by(email: email)
  user.username = username
  user.role     = role

  # Passwort nur setzen, wenn neu oder noch kein PW vorhanden
  if user.new_record? || user.password_digest.blank?
    # Fallback: starkes Default-Passwort, falls keins übergeben
    pwd = password.presence || "SuperSicheresPasswort!123" # >= 12 Zeichen
    user.password              = pwd
    user.password_confirmation = pwd
  end

  user.save!
  user
end

admin = ensure_user!(
  email: "admin@example.com",
  role:  "admin",
  username: "Admin",
  password: "SuperSicheresPasswort!"    # 23 Zeichen
)

ensure_user!(
  email: "mod@example.com",
  role:  "moderator",
  username: "Moderator",
  password: "SuperSicheresPasswort!123"    # >=12
)

ensure_user!(
  email: "user@example.com",
  role:  "user",
  username: "User",
  password: "SuperSicheresPasswort!123"    # >=12
)

puts "Admin bereit: #{admin.email}"
