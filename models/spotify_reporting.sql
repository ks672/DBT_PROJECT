
/*
    This script builds a reporting table in snowflake for spotify data. 
    This will feed into a data visualisation tool.
*/

{{ config(materialized='incremental',  unique_key='fact_playlist_track_id') }}

select
    distinct
    fpt.fact_playlist_track_id,
    fpt.added_at,
    fpt.track_name,
    fpt.artist_name,
    fpt.album_name,
    {{ split_to_columns('a.genres', 9) }},
    a.followers,
    
    t.popularity,
    t.duration_ms,
    t.explicit,
    current_timestamp() as load_timestamp

    from spotify_db.curated.fact_playlist_track fpt

    left join spotify_db.curated.artist a
    on fpt.artist_id = a.artist_id
    left join spotify_db.curated.track t
    on fpt.track_id = t.track_id