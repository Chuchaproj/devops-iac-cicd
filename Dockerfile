FROM python:3.11-slim-trixie@sha256:bab1b7ef4b450c81002278d035eff85ebe394ae94df904f7a3ba14f7e16e487b
WORKDIR /srv
RUN useradd --uid 10001 --create-home app
COPY --chown=10001:10001 app ./app
USER 10001
EXPOSE 8000
CMD ["python", "app/server.py"]
