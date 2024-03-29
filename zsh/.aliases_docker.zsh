if command -v "docker" &> /dev/null; then
    alias dps="docker ps"
    alias dpsa="docker ps -a"
    alias di="docker images"
    alias drm="docker rm"
    alias drmi="docker rmi"
    alias ds="docker start"
    alias de="docker exec -ti"
    alias dl="docker pull"
    alias drestart="sudo systemctl restart docker"
fi
