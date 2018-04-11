FROM alpine:latest
MAINTAINER Bill Shetti "billshetti@gmail.com"


ENV MYSQL_ID="db_app_user" 
ENV MYSQL_PASSWORD="VMware123!" 
ENV MYSQL_SERVER="fitcyclecustomers.cy4b7ufzt54x.us-west-2.rds.amazonaws.com"

RUN apk update && \
    apk add python-dev && \
    apk add mysql mysql-client && \
    apk add py-pip && \
    apk add py-sqlalchemy && \
    apk add py-django && \
    apk add py-mysqldb && \
    apk add py-requests && \
    apk add git

RUN ["git", "clone", "https://github.com/bshetti/fitcycle.git"]

WORKDIR /fitcycle

COPY ./requirements.txt requirements.txt
COPY ./startfitcycle.sh startfitcycle.sh

RUN pip install -r requirements.txt

COPY ./settings.py /fitcycle/fitcycle/settings.py
 
EXPOSE 8000

RUN ["python", "manage.py", "migrate"]

RUN ["chmod", "777", "./startfitcycle.sh"]

CMD ["./startfitcycle.sh"]
