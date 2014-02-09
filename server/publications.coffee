Meteor.publish(
    'posts',
    (options) ->
        Posts.find({}, options)
)


Meteor.publish(
    'singlePost',
    (id) ->
        if id then Posts.find(id) else null
)

Meteor.publish(
    'comments',
    (postId) ->
        Comments.find({postId: postId})
)

Meteor.publish(
    'notifications',
    () ->
        Notifications.find({userId: this.userId})
)
