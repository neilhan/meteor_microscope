Template.postPage.helpers({
    comments: () ->
        Comments.find({postId: this._id})
})
