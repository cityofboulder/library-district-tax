/*
When it comes to joining tax information about parcels, here are the considerations
that need to be made:

    1. One strap account can only be associated with one parcel number
	2. One strap account can only have one assessed value
	3. One parcel number can have multiple strap accounts
	4. One parcel can have multiple assessed values (residential, mineral, etc)
	5. One parcel can have only one mill levy, regardless of # of assessed values
	6. Confidential owners cannot have tax estimates performed.

Joining accounts to values is 1:1 and easy. There are fewer values than there are
accounts, so an inner join will suffice here because we can't estimate revenue
using null assessed values.

Joining accounts to owners is trickier. We have to join accounts to owners using
both STRAP and PARCELNUM fields so that every assessed value is retained for a
parcel. This works great for when there are multiple assessed values for a parcel
that all have different values; HOWEVER, in cases where a parcel has split
ownership, the assessed value is shared by the split, and so one assessed value
would show up as many times as there are owners. Thus, for every parcel number, 
we need to retain all assessed values that are different and shuck duplicate
values. Lastly, because some owners prefer confidentiality, the owners and account
tables should be inner joined, because revenue cannot be estimated with null
mill levies.

Since we are concerned with total revenue for this analysis, it follows that we
need to count every assessed value for a parcel. Geographically, this means that
joining a parcel to the assessor's data may make the parcel show up more than once.
This is fine as long as, for each duplicated parcel, the assessed values and
account numbers are different.
*/

INSERT INTO CLEAN.TAXES (PARCELNUM, ACCTTYPE, TAXYR, ACTUALVAL, ASSESSVAL, MILLLEVY)
SELECT DISTINCT ON (A.PARCELNUM, V.ASSESSVAL)
	A.PARCELNUM,
	O.ACCTTYPE,
	V.TAXYR,
	V.ACTUALVAL,
	V.ASSESSVAL,
	O.MILLLEVY
FROM PROC.ACCOUNTS A
JOIN PROC.VALUES V
ON A.STRAP = V.STRAP
JOIN PROC.OWNERS O
ON A.STRAP = O.STRAP AND A.PARCELNUM = O.PARCELNUM
ORDER BY PARCELNUM, ASSESSVAL;