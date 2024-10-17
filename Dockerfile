FROM python:3.10.11 AS server
COPY server /server
COPY requirements.txt /server/requirements.txt

WORKDIR /server

RUN pip install -r requirements.txt
RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0"]

FROM server AS pve_server
COPY pve_server /pve_server

WORKDIR /pve_server

RUN unzip -o pretrained.zip -d .

CMD ["python", "run_douzero.py"]

FROM node:14.21.3 AS ui
WORKDIR /app

COPY . .

# ENV NODE_VERSION=14.21.3
# ENV NVM_DIR=/root/.nvm
# ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# RUN apt install -y curl
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
# RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
# RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
# RUN node --version
# RUN npm --version
RUN npm install

EXPOSE 3000

CMD ["npm", "start"]