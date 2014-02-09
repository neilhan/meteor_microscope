class @PostsListRouteController extends RouteController
    # @before ->
    # @after ->
    # layoutTemplate: ''
    # waitOn ->
    # action ->
    
    template: 'postsList',

    increment: 5,

    limit: () ->
        parseInt(this.params.postsLimit) or this.increment

    findOptions: () ->
        {sort: {submitted: -1}, limit: this.limit()}

    posts: () ->
        Posts.find({}, this.findOptions())

    waitOn: () ->
        Meteor.subscribe('posts', this.findOptions())

    data: () ->
        hasMore = ( this.posts().fetch().length == this.limit() )
        nextPath = this.route.path({postsLimit: this.limit() + this.increment})
        {
            posts: this.posts().fetch(),
            nextPath: if hasMore then nextPath else null
        }
