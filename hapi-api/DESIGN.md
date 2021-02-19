```
                    [JWT]    [?JWT?]
                   /         /
[client] <---> [API] <---> [Database]
```
## Environment
```
  POSTGRES_DB=one_db
  POSTGRES_USER=postgres
  POSTGRES_PASSWORD=mysecretdatabasepassword
  POSTGRES_JWT_SECRET=PASSWORDmustBEATLEAST32CHARSLONGLONG
```
## Guest Token
Manual process https://jwt.io
```
  [Jwt.io]
      |
    (header("alg": "HS256","typ": "JWT")
      payload(
        aud:"<client-name>",
        iss:"",
        sub:false,
        user:"<guest-user>",
        scope:["guest"] )
      password(<POSTGRES_JWT_SECRET>))
      |
    (guest-token)
```
## Credentials

```
{
  username: "<email>",
  password: "<string>"
}
```

## Search Indices

```
primary index with search order of pk and then sk
secondary index with search order of sk and then tk
xyflip index with search order of tk and then sk
```

## Criteria

```
{
  pk:<string>,
  sk:<string>
}
or
{
  sk:<string>,
  tk:<string>
}
or
{
  xk:<string>,
  yk:<string>
}
```
* xk and yk implement a flip where tk is searched before sk is searched

## User
```
  user = {
    username:"<email>",
    displayname:"<string>",
    password:"<string>"
  }

```

## Query

```
   |
[[API]] <---------------------------------- + <--- +
   |                                        ^      ^
 (user-token,criteria)                      |      |
   |                                        |      |
[[DATABASE]]                              [[|]]  [[|]]
   |                                        |      |
[Verify(user-token)] --->(403, fail)------> +      |
   |                                        |      |
[Validate(criteria)] --->(400, fail)------> +      |
   |                                        |      |
 (pass)                                     |      |
   |                                        |      |
[Query (criteria)] --->(500, fail)--------> +      |
   |                                               |
 (success)                                         |
   |                                               |  
[return] --->(res(200, results))------------------ +

```

## Insert
```

  |
[[API]] <---------------------------------- + <--- +
  |                                         ^      ^
(user-token, chelate)                       |      |
  |                                         |      |
[[DATABASE]]                              [[|]]  [[|]]
  |                                         |      |
[Verify(user-token)] --->(403, fail)------> +      |
  |                                         ^      |
 (pass)                                     |      |
  |                                         |      |  
[Validate(chelate)] --->(400, fail)-------> +      |
  |                                         ^      |
(pass)                                      |      |
  |                                         |      |
[Check for Duplicate] --->(400,found)-----> +      |
  |                                         ^      |
 (unique)                                   |      |
  |                                         |      |
[Insert (chelate)] --->(500, fail)--------> +      |
  |                                                |
(success)                                          |
  |                                                |  
[return] --->(res(200, results))------------------ +
```

## Update
```
  |
[[API]] <--------------------------------------- + <--- +
  |                                              ^      ^
(user-token, criteria ,chelate)                  |      |
  |                                              |      |
[[DATABASE]]                                   [[|]]  [[|]]
  |                                              |      |
[Verify(user-token)] --->(403, fail)-----------> +      |
  |                                              ^      |
(pass)                                           |      |
  |                                              |      |  
[Validate(chelate)] --->(400, fail)------------> +      |
  |                                              ^      |
(pass)                                           |      |
  |                                              |      |
[Validate(criteria)] --->(400, fail)-----------> +      |
  |                                              ^      |
(pass)                                           |      |
  |                                              |      |
[Update (criteria, chelate)] --->(500, fail)---> +      |
  |                                                     |
(success)                                               |
  |                                                     |  
[return] --->(res(200, results))----------------------- +
```

## Delete
```
    |
[[API]] <----------------------------------- + <--- +
    |                                        ^      ^
(user-token,criteria)                        |      |
    |                                        |      |
[[DATABASE]]                               [[|]]  [[|]]
    |                                        |      |
[Verify(user-token)] --->(403, fail)-------> +      |
    |                                        |      |
  (pass)                                     |      |
    |                                        |      |
[Validate(criteria)] --->(400, fail)-------> +      |
    |                                        |      |
  (pass)                                     |      |
    |                                        |      |
[Delete (criteria)] --->(500, fail)--------> +      |
    |                                               |
(success)                                           |
    |                                               |  
[return] --->(res(200, results))------------------- +

```

## New User
```
[[Client]] <------------------------------ + <--- +
   |                                       ^      ^
 (guest-token, user)                       |      |
   |                                       |      |
[Request /user ]                           |      |
   |                                       |      |
 (req(head:guest-token, body:user))        |      |
   |                                       |      |
[[API]]                                  [[|]]  [[|]]
   |                                       |      |
[Verify(jwt)] --->(403, fail)------------> +      |
   |                                       ^      |
 (jwt, user)                               |      |
   |                                       |      |
[[DATABASE]]                             [[|]]  [[|]]
   |                                       |      |
[Validate Parameters] ---->(400, fail)---> +      |   
   |                                       ^      |  
 (pass)                                    |      |  
   |                                       |      |  
[Find User] --->(400, found)-------------> +      |
   |                                       ^      |
 (not found)                               |      |
   |                                       |      |
[Hash Password]                            |      |
   |                                       |      |
[Insert user] ------>(500, fail)---------> +      |
   |                                              |
 (200, OK)--------------------------------------- +
```

## Authentication / User-Token

```
 [[Client]] <------------------------------- + <--- +
    |                                        ^      ^
  (guest-token, credentials)                 |      |
    |                                        |      |
  [Request /signin                           |      |  
           guest-token,                      |      |  
           credentials]                      |      |  
 [[API]]                                   [[|]]  [[|]]
    |                                        |      |
 [Validate(guest-token)] --->(401, fail)---> +      |
    |                                        ^      |
  (pass)                                     |      |
    |                                        |      |
[[DATABASE]]                               [[|]]  [[|]]
    |                                        |      |
 [Validate(credentials)] --->(401, fail)---> +      |
    |                                        |      |
  (pass)                                     |      |
    |                                        |      |
 [Verify(credentials)] --->(???, fail)-----> +      |
    |                                               |
  (success)                                         |
    |                                               |  
 [return] --->(res(200, User-Token))--------------- +  
```  
