
WITH source_data AS (

    SELECT *
    FROM {{ source('facebook', 'new_campaign_de_randomized') }}

),

formatted AS (

    SELECT
        -- Identifiers
        CAST(campaign_id AS STRING) AS campaign_id,

        -- Campaign details
        CAST(campaign_name AS STRING) AS campaign_name,

        -- Metadata
        CAST(campaign_updated_at AS TIMESTAMP) AS campaign_updated_at

    FROM source_data

)

SELECT *
FROM formatted
