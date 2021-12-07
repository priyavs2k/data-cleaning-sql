create database project
use project
--Data cleaning
select * from nashhousing 

--standardize date format

select saledate from nashhousing

select saledate, CONVERT(date,saledate)
from nashhousing

alter table nashhousing
add saledateconverted date;

update nashhousing
set saledateconverted =convert(date,saledate)

select saledateconverted, CONVERT(date,saledate)
from nashhousing

--populate property address data

select PropertyAddress
from nashhousing 

select *
from nashhousing where PropertyAddress is null

select ParcelID, count(parcelid)
from nashhousing 
group by ParcelID

select a.ParcelID ,a.propertyaddress ,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from nashhousing a
join nashhousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from nashhousing a
join nashhousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual columns(address,city,state)

 select propertyaddress from nashhousing

 select 
 SUBSTRING(propertyaddress,1, charindex(',',propertyaddress))as address
 from nashhousing

 select 
 SUBSTRING(propertyaddress,1, charindex(',',propertyaddress)-1)as address,
 SUBSTRING(propertyaddress, CHARINDEX(',',PropertyAddress) +1 ,len(propertyaddress))as address
 from nashhousing

 alter table nashhousing
add PropertysplitAddress nvarchar(250);
 

update nashhousing
set PropertysplitAddress = SUBSTRING(propertyaddress,1, charindex(',',propertyaddress)-1)

alter table nashhousing
add Propertysplitcity nvarchar(250);

update nashhousing
set Propertysplitcity =  SUBSTRING(propertyaddress, CHARINDEX(',',PropertyAddress) +1 ,len(propertyaddress))
 
select * from nashhousing
select
PARSENAME(replace(owneraddress, ',','.') ,3),
PARSENAME(replace(owneraddress, ',','.') ,2),
PARSENAME(replace(owneraddress, ',','.') ,1)
from nashhousing

alter table nashhousing
add ownersplitaddress nvarchar(250);

update nashhousing
set ownersplitaddress = PARSENAME(replace(owneraddress, ',','.') ,3)

alter table nashhousing
add ownersplitcity nvarchar(250);

update nashhousing
set ownersplitcity = PARSENAME(replace(owneraddress, ',','.') ,2)

alter table nashhousing
add ownersplitstate nvarchar(250);

update nashhousing
set  ownersplitstate = PARSENAME(replace(owneraddress, ',','.') ,1)
select * from nashhousing

--changing 'y' and 'n' to 'yes' and 'no' in soldasvacant

select distinct(soldasvacant), count(soldasvacant)
from nashhousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'y' then 'yes'
      when SoldAsVacant = 'n' then 'no'
	  else SoldAsVacant
	  end
from nashhousing

update nashhousing
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
      when SoldAsVacant = 'n' then 'no'
	  else SoldAsVacant
	  end

-- DELETE UNUSED COLUMNS

select * from nashhousing

alter table nashhousing
drop column owneraddress,taxdistrict,propertyaddress