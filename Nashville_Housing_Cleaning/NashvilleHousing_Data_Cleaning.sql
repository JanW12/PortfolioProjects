/*
Written in MySQL workbench
Cleaning Data in SQL Queries
*/

use portfolio

Select *
From portfolio.nashvillehousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDate, CONVERT(SaleDate, date)
From portfolio.nashvillehousing

-- Select saleDate, STR_TO_DATE(saledate, '%month/%dd/%YYYY')
-- From portfolio.nashvillehousing

Update nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE nashvillehousing
Add SaleDateConverted Date;

Update ignore nashvillehousing
SET SaleDateConverted = CONVERT(SaleDate, signed)


 --------------------------------------------------------------------------------------------------------------------------

-- Checking for missing values

SELECT COUNT(*) AS 'n (total)',
     COUNT(PropertyAddress) AS 'n (non-missing)',
     COUNT(*) - COUNT(PropertyAddress) AS 'n (missing)',
     ((COUNT(*) - COUNT(PropertyAddress)) * 100) / COUNT(*) AS '% missing'
     FROM portfolio.nashvillehousing;

-- I found out that propertyaddress does not have nulls, it has '' and the same parcelID as previous row, so I have to clean it

Select *
From portfolio.nashvillehousing
where propertyaddress = ''
-- order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IF(a.PropertyAddress='',b.PropertyAddress,null)
From portfolio.nashvillehousing a
JOIN portfolio.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID 
Where a.PropertyAddress = ''


Update portfolio.nashvillehousing a
JOIN portfolio.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IF(a.PropertyAddress='',b.PropertyAddress,null)
Where a.PropertyAddress = ''



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From portfolio.nashvillehousing
-- Where PropertyAddress is null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) + 1 , LENGTH(PropertyAddress)) as Address
From portfolio.nashvillehousing

SELECT SUBSTRING_INDEX(PropertyAddress ,',',1),  SUBSTRING_INDEX(PropertyAddress ,',',-1)
FROM  portfolio.nashvillehousing;

ALTER TABLE nashvillehousing
Add PropertySplitAddress varchar(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1 )


ALTER TABLE nashvillehousing
Add PropertySplitCity varchar(255);

Update nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) + 1 , LENGTH(PropertyAddress))




Select *
From portfolio.nashvillehousing





Select OwnerAddress
From portfolio.nashvillehousing


Select
 SUBSTRING_INDEX(OwnerAddress ,',',1),
 SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),',', -1), 
 SUBSTRING_INDEX(OwnerAddress ,',',-1)
From portfolio.nashvillehousing



ALTER TABLE nashvillehousing
Add OwnerSplitAddress varchar(255);

Update nashvillehousing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress ,',',1)


ALTER TABLE nashvillehousing
Add OwnerSplitCity varchar(255);

Update nashvillehousing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),',', -1)



ALTER TABLE nashvillehousing
Add OwnerSplitState varchar(255);

Update nashvillehousing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress ,',',-1)



Select *
From portfolio.nashvillehousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolio.nashvillehousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From portfolio.nashvillehousing


Update nashvillehousing
SET SoldAsVacant = CASE 
	   When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 propertysplitaddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From portfolio.nashvillehousing
)
-- delete
Select *
From RowNumCTE
Where row_num > 1
Order by  propertysplitaddress
 
 -- Second solution but slower
 -- delete
Select * FROM portfolio.nashvillehousing a
INNER  JOIN portfolio.nashvillehousing b
WHERE
    a.UniqueID < b.UniqueID AND
    a.ParcelID = b.ParcelID AND
    a.propertysplitaddress = b.propertysplitaddress AND
    a.SalePrice = b.SalePrice AND
    a.SaleDate = b.SaleDate AND
	a.LegalReference = b.LegalReference;

Select *
From portfolio.nashvillehousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From portfolio.nashvillehousing


ALTER TABLE portfolio.nashvillehousing
DROP COLUMN OwnerAddress

ALTER TABLE portfolio.nashvillehousing
DROP COLUMN TaxDistrict

ALTER TABLE portfolio.nashvillehousing
DROP COLUMN PropertyAddress

ALTER TABLE portfolio.nashvillehousing
DROP COLUMN SaleDate