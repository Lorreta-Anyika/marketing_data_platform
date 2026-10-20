

WITH source_data AS (

    SELECT *
    FROM {{ source('facebook', 'new_adgroup_de_randomized') }}

),

formatted AS (

    SELECT
        -- Identifiers
        CAST(ad_group_id AS STRING) AS ad_group_id,

        -- Ad group details
        CAST(ad_group_name AS STRING) AS ad_group_name,

        -- Metadata
        CAST(ad_group_updated_at AS TIMESTAMP) AS ad_group_updated_at

    FROM source_data

)

SELECT *
FROM formatted
