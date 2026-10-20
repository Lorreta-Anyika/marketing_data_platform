
WITH source_data AS (

    SELECT *
    FROM {{ source('facebook', 'ads_stats') }}

),

formatted AS (

    SELECT
        -- Identifiers
        CAST(ad_id AS STRING) AS ad_id,

        -- Performance metrics
        CAST(ad_spend AS DOUBLE) AS ad_spend,

        CAST(
            NULLIF(TRIM(ad_impressions), 'null')
            AS BIGINT
        ) AS ad_impressions,

        CAST(
            NULLIF(TRIM(ad_clicks), 'null')
            AS BIGINT
        ) AS ad_clicks,

        -- Reporting date
        CAST(ad_date AS DATE) AS ad_date

    FROM source_data

)

SELECT *
FROM formatted
