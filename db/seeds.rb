# Admin-Benutzer, falls nicht vorhanden
if User.where(role: "admin").none?
User.create!(
email: "admin@example.com",
password: "SuperSicheresPasswort!",
password_confirmation: "SuperSicheresPasswort!",
role: "admin",
username: "Admin"
)
puts "Admin erstellt: admin@example.com"
end
