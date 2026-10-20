
WITH source_data AS (

    SELECT *
    FROM {{ source('snapchat', 'snapchat_ads_adgroup_history_new_ad_group_names') }}

),

formatted AS (

    SELECT
        -- Identifiers
        CAST(_surrogate_key AS STRING) AS surrogate_key,
        CAST(ad_group_id AS STRING) AS ad_group_id,
        CAST(campaign_id AS STRING) AS campaign_id,

        -- Ad group details
        CAST(ad_group_name AS STRING) AS ad_group_name,

        -- Metadata
        CAST(ad_group_updated_at AS TIMESTAMP) AS ad_group_updated_at

    FROM source_data

)

SELECT *
FROM formatted
