


# Change Example
# Given a Chelate
```
{
  "pk":"A#a",
  "sk":"B#b",
  "tk":"C#c",
  "form":{
     "A":"a",
     "B":"b",
     "C":"c",
     "D":"d"
  },
  "active":"true",
  "created":"2021-02-21 20:44:47.442374",
  "updated":"2021-02-21 20:44:47.442374",
  "owner":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
}
```
# Key Changes
* When "pk" != "form":"username" changes then change is true

| form | pk | sk | tk | result |
| --- | -- | -- | -- | -- |
| compare | A#a | B#b | C#c | |
| A:a | F | F | F |  |
| B:b | F | F | F | |
| C:c | F | F | F | |
| D:d | F | F | F | |
|   |   |   |   | F  |


```
{
  "pk":"A#a",
  "sk":"B#b",
  "tk":"C#c",
  "form":{
     "A":"e",
     "B":"b",
     "C":"c",
     "D":"d"
  },
  "active":"true",
  "created":"2021-02-21 20:44:47.442374",
  "updated":"2021-02-21 20:44:47.442374",
  "owner":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
}
```


| form | pk | sk | tk | result |
| --- | -- | -- | -- | -- |
| compare | A#a | B#b | C#c | |
| A:e | T | F | F |  |
| B:b | F | F | F | |
| C:c | F | F | F | |
| D:d | F | F | F | |
|   |   |   |   | T  |


```
{
  "pk":"A#a",
  "sk":"B#",
  "tk":"C#c",
  "form":{
     "A":"a",
     "B":"f",
     "C":"c",
     "D":"d"
  },
  "active":"true",
  "created":"2021-02-21 20:44:47.442374",
  "updated":"2021-02-21 20:44:47.442374",
  "owner":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
}
```

| form | pk | sk | tk | result |
| --- | -- | -- | -- | -- |
| compare | A#a | B#b | C#c | |
| A:a | F | F | F |  |
| B:f | F | T | F | |
| C:c | F | F | F | |
| D:d | F | F | F | |
|   |   |   |   | T  |


```
{
  "pk":"A#a",
  "sk":"B#b",
  "tk":"C#c",
  "form":{
     "A":"a",
     "B":"b",
     "C":"g",
     "D":"d"
  },
  "active":"true",
  "created":"2021-02-21 20:44:47.442374",
  "updated":"2021-02-21 20:44:47.442374",
  "owner":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
}
```

| form | pk | sk | tk | result |
| --- | -- | -- | -- | -- |
| compare | A#a | B#b | C#c | |
| A:a | F | F | F |  |
| B:b | F | F | F | |
| C:g | F | F | T | |
| D:d | F | F | F | |
|   |   |   |   | T |

```
{
  "pk":"A#a",
  "sk":"B#b",
  "tk":"C#c",
  "form":{
     "A":"a",
     "B":"b",
     "C":"c",
     "D":"h"
  },
  "active":"true",
  "created":"2021-02-21 20:44:47.442374",
  "updated":"2021-02-21 20:44:47.442374",
  "owner":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
}
```
| form | pk | sk | tk | result |
| --- | -- | -- | -- | -- |
| compare | A#a | B#b | C#c | |
| A:a | F | F | F |  |
| B:b | F | F | F | |
| C:c | F | F | F | |
| D:h | F | F | F | |
|   |   |   |   | F |

```
{
  "pk":"A#a",
  "sk":"B#b",
  "tk":"C#c",
  "form":{
     "A":"e",
     "B":"r",
     "C":"t",
     "D":"h" 
  },
  "active":"true",
  "created":"2021-02-21 20:44:47.442374",
  "updated":"2021-02-21 20:44:47.442374",
  "owner":"guid#820a5bd9-e669-41d4-b917-81212bc184a3"
}
```

| form | pk | sk | tk | result |
| --- | -- | -- | -- | -- |
| compare | A#a | B#b | C#c | |
| A:e | T | F | F |  |
| B:f | F | T | F | |
| C:g | F | F | T | |
| D:d | F | F | F | |
|   |   |   |   | T |



# Form Changes
