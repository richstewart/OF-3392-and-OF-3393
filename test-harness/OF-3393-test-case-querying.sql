/*
this is the query from the cur_sites cursor for the lwx_ar_invo_stmt_print.get_site_info procedure:
*/
    SELECT loc.ADDRESS1,
           loc.ADDRESS2,
           loc.ADDRESS3,
           loc.ADDRESS4,
           loc.CITY,
           substr(loc.STATE,1,2),
           substr(loc.POSTAL_CODE,1,12),
--            terr.TERRITORY_SHORT_NAME,
           --
           nvl(loc_assign.location_id,0) good_geocode
	   --
	   , addr.cust_account_id
	   , party_site.party_id
	   , hca.account_number customer_number
      FROM
--       AR_LOOKUPS         l_cat,
--           FND_TERRITORIES_VL terr,
--            FND_LANGUAGES_VL   lang,
           HZ_CUST_ACCT_SITES addr,
           HZ_PARTY_SITES     party_site,
           HZ_CUST_SITE_USES  csu,
           HZ_LOCATIONS       loc,
           HZ_LOC_ASSIGNMENTS loc_assign
	   --
	   , hz_cust_accounts hca
	   , lwx_ar_stmt_headers arsh
     WHERE
--          addr.CUSTOMER_CATEGORY_CODE = l_cat.LOOKUP_CODE(+)
           1=1
--        AND l_cat.LOOKUP_TYPE(+) = 'ADDRESS_CATEGORY'
--
--        AND loc.COUNTRY = terr.TERRITORY_CODE(+)
--        AND loc.LANGUAGE = lang.LANGUAGE_CODE(+)
       AND addr.PARTY_SITE_ID = party_site.PARTY_SITE_ID
       AND csu.CUST_ACCT_SITE_ID = addr.CUST_ACCT_SITE_ID
       AND csu.SITE_USE_CODE IN ('STMTS','BILL_TO')
       AND NVL(csu.PRIMARY_FLAG, 'N') = 'Y'
       AND loc.LOCATION_ID = party_site.LOCATION_ID
       AND loc.LOCATION_ID = loc_assign.LOCATION_ID(+) -- n.b. this is an "optional join" OF-3393
       -- EXTRA TESTING PREDICATES, NOT PRESENT IN THE ORIGINAL QUERY:
       and loc_assign.location_id is null
       and hca.cust_account_id = addr.cust_account_id
       and hca.party_id = party_site.party_id
       and hca.account_number = arsh.send_to_cust_nbr
--
-- The following two predicates are bound to input variables for the original program
-- cursor:
--       AND addr.cust_account_id = cn_cust_id
--       AND party_site.PARTY_ID = cn_party_id
       ORDER BY decode(csu.site_use_code,'STMTS',1,'BILL_TO',2,3)

