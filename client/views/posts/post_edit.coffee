Template.postEdit.events({
    # the edit submit function--------
    'submit form': (e) ->
        e.preventDefault()

        currentPostId = this._id
        
        postProperties = {
            url: $(e.target).find('[name=url]').val()
            title: $(e.target).find('[name=title]').val()
        }

        Posts.update(
            currentPostId,
            {$set: postProperties},
            (error) ->
                if error
                    Errors.throw(error.reason)
                else
                    Router.go('postPage', {_id: currentPostId})
        )

    # the delete function--------
    'click .delete': (e) ->
        e.preventDefault()

        if confirm('Delete this post?')
            currentPostId = this._id
            Posts.remove(currentPostId)
            Router.go('postsList')
})
