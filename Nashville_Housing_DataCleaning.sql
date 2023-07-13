/*
Data Cleaning in SQL FOr Nashville_Housing Dataset
*/

-- Standardize Date Format

select * from Nashville_Housing;

select saledate, cast(saledate as date)
from nashville_housing;

update nashville_housing
set saledate = cast(saledate as date);

alter table nashville_housing
add saledateconverted date;

update nashville_housing
set saledateconverted = cast(saledate as date);

-- Populate Property Address Data
select * from nashville_housing;

select * 
from nashville_housing
order by parcelid;

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from nashville_housing a
join nashville_housing b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null;

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from nashville_housing a
join nashville_housing b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null;

-- Breaking out address into indvidual columns (address, city, state)
select propertyaddress
from nashville_housing; 

SELECT 
    SUBSTRING(propertyaddress, 1, position(',' in propertyaddress) -1 ) AS address,
	substring(propertyaddress,  position(',' in propertyaddress) +1, length(propertyaddress)) as address
FROM 
    nashville_housing;

alter table nashville_housing
add propertysplit_address varchar(255); 

update nashville_housing
set propertysplit_address = SUBSTRING(propertyaddress, 1, position(',' in propertyaddress) -1 );

alter table nashville_housing
add propertysplit_city varchar(255);

update nashville_housing
set propertysplit_city = substring(propertyaddress,  position(',' in propertyaddress) +1, length(propertyaddress));

select * from nashville_housing;

select owneraddress
from nashville_housing;

select SPLIT_PART(owneraddress, ',', 1),
	SPLIT_PART(owneraddress, ',', 2),
	SPLIT_PART(owneraddress, ',', 3)
from nashville_housing;

alter table nashville_housing
add ownersplitaddress varchar(255); 

update nashville_housing
set ownersplitaddress = SPLIT_PART(owneraddress, ',', 1);

alter table nashville_housing
add  ownersplitcity varchar(255);

update nashville_housing
set ownersplitcity = SPLIT_PART(owneraddress, ',', 2);

alter table nashville_housing
add ownersplitstate varchar(255);

update nashville_housing
set ownersplitstate = SPLIT_PART(owneraddress, ',', 3);

select * from nashville_housing;

--- Change Y and N to Yes and No in 'Sold as Vacant' field
select distinct soldasvacant, count(soldasvacant)
from nashville_housing
group by soldasvacant
order by 2;

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end
from nashville_housing;

update nashville_housing
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end

-- Removing Duplicates
-- Inside the CTE
with dupicated_rows as (
select *,
row_number() over (partition by Parcelid, propertyaddress, saleprice, saledate, legalreference
				   order by uniqueID) row_num
from nashville_housing
)
-- delete 
select *
from dupicated_rows
where row_num > 1
order by propertyaddress;

--- Delete Unused Columns
select * from nashville_housing;

alter table nashville_housing
drop column owneraddress;

alter table nashville_housing
drop column taxdistrict;

alter table nashville_housing
drop column propertyaddress;

alter table nashville_housing
drop column saledate;





