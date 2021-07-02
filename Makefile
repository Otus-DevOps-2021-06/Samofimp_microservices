ifndef USER_NAME
$(error USER_NAME is not set)
endif

docker_worker: builder pusher

builder:
	cd src/ui; bash docker_build.sh
	cd src/post-py; bash docker_build.sh
	cd src/comment; bash docker_build.sh
	cd monitoring/alertmanager; docker build -t $(USER_NAME)/alertmanager .
	cd monitoring/prometheus; docker build -t $(USER_NAME)/prometheus .

pusher:
	docker login
	docker push $(USER_NAME)/ui
	docker push $(USER_NAME)/comment
	docker push $(USER_NAME)/post
	docker push $(USER_NAME)/prometheus
	docker push $(USER_NAME)/alertmanager
