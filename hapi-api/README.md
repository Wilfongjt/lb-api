This is an example in Node.js which use ES6 syntax (import, export ...) in both src and test. And use Jest as test runner and coverage

- Babel: ES6 support
- Jest: Testing
- Dotenv: Environment variables
- Nodemon: Reload autmatically
- JWT: JSON Web Tokens
- environment variables


### Dev

``` npm run dev```

### Test

``` npm test ```
# Hapi

```
npm i @hapi/hapi
```

# Babel

```
  npm install --save-dev @babel/core @babel/cli @babel/preset-env @babel/node

  npm install @babel/plugin-transform-runtime
  npm install --save @babel/runtime
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

```

# Dotenv

```
  npm i dotenv
```
## Example

```
import dotenv from 'dotenv';

if (process.env.NODE_ENV !== 'production') {
  process.env.DEPLOY_ENV=''

  const path = require('path');
  dotenv.config({ path: path.resolve(__dirname, '../../.env') });
}
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
  "dev": "nodemon --trace-warnings --exec babel-node server.js",

  ...,
},
...,
```
# JWT
```
npm install @hapi/jwt
```

# Environment variables (.env)
```
# Use for Hapi (API)
LB_API_PORT=5555
LB_API_HOST=0.0.0.0
LB_JWT_SECRET=PASSWORDmustBEATLEAST32CHARSLONGLONG
```
* LB_API_HOST only works when set to 0.0.0.0

# JSON Query
```
npm install json-query
```
