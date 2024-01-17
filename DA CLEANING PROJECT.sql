SELECT *
FROM Nashville

--------DATA CLEANING

--Date formatting

SELECT SaleDateconverted, CONVERT(Date,SaleDate) AS dates
FROM Nashville

UPDATE Nashville
SET SaleDate = CONVERT(Date,SaleDate) 

ALTER TABLE Nashville
ADD SaleDateconverted date

UPDATE Nashville
SET SaleDateconverted = CONVERT(Date,SaleDate) 


--Data Population

Select *
FROM Nashville
WHERE PropertyAddress is null

Select N.ParcelID, N.PropertyAddress, A.ParcelID, A.PropertyAddress, ISNULL(N.PropertyAddress, A.PropertyAddress)
FROM Nashville AS N
JOIN Nashville AS A
ON N.ParcelID = A.ParcelID
AND N.[UniqueID ] <> A.[UniqueID ]
WHERE N.PropertyAddress is null

UPDATE N
SET PropertyAddress = ISNULL(N.PropertyAddress, A.PropertyAddress)
FROM Nashville AS N
JOIN Nashville AS A
ON N.ParcelID = A.ParcelID
AND N.[UniqueID ] <> A.[UniqueID ]
WHERE N.PropertyAddress is null

Select N.ParcelID, N.PropertyAddress, A.ParcelID, A.PropertyAddress
FROM Nashville AS N
JOIN Nashville AS A
ON N.ParcelID = A.ParcelID
AND N.[UniqueID ] <> A.[UniqueID ]


--Breaking out Address

SELECT PropertyAddress
FROM Nashville

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM Nashville


ALTER TABLE Nashville
ADD PropertySplitAddress nvarchar(255)

UPDATE Nashville
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Nashville
ADD PropertySplitCity nvarchar(255)


UPDATE Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



SELECT *
FROM Nashville


SELECT OwnerAddress
FROM Nashville


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Nashville


ALTER TABLE Nashville
ADD OwnerSplitAddress nvarchar(255)

UPDATE Nashville
SET OwnerSplitAddress=  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville
ADD OwnerSplitCity nvarchar(255)


UPDATE Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE Nashville
ADD OwnerSplitState nvarchar(255)

UPDATE Nashville
SET OwnerSplitState=  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT*
FROM Nashville


--Change y to yes and n to no


SELECT DISTINCT(SoldAsVacant)
FROM Nashville


SELECT SoldAsVacant,
    CASE WHEN SoldAsVacant = 'N' THEN 'NO'
	     WHEN SoldAsVacant = 'Y' THEN 'YES'
	    ELSE SoldAsVacant
	    END
FROM Nashville

UPDATE Nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'NO'
	     WHEN SoldAsVacant = 'Y' THEN 'YES'
	    ELSE SoldAsVacant
	    END


--Remove Duplicates

WITH RownumCTE AS(

SELECT *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) AS row_number
FROM Nashville
)--ORDER BY ParcelID
SELECT *
FROM RownumCTE
WHERE row_number > 1
--ORDER BY PropertyAddress


--Deleting Unused columns

SELECT *
FROM Nashville

ALTER TABLE Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress