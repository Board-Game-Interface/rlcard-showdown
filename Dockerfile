FROM python:3.10.11
WORKDIR /app

COPY . .

ENV NODE_VERSION=14.21.3
ENV NVM_DIR=/root/.nvm
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN node --version
RUN npm --version

RUN npm install
RUN pip install -r requirements.txt
RUN cd server && python manage.py migrate && cd ..
RUN unzip -o pretrained.zip -d pve_server/
RUN chmod +x entrypoint.sh

EXPOSE 3000

CMD ./entrypoint.sh