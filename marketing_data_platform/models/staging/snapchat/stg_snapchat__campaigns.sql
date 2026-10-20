
WITH source_data AS (

    SELECT *
    FROM {{ source('snapchat', 'snapchat_ads_campaign_history_new_campaign_names') }}

),

formatted AS (

    SELECT
        -- Identifiers
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(account_id AS STRING) AS account_id,

        -- Campaign details
        CAST(campaign_name AS STRING) AS campaign_name

    FROM source_data

)

SELECT *
FROM formatted
