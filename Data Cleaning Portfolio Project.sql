-- Data Cleaning Project




--Standardize Date Format

Select SaleDateConverted, Convert(Date, Saledate)
from DataCleaning..Nashvillehousing

Update NashvilleHousing
Set SaleDate= Convert(Date,Saledate)

Alter Table Nashvillehousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

--Populate Property Adress Data 

Select *
from DataCleaning..Nashvillehousing
Order by ParcelID

Select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from DataCleaning..Nashvillehousing a
Join DataCleaning..Nashvillehousing b
	on a.parcelid = b.Parcelid
	and a.[UniqueID ] <> B.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.PropertyAddress, b.propertyaddress)
from DataCleaning..Nashvillehousing a
Join DataCleaning..Nashvillehousing b
	on a.parcelid = b.Parcelid
	and a.[UniqueID ] <> B.[UniqueID ]

-- Breaking out Addresses into individual Columns (address, City, State)

Select PropertyAddress
from DataCleaning..Nashvillehousing

Select
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1 ) as Address
, Substring(PropertyAddress, Charindex(',', PropertyAddress) + 1 , Len(PropertyAddress)) as Address

from DataCleaning..Nashvillehousing

Alter Table DataCleaning..Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update DataCleaning..Nashvillehousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1 )

Alter Table DataCleaning..Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update DataCleaning..Nashvillehousing
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) + 1 , Len(PropertyAddress))

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
from DataCleaning..Nashvillehousing

Alter Table DataCleaning..Nashvillehousing
Add OwnerAddressSplit Nvarchar(255);

Update DataCleaning..Nashvillehousing
Set OwnerAddressSplit = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table DataCleaning..Nashvillehousing
Add OwnerCitySplit Nvarchar(255);

Update DataCleaning..Nashvillehousing
Set OwnerCitySplit = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter Table DataCleaning..Nashvillehousing
Add OwnerStateSplit Nvarchar(255);

Update DataCleaning..Nashvillehousing
Set OwnerStateSplit = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

Select*
from DataCleaning..Nashvillehousing

-- Changing Y/N to Yes/No in "Sold as Vacant" field

Select Distinct(soldasvacant), Count(Soldasvacant)
From DataCleaning..Nashvillehousing
Group by SoldAsVacant
order by 2

Select soldasvacant
, Case when soldasvacant = 'Y' then 'Yes'
	   When soldasvacant = 'N' Then 'No'
	   Else soldasvacant
	   End
From DataCleaning..Nashvillehousing

Update DataCleaning..Nashvillehousing
Set SoldAsVacant = Case when soldasvacant = 'Y' then 'Yes'
	   When soldasvacant = 'N' Then 'No'
	   Else soldasvacant
	   End

-- Remove Duplicates

With RowNumCTE As(
Select *,
	ROW_NUMBER() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 Saleprice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) Row_Num

From DataCleaning..Nashvillehousing
)
Delete
From RowNumCTE
Where Row_num > 1

--Delete Unsed Columns

Select *
From DataCleaning .. NashvilleHousing

Alter Table DataCleaning .. NashvilleHousing
Drop Column OwnerAddress, PropertyAddress, SaleDate
