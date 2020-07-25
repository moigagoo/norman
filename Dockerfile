FROM nimlang/choosenim

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN choosenim devel
RUN apt-get update && apt-get install -y sqlite3
RUN nimble install -y
