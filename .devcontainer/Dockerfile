FROM mcr.microsoft.com/devcontainers/python:3.11

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

RUN chmod a+x /usr/local/bin/yq

USER vscode

ENV POETRY_VERSION="1.3.2"
ENV PATH=/home/vscode/.local/bin:$PATH

RUN curl -sSL https://install.python-poetry.org | python3 - 

RUN poetry config virtualenvs.in-project true
