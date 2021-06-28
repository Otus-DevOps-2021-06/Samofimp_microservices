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
