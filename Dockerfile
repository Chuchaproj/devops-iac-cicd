FROM python:3.11-slim-trixie@sha256:bab1b7ef4b450c81002278d035eff85ebe394ae94df904f7a3ba14f7e16e487b
RUN apt-get update && apt-get install --yes --no-install-recommends libpcre2-8-0=10.46-1~deb13u3 && rm -rf /var/lib/apt/lists/*
WORKDIR /srv
RUN pip uninstall --yes pip setuptools wheel && useradd --uid 10001 --create-home app
COPY --chown=10001:10001 app ./app
USER 10001
EXPOSE 8000
CMD ["python", "app/server.py"]
