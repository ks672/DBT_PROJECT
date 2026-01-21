select
    track_name,
    added_at,
    artist_name,
    album_name,
    count(*) as cnt
from {{ ref('spotify_reporting') }}
group by all
having count(*) > 1