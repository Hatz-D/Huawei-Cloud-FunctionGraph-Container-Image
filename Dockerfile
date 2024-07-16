FROM ubuntu:22.04

ENV HOME=/home/appuser
ENV GROUP_ID=1003
ENV GROUP_NAME=appuser
ENV USER_ID=1003
ENV USER_NAME=appuser

RUN mkdir -m 550 ${HOME} && groupadd -g ${GROUP_ID} ${GROUP_NAME} && useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}

RUN cd ${HOME}

RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C

RUN gpg --export --armor 871920D1991BC93C | sudo apt-key add - 

RUN apt-get update && apt-get install -y dotnet8 ca-certificates git

RUN chown -R ${USER_ID}:${GROUP_ID} ${HOME}

RUN dotnet new web -n HelloWorldApp

RUN cd HelloWorldApp

RUN git clone https://github.com/Hatz-D/Teste.git

RUN rm -f HelloWorldApp/Program.cs

RUN cp Teste/teste /HelloWorldApp/Program.cs

RUN rm -rf Teste

RUN mv HelloWorldApp /home/appuser

RUN chown -R appuser:appuser /home/appuser

USER appuser

WORKDIR /

EXPOSE 8000

ENTRYPOINT ["dotnet", "run", "--project", "/home/appuser/HelloWorldApp/HelloWorldApp.csproj"]

#CMD dotnet run --project /home/appuser/HelloWorldApp/HelloWorldApp.csproj
