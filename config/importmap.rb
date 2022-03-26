# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "marked", to: "https://ga.jspm.io/npm:marked@4.0.12/lib/marked.esm.js"
pin "dompurify", to: "https://cdnjs.cloudflare.com/ajax/libs/dompurify/2.3.6/purify.js"