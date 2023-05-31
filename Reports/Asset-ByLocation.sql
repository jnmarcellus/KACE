SELECT
  L.NAME AS 'LOCATION',
  ASSET.ASSET_DATA_ID,
  ASSET.NAME,
  ASSET_ASSOCIATION.ASSET_FIELD_ID,
  ASSET.LOCATION_ID,
  ASSET_ASSOCIATION.ASSOCIATED_ASSET_ID,
  ASSET_FIELD_DEFINITION.FIELD_NAME,
  ASSET.ID,
  ASSET.ASSET_TYPE_ID
From
  ASSET
  Inner JOIN ASSET_ASSOCIATION On ASSET.ID = ASSET_ASSOCIATION.ASSET_ID
  Inner Join ASSET_FIELD_DEFINITION On ASSET_ASSOCIATION.ASSET_FIELD_ID = ASSET_FIELD_DEFINITION.ID
  LEFT JOIN LABEL L ON ASSET.LOCATION_ID = L.ID