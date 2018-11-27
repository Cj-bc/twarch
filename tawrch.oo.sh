#!/usr/bin/env bash
#
# Copyright 2018 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version -

tag_query="えこてん OR #絵こてん #にこにこ放送局"
username_query="eko_0_1_0"
tag_last_id=""
user_last_id=""

function use_api() {
  tweet.sh/tweet.sh $@
}

function tag_get() {
  local tag_ret tag_ret_modifed
  if [ -z "$tag_last_id" ];then
    tag_ret="$(use_api search -q "$tag_query")"
  else
    tag_ret="$(use_api search -q "$tag_query" -s "$tag_last_id")"
  fi

  tag_ret_modifed="$( echo "$tag_ret" | jq '.statuses | map({data: .created_at, id: .id, text: .text, urls: .entities.urls, media: .entities.media, favorite_count: .favorite_count, retweet_count : .retweet_count, extended_entries: .extended_entities, possibly_sensitive: .possibly_sensitive, in_reply_to_status_id: .in_reply_to_status_id, in_reply_to_user_id: .in_reply_to_user_id})')"
  tag_last_id="$(echo "$tag_ret_modifed" | jq '.[-1].id')"

  echo "$tag_ret_modifed"
}

function username_get() {
  if [ -z "$username_last_id" ];then
    user_ret="$(use_api search -q "$username_query")"
  else
    user_ret="$(use_api search -q "$username_query") -s "$user_last_id""
  fi

  user_ret_modified="$(echo "$user_ret" | jq '.statuses | map({data: .created_at, id: .id, text: .text, urls: .entities.urls, media: .entities.media, favorite_count: .favorite_count, retweet_count : .retweet_count, extended_entries: .extended_entities, possibly_sensitive: .possibly_sensitive, in_reply_to_status_id: .in_reply_to_status_id, in_reply_to_user_id: .in_reply_to_user_id})')"
  user_last_id="$(echo "$user_ret_modified" | jq '.[-1].id')"

  echo "$user_ret_modified"
}
