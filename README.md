# Домашнее задание №16
## Задание со * (1)
В файле *docker-monolith/docker-1.log* содержится объяснение, чем отличается контейнер от образа на основе вывода команд *docker inspect*.

## Основное задание
Создан **Dockerfile** в директории docker-monolith, содержащий образ с приложением Reddit и необходимыми для его работы пакетами.

**mongod.conf** - конфигурационный файл для MongoDB.

**db_config** - переменная окружения для MongoDB.

**start.sh** - скрипт для запуска приложения Reddit.

Также получившийся образ опубликован на Docker Hub (**samofimp/otus-reddit**).

Запуск контейнера:
~~~ bash
docker run --name reddit -d -p 9292:9292 samofimp/otus-reddit:1.0
~~~

## Задание со * (2)
В директории **infra/terraform** содержится конфигурация для Terraform (запуск с помощью *terraform apply*).

В директории **infra/ansible** содержатся плейбуки Ansible (запуск с помощью *ansible-playbook main.yml*). Динамический inventory: *bash ./dynamic_inventory.sh*.

В директории **infra/packer** содержится конфигурация для сборки образа Packer (запуск с помощью *packer build -var-file=variables.json app.json).

# Домашнее задание №17
Приложение Reddit разделено на несколько сервисов (post_db, post, comment, ui).

Билд образов из директории **src**:
~~~ bash
docker build -t <your-dockerhub-login>/post:1.0 ./post-py
docker build -t <your-dockerhub-login>/comment:1.0 ./comment
docker build -t <your-dockerhub-login>/ui:1.0 ./ui
~~~

Запуск приложения с сетью и volume:
~~~ bash
docker volume create reddit_db
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post <your-dockerhub-login>/post:1.0
docker run -d --network=reddit --network-alias=comment <your-dockerhub-login>/comment:1.0
docker run -d --network=reddit -p 9292:9292 <your-dockerhub-login>/ui:2.0
~~~

# Домашнее задание №18
Подготовлена конфигурация для запуска приложения под docker-compose.

Запуск приложения производится после подключения к созданному ранее docker host'у (*eval $(docker-machine env docker-host)*). Работа производится в директории **src**. Переменные окружения должны содержаться в файле **.env** (пример находится в **.env.example**).
~~~ bash
# Запуск docker-compose
docker-compose up
~~~

Остановка и удаление контейнеров:
~~~ bash
docker-compose down
~~~

*Пояснение*: базовое имя проекта по умолчанию образуется из имени директории, откуда производится запуск команд docker-compose.

Задать собственное имя проекта можно двумя способами:
~~~ bash
docker-compose -p MY_PROJECT_NAME
~~~
~~~ bash
docker-compose --project-name MY_PROJECT_NAME
~~~

## Задание со *
Добавлен файл конфигурации **docker-compose.override.yml**, который позволяет:
* Изменять код каждого приложения, не пересобирая образ (реализовано через монтирование volume'ов с хоста).
* Запускать puma в дебаг режима с двумя воркерами (*puma --debug -w 2*).
