FROM ruby:2.5.0

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install 

RUN mkdir -p /mhb-api
COPY . /mhb-api
WORKDIR /mhb-api

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
