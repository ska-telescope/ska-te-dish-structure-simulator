FROM python:3.11

ENV POETRY_VERSION="1.3.2"
ENV PATH=/root/.local/bin:$PATH

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 - --install
RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /root/ska-te-dish-structure-simulator

COPY . .

RUN rm -rf images

RUN poetry install

CMD ["pytest", "test_ds_simp.py"]