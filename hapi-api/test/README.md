This is an example in Node.js which use ES6 syntax (import, export ...) in both src and test. And use Jest as test runner and coverage

- ES6 support: babel
- Test: Jest
- Coverage: Jest

### Run

``` npm run-script run ```

### Test

``` npm test ```


# Babel

```
  npm install --save-dev @babel/core @babel/cli @babel/preset-env @babel/node
```

## Create and configure .babelrc
Create if you don't have a .babelrc file
Update if you do.
```
  echo '{"presets": ["@babel/preset-env"]}' > .babelrc
```

## package.json

```
  ...,
  "scripts": {
    "run": "babel-node index.js",
    "build": "babel . -d ./dist --ignore=\"node_modules\""
  },
  ...,
```

# Jest
```
  npm install --save-dev jest
```

## package.json

```    
    ...,
    "scripts": {
      ...,
      "test": "jest --coverage",
      ...,
    },
    ...,
    "jest": {
      "verbose": true,
      "coverageReporters": [
        "html"
      ],
      "transform": {
        "^.+\\.[t|j]sx?$": "babel-jest"
      }
    },
    ...,
    "type": "module",
```

# Dotenv

```
  npm i dotenv
```

# Nodemon

```
  npm install --save-dev nodemon

```
## package.json

```
...,
"scripts": {
  ...,
  "dev": "nodemon --trace-warnings --exec babel-node index.js",
  ...,
},
...,
```
