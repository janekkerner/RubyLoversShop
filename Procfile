web: bin/rails server -p $PORT -e $RAILS_ENV
release: bin/rails db:migrate && bin/rails db:seed && bin/rails r -e production lib/production_tasks.rb
release: bin/rails db:migrate && bin/rails db:seed
