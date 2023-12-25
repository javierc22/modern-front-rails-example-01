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

- Generate devise views
  ~~~
  rails generate devise:views
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

## Agregando TypeScript

En este punto, tenemos una configuración completamente funcional de Rails 7 para comenzar a escribir código frontend. Podríamos detenernos aquí. Sin embargo, en lugar de eso, vamos a agregar TypeScript a nuestra mezcla.
Hay buenas y malas noticias sobre el uso de TypeScript con esbuild. La buena noticia es que esbuild convertirá los archivos .ts de TypeScript a JavaScript sin necesidad de cambios de configuración de nuestra parte. La mala noticia es que todo lo que hace esbuild es eliminar las anotaciones de tipo de TypeScript y cualquier otra cosa específica de TypeScript que pueda existir en el archivo. Específicamente, esbuild no ejecuta el compilador de TypeScript para determinar si el código es seguro desde el punto de vista de los tipos. Dado que queremos usar TypeScript específicamente para determinar si nuestro código es seguro desde el punto de vista de los tipos, esto parece menos que ideal.
Lo que queremos hacer es incorporar el compilador de TypeScript a nuestro proceso de construcción vigilado. La documentación de esbuild dice "aún deberás ejecutar tsc -noEmit en paralelo con esbuild para verificar los tipos", pero no ofrece orientación sobre cómo hacerlo.
Aquí entra en juego el paquete tsc-watch12, que ejecuta el compilador de TypeScript en modo de observación y nos permite especificar qué hacer en caso de éxito y de fallo.
Vamos a instalarlo:

- Add Typescript
  ~~~
  yarn add --dev typescript tsc-watch

  yarn add --dev @typescript-eslint/parser

  yarn add --dev @typescript-eslint/eslint-plugin
  ~~~

## Definición Scripts en package.json

En este momento, necesitamos actualizar nuestros scripts de desarrollo para usar tsc-watch. Los nuevos scripts se ven así:

~~~json
  "scripts": {
    "build:js": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds",
    "build:css": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css",
    "failure:js": "rm ./app/assets/builds/application.js && rm ./app/assets/builds/application.js.map",
    "dev": "tsc-watch --noClear -p tsconfig.json --onSuccess \"yarn build:js\" --onFailure \"yarn failure:js\""
  },
~~~

He cambiado el nombre de la tarea de construcción a build:js para que sea paralela a build:css, pero el cambio importante es el nuevo comando dev que llama a tsc-watch.

Estoy llamando a tsc-watch con cuatro argumentos:

- `noClear`, que evita que tsc-watch limpie la ventana de la consola. (Me gustaría hacerlo yo mismo, muchas gracias).

- `-p tsconfig.json`, que apunta al archivo de configuración de TypeScript que rige la compilación que quiero realizar.

- `--onSuccess \"yarn build:js\"`, que controla qué sucede si la compilación de TypeScript tiene éxito. En nuestro caso, queremos que ocurra la compilación regular de esbuild: build:js, ya que ahora sabemos que el código es seguro desde el punto de vista de los tipos.

- `--onFailure \"yarn failure:js\"`, que controla qué sucede si la compilación de TypeScript falla. Supongo que tenía opciones aquí, pero lo que elegí hacer es el script failure.js, es decir, rm ./app/assets/builds/application.js && rm ./app/assets/builds/application.js.map, lo que significa eliminar los archivos existentes de esbuild del directorio de construcción para que la página del navegador de desarrollo muestre un error en lugar de devolver las compilaciones exitosas más recientes. Pensé que permitir que la compilación más reciente exitosa permaneciera podría ser confuso.

Para que esto funcione, necesitamos que el comando dev reemplace a build.js en el archivo Procfile:

~~~
web: bin/rails server -p 3000
js: yarn dev
css: yarn build:css --watch
~~~

Y eso funciona. yarn dev llama a tsc-watch, que se configura automáticamente como un observador, así que no necesitamos hacerlo nuevamente aquí.

Cuando cambia un archivo relevante, se activa tsc-watch y ejecuta el compilador de TypeScript. Si la compilación es exitosa y solo si es exitosa, se llama a esbuild para agrupar el código en una forma compatible con el navegador. Si la compilación falla, entonces eliminamos la compilación exitosa anterior. El mensaje de error va a la consola y suponemos que corregimos el error.

En este momento, si intentamos esto, obtenemos el siguiente error:

~~~
error TS18003: No inputs were found in config file '/Users/noel/projects/pragmatic/north_by_sev- en /tsconfig.json'.
Specified 'include' paths were '["**/*"]' and 'exclude' paths were '["**/*.spec.ts","node_modules","vendor","public"]'.
~~~

TypeScript se queja porque no hay archivos de TypeScript para compilar. Para lidiar con esto por el momento, cambié el nombre del archivo `hello_controller.js` a `hello_controller.ts`, lo cual satisface al compilador por ahora. Cuando comencemos a escribir nuestros propios archivos de TypeScript, el problema desaparecerá. Y ahora Rails está configurado para usar TypeScript.

