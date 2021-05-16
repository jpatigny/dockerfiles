$version=$(select-string -Path Dockerfile -Pattern "ENV POWERCLI_VERSION").ToString().split()[-1]
docker tag powercli jpatigny/powercli:$version
docker push jpatigny/powercli:$version
docker tag powercli jpatigny/powercli:latest
docker push jpatigny/powercli:latest