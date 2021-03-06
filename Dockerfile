FROM nginx:1.17.7

LABEL maintainer="Mehmet KAPLAN"

ENV NGINX_VERSION 1.17.5
ENV NJS_VERSION   0.3.6
ENV PKG_RELEASE   1

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]

