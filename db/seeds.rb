def ensure_user!(email:, role:, username:, password: nil)
  user = User.find_or_initialize_by(email: email)
  user.username = username
  user.role     = role

  if password.present?
    # Explizit gesetztes Passwort IMMER übernehmen
    user.password              = password
    user.password_confirmation = password
  elsif user.new_record? || user.password_digest.blank?
    # Fallback nur, wenn neu oder noch kein Passwort vorhanden
    pwd = "SuperSicheresPasswort!123"
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
  password: "SuperSicheresPasswort!"
)

ensure_user!(
  email: "mod@example.com",
  role:  "moderator",
  username: "Moderator",
  password: "SuperSicheresPasswort!123"
)

ensure_user!(
  email: "user@example.com",
  role:  "user",
  username: "User",
  password: "SuperSicheresPasswort!123"
)

puts "All Done!"
