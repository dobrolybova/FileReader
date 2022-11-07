FROM erlang:24

EXPOSE 8080

RUN mkdir /Webserver
WORKDIR /Webserver

COPY README.md .
COPY Makefile .
COPY rebar.config .
COPY test.sh .

COPY ./src ./src
COPY ./ut ./ut

RUN make all

ENTRYPOINT ["make", "run"]