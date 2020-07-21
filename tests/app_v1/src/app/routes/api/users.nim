import json
import strutils
import sugar

import jester

import ../../db_backend
import ../../models/user


export json
export strutils
export sugar

export db_backend
export user


router users:
  post "/":
    withDb:
      discard newUser(@"email").dup:
        db.insert

    resp Http201

  get "/@id":
    var user = newUser("")

    try:
      withDb:
        db.select(user, "id = ?", @"id")

    except KeyError:
      resp Http404

    resp(%* user)

  get "/":
    let
      perPage = if len(@"per_page") > 0: parseInt(@"per_page") else: 10
      page = if len(@"page") > 0: parseInt(@"page") else: 1
      limit = if perPage > 0: perPage else: 10
      offset = if page > 0: limit * (page - 1) else: 0

    var users = @[newUser("")]

    withDb:
      db.select(users, "1 LIMIT ? OFFSET ?", limit, offset)

    resp(%* users)

  delete "/@id":
    try:
      withDb:
        discard newUser("").dup:
          db.select("id = ?", @"id")
          db.delete

      resp Http204

    except KeyError:
      resp Http404
