# Postgres
* version 11
* JWT
* Docker
* Docker-compose


# P
* connect as api_guest
* Signin as api_guest with guest token
* User delete as api_guest with scope of api_user
* User select as api_guest with scope of api_user
* User insert as api_guest with scope of api_user
* User update as api_guest with scope of api_user
*

# Layers
* API Functions
* General Dependent Functions
* Third Party Dependent Function
* Indpendent Functions


# Layers        access
* JWT Generator app-token
                guest      
* Application   app-token, user-token
* API           api-token,        
* Database

# Artifacts
* app-token.payload {aud:"\<app-abbr>",iss:"\<issuer-name>",sub:"\<string>",user:"\<guid>",scope:["\<value>",...]}
* scope is ["\<app-value>", "\<user-type>"]
* app-body is {app:"\<token>", chelate:{pk:"\<key>", sk:"\<key>", tk:"\<key>",form:{...}}}

-- Person: USER
-- Place: PLACE
-- Thing: THING


-- Thing: USER
-- Thing: STORMDRAIN
-- State: ADOPTEE
## Example Data

USER is {guid:"<string>", name:"<email>", displayname:"<string>", password:{hash:"<string>", salt:"<string>"}}
STORMDRAIN is {guid:"<string>", id:"<local-id>", lat:<numeric>, lon:<numeric>}
ADOPTEE is {user:"<guid>", name:"<drain-name>", lat:<numeric>, lon:<numeric>}

USER is {guid:"<string>", name:"<email>", displayname:"<string>", password:{hash:"<string>", salt:"<string>"}}
USER is {guid:"<string>", name:"<email>"}

storage (breakdown by individual data value)
{pk:"USER#<email>", sk:"USER", tk:"<guid>" value:{name:"<email>"}  -- for signin
{pk:"USER#<email>", sk:"DN#1", tk:"DISPLAYNAME" value:{displayname:"<string>"}     --
{pk:"USER#<email>", sk:"NAME#2", tk:"NAME" value:{name:"<email>"}     --
{pk:"USER#<email>", sk:"PASSWORD#3", tk:"PASSWORD" value:{hash:"<string>", salt:"<string>"}     --
# Sample
## Application Client Output / API Input
Use HTTPS for transfer of password to server.
```
{
  "username": "selectchange@user.com",
  "displayname": "J",
  "password": "a1A!aaaa"
}
```

### API Process
```
```

## API Server Output
```
{
  "pk": "guid#420a5bd9-e669-41d4-b917-81212bc184a3",
  "sk": "const#USER",
  "tk": "username#selectchange@user.com",
  "form": {
    "username": "selectchange@user.com",
    "displayname": "J",
    "password": {
      "hash":"048a1d2b6056d6589f8f63f48cf77165f5cff56e56663d1a9195ded9e230ee355b1abb8c22b3fb9ec409f02bc8a725f148988efaa233b30e1333aa1a28198703",
      "salt":"707bb65c19e52f452b17b51eb5d0b943"
    }
  },
  "active": true,
  "created": "2021-01-23T14:29:34.998Z"
}
```    
## Database Server Table
```
create table if not exists
    one_base.one  (
        pk TEXT DEFAULT uuid_generate_v4 (),
        sk varchar(256) not null check (length(sk) < 256),
        tk varchar(256) not null check (length(sk) < 256),
        form jsonb not null,
        active BOOLEAN NOT NULL DEFAULT true,
        created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
        updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
    );
```

# Definition
```
{
  pk:"guid#<string>" ,
  sk:"const#<capital-letters>",
  tk:"username#<email>",  
  form: {
    username: "<email>",
    displayname: "<string>",
    password: {
      hash:"<string>",
      salt:"<string>"
    }  
  },
  created:<date-time>,
  updated:<date-time>
}
```
# The Breakdown

## Key Map
```
PrimaryKey = pk + sk
SecondaryKey = sk + tk
```
{pk:"USER#<guid>", sk:"const#USER", tk:"USER#<email>" , guid:"<string>", password:{hash:"<string>", salt:"<string>"}}

## Routes
```
POST /user
POST /signin

```

## Database Functions
```
user({pk,sk,tk, form:{username, displayname, password}})
signin({sk,tk})
```
USER is
{
  pk:"USER#<email>",
  sk:"",
  tk:"",
  {
    guid:"<string>",
    name:"<email>",
    displayname:"<string>",
    password:{hash:"<string>", salt:"<string>"}
  }
}

# Hapi Example Calls
## New User
```
{
  method: 'post',
  url: '/user',
  headers: {
    authorization: app-token
  },
  payload: {
    username: username,
    displayname: 'J',
    password: 'a1A!aaaa'
  }
}
```
## Update User
```

```
## SignIn
```

```
## Insert Cases
```
-- Use CASES
-- * is whatever
-- (JSON)
-- {pk:a#v1, sk:b#v2, tk:c#v3, form:{a:v1, b:v2, c:v3, d:v4}} -- insert only {pk,sk,tk} {form
-- {pk:a#v1, sk:b#v2,          form:{a:v1, b:v2,       d:v4}} -- insert only {pk,sk,*} {form}
-- {         sk:b#v2, tk:c#v3, form:{*:* , b:v2, c:v3, d:v4}} -- insert      {*,sk,tk} {form}

Updates
   (pk,     sk,      form) {a,   b,   c,    d }
   (TEXT,   TEXT,    JSON, JSON)
-- pk:a#v1, sk:b#v2, form: {a:v1,             d:v4} -- no change
-- pk:a#v1, sk:b#v2, form: {      b:v2,       d:v4} -- no change
-- pk:a#v1, sk:b#v2  form: {            c:v3, d:v4} -- no change
-- pk:a#v1, sk:b#v2, form: {a:v1, b:v2,       d:v4} -- no change
-- pk:a#v1, sk:b#v2, form: {      b:v2, c:v3, d:v4} -- no change
-- pk:a#v1, sk:b#v2, form: {a:v1,       c:v3, d:v4} -- no change
-- pk:a#v1, sk:b#v2, form: {a:v1, b:v2, c:v3, d:v4} -- no change

-- pk:a#v1, sk:b#v2, form: {a:v1,             d:v5} -- non-key change
-- pk:a#v1, sk:b#v2, form: {      b:v2,       d:v5} -- non-key
-- pk:a#v1, sk:b#v2  form: {            c:v3, d:v5} -- non-key
-- pk:a#v1, sk:b#v2, form: {a:v1, b:v2,       d:v5} -- non-key
-- pk:a#v1, sk:b#v2, form: {      b:v2, c:v3, d:v5} -- non-key change
-- pk:a#v1, sk:b#v2, form: {a:v1,       c:v3, d:v5} -- non-key change
-- pk:a#v1, sk:b#v2, form: {a:v1, b:v2, c:v3, d:v5} -- non-key change

-- Key Change Cases
-- pk:a#v1, sk:b#v2, form: {a:n1,             d:v4} -- 1 key change
-- pk:a#v1, sk:b#v2, form: {      b:n2,       d:v4} -- 1 key change
-- pk:a#v1, sk:b#v2, form: {            c:n3, d:v4} -- 1 key change
-- pk:a#v1, sk:b#v2, form: {a:n1, b:n2,       d:v4} -- 2 key change
-- pk:a#v1, sk:b#v2, form: {      b:n2, c:n3, d:v4} -- 2 key change
-- pk:a#v1, sk:b#v2, form: {a:n1, b:n2, c:n3, d:v4} -- 3 key change

-- pk:a#v1, sk:b#v2, form: {a:n1,             d:v5} -- 1 key change & non-key change
-- pk:a#v1, sk:b#v2, form: {      b:n2,       d:v5} -- 1 key change & non-key change
-- pk:a#v1, sk:b#v2, form: {            c:n3, d:v5} -- 1 key change & non-key change
-- pk:a#v1, sk:b#v2, form: {a:n1, b:n2,       d:v5} -- 2 key change & non-key change
-- pk:a#v1, sk:b#v2, form: {      b:n2, c:n3, d:v5} -- 2 key change & non-key change
-- pk:a#v1, sk:b#v2, form: {a:n1, b:n2, c:n3, d:v5} -- 3 key change & non-key change
if

```
