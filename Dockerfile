FROM ruby:3.2.0

ENV SHELL=/bin/bash
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV APP_USER=app
ENV RAILS_ENV=development

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG APP_DIR=/app

RUN groupadd --gid $HOST_GID $APP_USER && \
    useradd --uid $HOST_UID --gid $HOST_GID $APP_USER --create-home && \
    mkdir -p $APP_DIR && chown ${APP_USER}:${APP_USER} $APP_DIR

WORKDIR $APP_DIR

RUN chown ${APP_USER}:${APP_USER} -R $GEM_HOME

USER $APP_USER

COPY --chown=${APP_USER}:${APP_USER} Gemfile* ./
RUN bundle install --retry=3 --jobs=4

COPY --chown=${APP_USER}:${APP_USER} . ${APP_DIR}
