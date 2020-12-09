# lb-api
Node restful api

## .env
.env goes in the lb_api/ folder
```
MY_GIT_OWNERNAME=Wilfongjt
MY_GIT_PROJECT=lb-api
MY_BRANCH=dock_cmp
COMMIT_MSG="Fix.Docker.Compose"
MY_TRUNK=main
```

## Clone
```
# clone
git clone https://github.com/Wilfongjt/lb-api.git

# Checkout branch
cd lb_api/

git checkout -b dock_cmp

```


## Docker
```
docker-compose down

docker-compose build

docker-compose up
```

## Rebase
```
cd lb-api/
git checkout dock_cmp
git add .
git commit -m "fix.docker"
git checkout
git pull origin main  
git checkout dock_cmp
git branch
git rebase dock_cmp
git push origin "dock_cmp"
open -a safari "https://github.com/Wilfongjt/lb-api"
```
