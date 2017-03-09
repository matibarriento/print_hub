FROM ubuntu:16.04
# RUN apt-get -qq update &&  apt-get install -y ruby ruby-dev gem cups-bsd libcups2-dev libxslt1-dev cups-pdf postgresql imagemagick libmagickwand-dev libpq-dev nodejs
# RUN mkdir /code
# WORKDIR /code
# ADD . /code
# RUN ls
# RUN gem install bundle RedCloth pg:0.18.4
# RUN bundle install
# RUN rake db:create
# RUN rake db:migrate

RUN apt-get update &&  apt-get install -y \ 
    ruby ruby-dev gem cups-bsd libcups2-dev \ 
    libxslt1-dev cups-pdf postgresql imagemagick \ 
    libmagickwand-dev libpq-dev nodejs
# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /app 
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
COPY Gemfile Gemfile.lock ./ 
RUN gem install bundle RedCloth pg:0.18.4 && bundle install

# Copy the main application.
COPY . ./

# RUN rake db:create
# RUN rake db:migrate

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.

# ENTRYPOINT []

CMD ["bundle", "exec","rails", "server", "-b", "0.0.0.0"]