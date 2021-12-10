# 构建镜像：skywalking/ui:latest
ui:
	 docker build --no-cache  --build-arg DIST=apache-skywalking-apm-bin.tar.gz --build-arg SKYWALKING_CLI_VERSION=0.7.0  -t skywalking/ui:latest  .

# 构建镜像：skywalking/oap:latest
oap：
	docker build --no-cache  --build-arg DIST=apache-skywalking-apm-bin.tar.gz --build-arg SKYWALKING_CLI_VERSION=0.7.0  -t skywalking/oap:latest  .

# docker-compose 启动:使用前两部构建的镜像 skywalking/oap:latest  skywalking/ui:latest
docker-compose:
	docker-compose up -d