FROM alpine:latest
MAINTAINER Bill Shetti "billshetti@gmail.com"


ENV MYSQL_ID="db_app_user" 
ENV MYSQL_PASSWORD="VMware123!" 
ENV MYSQL_SERVER="fitcyclecustomers.cy4b7ufzt54x.us-west-2.rds.amazonaws.com"

RUN apk update && \
#    apk add --update bash && \
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

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /fitcycle # backwards compat

COPY ./requirements.txt requirements.txt
COPY ./startfitcycle.sh startfitcycle.sh

RUN pip install -r requirements.txt

COPY ./settings.py /fitcycle/fitcycle/settings.py

EXPOSE 8000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["python", "/fitcycle/manage.py", "runserver",  "0.0.0.0:8000"]
