# lb-api
Node restful api


```
export MY_BRANCH=<branch-name>

```

## Clone
```
mkdir ${MY_BRANCH}

cd ${MY_BRANCH}/

# clone
git clone https://github.com/Wilfongjt/lb-api.git

# Checkout branch
cd lb_api/

git checkout -b ${MY_BRANCH}

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
git checkout ${MY_BRANCH}
git add .
git commit -m "fix.${MY_BRANCH}"
git checkout
git pull origin main  
git checkout ${MY_BRANCH}
git branch
git rebase ${MY_BRANCH}
git push origin "${MY_BRANCH}"
open -a safari "https://github.com/Wilfongjt/lb-api"
```
