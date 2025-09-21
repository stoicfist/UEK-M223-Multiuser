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

User.find_or_create_by!(email: "admin@example.com")     { |u| u.password = "Password1!"; u.role = "admin" }
User.find_or_create_by!(email: "mod@example.com")       { |u| u.password = "Password1!"; u.role = "moderator" }
User.find_or_create_by!(email: "user@example.com")      { |u| u.password = "Password1!"; u.role = "user" }
