pk:f1#A,
sk:f2#B,
tk:f3#C,
form: {
  f1:A,
  f2:B,
  f3:C
}

pksk f1#A,f2#B
sktk
tksk


pksk: [guest,user,admin]
sktk: [user,admin]
tksk: [user,admin]

guest pksk
user  pksk, sktk, tksk
admin pksk, sktk, tksk

if guest
  pksk
elif user
  pksk
  sktk
  tksk
elif admin
  pksk
  sktk
  tksk

pk:f1
sk:f2,
tk:f3,

pksk:{pk:"<key>",sk:"*"}
sktk:{sk:"",tk:""}
sktk:{sk:"",tk:"*"}
tksk:{xk:"",yk:""}

guest: {pk,sk} limit to one
user: [{pk,sk},{sk,tk},{xk,yk}] all possible
user: [{pk,sk},{sk,tk},{xk,yk}] all possible

guest: ["pk-sk"] limit to one
user:  ["pk-sk","sk-tk","xk-yk"] all possible
admin: ["pk-sk","sk-tk","xk-yk"] all possible

"guest-pk-sk": {}
"user-pk-sk"
"user-sk-tk"
"user-tk-sk"
"admin-pk-sk"
"admin-sk-tk"
"admin-tk-sk"
