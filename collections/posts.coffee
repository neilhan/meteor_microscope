# The collection for Posts

@Posts = new Meteor.Collection('posts')

Posts.allow({
    # insert: (userId, doc) ->
    #     return !! userId
    update: ownsDocument
    remove: ownsDocument
})

Posts.deny({
    update: (userId, post, fieldNames) ->
        # only allow url, title to be updated.
        return _.without(fieldNames, 'url', 'title').length > 0
})

Meteor.methods({
    post: (postAttributes) ->
        # logged in checking
        user = Meteor.user()

        if ! user
            throw new Meteor.Error(401, "You need to login to post new stories.")

        # duplicates checking
        postWithSameLink = Posts.findOne({url: postAttributes.url})

        if ! postAttributes.title
            throw new Meteor.Error(422, 'Please fill in a headline.')

        if postAttributes.url and postWithSameLink
            throw new Meteor.Error(302,
                'This link has already been posted.',
                postWithSameLink._id
            )

        # get isSimulation
        suffix = if this.isSimulation then '(client)' else '(server)'
        # only take the following values
        post = _.extend(
            _.pick(postAttributes, 'url', 'title', 'message'),
            {
                # this is to observe the post latency compensation
                title: postAttributes.title + " #{suffix}"
                userId: user._id,
                author: user.username,
                submitted: new Date().getTime(),
                commentsCount: 0
            }
        )

        # this is to observe the latency compensation
        if ! this.isSimulation
            Future = Npm.require('fibers/future')
            future = new Future()
            Meteor.setTimeout(
                () -> future.return(),
                5 * 1000
            )
            future.wait()

        # get the return ready
        postId = Posts.insert(post)

        return postId
})
