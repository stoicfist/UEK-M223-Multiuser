# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# ADMIN Konto huinzufügen:
db/seeds.rb (Kurzform)

latexhub(dev)> u = User.find_or_initialize_by(email: "admin@example.com")
latexhub(dev)> u.username = "Admin"
latexhub(dev)> u.role     = "admin"
latexhub(dev)> u.password = "SuperSicheresPasswort!"
latexhub(dev)> u.password_confirmation = "SuperSicheresPasswort!"
latexhub(dev)> u.save!
latexhub(dev)> exit