FROM mcr.microsoft.com/mssql/server
ENV ACCEPT_EULA=Y

WORKDIR /scripts
COPY . .

USER root
RUN chmod +x ./run-initialization.sh

EXPOSE 1433
CMD [ "/bin/bash", "./entrypoint.sh"]