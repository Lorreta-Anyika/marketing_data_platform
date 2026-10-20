
WITH facebook AS (

    SELECT
        CAST('facebook' AS STRING) AS platform,
        stats.ad_id,
        stats.ad_date,
        CAST(NULL AS STRING) AS ad_country,
        accounts.ad_currency_code,
        stats.ad_spend,
        stats.ad_impressions,
        stats.ad_clicks,
        CAST(NULL AS STRING) AS data_src

    FROM {{ ref('stg_facebook__stats') }} AS stats

    LEFT JOIN {{ ref('stg_facebook__ads') }} AS ads
        ON stats.ad_id = ads.ad_id

    LEFT JOIN {{ ref('stg_facebook__accounts') }} AS accounts
        ON ads.account_id = accounts.account_id

),

snapchat AS (

    SELECT
        CAST('snapchat' AS STRING) AS platform,
        ad_id,
        ad_date,
        ad_country,
        ad_currency_code,
        ad_spend,
        ad_impressions,
        ad_clicks,
        data_src

    FROM {{ ref('stg_snapchat__stats') }}

),

unified AS (

    SELECT * FROM facebook

    UNION ALL

    SELECT * FROM snapchat

),

fx_rates AS (

    SELECT
        rate_date,
        usd_per_eur
    FROM {{ ref('fx_rates_usd_eur') }}

),

with_fx AS (

    SELECT
        unified.*,
        fx.usd_per_eur,

        ROW_NUMBER() OVER (
            PARTITION BY
                unified.platform,
                unified.ad_id,
                unified.ad_date,
                unified.ad_country,
                unified.ad_currency_code
            ORDER BY fx.rate_date DESC NULLS LAST
        ) AS fx_row_num

    FROM unified

    LEFT JOIN fx_rates AS fx
        ON fx.rate_date <= unified.ad_date

)

SELECT
    platform,
    ad_id,
    ad_date,
    ad_country,
    ad_currency_code,
    ad_spend,
    ad_impressions,
    ad_clicks,
    data_src,
    usd_per_eur,

    {{ convert_to_eur('ad_spend', 'ad_currency_code', 'usd_per_eur') }}
        AS spend_eur

FROM with_fx
WHERE fx_row_num = 1