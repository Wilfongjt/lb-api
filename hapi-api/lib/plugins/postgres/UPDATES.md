pg_one_plugin
  |
  + pg_one_plugin.pg_query
    - client.query (postgres)
      - one_version_0_0_1.query()
  + pg_one_plugin.pg_delete
    - client.query (postgres)
  + pg_one_plugin.pg_insert
    - client.query (postgres)
  + pg_one_plugin.pg_update
    - client.query (postgres)
## Query
Hapi                      database                    schema
plugin                    postgres client               one_version_0_0_1
  |                                                   
  .pg_query(criteria) ---> .query(select_criteria) ---> .query(criteria)
                                                           |
  + <-------------- {status:"", msg:"", selection:[]} <--- +

## Delete
  .pg_delete(criteria) ---> .query(del_criteria) ---> .delete(criteria)
                                                           |
  + <-------------- {status:"", msg:"", deletion:[]} <--- +
