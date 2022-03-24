# README

## Run this command to watch for changes in the view files for Tailwind
npx tailwindcss -i app/assets/stylesheets/application.css -o app/assets/stylesheets/wind.css --watch

## Heroku Deployment Notes

This [article about how to run both Python and Ruby on Heroku was useful.](https://www.codementor.io/@inanc/how-to-run-python-and-ruby-on-heroku-with-multiple-buildpacks-kgy6g3b1e)

heroku buildpacks:clear
heroku buildpacks:add heroku/python
heroku buildpacks:add https://github.com/Verumex/heroku-buildpack-libvips
heroku buildpacks:add heroku/ruby

To see what buildpacks will be used:
heroku buildpacks