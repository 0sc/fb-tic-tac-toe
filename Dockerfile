FROM ruby:2.4.1

RUN apt-get update && apt install -V -y libgirepository1.0-dev

ADD . /

RUN bundle install
RUN chmod +x /start.sh

EXPOSE 6000

CMD ["/start.sh"]
