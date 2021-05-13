# Privileges

* Grant privileges for the table
* Grant privileges for the schema
* Grant privileges for the function

User Function Privileges

|        |  name | api_guest | api_user | api_admin |
| ------ | ----- | --------- | -------- | --------- |
| POST   | user(TEXT,JSON)      | C |
| GET    | user(TEXT,JSON,JSON) |   | r | R |
| PUT    | user(TEXT,TEXT,JSON) |   | u |
| DELETE | user(TEXT,TEXT)      |   | d |      

* C is create
* c is owner specific create
* R is read
* r is owner specific read
* U is update
* u is owner specific update
* D is delete
* d is owner specific delete

# Definition
```
[
  "user_form": {
    username:{type:"email",required:true},
    password:{type:"8ULS",required:true}
  },
  "User(TEXT,JSON)": { name:"User(TEXT,JSON)",   
    method:"POST",
    form: user_form,   
    privileges: {api_guest:"C",api_user:"",api_admin:""}
  },
  "User(TEXT,JSON,JSON)":{ name:"User(TEXT,JSON,JSON)",
    method:"GET",
    form: user_form
    privileges: {api_guest:"", api_user:"r",api_admin:"R"}
  },
  "User(TEXT,TEXT,JSON)":{ name:"User(TEXT,TEXT,JSON)",
    method:"PUT",
    form: user_form,
    privileges: {api_guest:"C",api_user:"u",api_admin:""}
  },
  "User(TEXT,TEXT)":{ name:"User(TEXT,TEXT)",
    method:"DELETE",   
    form: user_form,
    privileges: {api_guest:"C",api_user:"d",api_admin:""}
  }
]
```
| Api    | base |
| ------ | ---- |
| signin |      |
| user i | insert |

Primary is {pk sk}
Secondary is {sk tk}
Tertiary is {tk sk} aka {xk yk}
Quaternary is {sk pk} aka {yk zk}
1 is Primary
2 is Secondary
3 is Teriary
4 is Quaternary

__Privileges__
n is no permission
y is permission
O is owner specific permission
c is create non-specific
C is create owner-specific
r is read non-specific
R is read owner-specific
u is update non-specific
U is update owner-specific
d is delete non-specific
D is delete owner-specific



## Privileges

|  User  | | | | | | |
| -- | -- | -- | -- | -- | -- | -- |
|    | POST | GET | PUT | DELETE | | Privileges |
| guest   | __C__ | n | n | n |  | C |
| user    | n | __R__ | __U__ | __D__ |  | RUD |
| admin   | n | __r__ | n | n |  | r |


|  Adoptee  | | | | | | |
| -- | -- | -- | -- | -- | -- | -- |
|    | POST | GET | PUT | DELETE | | Privileges |
| guest | n | __r__ | n | n |  | r |
| user  | __C__ | __r__ | __U__ | __D__ | | CrUD |
| admin | n | __r__ | n | n |  | r |


## Token
All tokens have the same claim keys.
A is api_admin
G is api_guest
U is api_user
K is user's key not 0 and not NULL and not ''
k is user's key=0
N is name
E is email

|  User  | | | | | |
| -- | -- | -- | -- | -- | -- |
|    | user | scope | key | | token |
| guest | N | G  | k | | NGk |
| user  | E | U  | K | | EUK |
| admin | E | A  | K | | EAK |
