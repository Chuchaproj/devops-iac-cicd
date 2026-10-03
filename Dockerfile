FROM python:3.11-alpine3.24@sha256:f2cdc43fcddbabe870f53750cbdcc01ae4aa75b1959351252457fde88f91d20f
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
RUN pip uninstall --yes pip setuptools wheel && addgroup -g 10001 app && adduser -D -u 10001 -G app app
WORKDIR /srv
COPY --chown=10001:10001 app ./app
USER 10001
EXPOSE 8000
CMD ["python", "app/server.py"]
