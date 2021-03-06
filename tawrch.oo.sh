#!/usr/bin/env bash
#
# Copyright 2018 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version -

interval=360 # seconds
tag_query='"えこてん" OR "#絵こてん" -from:eko_0_1_0 exclude:retweets'
username_query='from:eko_0_1_0 exclude:retweets'
tag_last_id=""
username_last_id=""
tag_db_dir="db/tag"
username_db_dir="db/username"

jq_query='.statuses |
          map({data: .created_at,
               id: .id,
               text: .text,
               urls: .entities.urls,
               media: .entities.media,
               favorite_count: .favorite_count,
               retweet_count : .retweet_count,
               extended_entries: .extended_entities,
               possibly_sensitive: .possibly_sensitive,
               in_reply_to_status_id: .in_reply_to_status_id,
               in_reply_to_user_id: .in_reply_to_user_id
              })
         '

username_jq_query='map({data: .created_at,
                        id: .id,
                        text: .text,
                        urls: .entities.urls,
                        media: .entities.media,
                        favorite_count: .favorite_count,
                        retweet_count : .retweet_count,
                        extended_entries: .extended_entities,
                        possibly_sensitive: .possibly_sensitive,
                        in_reply_to_status_id: .in_reply_to_status_id,
                        in_reply_to_user_id: .in_reply_to_user_id
                       })
                  '
function use_api() {
  tweet.sh/tweet.sh $@
}

function tag_get() {
  local tag_ret tag_ret_modified
  if [ -z "$tag_last_id" ];then
    tag_ret="$(use_api search -q "$tag_query" -c 100)"
  else
    tag_ret="$(use_api search -q "$tag_query" -c 100 -s $tag_last_id)"
  fi

  tag_ret_modified="$( echo "$tag_ret" | jq "$jq_query")"
  tag_last_id="$(echo "$tag_ret_modified" | jq '.[0].id')"


  echo "$tag_ret_modifed"
}

function username_get() {
  local username_ret username_ret_modified
  if [ -z "$username_last_id" ];then
    username_ret="$(use_api fetch-posts -u eko_0_1_0 -c 100)"
  else
    username_ret="$(use_api fetch-posts -u eko_0_1_0 -c 100 -s $username_last_id)"
  fi

  username_ret_modified="$(echo "$username_ret" | jq "$username_jq_query")"
  username_last_id="$(echo "$username_ret_modified" | jq '.[0].id')"

  echo "$user_ret_modified"
}

main() {
  while true; do
    echo "Start scraping:"
    echo -n "scrape tags..."
    tag_get >> "${tag_db_dir}/tag_$(date +%Y-%m-%d-%H-%M-%S).json"
    echo "Done"
    echo -n "scrape username..."
    username_get >> "${username_db_dir}/username_$(date +%Y-%m-%d-%H-%M-%S).json"
    echo "Done"
    echo "All jobs completed."
    echo "Next: ${interval} seconds later"
    sleep $interval
  done
}

main
