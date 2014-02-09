# this is the router master file

Router.configure({
    layoutTemplate: 'layout'
    loadingTemplate: 'loading'
    notFoundTemplate: 'notFound'
    waitOn: () -> [ Meteor.subscribe('notifications') ]
    autoRender: true
})


Router.map(
    () ->
        #
        #The route for the individual post.
        this.route(
            'postPage',
            {
                path: '/posts/:_id'
                waitOn: () ->
                    [
                        Meteor.subscribe('comments', this.params._id),
                        Meteor.subscribe('singlePost', this.params._id)
                    ]
                data: () ->
                    Posts.findOne(this.params._id)
            }
        )
        #
        # The route for Posting a post
        this.route(
            'postSubmit',
            {
                path: '/submit',
                disableProgress: true
            }
        )  # omitting the template property.

        # This is to edit a post
        this.route(
            'postEdit',
            {
                path: '/posts/:_id/edit',
                waitOn: () ->
                    Meteor.subscribe('singlePost', this.params._id)
                data: () -> return Posts.findOne(this.params._id)
            }
        )
        #
        # the /home that does the same as the /. testing.
        this.route(
            'home',
            {
                path:'/home'
                template: 'postsList'
            }
        )
        #
        # this is another test
        this.route(
            'home2',
            {
                path:'/home2'
                template: 'postsList'
                layoutTemplate: 'layout2'
            }
        )
        #
        #The testing router for debug
        this.route(
            'debug',
            {
                path:'/debug/:p_a(*)'
                template: 'debug'
                data: () ->
                    {
                        'theRoute': this
                        'thePost': Posts.findOne()
                    }
                before: [
                    () ->
                        thePath = this.path
                        i = thePath.search('good')
                        if i == -1
                            setTimeout(
                                () -> Router.go('debug', {p_a: 'redirected/with/parameter/good'}),
                                # () -> Router.go('/debug/redirected/good'),
                                10000
                            )
                ]
            }
        )
        #
        # This route uses a controller that is provided in a separate file.
        this.route(
            'complex',
            {
                path: '/complex/:p_1(*)'
                controller: ComplexRoute
            }
        )
        #
        # the route for the Root, posts list
        this.route(
            'postsList',
            {
                path: '/:postsLimit?',
                controller: PostsListRouteController
                # disableProgress: true
            }
        )  # omitting the template property.
)

# the login checking function. It's registed as Router.before()
requireLogin = ()->
    if ! Meteor.user()
        if Meteor.loggingIn()
            @render(@loadingTemplate)
        else
            @render('accessDenied')
        @stop()

Router.before(requireLogin, {only: 'postSubmit'})

Router.before(()-> Errors.clearSeen())
