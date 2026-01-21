select *
from {{ ref('spotify_reporting') }}
where genre1 is null
  and genre2 is not null