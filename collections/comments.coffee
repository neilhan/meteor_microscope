# creating the collection: comments
# 
@Comments = new Meteor.Collection('comments')

Meteor.methods({
    comment: (commentAttributes) ->
        user = Meteor.user()
        post = Posts.findOne(commentAttributes.postId)

        if not user
            throw new Meteor.Error(401, "You need to login to make comments.")

        if not commentAttributes.body
            throw new Meteor.Error(422, "Please write some content.")

        if not post
            throw new Meteor.Error(422, "You must comment on an existing post.")

        comment = _.extend(
            _.pick(commentAttributes, 'postId', 'body'),
            {
                userId: user._id,
                author: user.username,
                submitted: new Date().getTime()
            }
        )

        # update Post to have the correct comments count
        Posts.update(comment.postId, {$inc: {commentsCount: 1}})

        comment._id = Comments.insert(comment)

        # Notification to the post owner
        createCommentNotification(comment)

        return comment._id
})
