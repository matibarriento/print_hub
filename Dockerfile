FROM ubuntu:16.04
RUN apt-get -qq update &&  apt-get install -y ruby ruby-dev gem cups-bsd libcups2-dev libxslt1-dev cups-pdf postgresql imagemagick libmagickwand-dev libpq-dev nodejs
RUN mkdir /code
WORKDIR /code
ADD . /code/
RUN ls
RUN gem install bundle RedCloth pg:0.18.4
RUN bundle install
