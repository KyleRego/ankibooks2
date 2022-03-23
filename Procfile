web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
release: npx tailwindcss -i app/assets/stylesheets/application.css -o app/assets/stylesheets/wind.css