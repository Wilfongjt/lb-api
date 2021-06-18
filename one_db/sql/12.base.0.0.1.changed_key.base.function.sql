\c one_db

SET search_path TO base_0_0_1, base_0_0_1, public;

--=======================================
-- Changed_key
--=======================================

CREATE OR REPLACE FUNCTION base_0_0_1.changed_key(chelate JSONB) RETURNS BOOLEAN
AS $$
	declare _rec record;
	declare _form JSONB;
	declare _value TEXT;
	declare _fld TEXT;
BEGIN
  -- [Function: Changed_Key]
  -- [Description: determines if one of the keys has been changed ]
  -- [Updates are done on primary key]
	-- Change when "tk" key not found

  _form := chelate ->> 'form';
  --   if not(chelate ? 'tk') or not(chelate ? 'pk') then

  if not(chelate ? 'pk') or not(chelate ? 'sk') then
    -- [Assume changed When chelate is missing pk and sk]
    -- unable to detect change to tk when not in chelate
    -- assume changed
    -- let the .update(chelate) function fix it
    return true;
  end if;
  -- evaluate form key
  -- [Detect change by comparing Chelate.Key.Value to Chelate.form keys and values]
  -- [Form to Key Transform is {name:A} to {k:name#A}]
	-- [Key to Form Tranform is {k:name#A to name:A}]
	-- No change is {pk:name#A,     form:{name:A}}
  --                       |                 |
  --                       +--- no change ---+
  -- Change is {{pk:name#A} form:{name:B}}
  --                     |             |
  --                     +--- change --+

	FOR _rec IN Select * from jsonb_each_text(_form)
  LOOP
    -- [usernname:a@b.com ---> usernname#a@b.com]
    _value := format('%s#%s',_rec.key, _rec.value) ; --> usernname#a@b.com
    _fld := format('%s#',_rec.key); --> usernname#
    --
    if strpos(chelate ->> 'pk', _fld) = 1 then -- starts with usernname#
  		if chelate ->> 'pk' != _value then -- no match then changed
  			return true;
  	  end if;
  	elsif strpos(chelate ->> 'sk', _fld) = 1 then
  		if chelate ->> 'sk' != _value then
  			return true;
  	  end if;
  	--elsif strpos(chelate ->> 'tk', _fld) = 1 then
  	--	if chelate ->> 'tk' != _value then
  	--		return true;
    --  end if;
    end if;
  END LOOP;
  -- [Return Boolean]
  return false;
END;
$$ LANGUAGE plpgsql;

grant EXECUTE on FUNCTION base_0_0_1.changed_key(JSONB) to api_user;
