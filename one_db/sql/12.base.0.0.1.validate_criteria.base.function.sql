\c one_db

SET search_path TO  base_0_0_1, public;


CREATE OR REPLACE FUNCTION base_0_0_1.validate_criteria(criteria JSONB) RETURNS JSONB
    AS $$
    BEGIN
      -- [Function: Validate Criteria given Criteria like {sk}, {pk,sk}, {sk,tk}, or {xk,yk}]
      -- sk
      -- pk sk
      -- sk pk
      -- xk yk

      if criteria is NULL then
        -- [Exit False when criteria is NULL]
      	return NULL;
      end if ;
      if not(criteria ? 'sk') then
        -- [Exit False when sk is missing]
        return NULL;
      elsif not(criteria ? 'pk') and not(criteria ? 'tk') then
        -- [Exit False when missing pk and tk]
        return NULL;
      end if;
      -- [Return Boolean]
      return criteria;
    END;
  $$ LANGUAGE plpgsql;

  grant EXECUTE on FUNCTION base_0_0_1.validate_criteria(JSONB) to api_user;
  --  grant EXECUTE on FUNCTION base_0_0_1.validate_criteria(JSONB) to api_guest;
