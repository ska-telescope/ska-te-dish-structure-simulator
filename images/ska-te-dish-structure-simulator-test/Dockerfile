FROM python:3.11

ENV POETRY_VERSION="1.3.2"
ENV PATH=/root/.local/bin:$PATH

COPY images/ska-te-dish-structure-simulator-test/get_poetry.py get_poetry.py

RUN python get_poetry.py

WORKDIR /root/ska-te-dish-structure-simulator

COPY . .

RUN rm -rf images

RUN poetry install

CMD ["pytest", "test_ds_simp.py"]