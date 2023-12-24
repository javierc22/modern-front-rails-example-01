# Modern Front-End Development For Rails Example 1

- Book Source code: https://pragprog.com/titles/nrclient2/modern-front-end-development-for-rails-second-edition/

## Getting Started

- Install Ruby 3.2.2
  ~~~bash
  rbenv install 3.2.2
  ~~~

- Set Ruby 3.2.2
  ~~~bash
  rbenv local 3.2.2
  ~~~

- Install Rails 7.1.2
  ~~~bash
  gem install rails -v 7.1.2
  ~~~

- Create new project
  ~~~bash
  rails new modern-front-rails-example-01 -a propshaft -j esbuild --database postgresql --skip-test --css tailwind
  ~~~

  - Notes:
      
    This gives us a standard Rails application with the following overrides:

    - We are using PostgreSQL as the database instead of the default SQLite.
    - We are skipping the installation of the default test library because we’re going to add in RSpec later.
    - We are using Propshaft as the asset handler rather than the default Sprockets, which we’ll look at in Propshaft, on page 152.
    - We are using jsbundling-rails with esbuild for JavaScript building rather than the default, which is importmap-rails.
    - We are using the Tailwind9 CLI for CSS packaging, rather than the default, which is nothing.

- Add credentials for database

  Edit credentials
  ~~~
  EDITOR="vim" rails credentials:edit
  ~~~

  Add config database
  ~~~
  # aws:
  #   access_key_id: 123
  #   secret_access_key: 345

  # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
  secret_key_base: 5138292040c86a841d5a276784b0aded02f0074c558cb397e2d2e8955bf10979879d9f98586d6c2c0647c3bd160597d1fcb6dcbf0eed1f4b8bf1ef2036292849

  database:
    db_username: javier
    db_password: admin
    db_name: modern_front_example1_development
    db_test_name: modern_front_example1_test

  ~~~

- Edit `config/database.yml`
  ~~~yml
  default: &default
    adapter: postgresql
    encoding: unicode
    # For details on connection pooling, see Rails configuration guide
    # https://guides.rubyonrails.org/configuring.html#database-pooling
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

  development:
    <<: *default
    database: <%= Rails.application.credentials.dig(:database, :db_name) %>
    username: <%= Rails.application.credentials.dig(:database, :db_username) %>
    password: <%= Rails.application.credentials.dig(:database, :db_password) %>

  test:
    <<: *default
    database: <%= Rails.application.credentials.dig(:database, :db_test_name) %>

  production:
    <<: *default
    database: <%= Rails.application.credentials.dig(:database, :db_name) %>
    username: <%= Rails.application.credentials.dig(:database, :db_username) %>
    password: <%= Rails.application.credentials.dig(:database, :db_password) %>
  ~~~

- Create database
  ~~~
  rails db:create
  ~~~

- Run serve
  ~~~
  rails s
  ~~~

## Add Devise

- Add devise gem to `Gemfile`
  ~~~rb
  gem "devise"
  ~~~

- Run bundle install
  ~~~
  bundle install
  ~~~

- Run devise generator
  ~~~
  rails generate devise:install
  ~~~

- Add configuration to `config/environments/development.rb`
  ~~~rb
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  ~~~

- Create User model
  ~~~
  rails g devise user
  ~~~

## Front End Gems

- Verificar que las siguientes gemas estén en el Gemfile
  ~~~
  gem "propshaft"
  gem "turbo-rails"
  gem "stimulus-rails"
  gem "jsbundling-rails"
  gem "cssbundling-rails"
  ~~~

  Obtenemos Propshaft porque lo especificamos directamente en nuestro comando de inicio. Turbo-rails y stimulus-rails son predeterminados y gestionan la relación entre Turbo, Stimulus y Rails. Obtuvimos la gema jsbundling-rails porque especificamos esbuild como nuestra herramienta de empaquetado de JavaScript.

  La herramienta cssbundling-rails es un poco más complicada. La herramienta de línea de comandos de Tailwind tiene dos versiones, una de las cuales utiliza Node.js y la otra es un binario independiente específico de la plataforma. Actualmente, Rails ofrece herramientas separadas para cada versión; la herramienta cssbundling-rails asume que tienes Node.js instalado y estás utilizando una herramienta de empaquetado basada en Node.js. Dado que especificamos esbuild, Rails asume que queremos la herramienta basada en Node.js, por lo que nos da cssbundling-rails. Si estuviéramos utilizando importmap-rails, nos daría la gema tailwind-rails, que construye CSS utilizando el binario independiente de Tailwind.

- Add Typescript
  ~~~
  yarn add --dev typescript tsc-watch

  yarn add --dev @typescript-eslint/parser

  yarn add --dev @typescript-eslint/eslint-plugin
  ~~~