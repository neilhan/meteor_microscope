
# user owns the doc
@ownsDocument = (userId, doc) ->
    return doc.userId == userId
