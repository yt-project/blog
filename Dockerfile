FROM cibuilds/hugo:0.80 AS builder

COPY content content
COPY static static
COPY themes themes
COPY resources resources
COPY config.toml .

RUN hugo --minify

FROM nginx:stable-alpine
COPY --from=builder /home/circleci/project/public /usr/share/nginx/html
