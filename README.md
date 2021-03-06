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

# Домашнее задание №20
## Основное задание
В файле **gitlab-ci.yml** в корне репозитория описаны этапы pipeline GitLab CI.

В **gitlab-ci/docker-compose.yml** описана конфигурация для запуска.

## Дополнительные задания
### 2.7* Автоматизация развёртывания GitLab
Для развёртывания GitLab с помощью Ansible необходимо из директории **docker-monolith/infra/ansible** запустить генерацию динамического inventory (dynamic_inventory_2.sh).

Затем - запустить playbook gitlab-ci.yml.

### 10.2* Автоматизация развёртывания GitLab Runner
Для развёртывания GitLab Runner с помощью Ansible необходимо в файле **docker-monolith/infra/ansible/variables.yml** установить gitlab_token на токен для раннеров из GitLab CI по примеру из **variables.yml.example**.

Затем из директории **docker-monolith/infra/ansible** необходимо запустить plabook deploy_runner.yml

# Домашнее задание №22
## Основное задание
Конфигурация docker-compose теперь находится в **docker** директории.

В **docker-compose.yml** помимо сервисов post_db, ui, comment, post добавлен сервис prometheus с приложением для монинторинга и node-exporter в качестве экспортера для сбора метрик с хоста.

Конфигурация Prometheus находится в **monitoring/prometheus/prometheus.yml**. Там же находится Dockerfile для билда образа.

Билд образов:
~~~ bash
/src/ui $ bash docker_build.sh
/src/post-py $ bash docker_build.sh
/src/comment $ bash docker_build.sh
/monitoring/prometheus $ docker build -t <your username>/prometheus .
~~~

Запуск сервисов производится из директории **docker** с помощью:
~~~ bash
docker-compose up -d
~~~

## Дополнительное задание
В Prometheus добавлен мониторинг MongoDB c помощью экспортера bitnami/mongodb-exporter.

Ссылки на образы в Docker Hub:

* [Prometheus](https://hub.docker.com/repository/docker/samofimp/prometheus)
* [Post](https://hub.docker.com/repository/docker/samofimp/post)
* [Comment](https://hub.docker.com/repository/docker/samofimp/comment)
* [UI](https://hub.docker.com/repository/docker/samofimp/ui)

# Домашнее задание №23
## Основное задание
Конфигурация docker-compose для приложения находится по-прежнему в **docker/docker-compose.yml**. Конфигурация docker-compose для мониторинга находится теперь в **docker/docker-compose-monitoring.yml**.

Были добавлены cAdvisor UI, Grafana и алертинг с помощью AlertManager, интегрированный со Slack.

Ссылки на образы в Docker Hub:

* [UI](https://hub.docker.com/repository/docker/samofimp/ui)
* [Comment](https://hub.docker.com/repository/docker/samofimp/comment)
* [Post](https://hub.docker.com/repository/docker/samofimp/post)
* [Prometheus](https://hub.docker.com/repository/docker/samofimp/prometheus)
* [AlertManager](https://hub.docker.com/repository/docker/samofimp/alertmanager)

## Дополнительное задание
* Добавлен Makefile для сборки и публикации образов. Запуск с помощью команды *make* из корня репозитория.

# Домашнее задание №25
## Основное задание
Добавлена конфигурация docker-compose для логирования Docker-контейнеров (**docker/docker-compose-logging.yml**) с помощью ElasticSearch (TSDB и поисковый движок для хранения данных), Fluentd (аггрегация) и Kibana (визуализация).
Произведён сбор структурированных логов, а также неструктурированных (для их приведения были использованы Grok-шаблоны).

## Дополнительное задание
* 8.3* Добавлен дополнительный Grok-шаблон парсинга логов UI-сервиса.

# Домашнее задание №27
## Основное задание
* Установка Kubernetes на инстансах Yandex Cloud по [данной инструкции](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl).
* Инициализация control plane на одном из хостов:
~~~ bash
kubeadm init --apiserver-cert-extra-sans=<external-master-ip> --apiserver-advertise-address=0.0.0.0 --control-plane-endpoint=<external-master-ip> --pod-network-cidr=10.244.0.0/16
~~~
* Добавление worker-ноды с помощью токена, полученного после выполнения предыдущей команды.
* Установка сетевого планига Calico [по инструкции](https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises).
* Применение манифестов Kubernetes (из директории **kubernetes/reddit**) с помощью команды *kubectl apply -f \<filename>*.

## Дополнительное задание
Описана установка кластера с помощью Terraform и Ansible, манифесты находятся в директориях **kubernetes/terraform** и **kubernetes/ansible** соответственно.

# Домашнее задание №28
Произведено развёртывание локального окружения для работы с Kubernetes с помощью Minikube, а также полноценного Kubernetes-кластера в Yandex Cloud (скриншоты в папке **screenshots** - **kubernetes-2-1.png** и **kubernetes-2-2.png**).
1. Запуск Minikube-кластера:
~~~bash
minikube start --kubernetes-version 1.19.7
~~~
2. Применение конфигураций ресурсов Deployment, Service, Namespace (запускается из корня данного репозитория):
~~~bash
kubectl apply -f ./kubernetes/reddit/ -n dev
~~~
3. Получение внешнего IP-адреса нод кластера:
~~~bash
kubectl get nodes -o wide
~~~
Получение порта публикации сервиса ui
~~~bash
kubectl describe service ui -n dev | grep NodePort
~~~
Таким образом, открыть приложение можно по адресу http://\<node-ip\>:\<NodePort\>.

# Домашнее задание №29
## Основное задание
1. Описан Ingress Controller (**kubernetes/reddit/ui-ingress.yml**).
Установка nginx ingress:
~~~bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml
~~~
2. Добавлен Secret для подключения к приложению по TLS по самоподписанному сертификату.
~~~bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=<your ip address>"
~~~
3. Описана сетевая политика (**kubernetes/reddit/mongo-network-policy.yml**) для ограничения трафика, поступающего к MongoDB, кроме сервисов post и comment.
4. Описан ресурс дискового хранилища (**kubernetes/reddit/mongo-volume.yml**) для хранения данных БД, а также запрос на выдачу ресурса (**kubernetes/reddit/mongo-claim.yml**).

## Дополнительное задание
Объект Secret описан в виде Kubernetes-манифеста (**kubernetes/reddit/ui-ingress-secret.yml**). Ключ и сертификат зашифрованы по стандарту Base64.
~~~bash
openssl base64 -in tls.crt -out tls64.crt
openssl base64 -in tls.key -out tls64.key
~~~

# Домашнее задание №30
## Основное задание
1. Добавлен chart для развёртывания GitLab CI (**kubernetes/Charts/gitlab-omnibus**).
2. Произведён запуск CI/CD конвейера в Kubernetes.
Конфигурации GitLab CI для компонентов приложения:
* **src/ui/.gitlab-ci.yml** (Helm 2 + Tiller Chart)
* **src/post/.gitlab-ci.yml** (Helm 3)
* **src/comment/.gitlab-ci.yml** (Helm 2 + Tiller Plugin)
* **kubernetes/Charts/.gitlab-ci.yml** (reddit-deploy)

# Домашнее задание №31
## Основное задание
1. Добавлен chart Prometheus для мониторинга (**kubernetes/Charts/prometheus**).
Установка:
~~~bash
helm upgrade prometheus . -f custom_values.yml --install
~~~
2. Добавлен chart Kibana для логирования (**kubernetes/Charts/kibana**).
Установка:
~~~bash
helm upgrade kibana . -f values.yml --install
~~~
3. Добавлены Kubernetes-манифесты для ElasticSearch и Fluentd (**kubernetes/efk**).
