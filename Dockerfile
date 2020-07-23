FROM node:12.13.1-stretch-slim

WORKDIR /bcrypt
new error
COPY app/ /bcrypt/

RUN echo "[INFO]::[install-run-nmp]" && \
    npm install && \
    npm run build

CMD ["/bin/bash", "-c", "npm run serve"]
