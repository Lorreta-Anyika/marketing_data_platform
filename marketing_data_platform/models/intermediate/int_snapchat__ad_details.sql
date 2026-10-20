
WITH ads AS (

    SELECT *
    FROM {{ ref('stg_snapchat__ads') }}

),

ad_groups_ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ad_group_id
            ORDER BY
                ad_group_updated_at DESC NULLS LAST,
                surrogate_key DESC
        ) AS row_num
    FROM {{ ref('stg_snapchat__ad_groups') }}

),

ad_groups AS (

    SELECT *
    FROM ad_groups_ranked
    WHERE row_num = 1

),

campaigns AS (

    SELECT *
    FROM {{ ref('stg_snapchat__campaigns') }}

),

enriched AS (

    SELECT
        ads.ad_id,
        ads.ad_name,
        ads.ad_detail_updated_at,

        ads.ad_group_id,
        ad_groups.ad_group_name,

        ad_groups.campaign_id,
        campaigns.campaign_name,
        campaigns.account_id

    FROM ads

    LEFT JOIN ad_groups
        ON ads.ad_group_id = ad_groups.ad_group_id

    LEFT JOIN campaigns
        ON ad_groups.campaign_id = campaigns.campaign_id

)

SELECT
    *,
    'snapchat' AS platform,
    'Paid Social' AS channel_name
FROM enriched
