FROM alpine:3.10

LABEL name twa
LABEL src "https://github.com/trailofbits/twa"
LABEL creator woodruffw
LABEL dockerfile_maintenance khast3x
LABEL desc "A tiny web auditor with strong opinions."

RUN apk add --no-cache bash git curl ncurses bind-tools

COPY . /twa

WORKDIR /twa

ENTRYPOINT [ "/twa/twa" ]
CMD  ["-h"]
