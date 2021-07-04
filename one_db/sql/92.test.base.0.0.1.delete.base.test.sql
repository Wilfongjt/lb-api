
\c one_db;

SET search_path TO base_0_0_1, public;
/*
Delete
     _      _      _
    | |    | |    | |
  __| | ___| | ___| |_ ___
 / _` |/ _ \ |/ _ \ __/ _ \
| (_| |  __/ |  __/ ||  __/
 \__,_|\___|_|\___|\__\___|

*/
-- DELETE
BEGIN;
  SELECT plan(3);
  \set notfoundUserName '''notfound@user.com'''
  \set username '''base_0_0_1_delete@user.com'''
  \set displayname '''J'''
  \set type_ '''const#USER'''
  \set key1 '''base_0_0_1_9876543210'''
  \set pkName '''username'''
  \set pk format('''%s#%s''',:pkName, :username)
  \set form format('''{"%s":"%s", "displayname":"%s", "password":"a1!Aaaaa"}''', :pkName, :username, :displayname)::JSONB
  \set criteriaOK format('''{"pk":"%s#%s", "sk":"%s"}''', :pkName, :username, :type_ )::JSONB
  \set criteriaNF format('''{"pk":"%s#%s", "sk":"%s"}''', :pkName, :notfoundUserName, :type_ )::JSONB

\set form format('''{"%s":"%s", "displayname":"%s", "password":"a1!Aaaaa"}''', :pkName, :username, :displayname)::JSONB

insert into base_0_0_1.one
    (pk,sk,tk,form,owner)
    values
    ('username#base_0_0_1_delete@user.com', 'const#USER', 'base_0_0_1_9876543210', '{"username":"","displayname":"","password":""}'::JSONB, 'base_0_0_1_9876543210') ;

  --insert into base_0_0_1.one
  --  (pk,sk,tk,form,owner)
  --  values
  --  (format('%s#%s',:pkName, :username), :type_, :key1, :form,  :key1 ) ; --returning * into iRec;

  SELECT has_function(
      'base_0_0_1',
      'delete',
      ARRAY[ 'JSONB', 'TEXT' ],
      'Function Delete (jsonb,text) exists'
  );

  -- 2
  SELECT is (
    base_0_0_1.delete( :criteriaNF, :key1 )::JSONB,
    '{"msg": "Not Found", "owner": "base_0_0_1_9876543210", "status": "404", "criteria": {"pk": "username#notfound@user.com", "sk": "const#USER"}}'::JSONB,
    'delete pk sk form,  Not Found 0_0_1'::TEXT
  );

  -- 3
  SELECT is (
    (base_0_0_1.delete(
      format('{"pk":"%s#%s", "sk":"%s"}', :pkName::TEXT, :username::TEXT, :type_::TEXT)::JSONB,
      :key1
    )::JSONB - '{"deletion","criteria"}'::TEXT[]),
    '{"msg":"OK","status":"200"}'::JSONB,
    'delete pk sk form,  OK 0_0_1'::TEXT
  );

  SELECT * FROM finish();


ROLLBACK;

/*
Do
$BODY$
  Declare iRec record;
  Declare notfoundUserName TEXT := '''notfound@user.com''';
  Declare username TEXT := '''base_0_0_1_delete@user.com''';
  Declare displayname TEXT := '''J''';
  Declare type TEXT := '''const#USER''';
  Declare key1 TEXT := '''guid#720a5bd9-e669-41d4-b917-81212bc184a3''';
  Declare pkName TEXT := '''username''';
  Declare pk JSONB := format('''%s#%s''',pkName, username) JSONB;
  Declare form  JSONB :=  format('''{"%s":"%s", "displayname":"%s", "password":"a1!Aaaaa"}''', pkName, username, displayname)::JSONB;
  Declare criteriaOK JSONB := format('''{"pk":"%s#%s", "sk":"%s"}''', pkName, username, type )::JSONB;
  Declare criteriaNF JSONB := format('''{"pk":"%s#%s", "sk":"%s"}''', pkName, notfoundUserName, type )::JSONB;

--BEGIN;
BEGIN
  select notfoundUserName;
  */
/*
  \set notfoundUserName '''notfound@user.com'''
  \set username '''base_0_0_1_delete@user.com'''
  \set displayname '''J'''
  \set type '''const#USER'''
  \set key1 '''guid#720a5bd9-e669-41d4-b917-81212bc184a3'''
  \set pkName '''username'''
  \set pk format('''%s#%s''',:pkName, :username)
  \set form format('''{"%s":"%s", "displayname":"%s", "password":"a1!Aaaaa"}''', :pkName, :username, :displayname)::JSONB
  \set criteriaOK format('''{"pk":"%s#%s", "sk":"%s"}''', :pkName, :username, :type )::JSONB
  \set criteriaNF format('''{"pk":"%s#%s", "sk":"%s"}''', :pkName, :notfoundUserName, :type )::JSONB
*/

  --SELECT criteriaOK ;
  --SELECT criteriaNF ;
/*
  insert into base_0_0_1.one
    (pk,sk,form,owner) values
    (username, type, form,  key1 ) returning * into iRec;
  raise notice 'insert %', iRec;
  --insert into base_0_0_1.one
  --  (pk,sk,form,owner) values
  --  ('username#delete1@user.com',
  --    'const#USER', '
  --    {"username":"delete1@user.com", "sk":"const#USER", "tk":"guid#B720a5bd9-e669-41d4-b917-81212bc184a3"}'::JSONB,
  --    'guid#B720a5bd9-e669-41d4-b917-81212bc184a3' );

  SELECT plan(5);

  -- {pk:"username#base_0_0_1_delete@user.com",sk:"const#USER"}
  -- {pk:"usename#nonexisting@user.com",sk:"const#USER"}
  -- Delete returns the deleted item
  -- Delete only acceptes Primary Key combination i.e., pk and sk
  -- 1
  SELECT has_function(
      'base_0_0_1',
      'delete',
      ARRAY[ 'JSONB', 'TEXT' ],
      'Function Delete (jsonb,text) exists'
  );

  -- 2
  --SELECT format('{"pk":"username#noname@user.com", "sk":"%s"}', :type::TEXT)::JSONB;

  SELECT is (
    base_0_0_1.delete( criteriaNF, key1 )::JSONB,
    '{"msg": "Not Found", "owner": "guid#720a5bd9-e669-41d4-b917-81212bc184a3", "status": "404", "criteria": {"pk": "username#notfound@user.com", "sk": "const#USER"}}'::JSONB,
    'delete pk sk form,  Not Found 0_0_1'::TEXT
  );
  -- 3
  SELECT is (
    base_0_0_1.delete(
      format('{"pk":"%s#%s", "sk":"%s"}', pkName::TEXT, username::TEXT, type::TEXT)::JSONB,
      key1
    ),
    '{"msg":"OK","status":"200"}'::JSONB,
    'delete pk sk form,  OK 0_0_1'::TEXT
  );


  SELECT * FROM finish();

ROLLBACK;
-- END;
$BODY$;
*/
