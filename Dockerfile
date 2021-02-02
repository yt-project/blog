FROM cibuilds/hugo:0.80 AS builder

COPY ./ .

RUN hugo --minify

FROM nginx:stable-alpine
COPY --from=builder /home/circleci/project/public /usr/share/nginx/html
