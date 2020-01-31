
docker build -f ./docker/Dockerfile --target base -t jgkawell/ompl:base ./docker
docker build -f ./docker/Dockerfile --target nvidia -t jgkawell/ompl:base-nvidia ./docker
