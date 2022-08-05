FROM registry.artifakt.io/node:14

WORKDIR /var/www/html/

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# dependency management
RUN npm install

# copy the artifakt folder on root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY . .
RUN  if [ -d .artifakt ]; then cp -rp /var/www/html/.artifakt /.artifakt/; fi

# PERSISTENT DATA FOLDERS
# standard, no specifics

# run custom scripts build.sh
# hadolint ignore=SC1091
RUN --mount=source=artifakt-custom-build-args,target=/tmp/build-args \
    if [ -f /tmp/build-args ]; then source /tmp/build-args; fi && \
    if [ -f /.artifakt/build.sh ]; then /.artifakt/build.sh; fi
