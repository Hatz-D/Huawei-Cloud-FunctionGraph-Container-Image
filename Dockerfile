FROM ubuntu:20.04

ENV HOME=/home/appuser
ENV GROUP_ID=1003
ENV GROUP_NAME=appuser
ENV USER_ID=1003
ENV USER_NAME=appuser

RUN mkdir -m 550 ${HOME} && groupadd -g ${GROUP_ID} ${GROUP_NAME} && useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}

RUN cd ${HOME}

RUN apt-get update && apt-get install -y wget

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

ENV TZ=Asia/Dubai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y dotnet-sdk-8.0 ca-certificates git

RUN dotnet new web -n HelloWorldApp

RUN cd HelloWorldApp

RUN git clone https://github.com/Hatz-D/Huawei-Cloud-FunctionGraph-Container-Image.git

RUN rm -f HelloWorldApp/Program.cs

RUN cp Huawei-Cloud-FunctionGraph-Container-Image/source-code /HelloWorldApp/Program.cs

RUN rm -rf Huawei-Cloud-FunctionGraph-Container-Image

RUN mv HelloWorldApp /home/appuser

RUN chown -R ${USER_ID}:${GROUP_ID} ${HOME}

USER appuser

WORKDIR /

EXPOSE 8000

ENTRYPOINT ["dotnet", "run", "--project", "/home/appuser/HelloWorldApp/HelloWorldApp.csproj"]
