WITH ads AS (

    SELECT *
    FROM {{ ref('stg_facebook__ads') }}

),

ad_groups AS (

    SELECT *
    FROM {{ ref('stg_facebook__ad_groups') }}

),

campaigns AS (

    SELECT *
    FROM {{ ref('stg_facebook__campaigns') }}

),

accounts AS (

    SELECT *
    FROM {{ ref('stg_facebook__accounts') }}

),

enriched AS (

    SELECT
        ads.ad_id,
        ads.ad_name,
        ads.ad_status,

        ads.ad_group_id,
        ad_groups.ad_group_name,

        ads.campaign_id,
        campaigns.campaign_name,

        ads.account_id,
        accounts.account_name,
        accounts.ad_currency_code,

        ads.ad_updated_at

    FROM ads

    LEFT JOIN ad_groups
        ON ads.ad_group_id = ad_groups.ad_group_id

    LEFT JOIN campaigns
        ON ads.campaign_id = campaigns.campaign_id

    LEFT JOIN accounts
        ON ads.account_id = accounts.account_id

)

SELECT
    *,
    'facebook' AS platform,
    'Paid Social' AS channel_name
FROM enriched