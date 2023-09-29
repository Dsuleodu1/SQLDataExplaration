/*

Cleaning Data in SQL Queries

*/



Select*
From projects.dbo.NashvilleHousing


-------------------------------------------------------------------------------------------------

--Standardize Date Format



Select SaleDateConverted, CONVERT(Date,SaleDate)
From projects.dbo.NashvilleHousing



UPDATE NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate)


-- If it doesn't Update properly


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


UPDATE NashvilleHousing
SET SaleDateConverted =CONVERT(Date,SaleDate)




-------------------------------------------------------------------------------------------------

--Populate Property Address data


Select *
From projects.dbo.NashvilleHousing
--Where PropertyAddress is null
ORDER BY ParcelID




Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From projects.dbo.NashvilleHousing a
JOIN projects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From projects.dbo.NashvilleHousing a
JOIN projects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null






------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)




Select PropertyAddress
From projects.dbo.NashvilleHousing
--Where PropertyAddress is null
--ORDER BY ParcelID



SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address


From Projects.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))







Select*
From Projects.dbo.NashvilleHousing







Select OwnerAddress
From Projects.dbo.NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',',',') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',',',') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',',',') ,1)
From Projects.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)








-----------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in ""Sold as Vacant" field




Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From Projects.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
,	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldasVacant = 'N' THEN 'No'
		 ELSE SoldasVacant
		 END
From Projects.dbo.NashvilleHousing




UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant  = 'Y' THEN 'Yes'
		 When SoldasVacant = 'N' THEN 'No'
		 ELSE SoldasVacant
		 END





----------------------------------------------------------------------------------------------------------------

-- Rmove Duplicates


WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				  UniqueID
				   ) row_num


From Projects.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress





----------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From Projects.dbo.NashvilleHousing


ALTER TABLE Projects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress



ALTER TABLE Projects.dbo.NashvilleHousing
DROP COLUMN SaleDate


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------