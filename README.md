# lb-api
Node restful api

## Clone
```
mkdir dock_cmp

cd dock_cmp/

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
