FROM postgres:11
# build postres container with jwt included
# * cd postgres-jwt
# * docker build -t postgres-jwt .

RUN apt-get update && apt-get install -y make git postgresql-server-dev-11 postgresql-11-pgtap
# COPY custom.postgresql.conf /etc/postgresql/postgresql.conf
# RUN chmod 755 /etc/postgresql/postgresql.conf
# set up jwt tokens
RUN mkdir "/postgres-jwt"
WORKDIR "/postgres-jwt"
COPY . .
RUN make && make install

# fire up postres with new config file
#CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
CMD ["postgres"]
