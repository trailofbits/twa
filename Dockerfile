FROM alpine:3.6

LABEL name twa
LABEL src "https://github.com/trailofbits/twa"
LABEL creator woodruffw
LABEL dockerfile_maintenance khast3x
LABEL desc "A tiny web auditor with strong opinions."

RUN apk add --no-cache bash git curl ncurses \
&& git clone https://github.com/trailofbits/twa.git
WORKDIR twa
RUN bash
ENTRYPOINT [ "./twa" ]
CMD  ["-h"]
