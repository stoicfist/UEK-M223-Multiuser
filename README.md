# README

## Voraussetzungen

- **Ruby Version:** 3.x (empfohlen, siehe `.ruby-version` falls vorhanden)
- **Rails Version:** 8.x
- **Systemabhängigkeiten:**  
  - Node.js (nur für Entwicklungs-Tools, nicht für Asset-Build)
  - SQLite/PostgreSQL (je nach Umgebung)
- **Gems:**  
  - `pundit` (Rollen & Rechte)
  - `paper_trail` (Audit-Log)
  - `chartkick`, `groupdate` (Diagramme)
  - `kaminari` (Pagination)
  - `liquid` (Template-Rendering)
  - `bcrypt` (Passwort-Hashing)
  - `rubyzip` (ZIP-Export)
  - `rspec-rails`, `factory_bot_rails`, `faker` (Tests)
  - `importmap-rails`, `turbo-rails`, `stimulus-rails` (JS-Framework)

## Setup

1. **Abhängigkeiten installieren:**
   ```sh
   bundle install
   bin/setup
   ```

2. **DB anlegen & migrieren:**
   ```sh
   rails db:create db:migrate db:seed
   ```

3. **Admin-Konto anlegen:**
   Siehe unten oder führe das Snippet in der Rails-Konsole aus.

4. **Server starten:**
   ```sh
   bin/dev
   ```

## Features

- Benutzerverwaltung (Registrierung, Login, Rollen, Profil)
- Templates (LaTeX) mit Filter, Suche, Sichtbarkeit (public/private)
- Dokumente aus Templates erzeugen
- Audit-Log (Änderungen, Nutzer, Zeit, Event)
- Diagramme (Aktivität je Tag, Typ, Nutzer, Ereignis)
- Responsive UI, modernes Design (Importmap, Hotwire, modulares CSS)
- Admin-Bereich mit Benutzer- und Aktivitätsverwaltung
- ZIP-Export für Dokumente
- Passwort-Reset, E-Mail-Änderung
- Pundit-Policies für Rechte

## Tests

- RSpec, FactoryBot, Faker
- Test-Suite:  
  ```sh
  bundle exec rspec
  ```

## Deployment

- Standard Rails-Deployment (z.B. mit Docker, Kamal, Heroku)
- Keine JS-Bundler nötig (Importmap-Setup)

---

# ADMIN Konto hinzufügen:
db/seeds.rb (Kurzform)

```sh
   bin/rails c
   ```
```ruby
u = User.find_or_initialize_by(email: "admin@example.com")
u.username = "Admin"
u.role     = "admin"
u.password = "SuperSicheresPasswort!"
u.password_confirmation = "SuperSicheresPasswort!"
u.save!
```