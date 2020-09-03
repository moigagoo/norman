FROM nimlang/nim:1.2.6

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN apt-get update && apt-get install -y sqlite3
RUN nimble install -y
