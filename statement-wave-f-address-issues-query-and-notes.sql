-- -*- indent-tabs-mode: nil tab-width: 4 -*-
/*
N.B. Here is Greg's explanatory text, from the email he sent on
[2020-02-19 Wed 05:28].
Good morning. the message you see below is typical of what we get with wave F.
We would have gotten the same message in DEV. To confirm that I went to DEV and
pulled out one of the sql statements you will be changing. Knowing about this
account might help you with your testing. You may need to execute the code that
is commented out first, since some of the tables are tied to apps. I need to go
over with you how to test statements.

First I ran: 
  select party_id, cust_account_id
  from ar.hz_cust_accounts
  where account_number = '2000049678'

Then I ran the commented-out code.

Then I ran the query below with HZ_LOC_ASSIGNMENTS not optional. 
Nothing was found.

Then I made HZ_LOC_ASSIGNMENTS optional and a record was found.

*/

/* 
The following is the body of an automated email the server sent
to GWright and some others which shows an example of the error messages
which are received when the geocode is missing, and which indicates that
the present situation causes the statement to be withheld/not-generated:

rom: <applprod@lifeway.com>
Date: Tue, Feb 18, 2020 at 6:56 PM
Subject: Statement Address Issues
To: <arsuppo@lifeway.com>, <greg.wright@lifeway.com>, <james.jordan@lifeway.com>, <keith.bevill@lifeway.com>, <mike.hamblin@lifeway.com>


List of Messages:
/u22/apps/oracle/PROD/inst/apps/PROD_oraebsprd/logs/appl/conc/log/l131347746.req
*** Warning: Primary Bill_To Site Address not found
*** Warning: Please fix the Primary Bill_To Site Details for customer number: 2000049678 Customer Skipped

*/

/*
I AM *NOT* 100% SURE WHAT THE CALL TO THE 
  lwx_fnd_query.set_org
IS ALL ABOUT; IT SEEMS TO BE SOME KIND OF "SET AN ENVIRONMENTAL
GLOBAL SETTING WHICH AFFECTS A WIDE CROSS-SECTION OF SUBSEQUENT
BEHAVIOR" SORT OF THING, AND I THINK THAT THE 'org' IS EBSUITE
JARGON...

I looked at the lwx_fnd_query package, and it appears to be chokablok
with precisely that sort of functionality.  deep-breath!

It doesn't appear to make a difference when actually running
the queries, however.  Maybe it makes a difference in other regards?
*/

/*
begin
lwx_fnd_query.set_org(102);
end;
*/

/* 
I squished the two queries together, rather than trying to run them
separately and trying to make out the separated party_id and cust_account_id.
*/

    SELECT loc.ADDRESS1,
           loc.ADDRESS2,
           loc.ADDRESS3,
           loc.ADDRESS4,
           loc.CITY,
           substr(loc.STATE,1,2),
           substr(loc.POSTAL_CODE,1,12),
           terr.TERRITORY_SHORT_NAME
      FROM apps.AR_LOOKUPS         l_cat,
           apps.FND_TERRITORIES_VL terr,
           apps.FND_LANGUAGES_VL   lang,
           ar.HZ_CUST_ACCT_SITES_all addr,
           ar.HZ_PARTY_SITES     party_site,
           ar.HZ_CUST_SITE_USES_all  csu,
           ar.HZ_LOCATIONS       loc,
           apps.HZ_LOC_ASSIGNMENTS loc_assign
           --
           ,
           ar.hz_cust_accounts ca
     WHERE addr.CUSTOMER_CATEGORY_CODE = l_cat.LOOKUP_CODE(+)
       AND l_cat.LOOKUP_TYPE(+) = 'ADDRESS_CATEGORY'
       AND loc.COUNTRY = terr.TERRITORY_CODE(+)
       AND loc.LANGUAGE = lang.LANGUAGE_CODE(+)
       AND addr.PARTY_SITE_ID = party_site.PARTY_SITE_ID
       AND csu.CUST_ACCT_SITE_ID = addr.CUST_ACCT_SITE_ID
       AND csu.SITE_USE_CODE IN ('STMTS','BILL_TO')
       AND NVL(csu.PRIMARY_FLAG, 'N') = 'Y'
       AND loc.LOCATION_ID = party_site.LOCATION_ID
       AND loc_assign.LOCATION_ID (+) = loc.LOCATION_ID --- Here is where I made hz_loc_assignments optional
       AND addr.cust_account_id = ca.cust_account_id -- 694237 -- cn_cust_id for account 2000049678
       AND party_site.PARTY_ID = ca.party_id -- 730058 -- cn_party_id
       and ca.account_number = '2000049678'
       ORDER BY decode(csu.site_use_code,'STMTS',1,'BILL_TO',2,3);
