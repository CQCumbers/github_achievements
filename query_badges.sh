#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#  --data-raw $'
#  SELECT actor_login AS login, count() AS points
#    FROM github_events
#   WHERE event_type = \'IssueCommentEvent\'
#         AND body in (\'+1\', \':+1:\', char(0xF0, 0x9F, 0x91, 0x8D))
#GROUP BY login
#  HAVING points > 100
#ORDER BY points DESC' \
#  -o _data/vital_contributor.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#  --data-raw $'
#  SELECT closer AS login, count() AS points
#    FROM (
#  SELECT repo_name, number,
#         min(created_at) AS start,
#         max(created_at) AS end,
#         argMin(actor_login, created_at) AS opener,
#         argMax(actor_login, created_at) AS closer,
#         argMin(action, created_at) AS min_action,
#         argMax(action, created_at) AS max_action,
#         argMax(merged_at, created_at) AS max_merged,
#         count() AS events
#    FROM github_events
#   WHERE event_type = \'PullRequestEvent\'
#         AND (action = \'opened\' OR action = \'closed\')
#         AND additions > 10000
#GROUP BY repo_name, number
#  HAVING events = 2
#         AND dateDiff(\'second\', start, end) < 30
#         AND opener != closer
#         AND closer NOT LIKE \'%[bot]\'
#         AND min_action = \'opened\'
#         AND max_action = \'closed\'
#         AND toDate(max_merged) != toDate(\'1970-01-01\'))
#GROUP BY login
#  HAVING points > 3
#ORDER BY points DESC' \
#  -o _data/speed_reader.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#  --data-raw $'
#  SELECT splitByChar(\'/\', repo_name)[1] AS login,
#         count() AS points
#    FROM (
#  SELECT repo_name, number,
#         argMin(action, created_at) AS min_action,
#         count() AS events
#    FROM github_events
#   WHERE event_type = \'IssuesEvent\'
#         AND (action = \'opened\' OR action = \'closed\')
#GROUP BY repo_name, number
#  HAVING events = 1
#         AND min_action = \'opened\')
#GROUP BY login
#  HAVING points > 10000
#ORDER BY points DESC' \
#  -o _data/this_is_fine.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#  --data-raw $'
#  SELECT opener AS login,
#         count() AS points
#    FROM (
#  SELECT repo_name, number,
#         min(created_at) AS start,
#         max(created_at) AS end,
#         argMin(actor_login, created_at) AS opener,
#         argMax(actor_login, created_at) AS closer,
#         argMin(action, created_at) AS min_action,
#         argMax(action, created_at) AS max_action,
#         argMax(merged_at, created_at) AS max_merged,
#         count() AS events
#    FROM github_events
#   WHERE event_type = \'PullRequestEvent\'
#         AND (action = \'opened\' OR action = \'closed\')
#         AND lower(title) LIKE \'%fix%\'
#GROUP BY repo_name, number
#  HAVING events = 2
#         AND dateDiff(\'day\', start, end) > 730
#         AND opener != closer
#         AND opener NOT LIKE \'%[bot]\'
#         AND min_action = \'opened\'
#         AND max_action = \'closed\'
#         AND toDate(max_merged) != toDate(\'1970-01-01\'))
#GROUP BY login
#  HAVING points > 1
#ORDER BY points DESC' \
#  -o _data/patient_skeleton.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#  --data-raw $'
#  SELECT actor_login AS login,
#         count() AS points
#    FROM github_events
#   WHERE event_type = \'ForkEvent\'
#GROUP BY login
#  HAVING points > 5000
#ORDER BY points DESC' \
#  -o _data/archivist.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#   --data-raw $'
#  SELECT splitByChar(\'/\', repo_name)[1] AS login,
#         count() AS points
#    FROM (
#  SELECT repo_name,
#         concat(ref, head_ref) AS both_ref,
#         argMin(event_type, created_at) min_type,
#         argMax(event_type, created_at) max_type,
#         count() AS events
#    FROM github_events
#   WHERE (event_type = \'PullRequestEvent\'
#         AND action = \'closed\'
#         AND toDate(merged_at) != toDate(\'1970-01-01\')
#         AND author_association = \'OWNER\')
#         OR (event_type = \'DeleteEvent\')
#GROUP BY repo_name, both_ref
#  HAVING events = 1
#         AND min_type = \'PullRequestEvent\')
#GROUP BY login
#  HAVING points > 300
#ORDER BY points DESC' \
#  -o _data/arborist.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#   --data-raw $'
#  SELECT opener AS login,
#         count() AS points
#    FROM (
#  SELECT repo_name, number,
#         argMin(actor_login, created_at) AS opener,
#         argMin(event_type, created_at) AS min_type,
#         argMin(action, created_at) AS min_action,
#         sum(arrayExists(x -> lower(x) LIKE \'%feature%\', labels)) AS sum_exists
#    FROM github_events
#   WHERE (event_type =\'IssuesEvent\' AND action = \'opened\')
#         OR ((event_type = \'IssuesEvent\' OR event_type = \'IssueCommentEvent\')
#         AND arrayExists(x -> lower(x) LIKE \'%feature%\', labels))
#GROUP BY repo_name, number
#  HAVING min_type = \'IssuesEvent\' AND min_action = \'opened\'
#         AND opener NOT LIKE \'%[bot]%\'
#         AND opener != splitByChar(\'/\', repo_name)[1]
#         AND sum_exists > 1)
#GROUP BY login
#  HAVING points > 150
#ORDER BY points DESC' \
#  -o _data/ideas_person.csv

#curl 'https://play.clickhouse.com/?default_format=CSVWithNames' \
#  -X POST \
#  -H 'Authorization: Basic cGxheTo=' \
#   --data-raw $'
#  SELECT actor_login AS login,
#         count() AS points
#    FROM github_events
#   WHERE event_type =\'IssuesEvent\' AND action = \'closed\'
#         AND arrayExists(x -> lower(x) LIKE \'%wontfix%\', labels)
#         AND actor_login NOT LIKE \'%[bot]%\'
#GROUP BY login
#  HAVING points > 50
#ORDER BY points DESC' \
#  -o _data/status_quo.csv
